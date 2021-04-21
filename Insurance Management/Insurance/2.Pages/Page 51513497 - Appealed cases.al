page 51513497 "Appealed cases"
{
    // version AES-INS 1.0

    Caption = 'Appealed cases';
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Legal Diary";
    SourceTableView = WHERE("Judgement Decision" = CONST(Liable),
                            "Judgement Decision Response" = CONST(Appeal));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Case No."; "Case No.")
                {
                }
                field("Legal Stage Code"; "Legal Stage Code")
                {
                }
                field("Stage Description"; "Stage Description")
                {
                }
                field(Date; Date)
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End time"; "End time")
                {
                }
                field("Judgement Decision"; "Judgement Decision")
                {
                }
                field("Judgement Decision Response"; "Judgement Decision Response")
                {
                }
                field("Amount awarded"; "Amount awarded")
                {
                }
                field("Date received"; "Date received")
                {
                }
                field("Reminder date"; "Reminder date")
                {
                }
                field("Payment Period"; "Payment Period")
                {
                }
                field("Payment Expiry date"; "Payment Expiry date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Adjust Reserves")
            {
                Caption = 'Adjust Reserves';
            }
            action("Make Payment Requisition")
            {
                Caption = 'Make Payment Requisition';

                trigger OnAction();
                begin
                    Insmgt.TransferLegalDecision2Payment(Rec);
                end;
            }
            action("Apply for stay (Appeal)")
            {
                Caption = 'Apply for stay (Appeal)';

                trigger OnAction();
                begin
                    "Judgement Decision Response" := "Judgement Decision Response"::Appeal;
                    MODIFY;
                end;
            }
            action("Court Deposit PV")
            {
                Caption = 'Court Deposit PV';

                trigger OnAction();
                begin
                    Insmgt.TransferLegalDecision2Payment(Rec);
                end;
            }
        }
    }

    var
        Insmgt: Codeunit "Insurance management";
}

