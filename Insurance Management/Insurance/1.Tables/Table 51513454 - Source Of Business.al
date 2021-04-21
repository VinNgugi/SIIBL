table 51513454 "Source Of Business"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513465;
    LookupPageID = 51513465;

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Description;Text[30])
        {
        }
        field(3;Type;Option)
        {
            OptionCaption = '" ,Employee,Customer,Vendor,Contact"';
            OptionMembers = " ",Employee,Customer,Vendor,Contact;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

