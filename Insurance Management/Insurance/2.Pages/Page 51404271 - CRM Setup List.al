page 51404271 "CRM Setup List"
{
    // version AES-PAS 1.0

    CardPageID = "CRM Setup";
    PageType = List;
    SourceTable = 51404200;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Client Interaction Type Nos.";"Client Interaction Type Nos.")
                {
                }
                field("Client Interaction Cause Nos.";"Client Interaction Cause Nos.")
                {
                }
                field("Interaction Resolution Nos.";"Interaction Resolution Nos.")
                {
                }
                field("Client Interaction Header Nos";"Client Interaction Header Nos")
                {
                }
                field("Client Record Change Nos.";"Client Record Change Nos.")
                {
                }
                field("Employer Inter. Header Nos.";"Employer Inter. Header Nos.")
                {
                }
            }
        }
    }

    actions
    {
    }
}

