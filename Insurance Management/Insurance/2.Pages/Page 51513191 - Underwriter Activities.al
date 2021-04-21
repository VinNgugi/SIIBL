page 51513191 "Underwriter Activities"
{
    // version AES-INS 1.0

    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Underwriting Cue";

    layout
    {
        area(content)
        {
            cuegroup("BI-Sales")
            {
                Caption = 'BI-Sales';
                field("No. Of Vehicles Insured"; "No. Of Vehicles Insured")
                {
                    DrillDownPageID = "Schedule of Insured List Non E";
                }
                field("No. of  Vehicles out of Cover"; "No. of  Vehicles out of Cover")
                {
                    Caption = 'No. of  Vehicles out of Cover';
                    DrillDownPageID = "Schedule of Insured List Non E";
                }
                field("No. Of Active Policies"; "No. Of Active Policies")
                {
                    Caption = 'No. Of Active Policies';
                    DrillDownPageID = "Policy List";
                }
                field("New Business"; "New Business")
                {
                }
                field("Debited Premium"; "Debited Premium")
                {
                }
                field(Receipts; Receipts)
                {
                }
                field("Credited Premium"; "Credited Premium")
                {
                }
                field("Expected Renewals"; "Expected Renewals")
                {
                }
                field("New Business Amount"; "New Business Amount")
                {
                }
            }
            cuegroup("Document Approvals")
            {
                Caption = 'Document Approvals';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;

        SETFILTER("Date Filter", '<%1', WORKDATE);
    end;
}

