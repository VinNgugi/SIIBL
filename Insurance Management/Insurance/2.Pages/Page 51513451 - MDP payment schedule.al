page 51513451 "MDP payment schedule"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "MDP Schedule";
    SourceTableView = SORTING("Instalment Due Date");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("XOL Layer"; "XOL Layer")
                {
                }
                field("Instalment Due Date"; "Instalment Due Date")
                {
                }
                field("Premium Amount"; "Premium Amount")
                {
                }
                field(Paid; Paid)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(MDPs)
            {
                Caption = 'MDPs';
                action("Create payment Voucher")
                {
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction();
                    begin
                        CreatePV(Rec);
                    end;
                }
            }
        }
    }

    var
        PVlines: Record "PV Lines1";
        PV: Record Payments1;
        RecPayTypes: Record "Receipts and Payment Types";
        UserDetails: Record "User Setup Details";
        Treaty: Record Treaty;
        MDPSchedule: Record "MDP Schedule";

    local procedure CreatePV(var MDP: Record "MDP Schedule");
    begin
        PV.INIT;
        PV.Date := WORKDATE;
        RecPayTypes.RESET;
        RecPayTypes.SETRANGE(RecPayTypes.Type, RecPayTypes.Type::Payment);
        RecPayTypes.SETRANGE(RecPayTypes."Insurance Trans Type", RecPayTypes."Insurance Trans Type"::"Deposit Premium");
        IF NOT RecPayTypes.FINDFIRST THEN
            ERROR('Please setup a payment type for Deposit Premium')
        ELSE
            PV.Type := RecPayTypes.Code;
        IF UserDetails.GET(USERID) THEN
            PV."Paying Bank Account" := UserDetails."Default Payment Bank";
        PV."Account Type" := PV."Account Type"::Customer;
        IF Treaty.GET(MDP."Treaty Code", MDP."Treaty Addendum") THEN
            PV."Account No." := Treaty.Broker;
        PV.VALIDATE(PV."Account No.");
        PV.INSERT(TRUE);
        MDPSchedule.COPYFILTERS(Rec);
        IF MDPSchedule.FINDFIRST THEN BEGIN
            REPEAT
                PVlines.INIT;
                PVlines."PV No" := PV.No;
                PVlines."Line No" := PVlines."Line No" + 10000;
                PVlines."Account Type" := PVlines."Account Type"::Customer;
                PVlines."Account No" := Treaty.Broker;
                PVlines.VALIDATE(PVlines."Account No");
                PVlines.Description := STRSUBSTNO('%1 due on %2', MDPSchedule."XOL Layer", MDPSchedule."Instalment Due Date");
                PVlines.Amount := MDPSchedule."Premium Amount";
                PVlines."Treaty Code" := MDPSchedule."Treaty Code";
                PVlines."Treaty Addendum" := MDPSchedule."Treaty Addendum";
                PVlines."XOL Layer" := MDPSchedule."XOL Layer";
                PVlines."Instalment Plan No." := MDPSchedule."Payment No.";
                PVlines."Premium Due Date" := MDPSchedule."Instalment Due Date";
                PVlines."Shortcut Dimension 1 Code" := UserDetails."Global Dimension 1 Code";
                IF PVlines.Amount <> 0 THEN
                    PVlines.INSERT(TRUE);

            UNTIL MDPSchedule.NEXT = 0;
            MESSAGE('Payment Voucher %1 created', PV.No);
        END;
    end;
}

