page 51513172 "Claim Garage"
{
    // version AES-INS 1.0

    CardPageID = "Appoint Garage";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Service Appointments";
    //SourceTableView = WHERE("Appointment Date"=CONST(03/03/16D));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Service Provider Type"; "Service Provider Type")
                {
                }
                field("Sourcing type"; "Sourcing type")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Assessor's Report")
            {
                RunObject = Page 51513171;
            }
        }
    }
}

