table 51513180 "Maturity Instalments setup"
{
  // version AES-INS 1.0


    fields
    {
        field(1; "Policy Type"; Code[20])
        {
            //TableRelation = "Policy Type";
        }
        field(2; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments"."No. Of Instalments";

            trigger OnValidate();
            begin
                IF NoOfInstalments.GET("No. Of Instalments") THEN BEGIN
                    Description := NoOfInstalments.Description;
                END;
            end;
        }
        field(3; Description; Text[30])
        {
        }
        field(4; "% Loading"; Decimal)
        {
        }
        field(5; "% Discount"; Decimal)
        {
        }
        field(6;"Underwriter Code";Code[20])
        {
            
        }
        field(7;"Instalment Type";Enum InstalmentType)
        {

        }
        field(8;"Benefit Code";Code[20])
        {
            
        }
    }

    keys
    {
        key(Key1; "Policy Type","Underwriter Code", "No. Of Instalments","Instalment Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        NoOfInstalments: Record "No. of Instalments";
}

