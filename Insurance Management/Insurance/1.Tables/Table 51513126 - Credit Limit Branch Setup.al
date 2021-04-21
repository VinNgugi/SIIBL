table 51513126 "Credit Limit Branch Setup"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513119;
    LookupPageID = 51513119;

    fields
    {
        field(1; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No."=CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
                IF GLSetup.GET THEN
                    IF DimVal.GET(GLSetup."Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code") THEN
                        "Branch Name" := DimVal.Name;
                //MESSAGE('%1',"Branch Name");
            end;
        }
        field(2; "Effective Date"; Date)
        {
        }
        field(3; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                IF Insetup.GET THEN
                    Insetup.CALCFIELDS(Insetup."Total Branch Credit Allocation");
                IF Insetup."Total Branch Credit Allocation" > Insetup."Company Credit Limit" THEN
                    ERROR('you cannot exceed the company credit limit');
            end;
        }
        field(4; Percentage; Decimal)
        {

            trigger OnValidate();
            begin
                IF GLSetup.GET THEN
                    IF Insetup.GET THEN
                        IF Percentage <> 0 THEN
                            Amount := Insetup."Company Credit Limit" * (Percentage / 100);
                VALIDATE(Amount);
            end;
        }
        field(5; "Branch Name"; Text[30])
        {
        }
        field(6; "Applied Credit Amount"; Decimal)
        {
            CalcFormula = Sum("Credit Request"."Credit Amount" WHERE("Shortcut Dimension 1 Code"=FIELD("Shortcut Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(7;"Approved Credit Amount";Decimal)
        {
            CalcFormula = Sum("Credit Request"."Credit Amount" WHERE ("Shortcut Dimension 1 Code"=FIELD("Shortcut Dimension 1 Code"),
                                                                      Status=CONST(Released)));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Shortcut Dimension 1 Code","Effective Date")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Insetup : Record "Insurance setup";
        GLSetup : Record "General Ledger Setup";
        DimVal : Record "Dimension Value";
}

