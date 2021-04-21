table 51511034 "Levy Receipt Header"
{
    // version FINANCE

    //DrillDownPageID = 51511629;
    //LookupPageID = 51511629;

    fields
    {
        field(1; No; Code[20])
        {
        }
        field(2; "Scheme Registration No."; Code[50])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin

                IF SchemeRec.GET("Scheme Registration No.") THEN
                    IF Type = Type::Batch THEN BEGIN
                        "Scheme Name" := SchemeRec.Name;
                        "Paid in By" := SchemeRec.Name;
                    END ELSE BEGIN
                        "Scheme Name" := SchemeRec.Name;
                        "Paid in By" := SchemeRec.Name;
                        /* IF (SchemeRec.CustomerTypeID = 1) THEN BEGIN
                            LevyReceiptLines.RESET;
                            LevyReceiptLines.SETRANGE(LevyReceiptLines."Document No.", No);
                            // LevyReceiptLines.SETRANGE(LevyReceiptLines."Customer No.","Scheme Registration No.");
                            IF (LevyReceiptLines.FIND('-')) THEN BEGIN
                                LevyReceiptLines."Customer No." := SchemeRec."No.";
                                LevyReceiptLines.VALIDATE("Customer No.");
                                LevyReceiptLines.CALCFIELDS(LevyReceiptLines."Amount Due");
                                // LevyReceiptLines.Amount:=LevyReceiptLines."Amount Due";
                                LevyReceiptLines."In Payment For" := SchemeRec.Name;
                                LevyReceiptLines."Account Type" := LevyReceiptLines."Account Type"::Customer;
                                LevyReceiptLines."Account No." := LevyReceiptLines."Customer No.";
                                LevyReceiptLines.MODIFY(TRUE);
                            END ELSE BEGIN
                                LevyReceiptLines.INIT;
                                LevyReceiptLines."Document No." := No;
                                //LevyReceiptLines."Receipt No.":='';
                                LevyReceiptLines."Customer No." := SchemeRec."No.";
                                LevyReceiptLines.VALIDATE("Customer No.");
                                LevyReceiptLines.CALCFIELDS(LevyReceiptLines."Amount Due");
                                //LevyReceiptLines.Amount:=LevyReceiptLines."Amount Due";
                                LevyReceiptLines."In Payment For" := SchemeRec.Name;
                                LevyReceiptLines."Account Type" := LevyReceiptLines."Account Type"::Customer;
                                LevyReceiptLines."Account No." := LevyReceiptLines."Customer No.";
                                //IF NOT  LevyReceiptLines.GET(LevyReceiptLines."Receipt No.",No) THEN
                                LevyReceiptLines.INSERT(TRUE)
                                //ELSE LevyReceiptLines.MODIFY(TRUE);

                            END;
                        END ELSE BEGIN
                            LevyReceiptLines.SETRANGE(LevyReceiptLines."Document No.", No);
                            IF (LevyReceiptLines.FIND('-')) THEN BEGIN
                                REPEAT
                                    LevyReceiptLines."Customer No." := '';
                                    LevyReceiptLines.MODIFY;
                                UNTIL LevyReceiptLines.NEXT = 0;
                            END;
                        END;*/
                    END; 
            end;
        }
        field(3; "Scheme Name"; Text[200])
        {
        }
        field(4; Amount; Decimal)
        {
            CalcFormula = Sum("Levy Receipt Lines".Amount WHERE("Document No." = FIELD(No)));
            FieldClass = FlowField;
        }
        field(5; "Payment Mode"; Code[20])
        {
            TableRelation = "Payment Method";
        }
        field(6; "Cheque Drawer"; Text[200])
        {
        }
        field(7; "Receipt Date"; Date)
        {
        }
        field(8; "Cheque Date"; Date)
        {
        }
        field(9; "Cheque Name"; Text[50])
        {
        }
        field(10; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(11; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Paid in By"; Text[200])
        {
        }
        field(13; "External Document No."; Code[20])
        {
        }
        field(14; Posted; Boolean)
        {
        }
        field(15; "Cheque No."; Code[20])
        {
        }
        field(16; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(17; "Global Dimension 1 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; "Global Dimension 2 Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(19; "Posted Date"; Date)
        {
        }
        field(20; "Posted Time"; Time)
        {
        }
        field(21; "Posted By"; Code[20])
        {
        }
        field(22; "Amount (LCY)"; Decimal)
        {
        }
        field(23; Cashier; Code[20])
        {
        }
        field(24; Type; Option)
        {
            OptionCaption = 'Normal,Batch';
            OptionMembers = Normal,Batch;
        }
        field(25; "No Printed"; Integer)
        {
        }
        field(26; "Receipt Type"; Option)
        {
            OptionCaption = 'Levy,Penalty,Fees';
            OptionMembers = Levy,Penalty,Fees;
        }
        field(27; Bank; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(28; "Financial Year"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(29; Reversal; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(30; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Reversal Entries Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF No = '' THEN BEGIN
            LevySetup.GET;
            LevySetup.TESTFIELD(LevySetup."Levy Nos");
            NoSeriesMgt.InitSeries(LevySetup."Levy Nos", xRec."No. Series", 0D, No, "No. Series");
        END;
    end;

    var
        SchemeRec: Record Customer;
        LevySetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        LevyReceiptLines: Record "Levy Receipt Lines";
        RecLines: Record "Levy Receipt Lines";
}

