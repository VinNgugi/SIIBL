table 51513062 "ICD 10 Codes"
{
    // version AES-INS 1.0


    fields
    {
        field(1;"ICD10 Code";Code[10])
        {
            NotBlank = true;
        }
        field(2;Description;Text[250])
        {
        }
        field(3;"Moratorium Period";DateFormula)
        {
        }
        field(4;Remarks;Option)
        {
            OptionMembers = "No remarks",exclude,"don't exclude","do not offer terms";
        }
        field(5;"ACTUAL CODE";Option)
        {
            OptionMembers = "1222","1333";
        }
    }

    keys
    {
        key(Key1;"ICD10 Code")
        {
        }
    }

    fieldgroups
    {
    }
}

