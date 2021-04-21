page 51513044 "Proportional Treaty"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = Treaty;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Treaty Code"; "Treaty Code")
                {
                }
                field("Treaty description"; "Treaty description")
                {
                }
                field("Addendum Code"; "Addendum Code")
                {
                }
                field("Apportionment Type"; "Apportionment Type")
                {
                }
                field(Type; Type)
                {
                }
                field("Effective date"; "Effective date")
                {
                }
                field("Expiry Date"; "Expiry Date")
                {
                }
                field("Contract Currency Code"; "Contract Currency Code")
                {
                }
                field("Territory Code"; "Territory Code")
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Broker; Broker)
                {
                }
                field("Broker Name"; "Broker Name")
                {
                }
                field("Broker Commision"; "Broker Commision")
                {
                }
            }
            group("Proportional Treaty")
            {
                field("Quota Share"; "Quota Share")
                {
                }
                field("Quota share Retention"; "Quota share Retention")
                {
                }
                field("Insurer quota percentage"; "Insurer quota percentage")
                {
                }
                field(Surplus; Surplus)
                {
                }
                field("Surplus Retention"; "Surplus Retention")
                {
                }
                field(Facultative; Facultative)
                {
                }
                field("Exess of loss"; "Exess of loss")
                {
                }
            }
            group(Commission)
            {
                field("Profit commission percentage"; "Profit commission percentage")
                {
                }
            }
           /*  part(QuotaShare;"Quota Share")
            {
                Caption = 'Quota Share';
                SubPageLink = "Quota Share" = CONST(True),
                              "Treaty Code" = FIELD("Treaty Code"),
                              "Addendum Code" = FIELD("Addendum Code");
            }
            part(Surplus1; Surplus)
            {
                Caption = 'Surplus';
                SubPageLink = Surplus = CONST(True),
                              "Treaty Code" = FIELD("Treaty Code"),
                              "Addendum Code" = FIELD("Addendum Code");
            } */
            part("Reinsurance Share Lines"; "Reinsurance Share Lines")
            {
                SubPageLink = Facultative = CONST(True),
                              "Treaty Code" = FIELD("Treaty Code"),
                              "Addendum Code" = FIELD("Addendum Code");
            }
        }
    }

    actions
    {
    }
}

