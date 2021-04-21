page 51513031 "Premium table card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Premium Table";
    ;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Inclusive of Taxes"; "Inclusive of Taxes")
                {
                }
                field("Effective Date"; "Effective Date")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field("Vehicle Class"; "Vehicle Class")
                {
                }
                field("Vehicle Usage"; "Vehicle Usage")
                {
                }
            }
            part("Premium table lines"; "Premium table lines")
            {
                SubPageLink = "Premium Table" = FIELD(Code);
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Load TPO Premium")
            {

                trigger OnAction();
                begin
                    InsMgt.UpdateTPOPremiumTable(Rec);
                end;
            }
            action("Copy Premium Table")
            {

                trigger OnAction();
                begin
                    CopyPremium.GetRec(Rec);
                    CopyPremium.RUN;
                end;
            }
        }
    }

    var
        InsMgt: Codeunit "Insurance management";
        CopyPremium: Report "Copy Premium Tables";
}

