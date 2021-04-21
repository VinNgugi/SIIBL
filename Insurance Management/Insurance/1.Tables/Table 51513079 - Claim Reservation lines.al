table 51513079 "Claim Reservation lines"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513096;
    LookupPageID = 51513096;

    fields
    {
        field(1;"Claim No";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
        }
        field(3;"Reservation DateTime";DateTime)
        {
        }
        field(4;"Reservation date";Date)
        {
        }
        field(5;Type;Option)
        {
            OptionMembers = " ",Add,Reduce;
        }
        field(6;Amount;Decimal)
        {

            trigger OnValidate();
            begin
                   IF Type=Type::Add THEN
                   Amount:=ABS(Amount);
                   IF Type=Type::Reduce THEN
                   Amount:=-ABS(Amount);
            end;
        }
        field(7;Posted;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Claim No","Line No.","Reservation DateTime")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
           "Reservation DateTime":=CURRENTDATETIME;
    end;
}

