xmlport 51404102 "Interaction Types"
{
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Interaction Type";"Interaction Type")
            {
                XmlName = 'InteractionType';
                fieldattribute(No;"Interaction Type"."No.")
                {
                }
                fieldattribute(Desc;"Interaction Type".Description)
                {
                }
                fieldattribute(Type;"Interaction Type"."Interaction Type")
                {
                }
                fieldattribute(Status;"Interaction Type".Status)
                {
                }
                fieldattribute(DayStart;"Interaction Type"."Day Start Time")
                {
                }
                fieldattribute(DayEnd;"Interaction Type"."Day End Time")
                {
                }
                fieldattribute(OverallDurationLevel;"Interaction Type"."Escalation Expiration -Hrs")
                {
                }
                fieldattribute(AssignedtoBusinessUnit;"Interaction Type"."Assigned to Business Unit")
                {
                }
                fieldattribute(AssignedtoBusinessEmail;"Interaction Type"."Business Unit Email")
                {
                }
                fieldattribute(AssignedtoBusinessName;"Interaction Type"."Assigned to Business Name")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

