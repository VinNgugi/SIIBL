page 51513093 "Risk Cover Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Risk Covers";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Policy No."; "Policy No.")
                {
                }
                field("Risk Id"; "Risk Id")
                {
                }
                field("Cover No."; "Cover No.")
                {
                }
                field("Cover Start Date"; "Cover Start Date")
                {
                }
                field("Cover End Date"; "Cover End Date")
                {
                }
                field("Suspension Date"; "Suspension Date")
                {
                }
                field("Re-instatement Date"; "Re-instatement Date")
                {
                }
                field("Extension Period"; "Extension Period")
                {
                }
                field("Substitute Risk ID"; "Substitute Risk ID")
                {
                }
                field("Substitution Date"; "Substitution Date")
                {
                }
                field(Status; Status)
                {
                }
                field(Select; Select)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Generate Debit Note")
            {

                trigger OnAction();
                begin
                    // InsuranceMgnt.ConvertQuote2DebitNote(Rec)
                    IF PolicyRec.GET(PolicyRec."Document Type"::Policy, "Policy No.") THEN BEGIN
                        InsuranceMgnt.ConvertPolicy2DebitNote(PolicyRec, Rec);
                    END;
                end;
            }
            action("Suspend Cover")
            {

                trigger OnAction();
                begin
                    Insmanagement.SuspendCover(Rec);
                end;
            }
            action("Reinstate Cover")
            {

                trigger OnAction();
                begin
                    Insmanagement.ReinstateCover(Rec);
                end;
            }
            action("Substitute ")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.SubstituteRisk(Rec);
                end;
            }
            action("Extend Cover")
            {

                trigger OnAction();
                begin
                    Insmanagement.ExtendCover(Rec);
                end;
            }
        }
    }

    var
        Insmanagement: Codeunit "Insurance management";
        InsuranceMgnt: Codeunit "Insurance management";
        PolicyRec: Record "Insure Header";
}

