page 51513018 "Risk database"
{
    // version AES-INS 1.0

    CardPageID = "Vehicle Database";
    Editable = false;
    PageType = List;
    SourceTable = "Risk Database";
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("<Regestration No>"; RiskDatabaseID)
                {
                }
                field(Make; Make)
                {
                }
                field(Model; Model)
                {
                }
                field("Engine No."; "Engine No.")
                {
                }
                field("Chassis No."; "Chassis No.")
                {
                }
                field(Colour; Colour)
                {
                }
                field("Body Type"; "Body Type")
                {
                }
                field(Usage; Usage)
                {
                }
                field(Trailer; Trailer)
                {
                }
                field("Associated Vehicle"; "Associated Vehicle")
                {
                }
                field("License Class"; "License Class")
                {
                }
                field(Tonnage; Tonnage)
                {
                }
                field("Year of Manufacture"; "Year of Manufacture")
                {
                }
                field(Route; Route)
                {
                }
                field("Route Description"; "Route Description")
                {
                }
                field(Valuation; Valuation)
                {
                }
                field("Cubic Centimeter"; "Cubic Centimeter")
                {
                }
                field("No of Passengers"; "No of Passengers")
                {
                }
            }
        }
    }

    actions
    {
    }
}

