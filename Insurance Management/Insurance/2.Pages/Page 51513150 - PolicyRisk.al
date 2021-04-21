page 51513150 PolicyRisk
{
    // version AES-INS 1.0

    PageType = ListPart;
    SourceTable = PolicyProposalRisk;
    SourceTableView = WHERE(CustomerContactType = FILTER(Customer));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Line No."; "Line No.")
                {
                }
                field(CustomerContactType; CustomerContactType)
                {
                }
                field(PolicyProposalNo; PolicyProposalNo)
                {
                }
                field(NoofInstalments; NoofInstalments)
                {
                }
                field(RiskDatabaseID; RiskDatabaseID)
                {
                }
                field("No of Passangers"; "No of Passangers")
                {
                }
                field(PolicyType; PolicyType)
                {
                }
                field(PolicyTypeName; PolicyTypeName)
                {
                }
                field("Estimated Value"; "Estimated Value")
                {
                }
                field("Valuers Value"; "Valuers Value")
                {
                }
                field(RiskTableID; RiskTableID)
                {
                }
            }
        }
    }

    actions
    {
    }
}

