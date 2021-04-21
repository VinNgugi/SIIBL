page 51513176 "Claim Reservation line"
{
    // version AES-INS 1.0

    AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Claim Reservation Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Description)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field("Reserved Amount"; "Reserved Amount")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field("Service Provider No."; "Service Provider No.")
                {
                }
                field("Service Provider Name"; "Service Provider Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

