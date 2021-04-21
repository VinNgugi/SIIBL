table 51513067 "Policy benefits"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"No.";Integer)
        {
            NotBlank = true;
        }
        field(2;"Insurance Type";Code[10])
        {
        }
        field(3;Description;Text[250])
        {
        }
        field(4;"Insured Value";Decimal)
        {
        }
        field(5;"Premium %";Decimal)
        {
        }
        field(6;"Premium Amount";Decimal)
        {
        }
        field(7;"Actual Amount";Decimal)
        {
        }
        field(8;"Type Description";Text[250])
        {
        }
        field(9;"Text Type";Option)
        {
            OptionMembers = Normal,Bold,"Underline ";
        }
        field(10;Type;Option)
        {
            OptionMembers = Benefits,Limits,Exclusions,Warranties;
        }
        field(11;"Policy Type";Code[12])
        {
        }
        field(12;"Document No.";Code[20])
        {
        }
        field(13;"Document Type";Option)
        {
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Policy;
        }
        field(14;"Line No";Integer)
        {
        }
        field(15;Name;Text[80])
        {
        }
        field(16;Exclusion;Text[250])
        {
        }
        field(17;"Policy No";Text[20])
        {
        }
        field(18;"Benefit ID";Code[20])
        {
            NotBlank = true;
            TableRelation = Benefits;

            trigger OnValidate();
            begin
                /*IF ICD10Rec.GET("Benefit ID") THEN
                BEGIN
                Description:=ICD10Rec.Description;
                Exclusion:=ICD10Rec.Description;
                "Moratorium Period":=ICD10Rec."Moratorium Period";
                VALIDATE("Moratorium Period");
                END;*/

            end;
        }
        field(19;"Moratorium Date";Date)
        {
        }
        field(21;"Claims Amount (Premium Curr)";Decimal)
        {
            FieldClass = Normal;
        }
        field(22;"Time Limit";DateFormula)
        {
        }
        field(23;"Overall Maximum";Decimal)
        {
        }
        field(24;Category;Code[20])
        {
            TableRelation = "Claim Types";
        }
        field(25;"Currency Code";Code[20])
        {
            TableRelation = Currency;
        }
        field(26;"Benefit Category";Code[20])
        {
            TableRelation = "Claim Types";
        }
        field(27;Quantity;Decimal)
        {
        }
        field(28;"Unit of Measure";Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(29;"Moratorium Period";DateFormula)
        {
        }
        field(30;"Member Period";DateFormula)
        {
        }
        field(31;"No. Of Incidences";Decimal)
        {
        }
        field(32;"Day/Night Monetary Limit";Decimal)
        {
        }
        field(33;"Incident Monetary Limit";Decimal)
        {
        }
        field(34;"Benefit Type";Option)
        {
            OptionMembers = " ","Overall Maximimum ","Full Refund","Full Refund+ # Sessions","Limited by Amount","Limited to Period","Full refund Upto Amt Per Day","Full refund upto # Days","Full refund upto # Days+waiting period","Limited by amount up to # Days","Limited by Amount and Membership Period","Limited by Amt and Waiting Period","Full Refund+Waiting Period","Full refund+Daily amount+Period Limit","Amt Limit+Amt Per day+Period","Limited by Amount+Lifetime benefit";
        }
        field(35;"Monetary Limit (Maximum)";Decimal)
        {
        }
        field(36;"Paid Amount (Premuim Curr)";Decimal)
        {
            FieldClass = Normal;
        }
        field(37;"Benefit Section";Option)
        {
            OptionMembers = "0","1-Overall Maximum","2-Emergency Medical Transfer & Evacuation","3-Additional Transportation","4-Elective Medical transfer","5-In-Patient Treatment","6-Daycare Treatment","7-Out-Patient Treatment","8-Chronic Treatment","9-Kidney Dialysis","10-Infertility","11-Cancer Care","12-Organ Transplant","13-Lifetime","14-Cash","15-Pregnancy and Childbirth","16-Emergency Dental","17-Optical","18-Audiology","19-Wellness","20-Out of Area Cover","21-Optional Dental";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }
}

