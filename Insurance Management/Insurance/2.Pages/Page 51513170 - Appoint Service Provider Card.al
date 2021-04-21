page 51513170 "Appoint Service Provider Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim Service Appointments";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Appointment No."; "Appointment No.")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field("Claimant ID"; "Claimant ID")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Service Provider Type"; "Service Provider Type")
                {
                }
                field("Sourcing type"; "Sourcing type")
                {
                }
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Loss Type";
                "Loss Type")
                {
                }
                field("Task Assigned"; "Task Assigned")
                {
                }
                field("Task Description"; "Task Description")
                {
                }
                field("Appointment Instructions"; "Appointment Instructions")
                {
                }
                field("Appointment Date"; "Appointment Date")
                {
                }
                field("Appointment Time"; "Appointment Time")
                {
                }
                field("Appointed By"; "Appointed By")
                {
                }
                field(Stage; Stage)
                {
                }
                field("SLA End Date"; "SLA End Date")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        ClaimantRec: Record "Claim Involved Parties";

    local procedure getClaimant(var Claimant: Record "Claim Involved Parties");
    begin
        ClaimantRec.COPY(Claimant);
    end;
}

