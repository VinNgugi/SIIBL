tableextension 50123 "Opportunity Ext" extends Opportunity
{
    fields
    {
        field(50100; "Insurance Type"; Option)
        {
            Caption = 'Insurance Type';
            DataClassification = ToBeClassified;
            OptionMembers = " ",General,Life;
        }
        field(50101; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1), Blocked = const(false));

        }
        field(50102; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2), Blocked = const(false));
        }
        field(50103; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3), Blocked = const(false));
        }
        field(50104; "Business Type"; Enum "Business Type")
        {

        }
        field(50105; "Sum Insured"; Decimal)
        {

        }
        field(50106; "Premium Amount"; Decimal)
        {

        }
        field(50107; "Commission Amount"; Decimal)
        {
            trigger OnValidate()
            var

            begin
                if "Commission Amount" <> 0 then
                    "Estimated Value (LCY)" := "Commission Amount";
            end;
        }
    }
}
