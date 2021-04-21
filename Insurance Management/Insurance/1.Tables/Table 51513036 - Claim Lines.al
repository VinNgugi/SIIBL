table 51513036 "Claim Lines"
{
    // version AES-INS 1.0

    //DrillDownPageID = 51513063;
    //LookupPageID = 51513063;

    fields
    {
        field(1; "Claim No"; Code[20])
        {
        }
        field(2; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Type; Option)
        {
            OptionCaption = 'Vendor,G/L Account';
            OptionMembers = Vendor,"G/L Account";
        }
        field(4; No; Code[20])
        {
            TableRelation = IF (Type = CONST(Vendor)) Vendor
            ELSE
            IF (Type = CONST("G/L Account")) "G/L Account";

            trigger OnValidate();
            begin

                CASE Type OF
                    Type::Vendor:
                        BEGIN
                            IF Vendor.GET(No) THEN BEGIN
                                "Account Name" := Vendor.Name;
                            END;
                        END;
                    Type::"G/L Account":
                        BEGIN
                            IF GLAccount.GET(No) THEN BEGIN
                                "Account Name" := GLAccount.Name;
                            END;
                        END;
                END;
            end;
        }
        field(5; "Account Name"; Text[70])
        {
        }
        field(6; Description; Text[100])
        {
        }
        field(7; "Claim Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                "Claim Amount(LCY)" := "Claim Amount";
            end;
        }
        field(8; "Claim Amount(LCY)"; Decimal)
        {
        }
        field(9; "Excess Amount"; Decimal)
        {

            trigger OnValidate();
            begin
                "Excess Amount(LCY)" := "Excess Amount";
            end;
        }
        field(10; "Excess Amount(LCY)"; Decimal)
        {
        }
        field(11; Currency; Code[20])
        {
            TableRelation = Currency;
        }
        field(12; "Shortcut  Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(14; "Claimant Name"; Text[50])
        {
        }
        field(15; "Claimant Attorney"; Text[30])
        {
        }
        field(16; "Reserve Amount"; Decimal)
        {
        }
        field(17; "Medical Expenses"; Decimal)
        {
        }
        field(18; TDD; Decimal)
        {
        }
        field(19; PTD; Decimal)
        {
        }
        field(20; Property; Decimal)
        {
        }
        field(21; "Claimant ID"; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST(Claimant));

            trigger OnValidate();
            begin
                IF Vendor.GET("Claimant ID") THEN BEGIN
                    "Claimant Name" := Vendor.Name;
                END;
            end;
        }
        field(22; "Claimant Attorney ID"; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));

            trigger OnValidate();
            begin
                IF Vendor.GET("Claimant Attorney ID") THEN BEGIN
                    "Claimant Attorney" := Vendor.Name;
                END;
            end;
        }
        field(23; "Case No"; Code[20])
        {
            TableRelation = Litigations;

            trigger OnValidate();
            begin
                IF Litigation.GET("Case No") THEN BEGIN
                    "Law Court No." := Litigation."Law Court";
                    VALIDATE("Law Court No.");
                    "Claimant Attorney ID" := Litigation."Third Party Lawyer";
                    VALIDATE("Claimant Attorney ID");
                    "Our Attorney" := Litigation."Law Firm";
                    VALIDATE("Our Attorney");
                END;
            end;
        }
        field(24; "Law Court No."; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law courts"));

            trigger OnValidate();
            begin
                IF Vendor.GET("Law Court No.") THEN BEGIN
                    "Law Court Name" := Vendor.Name;
                END;
            end;
        }
        field(25; "Law Court Name"; Text[30])
        {
        }
        field(26; "Our Attorney"; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));

            trigger OnValidate();
            begin
                IF Vendor.GET("Our Attorney") THEN BEGIN
                    "Our Attorney Name" := Vendor.Name;
                END;
            end;
        }
        field(27; "Our Attorney Name"; Text[30])
        {
        }
        field(28; "Reserve Amounts"; Decimal)
        {
            CalcFormula = Sum("Claim Reservation lines".Amount WHERE("Claim No" = FIELD("Claim No"),
                                                                      "Line No." = FIELD("Line No")));
            FieldClass = FlowField;
        }
        field(29; "Amount Paid"; Decimal)
        {
            FieldClass = FlowField;
            //CalcFormula = Sum("Payment Signatories".Field6 WHERE (Field12=FIELD("Claim No"),
            //                                                      Field20=FIELD("Line No")));

        }
        field(30; "Document No."; Code[20])
        {
        }
        field(31; "Document Date"; Date)
        {
        }
        field(32; Paid; Boolean)
        {
        }
        field(33; "Reinsurer Share"; Decimal)
        {
        }
        field(34; "Our Share"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Claim No", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        Litigation: Record Litigations;
}

