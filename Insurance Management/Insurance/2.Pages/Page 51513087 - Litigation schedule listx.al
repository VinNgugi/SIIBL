page 51513087 "Litigation schedule listx"
{
    // version AES-INS 1.0

    CardPageID = "Litigation Schedule cardx";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Litigation schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Litigation schedule code"; "Litigation schedule code")
                {
                }
                field("Date Received"; "Date Received")
                {
                }
                field(Remarks; Remarks)
                {
                }
                field("Hearing Date"; "Hearing Date")
                {
                    Caption = 'Date';
                }
                field(Time; Time)
                {
                }
                field(Venue; Venue)
                {
                }
                field(Details; Details)
                {
                }
                field(Status; Status)
                {
                }
                field(Witness; Witness)
                {
                }
                field("Court Decision"; "Court Decision")
                {
                }
            }
        }
    }

    actions
    {
    }
}

