table 51513034 "Insure Header Loading_Discount"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            NotBlank = false;
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement,Insurer Quotes"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement,"Insurer Quotes";
        }
        field(2; "No."; Code[30])
        {
            //TableRelation = "Insure Header"."No." WHERE ("Document Type"=FIELD("Document Type"));
        }
        field(3;"Code";Code[20])
        {
            NotBlank = true;
            TableRelation = "Loading and Discounts Setup";

            trigger OnValidate();
            begin


                      IF LoadDiscRec.GET(Code) THEN
                      BEGIN

                       Description:=LoadDiscRec.Description;
                      "Discount %":=LoadDiscRec."Discount Percentage";
                      "Loading %":=LoadDiscRec."Loading Percentage";
                      "Discount Amount":=LoadDiscRec."Discount Amount";
                      "Loading Amount":=LoadDiscRec."Loading Amount";
                       END;
            end;
        }
        field(4;Description;Text[130])
        {
        }
        field(5;"Discount %";Decimal)
        {
        }
        field(6;"Loading %";Decimal)
        {
        }
        field(7;"Discount Amount";Decimal)
        {
        }
        field(8;"Loading Amount";Decimal)
        {
        }
        field(9;Selected;Boolean)
        {
        }
        field(10;Amount;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;"Document Type","No.","Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LoadDiscRec : Record "Loading and Discounts Setup";
}

