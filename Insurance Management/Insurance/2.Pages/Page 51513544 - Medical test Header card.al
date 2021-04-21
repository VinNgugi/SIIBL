page 51513544 "Medical test Header card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Medical Test Header";

    layout
    {
        area(content)
        {
            group(General)
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
            part("Medical test lines"; "Medical test lines")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
    }
}

