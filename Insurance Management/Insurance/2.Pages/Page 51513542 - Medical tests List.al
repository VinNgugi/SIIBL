page 51513542 "Medical tests List"
{
    // version AES-INS 1.0

    CardPageID = "Medical test Header card";
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Medical Test Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field("User Requesting"; "User Requesting")
                {
                }
                field("Medical Provider"; "Medical Provider")
                {
                }
                field("Document Type"; "Document Type")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Member ID"; "Member ID")
                {
                }
                field("Family Name"; "Family Name")
                {
                }
                field("First names"; "First names")
                {
                }
                field("Date of Birth"; "Date of Birth")
                {
                }
                field(Sex; Sex)
                {
                }
                field("Medical Practitioner Name"; "Medical Practitioner Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

