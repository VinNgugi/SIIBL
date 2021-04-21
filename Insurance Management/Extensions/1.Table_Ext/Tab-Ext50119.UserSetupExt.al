tableextension 50119 "User Setup Ext" extends "User Setup"
{
    fields
    {
        field(50000; "Employee No."; Code[20])
        {

        }
        field(50011; Location; Code[20])
        {
            TableRelation = Location;
        }
        
        field(50002; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(50003; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(50004; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(3,"Global Dimension 1 Code");
            end;
        }
        field(50005; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Global Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(4,"Global Dimension 2 Code");
            end;
        }
        field(50006; Signature; BLOB)
        {
            SubType = Bitmap;
        }
        field(50007; "Default Receipting Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(50010; "Default Payment Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(50008; "Sales Person Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(50009; "Sales Agent Code"; Code[20])
        {
            TableRelation = Vendor."No." where("Vendor Type" = const(Agent));
        }
    }
}
