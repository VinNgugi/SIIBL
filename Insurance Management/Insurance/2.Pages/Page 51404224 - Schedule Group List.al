page 51404224 "Schedule Group List"
{
    // version Scheduler

    Caption = 'Schedule Group List';
    Editable = false;
    PageType = Card;
    SourceTable = "Schedule Group";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                }
                field(Description;Description)
                {
                }
                field("Run on Monday";"Run on Monday")
                {
                }
                field("Run on Tuesday";"Run on Tuesday")
                {
                }
                field("Run on Wednesday";"Run on Wednesday")
                {
                }
                field("Run on Thursday";"Run on Thursday")
                {
                }
                field("Run on Friday";"Run on Friday")
                {
                }
                field("Run on Saturday";"Run on Saturday")
                {
                }
                field("Run on Sunday";"Run on Sunday")
                {
                }
                field("Interval (secs)";"Interval (secs)")
                {
                }
                field(Enabled;Enabled)
                {
                }
                field("Next Scheduled Date Time";"Next Scheduled Date Time")
                {
                }
                field("Last Date Time Executed";"Last Date Time Executed")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Schedule Group")
            {
                Caption = '&Schedule Group';
                action(Card)
                {
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Schedule Group Card";
                   // RunPageLink ="No." =field("No.");
                    ShortCutKey = 'Shift+F7';
                }
            }
        }
    }
}

