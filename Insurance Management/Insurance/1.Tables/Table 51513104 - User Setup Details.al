table 51513104 "User Setup Details"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "User ID"; Code[80])
        {
        }
        field(2; Location; Code[20])
        {
            TableRelation = Location;
        }
        field(3; Employee; Code[20])
        {
            TableRelation = Employee;
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");
            end;
        }
        field(5; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Global Dimension 2 Code");
            end;
        }
        field(6; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(3,"Global Dimension 1 Code");
            end;
        }
        field(7; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Global Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(4,"Global Dimension 2 Code");
            end;
        }
        field(8; Signature; BLOB)
        {
            SubType = Bitmap;
        }
        field(9; "Default Receipting Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(10; "Default Payment Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(11; "Sales Person Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
        }
        field(12; "Sales Agent Code"; Code[20])
        {
            TableRelation = Vendor."No." where("Vendor Type" = const(Agent));
        }
    }

    keys
    {
        key(Key1; "User ID")
        {
        }
    }

    fieldgroups
    {
    }

    var
        DimMgt: Codeunit 408;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"User Setup Details", "User ID", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;
}

