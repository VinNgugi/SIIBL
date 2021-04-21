page 51513546 "beneficiary list"
{
    // version AES-INS 1.0

    PageType = List;
    UsageCategory=Lists;
    SourceTable = Beneficiaries;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Beneficiary No";"Beneficiary No")
                {
                }
                field("Family name";"Family name")
                {
                }
                field("First Name";"First Name")
                {
                }
                field(Relationship;Relationship)
                {
                }
                field("Date of Birth";"Date of Birth")
                {
                }
                field("% share";"% share")
                {
                }
            }
        }
    }

    actions
    {
    }
}

