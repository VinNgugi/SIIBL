page 51513016 "Policy Classes"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Insurance Class";
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Commission Percentage"; "Commission Percentage")
                {
                }
                field(Type; Type)
                {
                }
                field("Treaty Code"; "Treaty Code")
                {
                }
                field("Addendum Code"; "Addendum Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

