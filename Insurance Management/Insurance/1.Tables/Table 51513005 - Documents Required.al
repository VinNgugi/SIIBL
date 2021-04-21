table 51513005 "Documents Required"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Transaction Type"; Option)
        {
            OptionCaption = '" ,Underwriting,Claims';
            OptionMembers = " ",Underwriting,Claims;
        }
        field(2; "Policy Type"; Code[20])
        {
            //TableRelation = "Policy Type";
        }
        field(3; "Code"; Code[20])
        {
            TableRelation = IF ("Transaction Type" = CONST(Underwriting)) "Endorsement Types".Code
            ELSE
            IF ("Transaction Type" = CONST(Claims)) "Loss Type".Code;

            trigger OnValidate();
            var
            EndorsementRec:Record "Endorsement Types";
            LossTypeRec: Record "Loss Type";
            begin
                IF "Transaction Type"="Transaction Type"::Underwriting THEN
                  IF EndorsementRec.GET(Code) THEN
                    Description:=EndorsementRec.Description;

                IF "Transaction Type"="Transaction Type"::Claims THEN
                  IF LosstypeRec.GET(Code) THEN
                    Description:=LosstypeRec.Description;
            end;
        }
        field(4; Description; Text[30])
        {
        }
        field(5; "Document Name"; Text[40])
        {
            TableRelation = "Document Setup";
        }
        field(6; Mandatory; Boolean)
        {
        }
        field(7; "Insurer Code"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Transaction Type", "Policy Type","Insurer Code", "Code", "Document Name")
        {
        }
    }

    fieldgroups
    {
    }

    var
    //EndorsementRec : Record Endorsement Types;
    //LosstypeRec : Record "Loss Type";
    //DocSetup : Record "51513004";
}

