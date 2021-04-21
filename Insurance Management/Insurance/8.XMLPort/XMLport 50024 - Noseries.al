xmlport 50124 Noseries
{
    // version AES-INS 1.0


    schema
    {
        textelement("no. series lines")
        {
            XmlName = 'Noseriesx';
            tableelement("No. Series Line"; "No. Series Line")
            {
                XmlName = 'Noserieslines';
                fieldelement(Codes; "No. Series Line"."Series Code")
                {
                }
                fieldelement(LineNo; "No. Series Line"."Line No.")
                {
                }
                fieldelement(StartDate; "No. Series Line"."Starting Date")
                {
                }
                fieldelement(StartingNo; "No. Series Line"."Starting No.")
                {
                }
                fieldelement(EndingNo; "No. Series Line"."Ending No.")
                {
                }
                fieldelement(WarningNo; "No. Series Line"."Warning No.")
                {
                }
                fieldelement(incrementbyno; "No. Series Line"."Increment-by No.")
                {
                }
                fieldelement(lastno; "No. Series Line"."Last No. Used")
                {
                }
                fieldelement(open; "No. Series Line".Open)
                {
                }
                fieldelement(lastdateused; "No. Series Line"."Last Date Used")
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }
}

