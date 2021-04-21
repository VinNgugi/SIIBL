page 51513209 Sms
{
    // version AES-INS 1.0

    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "PSV_SMS";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SmsID; SmsID)
                {
                }
                field(V_phone; V_phone)
                {
                }
                field(V_message; V_message)
                {
                }
                field(V_response; V_response)
                {
                }
            }
        }
    }

    actions
    {
    }
}

