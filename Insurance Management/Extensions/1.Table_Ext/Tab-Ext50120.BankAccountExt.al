tableextension 50120 "Bank Account Ext" extends "Bank Account"
{
    fields
    {
        field(50000; "WB Account"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Tag Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = Table0;
        }
        field(50002; "Tag Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            // TableRelation = Table0;
        }
        field(50003; "Payments No"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50007; "Previously Yr Unpresented Chqs"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(51004; "Bank Account Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51005; "Global Dimension 6 Filter"; Code[20])
        {
            CaptionClass = '1,3,6';
            Caption = 'Global Dimension 6 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(51006; "Global Dimension 7 Filter"; Code[20])
        {
            CaptionClass = '1,3,72';
            Caption = 'Global Dimension 7 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(51007; "Global Dimension 6 Code"; Code[20])
        {
            Caption = 'Global Dimension 6 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(6,"Global Dimension 7 Code");
            end;
        }
        field(51008; "Global Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,1,7';
            Caption = 'Global Dimension 7 Code';
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(7,"Global Dimension 7 Code");
            end;
        }
        field(51009; "Bank Branch Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."Bank Branch No.";
        }
        field(53000; "Bank Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = Normal,"Petty Cash";
        }
        field(53001; "Last Deposit No"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(53002; "Deposit to Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(53003; "Cheque Collection Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(53004; "Cash Collection Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(53005; "Call Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(53006; Custodian; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value";
        }
        field(53007; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Open,Pending Approval,Rejected,Released';
            OptionMembers = Open,"Pending Approval",Rejected,Released;
        }
    }
}
