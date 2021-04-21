page 51513501 "Legal Activities"
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
                field("No. Of Items Due (Legal Diary)"; "No. Of Items Due (Legal Diary)")
                {
                    Caption = 'No. Of Items Due (Legal Diary)';
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

