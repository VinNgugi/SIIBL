page 51513192 "Claims Activities"
{
    // version AES-INS 1.0

    Caption = 'Activities';
    PageType = CardPart;
    SourceTable = "Claims Cue";

    layout
    {
        area(content)
        {
            cuegroup(Payments)
            {
                Caption = 'Payments';
                field("No. Of Claims"; "No. Of Claims")
                {
                }
                field("No. Of Rejected Claims"; "No. Of Rejected Claims")
                {
                }
                field("Total Reserves"; "Total Reserves")
                {
                }
                field("Total Claims Outstanding"; "Total Claims Outstanding")
                {
                }
                field("Total Paid"; "Total Paid")
                {
                    Caption = 'Total Paid';
                }
                field("No. of Closed Claims"; "No. of Closed Claims")
                {
                }
                field("Reinsurance Share"; "Reinsurance Share")
                {
                    Caption = 'Reinsurance Share';
                }
                field("No. Of Items Due (Legal Diary)"; "No. Of Items Due (Legal Diary)")
                {
                    Caption = 'No. Of Items Due (Legal Diary)';
                }
                field("No. Of Payments Due"; "No. Of Payments Due")
                {
                    Caption = 'No. Of Payments Due';
                }
                field("No. of Services Due"; "No. of Services Due")
                {
                    Caption = 'No. of Services Due';
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

