table 51513200 "SMS Setup"
{

    fields
    {
        field(1;"Vendor Name";Code[20])
        {
            NotBlank = false;
        }
        field(2;URL;Text[250])
        {
        }
        field(3;"Message Parameter";Text[100])
        {
            NotBlank = true;
        }
        field(4;"Phone Parameter";Text[100])
        {
            NotBlank = true;
        }
        field(5;Status;Option)
        {
            OptionMembers = " ",Active,Inactive;
        }
        field(6;"Phone Prefix";Text[10])
        {
        }
        field(7;"Sender ID";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Vendor Name")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Status : Text[30];
}

