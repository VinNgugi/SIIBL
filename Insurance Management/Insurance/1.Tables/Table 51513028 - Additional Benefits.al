table 51513028 "Additional Benefits"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement;
        }
        field(2; "Document No."; Code[30])
        {
        }
        field(3; "Risk ID"; Integer)
        {
            TableRelation = "Insure Lines"."Line No." WHERE("Document Type" = FIELD("Document Type"),
                                                             "Document No." = FIELD("Document No."),
                                                             "Description Type" = CONST("Schedule of Insured"));
        }
        field(4; "Option ID"; Code[10])
        {

            trigger OnValidate();
            begin
                IF "Risk ID" = 0 THEN
                    ERROR('Please select the Risk ID before selecting an additional cover/rider');

                IF OptionalItems.GET("Option ID") THEN BEGIN
                    Description := OptionalItems.Description;
                    "Free Limit" := OptionalItems."Free Limit Value";
                    "Rate %" := OptionalItems.Rate;
                    "Value Allowed" := OptionalItems."Value Allowed";
                    "Loading Amount" := OptionalItems."Loading Amount";
                    Premium := OptionalItems."Loading Amount";
                    "Discount Amount" := OptionalItems."Discount Amount";
                END;
                IF Insurelines.GET("Document Type", "Document No.", "Risk ID") THEN BEGIN
                    Description := Insurelines."Registration No." + ' ' + OptionalItems.Description;
                    "Sum Insured" := Insurelines."Sum Insured";
                    VALIDATE("Rate %");
                END;
            end;
        }
        field(5; Description; Text[250])
        {
        }
        field(6; "Sum Insured"; Decimal)
        {
        }
        field(7; "Free Limit"; Decimal)
        {
        }
        field(8; "Additional Cover Required"; Decimal)
        {
        }
        field(9; "Rate %"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Value Allowed" <> 0 THEN
                    Premium := ("Rate %" / 100) * "Value Allowed";

                IF "Sum Insured" <> 0 THEN
                    Premium := ("Rate %" / 100) * "Sum Insured";

                IF "Additional Cover Required" <> 0 THEN
                    Premium := ("Rate %" / 100) * "Additional Cover Required";
            end;
        }
        field(10; Premium; Decimal)
        {
        }
        field(11; "Loading Amount"; Decimal)
        {
        }
        field(12; "Discount Amount"; Decimal)
        {
        }
        field(13; "Value Allowed"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Risk ID", "Option ID")
        {
            SumIndexFields = Premium;
        }
    }

    fieldgroups
    {
    }

    var
        OptionalItems: Record "Optional Covers";
        Insurelines: Record "Insure Lines";
}

