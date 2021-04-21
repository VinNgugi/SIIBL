page 51513173 "Appoint Garage"
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
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
       // "Appointment Date" := "Appointment Date"::"Payment Terms";
    end;
}

