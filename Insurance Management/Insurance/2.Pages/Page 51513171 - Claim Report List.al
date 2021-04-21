page 51513171 "Claim Report List"
{
    // version AES-INS 1.0

    CardPageID = "Claim Report";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Claim Report Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field("Reported By"; "Reported By")
                {
                }
                field("Total Estimated Value"; "Total Estimated Value")
                {
                }
                field(Decision; Decision)
                {
                }
                field("Service Provider No."; "Service Provider No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Decision Code"; "Decision Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

