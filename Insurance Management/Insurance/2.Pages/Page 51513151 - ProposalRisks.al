page 51513151 ProposalRisks
{
    // version AES-INS 1.0

    PageType = ListPart;
    SourceTable = PolicyProposalRisk;
    SourceTableView = WHERE(CustomerContactType = FILTER(Contact));

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

