page 51513486 "Summon card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim Letters";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("External Reference No."; "External Reference No.")
                {
                }
                field("Case No."; "Case No.")
                {
                }
                field("Case Title"; "Case Title")
                {
                }
                field("Court No."; "Court No.")
                {
                }
                field("Court Name"; "Court Name")
                {
                }
                field("Demand Letter No."; "Demand Letter No.")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Claimant ID"; "Claimant ID")
                {
                }
                field("Received by"; "Received by")
                {
                }
                field("Received Date"; "Received Date")
                {
                }
                field("Received Time"; "Received Time")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Create Case")
            {

                trigger OnAction();
                begin
                    IF "Case No." = '' THEN
                        ERROR('You must have a case no. before creating a case')
                    ELSE BEGIN
                        Litigations.INIT;
                        Litigations."Case No." := "Case No.";
                        Litigations."Claim No." := "Claim No.";
                        Litigations."Claimant ID" := "Claimant ID";
                        Litigations.VALIDATE(Litigations."Claimant ID");
                        Litigations.Description := "Case Title";
                        Litigations."Law Court" := "Court No.";
                        Litigations.INSERT;
                        MESSAGE('Case No %1 created', "Case No.");
                    END;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Letter Type" := "Letter Type"::Summons;
    end;

    var
        Litigations: Record Litigations;
}

