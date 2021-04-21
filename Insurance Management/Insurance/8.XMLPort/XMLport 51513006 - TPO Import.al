xmlport 51513006 "TPO Import"
{
    // version AES-INS 1.0

    Format = VariableText;
    FormatEvaluate = Legacy;

    schema
    {
        textelement(TPOTableImport)
        {
            tableelement(TPO; TPO)
            {
                XmlName = 'TPO';
                fieldelement(Seating; TPO."Seating Capacity")
                {
                }
                fieldelement(ONE; TPO."1")
                {
                }
                fieldelement(TWO; TPO."2")
                {
                }
                fieldelement(THREE; TPO."Payment Terms")
                {
                }
                fieldelement(FOUR; TPO.Currency)
                {
                }
                fieldelement(FIVE; TPO."5")
                {
                }
                fieldelement(SIX; TPO."6")
                {
                }
                fieldelement(SEVEN; TPO."7")
                {
                }
                fieldelement(EIGHT; TPO."8")
                {
                }
                fieldelement(NINE; TPO."Country/Region")
                {
                }
                fieldelement(TEN; TPO."10")
                {
                }
                fieldelement(ELEVEN; TPO."11")
                {
                }
                fieldelement(TWELVE; TPO."Gen. Jnl.-Post Line")
                {
                }
                fieldelement(TWENTYSIX; TPO."26")
                {
                }
                fieldelement(FIFTYTWO; TPO."52")
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

