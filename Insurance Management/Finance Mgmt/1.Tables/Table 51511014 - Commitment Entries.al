table 51511014 "Commitment Entries"
{
    // version FINANCE

    //DrillDownPageID = 51511913;
    //LookupPageID = 51511913;

    fields
    {
        field(1; "Entry No"; Integer)
        {
        }
        field(2; "Commitment Date"; Date)
        {
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Budget Line"; Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(6; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Commitment Type"; Option)
        {
            OptionCaption = ' ,LPO,LSO,IMPREST,PR';
            OptionMembers = " ",LPO,LSO,IMPREST,PR;
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(9; "Budget Year"; Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(10; "User ID"; Code[50])
        {
        }
        field(11; "Time Stamp"; Time)
        {
        }
        field(12; Description; Text[150])
        {
        }
        field(13; "Commitment No"; Code[20])
        {
        }
        field(15; Type; Option)
        {
            OptionCaption = ' ,Committed,Reversal,Reservation';
            OptionMembers = " ",Committed,Reversal,Reservation;
        }
        field(16; GLAccount; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(18; InvoiceNo; Code[20])
        {
        }
        field(19; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(20; No; Code[20])
        {
        }
        field(24; "Line No."; Integer)
        {
        }
        field(25; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset";

            trigger OnValidate()
            begin
                IF ObjGLAccount.GET("Account No.") THEN
                    "Account Name" := ObjGLAccount.Name;
            end;
        }
        field(26; "Account Name"; Text[100])
        {
        }
        field(28; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(29; "Uncommittment Date"; Date)
        {
        }
        field(30; WorkPlan; Code[50])
        {
        }
        field(31; "PE Admin Code"; Code[50])
        {
        }
        field(32; "Procurement Plan"; Code[50])
        {
        }
        field(33; Created; Boolean)
        {
        }
        field(34; "Source Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(35; "Unit Cost"; Decimal)
        {
        }
        field(36; Quantity; Integer)
        {
        }
        field(37; "Remaining Quanity"; Integer)
        {
        }
        field(38; "Item Budget Entry"; Boolean)
        {
        }
        field(39; Perdiem; Boolean)
        {
        }
        field(40; "Tuition Fee"; Boolean)
        {
        }
        field(41; "Air Fair"; Boolean)
        {
        }
        field(42; Memo; Boolean)
        {
        }
        field(43; "Memo Member"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(44; Committed; Decimal)
        {
            CalcFormula = Sum("Commitment Entries".Amount WHERE("Document No." = FIELD("Document No."),
                                                                 "Budget Year" = FIELD("Budget Year"),
                                                                 Memo = CONST(True),
                                                                 "Memo Member" = FIELD("Memo Member"),
                                                                 GLAccount = FIELD(GLAccount)));
            FieldClass = FlowField;
        }
        field(45; "Finance Released"; Boolean)
        {
        }
        field(46; "Finance Release Entry"; Boolean)
        {
        }
        field(47; "Procurement Plan Line"; Boolean)
        {
        }
        field(48; "Source No"; Code[20])
        {
        }
        field(49; "Procurement Plan Item No"; Integer)
        {
        }
        field(50; "Global Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
    }

    keys
    {
        key(Key1; "Entry No")
        {
        }
        key(Key2; "Budget Line", "Global Dimension 1 Code", "Global Dimension 2 Code", "Commitment Date", "Budget Year")
        {
            SumIndexFields = Amount;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Entry No", "Document No.", "Remaining Quanity")
        {
        }
    }

    var
        ObjGLAccount: Record "G/L Account";
        FixedAsset: Record "Fixed Asset";
        Item: Record Item;
}

