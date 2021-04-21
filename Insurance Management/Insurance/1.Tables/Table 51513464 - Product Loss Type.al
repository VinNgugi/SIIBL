table 51513464 "Product Loss Type"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Code"; Code[20])
        {
            TableRelation="Loss Type";
            trigger OnValidate()
            var
                
            begin
                If LossTypeRec.GET(code) then
                Description:=LossTypeRec.Description;
            end;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Minimum Reserve"; Decimal)
        {
        }
        field(4; "Reserve calculation type"; Option)
        {
            OptionMembers = " ","Flat Amount","Full Value","% of Full Value";
        }
        field(5; Percentage; Decimal)
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = '" ,Accident+Third Party,Theft,Fire,Own Damage"';
            OptionMembers = " ","Accident+Third Party",Theft,Fire,"Own Damage";
        }
        field(7; "Excess Required"; Decimal)
        {
        }
        field(8; "Cover Type"; Code[20])
        {
            //TableRelation = "Policy Type";
        }
        field(9; "Underwriter Code"; Code[20])
        {
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "Cover Type", "Code","Underwriter Code")
        {
        }
    }

    fieldgroups
    {
    }
    Var 
    LossTypeRec:Record "Loss Type";
}

