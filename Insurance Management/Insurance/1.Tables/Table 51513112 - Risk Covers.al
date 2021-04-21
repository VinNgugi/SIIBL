table 51513112 "Risk Covers"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Policy No."; Code[20])
        {
        }
        field(2; "Risk ID"; Code[20])
        {
            TableRelation = "Risk Database";
        }
        field(3; "Cover No."; Integer)
        {
        }
        field(4; "Cover Start Date"; Date)
        {
        }
        field(5; "Cover End Date"; Date)
        {

            trigger OnValidate();
            begin
                "No. of Months" := InsMngt.GetNoOfMonths("Cover Start Date", "Cover End Date");
            end;
        }
        field(6; Select; Boolean)
        {
        }
        field(7; "Suspension Date"; Date)
        {
        }
        field(8; "Reason for Suspension"; Code[10])
        {
        }
        field(9; Status; Option)
        {
            Editable = false;
            OptionMembers = Active,Suspended,Substituted;
        }
        field(10; "Sum Insured"; Decimal)
        {
        }
        field(11; Rate; Decimal)
        {
        }
        field(12; Premium; Decimal)
        {
        }
        field(13; "Substitute Risk ID"; Code[20])
        {
            TableRelation = "Risk Database";
        }
        field(14; "Substitution Date"; Date)
        {
        }
        field(15; "Cert No."; Code[10])
        {
        }
        field(16; "Certificate Printed"; Boolean)
        {
        }
        field(17; "Re-instatement Date"; Date)
        {
        }
        field(18; "Extension Period"; DateFormula)
        {
        }
        field(19; "No. of Months"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Policy No.", "Risk Id", "Cover No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        RiskCoversRec.RESET;
        RiskCoversRec.SETRANGE(RiskCoversRec."Policy No.", "Policy No.");
        RiskCoversRec.SETRANGE(RiskCoversRec."Risk Id", "Risk Id");
        IF RiskCoversRec.FINDLAST THEN
            "Cover No." := RiskCoversRec."Cover No." + 1;
    end;

    var
        RiskCoversRec: Record "Risk Covers";
        InsMngt: Codeunit "Insurance management";
}

