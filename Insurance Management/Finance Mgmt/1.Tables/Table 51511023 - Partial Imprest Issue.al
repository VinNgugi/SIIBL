table 51511023 "Partial Imprest Issue"
{
    // version FINANCE

    //DrillDownPageID = 51511903;
    //LookupPageID = 51511903;

    fields
    {
        field(1;"Imprest No";Code[20])
        {
        }
        field(2;"Line No";Integer)
        {
        }
        field(3;"Employee No";Code[20])
        {
        }
        field(4;Date;Date)
        {
        }
        field(5;"Approved Amount";Decimal)
        {
        }
        field(6;"Amount Already Issued";Decimal)
        {
        }
        field(7;"Remaining Amount";Decimal)
        {
        }
        field(8;"Amount to Issue";Decimal)
        {

            trigger OnValidate()
            begin
                CALCFIELDS("Amount Issued to date");
                IF ("Amount Issued to date" + "Amount to Issue") > "Approved Amount" THEN
                ERROR(Text000,"Amount to Issue","Approved Amount",(("Amount Issued to date" + "Amount to Issue") - "Approved Amount"));
            end;
        }
        field(9;"Pay Mode";Code[10])
        {
            TableRelation = "Pay Modes";
        }
        field(10;"User ID";Code[50])
        {
        }
        field(11;Posted;Boolean)
        {
            Editable = false;
        }
        field(12;"Posted Date";DateTime)
        {
        }
        field(13;"Amount Issued to date";Decimal)
        {
            CalcFormula = Sum("Partial Imprest Issue"."Amount to Issue" WHERE ("Imprest No"=FIELD("Imprest No"),
                                                                               Posted=FILTER(true)));
            FieldClass = FlowField;
        }
        field(14;"Imprest Dead Line";Date)
        {
        }
        field(15;"Select to Surrender";Boolean)
        {
        }
        field(16;Surrendered;Boolean)
        {
        }
        field(17;"PV Created";Boolean)
        {
        }
        field(18;Partial;Boolean)
        {
        }
    }

    keys
    {
        key(Key1;"Imprest No","Line No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Text000: Label 'If you issue Amount %1,the total issued Amount will be more than the Approved Imprest Amount of %2 by %3';
}

