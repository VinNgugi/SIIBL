table 51513105 "Underwriter Receipt"
{



    Caption = 'Underwriter Receipt';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No.";
        Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Date Receipted"; Date)
        {
            Caption = 'Date Receipted';
            DataClassification = ToBeClassified;
        }
        field(3; "Insurer Receipt No."; Code[30])
        {
            Caption = 'Insurer Receipt No.';
            DataClassification = ToBeClassified;
        }
        field(4; "Insured No."; Code[20])
        {
            Caption = 'Insured No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
            trigger OnValidate()
            var

            begin
                IF cust.GET("Insured No.") then
                    "Insured Name" := Cust.Name;
            end;

        }
        field(5; "Insured Name"; Text[250])
        {
            Caption = 'Insured Name';
            DataClassification = ToBeClassified;
        }
        field(6; "Debit Note No."; Code[20])
        {
            Caption = 'Debit Note No.';
            DataClassification = ToBeClassified;
            Tablerelation = "Insure Debit Note" where("Insured No." = FIELD("Insured No."));

        }
        field(7; "Instalment No."; Integer)



        {
            Caption = 'Instalment No.';
            DataClassification = ToBeClassified;
            Tablerelation = "Instalment Payment plan"."Payment No" where("Document No." = FIELD("Debit Note No."));

            trigger OnValidate()

            begin
                Instalplan.reset;
                InstalPlan.SETRAnGE(Instalplan."Document No.", "Debit Note No.");
                InstalPlan.SetRange(Instalplan."Payment No", "Instalment No.");
                If InstalPlan.FindFirst() then begin
                    "Amount Due" := InstalPlan."Amount Due";
                    "Instalment Due date" := InstalPlan."Due date";
                end;
            end;
        }
        field(8; "Instalment Due Date"; Date)
        {
            Caption = 'Instalment Due Date';
            DataClassification = ToBeClassified;
        }
        field(9; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            DataClassification = ToBeClassified;
        }

        field(10; "Amount Due"; Decimal)
        {
            Editable = FALSE;
        }
        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(12; Acknowledged; Boolean)
        {
            Caption = 'Acknowledged';
            DataClassification = ToBeClassified;
        }
        field(13; "No. series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(14; "User ID"; Code[80])
        {

        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    trigger OnInsert();
    begin

        IF "No." = '' THEN BEGIN

            GLSetup.GET;
            GLSetup.TESTFIELD(GLSetup."Underwriter Receipt Nos.");
            NoSeriesMgt.InitSeries(GLSetup."Underwriter Receipt Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            "Date Receipted" := TODAY;
            "User Id" := USERID;
            //"Receipt Amount type":="Receipt Amount type"::Gross;

        END;
    end;

    var
        GLSetup: record "Cash management setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cust: Record Customer;
        InstalPlan: record "Instalment payment plan";


}
