
pageextension 50106 "Notification Setup Ext" extends "Notification Setup"
{
    layout
    {
        addafter(Schedule)
        {
            field("Sms Message";Rec."SMS Message")
            {

            }
            field("Notification Start Period";Rec."Notification Start Period")
            {

            }
            field("Holiday Date";Rec."Holiday Date")
            {
                
            }
        }
    }
}
