page 51513165 "Service Provider Appointments"
{
    // version AES-INS 1.0

    CardPageID = "Appoint Service Provider Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Service Appointments";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Appointment No."; "Appointment No.")
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
                field("Appointment Instructions"; "Appointment Instructions")
                {
                }
                field("Claim No."; "Claim No.")
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
                field("Claimant ID"; "Claimant ID")
                {
                }
                field("Loss Type";
                "Loss Type")
                {
                }
                field("Task Assigned"; "Task Assigned")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Service Provider Reports")
            {
                RunObject = Page 51513171;
                RunPageLink = "Appointment No."=FIELD("Appointment No.");
            }
        }
    }
}

