table 51513456 "IBNR Setup"
{

    fields
    {
        field(1;Class;Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3));
        }
        field(2;"Year No.";Integer)
        {
        }
        field(3;"Period Length";DateFormula)
        {
        }
        field(4;"Gross Premium Account";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5;"Reinsurance Premium Account";Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(6;"IBNR Percentage";Decimal)
        {
        }
        field(7;"IBNR Amount";Decimal)
        {
        }
        field(8;"Starting Date";Date)
        {

            trigger OnValidate();
            begin
                "Ending Date":=CALCDATE("Period Length","Starting Date")-1;
            end;
        }
        field(9;"Ending Date";Date)
        {
        }
        field(10;"Net Premium";Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Class),
                                                        "Insurance Trans Type"=FILTER(Premium|"Reinsurance Premium"),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter")));
            FieldClass = FlowField; */
        }
        field(11;"Date Filter";Date)
        {
            FieldClass = FlowFilter;
        }
        field(12;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(13;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(14;"Sub Class";Code[10])
        {
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                IF PolicyType.GET("Sub Class") THEN
                  BEGIN

                    Class:=PolicyType.Class;
                    "Product Name":=PolicyType.Description;

                  END;
            end;
        }
        field(15;"Net Premium Sub Class";Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE ("Policy Type"=FIELD("Sub Class"),
                                                        "Insurance Trans Type"=FILTER(Premium|"Reinsurance Premium"),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter")));
            FieldClass = FlowField;
        }
        field(16;"Product Name";Text[250])
        {
        }
        field(17;"Posted IBNR";Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE ("Policy Type"=FIELD("Sub Class"),
                                                        "Insurance Trans Type"=FILTER(IBNR),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter")));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Sub Class","Year No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PolicyType : Record 51513000;
}

