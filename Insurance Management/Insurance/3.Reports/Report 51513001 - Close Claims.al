report 51513001 "Close Claims"
{
    // version AES-INS 1.0

    ProcessingOnly = true;

    dataset
    {
        dataitem("Claim"; "Claim")
        {

            trigger OnAfterGetRecord();
            begin


                Claim."Claim Status" := Claim."Claim Status"::Closed;
                Claim.MODIFY;
            end;

            trigger OnPreDataItem();
            begin
                Claim.SETRANGE(Claim."Claim Closure Date", WORKDATE);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

