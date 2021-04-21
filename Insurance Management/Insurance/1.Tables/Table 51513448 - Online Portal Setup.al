table 51513448 "Online Portal Setup"
{
    // version AES-INS 1.0


    fields
    {
        field(1;CompanyName;Code[100])
        {
            TableRelation = Company.Name;
        }
        field(2;MaxFileUploadSize;Integer)
        {
        }
        field(3;DocumentPath;Text[30])
        {
        }
        field(4;XmlPath;Text[30])
        {
        }
        field(5;ScriptsPath;Text[30])
        {
        }
        field(6;MaxPasswordDays;Integer)
        {
        }
        field(7;PasswordReminderDays;Integer)
        {
        }
        field(8;MaxLoginAttempts;Integer)
        {
        }
        field(9;MaxNonAllowablePasswords;Integer)
        {
        }
        field(10;MinPasswordLength;Integer)
        {
        }
        field(11;ActivationLinkIP;Text[30])
        {
        }
        field(12;ExportFilePath;Text[30])
        {
        }
        field(13;UserManualPath;Text[30])
        {
        }
        field(14;SendAtIntervals;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;CompanyName)
        {
        }
    }

    fieldgroups
    {
    }
}

