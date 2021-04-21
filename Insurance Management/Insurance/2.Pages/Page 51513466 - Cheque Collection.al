page 51513466 "Cheque Collection"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Cheque Register";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PVNo; PVNo)
                {
                }
                field("Cheque No."; "Cheque No.")
                {
                }
                field("Cheque Printing Date"; "Cheque Printing Date")
                {
                }
                field("Notification Alert Date"; "Notification Alert Date")
                {
                }
                field(Payee; Payee)
                {
                }
                field("Date Collected"; "Date Collected")
                {
                }
                field("Name of Collector"; "Name of Collector")
                {
                }
                field(Status; Status)
                {
                }
            }
        }
    }

    actions
    {
    }
}

