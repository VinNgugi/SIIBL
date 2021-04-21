table 51404242 "Interaction Type Nt"
{
    // version SIAML CONSOLIDATION


    fields
    {
        field(1;"Interaction Type No.";Code[10])
        {
        }
        field(2;Description;Text[100])
        {
        }
        field(3;"Entry No.";Integer)
        {
        }
        field(4;Notes;Text[250])
        {
        }
        field(5;Status;Option)
        {
            OptionMembers = Logged,Assigned,Escalated,"Awaiting 3rd Party",Closed,Pending,"Awaiting Client",Reopened,ReAssigned,Resolved;
        }
        field(6;"Additional Notes";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"Interaction Type No.","Entry No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;Notes,Status,"Additional Notes")
        {
        }
    }

    trigger OnInsert()
    begin
        InterTypeNo.RESET;
        InterTypeNo.SETCURRENTKEY("Entry No.","Interaction Type No.");
        InterTypeNo.SETRANGE(InterTypeNo."Interaction Type No.","Interaction Type No.");
        IF InterTypeNo.FINDLAST THEN
         "Entry No." := InterTypeNo."Entry No." + 1
        ELSE
         "Entry No." := 1;
    end;

    var
        InterTypeNo: Record "Interaction Type Nt";
        EntryNo: Integer;
}

