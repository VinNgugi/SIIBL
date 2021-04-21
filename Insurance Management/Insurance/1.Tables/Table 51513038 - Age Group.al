table 51513038 "Age Group"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Age Band"; Code[10])
        {
            NotBlank = true;
        }
        field(2; "Minimum Age"; Integer)
        {
        }
        field(3; "Maximum Age"; Integer)
        {
        }
        field(4; "Applicable to"; Option)
        {
            OptionMembers = "New & Renewal",Renewal;
        }
        field(5; "Excess Filter"; Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Policy Excess";
        }
        field(6; "Effective Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(7; "Policy Type Filter"; Code[10])
        {
            FieldClass = FlowFilter;
        }
        field(8; "Insurance Type Filter"; Code[10])
        {
            FieldClass = FlowFilter;
        }
        field(9; "Area Of Cover Filter"; Code[10])
        {
            FieldClass = FlowFilter;
        }
        field(10; "Premium Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Premium Table Entry"."Premium Amount" WHERE("Age Band" = FIELD("Age Band"),
                                                                            "Policy Type" = FIELD("Policy Type Filter"),
                                                                            "Area of Cover" = FIELD("Area Of Cover Filter"),
                                                                            Excess = FIELD("Excess Filter"),
                                                                            "Effective Start Date" = FIELD("Effective Date Filter"),
                                                                            "Payment Frequency" = FIELD("Premium Payment Filter"),
                                                                            "Premium Currency" = FIELD("Currency Filter"),
                                                                            UnderWriter = FIELD("UnderWriter Filter"),
                                                                            "Client Type"=FIELD("Client Type Filter"),
                                                                            "Employee Range"=FIELD("Employee Range Filter")));
            
        }
        field(11;"Premium Payment Filter";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = "Payment Terms";
        }
        field(12;"Currency Filter";Code[10])
        {
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
        field(13;Underwriter;Code[20])
        {
        }
        field(14;"UnderWriter Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                    IF UnderwriterRec.GET(Underwriter) THEN
                    "Underwriters Name":=UnderwriterRec.Name;
            end;
        }
        field(15;"Age Band Filter";Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = "Age Group"."Age Band";
        }
        field(16;"Client Type Filter";Code[10])
        {
            FieldClass = FlowFilter;
        }
        field(17;"Underwriters Name";Text[30])
        {
        }
        field(18;"Employee Range Filter";Code[20])
        {
        }
        field(19;"Client Type";Code[10])
        {
        }
    }

    keys
    {
        key(Key1;"Age Band")
        {
        }
    }

    fieldgroups
    {
    }

    var
        UnderwriterRec : Record Vendor;
}

