table 51511052 "Memo Lines-Members"
{
    // version FINANCE


    fields
    {
        field(1; "Memo No"; Code[20])
        {
        }
        field(2; "Budget Name"; Code[20])
        {
        }
        field(3; Department; Code[20])
        {
        }
        field(4; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(5; "Member ID"; Code[50])
        {
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                usersetup.RESET;
                usersetup.GET("Member ID");
                //"Member Name" := usersetup.Name;

                IF "Member Name" = '' THEN BEGIN
                    "Member Name" := "Member ID";
                END;
            end;
        }
        field(8; "Member Name"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Memo No", "Budget Name", Department, "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        gl: Record "G/L Account";
        usersetup: Record "User Setup";
}

