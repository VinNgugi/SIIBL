table 51513161 "Insure Header Cover Selection"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            NotBlank = false;
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement;
        }
        field(2; "No."; Code[30])
        {
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(3; "Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Product Benefits & Riders"."Benefit Code";

            trigger OnValidate();
            begin
                IF InsureHeader.GET("Document Type", "No.") THEN
                    "Product Code" := InsureHeader."Policy Type";

                IF LoadDiscRec.GET(Code) THEN BEGIN

                    Description := LoadDiscRec."Benefit Name";
                    //"Discount %":=LoadDiscRec."Premium Rate";
                    "Loading %" := LoadDiscRec."Premium Rate";
                    //"Discount Amount":=LoadDiscRec."Amount Per Person";
                    "Loading Amount" := LoadDiscRec."Amount Per Person";
                END;
            end;
        }
        field(4; Description; Text[130])
        {
        }
        field(5; "Discount %"; Decimal)
        {
        }
        field(6; "Loading %"; Decimal)
        {
        }
        field(7; "Discount Amount"; Decimal)
        {
        }
        field(8; "Loading Amount"; Decimal)
        {
        }
        field(9; Selected; Boolean)
        {
        }
        field(10; Amount; Decimal)
        {
        }
        field(11; "Product Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LoadDiscRec: Record "Product Benefits & Riders";
        InsureHeader: Record "Insure Header";
}

