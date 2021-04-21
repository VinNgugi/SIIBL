table 51511027 "Receipts Header"
{
    // version FINANCE


    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                GLSetup.GET;
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesMgt.TestManual(GLSetup."Receipt No");
                    MESSAGE('the one');
                END;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; "Pay Mode"; Code[20])
        {
            TableRelation = "Pay Modes";
        }
        field(4; "Cheque No"; Code[20])
        {
        }
        field(5; "Cheque Date"; Date)
        {
        }
        field(6; "Total Amount"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Receipt Lines".Amount WHERE("Receipt No." = FIELD("No.")));

        }
        field(7; "Amount(LCY)"; Decimal)
        {
        }
        field(8; "Bank Code"; Code[50])
        {
            TableRelation = "Bank Account";
        }
        field(9; "Received From"; Text[250])
        {
        }
        field(10; "On Behalf Of"; Text[250])
        {
            NotBlank = true;
        }
        field(11; Cashier; Code[50])
        {
            Editable = false;
        }
        field(12; Posted; Boolean)
        {
            Editable = false;
        }
        field(13; "Posted Date"; Date)
        {
            Editable = false;
        }
        field(14; "Posted Time"; Time)
        {
            Editable = false;
        }
        field(15; "Posted By"; Code[50])
        {
            Editable = false;
        }
        field(16; "No. Series"; Code[50])
        {
            TableRelation = "No. Series";
        }
        field(17; "Currency Code"; Code[50])
        {
            TableRelation = Currency.Code;
        }
        field(18; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(19; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(20; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Pending Prepayment,Released,Closed,Rejected';
            OptionMembers = Open,"Pending Approval","Pending Prepayment",Released,Closed,Rejected;
        }
        field(21; Amount; Decimal)
        {
        }
        field(22; Banked; Boolean)
        {
        }
        field(23; "Procurement Method"; Option)
        {
            OptionCaption = ' ,Direct,RFQ,RFP,Tender,Low Value,Specially Permitted,EOI';
            OptionMembers = " ",Direct,RFQ,RFP,Tender,"Low Value","Specially Permitted",EOI;
        }
        field(24; "Procurement Request"; Code[30])
        {

            trigger OnValidate()
            begin
                //IF (Procurement Method=CONST(Direct)) "Procurement Request1" WHERE (Process Type=CONST(Direct)) ELSE IF (Procurement Method=CONST(RFP)) "Procurement Request1" WHERE (Process Type=CONST(RFP)) ELSE IF (Procurement Method=CONST(RFQ)) "Procurement Re
            end;
        }
        field(25; "Global Dimension 3 Code"; Code[50])
        {
            CaptionClass = '1,1,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(26; "Record From SMS"; Boolean)
        {
        }
        field(27; "Customer Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Service Provider,Schemes,Staff,Vendors';
            OptionMembers = ,"Service Provider",Schemes,Staff,Vendors;
        }
        field(28; "Received From No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                IF Customer.GET("Received From No") THEN BEGIN
                    "Received From" := Customer.Name;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            CashMmtSetup.GET;
            CashMmtSetup.TESTFIELD(CashMmtSetup."Receipt No");
            NoSeriesMgt.InitSeries(CashMmtSetup."Receipt No", xRec."No. Series", 0D, "No.", "No. Series");
            Posted:=false;
            MESSAGE('doing it');
        END;
        GLSetup.GET;
        Cashier := USERID;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GLSetup: Record "Cash Management Setup";
        CashMmtSetup: Record "Cash Management Setup";
        ReceiptLines: Record "Receipt Lines";
        Customer: Record Customer;

    [Scope('Personalization')]
    procedure ReqLinesExist(): Boolean
    begin
        ReceiptLines.RESET;
        ReceiptLines.SETRANGE("Receipt No.", "No.");
        EXIT(ReceiptLines.FINDFIRST);
    end;
}

