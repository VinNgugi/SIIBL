table 51513074 "Credit Request"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513138;
    LookupPageID = 51513138;

    fields
    {
        field(1; "Request No."; Code[20])
        {
        }
        field(2; "Request Date"; Date)
        {
            Editable = false;
        }
        field(3; "Request Time"; Time)
        {
            Editable = false;
        }
        field(4; "Recommended By"; Code[80])
        {
            Editable = false;
        }
        field(5; "Credit Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                CALCFIELDS("Total Approved Credit");
                //MESSAGE('%1 %2',"Branch Credit Amount","Total Approved Credit");
                IF "Credit Amount" > ("Branch Credit Amount" - "Total Approved Credit") THEN
                    ERROR('The amount exceeds what is available for your branch. Kindly reduce the amount and try again');
            end;
        }
        field(6; "Credit Period"; DateFormula)
        {

            trigger OnValidate();
            begin
                VALIDATE("Credit Start Date");
            end;
        }
        field(7; "Customer ID"; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                IF Cust.GET("Customer ID") THEN
                    "Customer Name" := Cust.Name;
            end;
        }
        field(8; "Customer Name"; Text[50])
        {
            Editable = false;
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                BranchCrSetup.RESET;
                BranchCrSetup.SETRANGE(BranchCrSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                IF BranchCrSetup.FINDLAST THEN
                    "Branch Credit Amount" := BranchCrSetup.Amount;
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(11; "Dimension Set ID"; Integer)
        {
        }
        field(104; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Expired';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Expired;
        }
        field(105; "Credit Start Date"; Date)
        {

            trigger OnValidate();
            begin
                "Credit End Date" := CALCDATE("Credit Period", "Credit Start Date");
            end;
        }
        field(106; "Credit End Date"; Date)
        {
        }
        field(107; "No. Series"; Code[10])
        {
        }
        field(108; "Customer Balance"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("Customer ID"),
                                                                                 "Insurance Trans Type" = CONST("Net Premium")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(109; "Branch Balance"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Initial Entry Global Dim. 1" = FIELD("Shortcut Dimension 1 Code"),
                                                                                 "Insurance Trans Type" = CONST("Net Premium")));

        }
        field(110; "Branch Credit Amount"; Decimal)
        {
        }
        field(111; "Available Credit"; Decimal)
        {
        }
        field(112; "Total Approved Credit"; Decimal)
        {
            CalcFormula = Sum("Credit Request"."Credit Amount" WHERE("Shortcut Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"),
                                                                      Status = CONST(Released)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Request No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Request No." = '' THEN BEGIN
            InsSetup.GET;
            InsSetup.TESTFIELD(InsSetup."Credit Request Nos");
            NoSeriesMgt.InitSeries(InsSetup."Credit Request Nos", xRec."No. Series", 0D, "Request No.", "No. Series");
        END;

        IF UserSetupDetails.GET(USERID) THEN BEGIN
            "Shortcut Dimension 1 Code" := UserSetupDetails."Global Dimension 1 Code";
            VALIDATE("Shortcut Dimension 1 Code");
            "Shortcut Dimension 2 Code" := UserSetupDetails."Global Dimension 2 Code";
        END;

        "Request Date" := TODAY;
        "Request Time" := TIME;
        "Recommended By" := USERID;
        "Credit Start Date" := TODAY;
        "Credit End Date" := CALCDATE("Credit Period", "Credit Start Date");
    end;

    var
        InsSetup: Record "Insurance setup";
        DimMgt: Codeunit 408;
        Cust: Record Customer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserSetupDetails: Record "User Setup Details";
        BranchCrSetup: Record "Credit Limit Branch Setup";

    procedure TestNoSeries(): Boolean;
    begin
        InsSetup.GET;

        /*CASE "Document Type" OF
          "Document Type"::Quote:
          BEGIN
            InsSetup.TESTFIELD(InsSetup."New Quotation Nos");
            InsSetup.TESTFIELD(InsSetup."Renewal Quote Nos");
            InsSetup.TESTFIELD(InsSetup."Modification Quote Nos");
          END;
          "Document Type"::"Debit Note":
            BEGIN
              //SalesSetup.TESTFIELD("Invoice Nos.");
              //SalesSetup.TESTFIELD("Posted Invoice Nos.");
            END;
        
           // SalesSetup.TESTFIELD("Return Order Nos.");
          "Document Type"::"Credit Note":
            BEGIN
             // SalesSetup.TESTFIELD("Credit Memo Nos.");
             // SalesSetup.TESTFIELD("Posted Credit Memo Nos.");
            END;
         // "Document Type"::policy:
          // InsSetup.TESTFIELD(InsSetup."Policy Nos");
        END;*/

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        //OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "Request No." <> '' THEN
            MODIFY;

        /*IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF SalesLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;*/

    end;
}

