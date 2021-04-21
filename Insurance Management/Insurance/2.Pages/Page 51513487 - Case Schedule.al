page 51513487 "Case Schedule"
{
    // version AES-INS 1.0

    CardPageID = "Case schedule Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Legal Diary";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Legal Stage Code"; "Legal Stage Code")
                {
                }
                field("Stage Description"; "Stage Description")
                {
                }
                field(Date; Date)
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End time"; "End time")
                {
                }
                field("Date received"; "Date received")
                {
                }
                field("Reminder date"; "Reminder date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

