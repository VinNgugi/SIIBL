table 51513134 "Policies Issued"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Policy No."; Code[30])
        {
        }
        field(2; "Issued Date"; Date)
        {
        }
        field(3; "Issued Time"; Time)
        {
        }
        field(4; "Issued by"; Code[80])
        {
        }
        field(5; "Name of Person picking"; Text[80])
        {
        }
        field(6; "Registration No."; Code[20])
        {

            trigger OnValidate();
            begin
                InsureLinesRec.RESET;
                InsureLinesRec.SETCURRENTKEY(InsureLinesRec."Start Date");
                InsureLinesRec.SETRANGE(InsureLinesRec."Document Type", InsureLinesRec."Document Type"::Policy);
                InsureLinesRec.SETRANGE(InsureLinesRec.Status, InsureLinesRec.Status::Live);
                InsureLinesRec.SETRANGE(InsureLinesRec."Registration No.", "Registration No.");
                IF InsureLinesRec.FINDFIRST THEN BEGIN
                    "Policy No." := InsureLinesRec."Document No.";

                END;
            end;
        }
    }

    keys
    {
        key(Key1; "Registration No.", "Issued Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "Issued Date" := TODAY;
        "Issued Time" := TIME;
        "Issued by" := USERID;
    end;

    var
        InsureLinesRec: Record "Insure Lines";
}

