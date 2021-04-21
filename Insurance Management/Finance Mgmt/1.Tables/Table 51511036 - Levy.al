table 51511036 Levy
{
    // version FINANCE

    //DrillDownPageID = 51511626;
    //LookupPageID = 51511626;

    fields
    {
        field(1; LevyNo; Integer)
        {
            AutoIncrement = true;
            DataClassification = ToBeClassified;
        }
        field(3; LevyTypeCode; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Levy Types";
        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; DueDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; PostingDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; AssociatedLevyReferenceNo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(8; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(9; Name; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(10; DateFilter; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "CustomerNo."; Code[150])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                IF Cust.GET("CustomerNo.") THEN
                    Name := Cust.Name;
            end;
        }
        field(12; FundValue; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; "Amount Paid"; Decimal)
        {
            CalcFormula = - Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("CustomerNo.")));
            FieldClass = FlowField;
        }
        field(14; UserID; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(15; InvoiceNo; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(16; InvoiceGenerated; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(17; ExpToleranceThreshhold; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(18; Period; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(19; Processed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(20; ReportHeaderID; Integer)
        {
            DataClassification = ToBeClassified;
            NotBlank = false;
        }
        field(21; Reversal; Boolean)
        {
            DataClassification = ToBeClassified;
            InitValue = false;
        }
        field(22; InvoiceNumber; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; LevyNo)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*IF LevyNo= '' THEN BEGIN
          SalesSetup.GET;
          SalesSetup.TESTFIELD(SalesSetup."Levy Nos");
          NoSeriesMgt.InitSeries(SalesSetup."Levy Nos",xRec.FundValue,0D,LevyNo,FundValue);
        //"GL Account":=HumanResSetup."Account No (Training)";
        END;
        */

    end;

    var
        SalesSetup: Record 311;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cust: Record 18;
}

