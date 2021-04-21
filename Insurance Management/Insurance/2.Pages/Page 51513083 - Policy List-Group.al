page 51513083 "Policy List-Group"
{
    // version AES-INS 1.0

    CardPageID = "Debit Note Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Policy), "Cover Type" = CONST(Individual));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Insured No."; "Insured No.")
                {
                }
                field("Insured Name"; "Insured Name")
                {
                }
                field("Agent/Broker"; "Agent/Broker")
                {
                }
                field("Brokers Name"; "Brokers Name")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Policy Description"; "Policy Description")
                {
                }
                field("From Date"; "From Date")
                {
                }
                field("To Date"; "To Date")
                {
                }
                field("Quotation No."; "Quotation No.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Additions/Extensions")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.Endorsement(Rec);
                end;
            }
            action("Cancel Policy")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.CancelPolicy(Rec);
                end;
            }
            action("Lapse Policy")
            {
            }
            action(Addition)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.Endorsement(Rec);
                end;
            }
            action("Nil Endorsement")
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.Endorsement(Rec);
                end;
            }
            action(Deletion)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.PolicyDeletion(Rec);
                end;
            }
            action(Suspension)
            {
            }
            action(Substitution)
            {
            }
            action(Renew)
            {

                trigger OnAction();
                begin
                    InsuranceMgnt.RenewPolicy(Rec);
                end;
            }
        }

    }

    var
        InsuranceMgnt: Codeunit "Insurance management";
}

