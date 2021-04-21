table 51511031 "Budget Approval"
{
    // version FINANCE


    fields
    {
        field(1; "Approval No"; Code[20])
        {
        }
        field(2; "Source Department"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
        }
        field(3; "Source G/L"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                glaccount.RESET;
                glaccount.SETFILTER("No.", "Source G/L");
                glaccount.SETFILTER("Budget Filter", "Current Budget");
                glaccount.SETFILTER("Global Dimension 1 Filter", "Source Department");

                IF glaccount.FINDSET THEN BEGIN
                    glaccount.CALCFIELDS(glaccount."Budgeted Amount");
                    "Source G/L Current Amount" := glaccount."Budgeted Amount"; //bd -will have to factor in Commitment
                END;
            end;
        }
        field(4; "Destination Department"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
        }
        field(5; "Destination G/L"; Code[20])
        {
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                glaccount.RESET;
                glaccount.SETFILTER("No.", "Destination G/L");
                glaccount.SETFILTER("Budget Filter", "Current Budget");
                glaccount.SETFILTER("Global Dimension 1 Filter", "Destination Department");

                IF glaccount.FINDSET THEN BEGIN
                    glaccount.CALCFIELDS(glaccount."Budgeted Amount");
                    "Destination G/L Current Amount" := glaccount."Budgeted Amount"; //bd -will have to factor in Commitment
                END;
            end;
        }
        field(6; "Amount Requested"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Destination G/L");
                "Destination G/L Amount After T" := "Destination G/L Current Amount" + "Amount Requested";
            end;
        }
        field(7; "Source G/L Current Amount"; Decimal)
        {
        }
        field(8; "Source G/L Amount After Transf"; Decimal)
        {
        }
        field(9; "Destination G/L Current Amount"; Decimal)
        {
        }
        field(10; "Destination G/L Amount After T"; Decimal)
        {
        }
        field(11; "Current Budget"; Code[20])
        {
        }
        field(12; "Requesting User"; Code[50])
        {
        }
        field(13; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Released,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;

            trigger OnValidate()
            begin
                //Open,Released,Pending Approval,Pending Prepayment,Rejected
            end;
        }
        field(14; "No. Series"; Code[20])
        {
        }
        field(15; "Reason For Request"; Text[250])
        {
        }
        field(16; "No of Approvers"; Integer)
        {
            FieldClass = Normal;
        }
        field(17; "Transfer Request Date"; Date)
        {
        }
        field(18; "Transfer Request Date and Time"; DateTime)
        {
        }
        field(19; "Total Amount"; Decimal)
        {
            //CalcFormula = Sum("Budget Reallocation Lines"."Transfer Amount" WHERE("Approval No" = FIELD("Approval No")));
            FieldClass = FlowField;
        }
        field(20; "Re-Allocation Message"; BLOB)
        {
        }
        field(21; "Reallocation Subject"; Text[250])
        {
        }
        field(22; "Finance Officer 1"; Code[50])
        {
            //TableRelation = "User Setup"."User ID" WHERE(Department = CONST('030'));
        }
        field(23; "Finance Officer 2"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(24; "Re-Allocation Posted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25; "From Station"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False),
                                                          "Global Dimension No." = CONST(2));
        }
        field(26; "To Station"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Value Type" = CONST(Standard),
                                                          Blocked = CONST(False),
                                                          "Global Dimension No." = CONST(2));
        }
    }

    keys
    {
        key(Key1; "Approval No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        IF Status <> Status::Open THEN BEGIN
            ERROR('You cannot Delete Budget Changes at this stage...');
        END;
    end;

    trigger OnInsert()
    begin

        IF UsersRec.GET(USERID) THEN BEGIN
            //  "To Station":=UsersRec."Global Dimension 2 Code";
            //"Destination Department" := UsersRec.Department;
            /*
          IF Empl.GET(UsersRec."Employee No.") THEN
          BEGIN
           "Destination Department":=Empl."Global Dimension 1 Code";
          END;
          */
        END;


        /* glsetup.GET; //error('3....99');
        glsetup.TESTFIELD("Budget Approvals No.");
        NoSeriesMgt.InitSeries(glsetup."Budget Approvals No.", xRec."Approval No", 0D, "Approval No", "No. Series");
        "Current Budget" := glsetup."Current Budget";
        "Requesting User" := USERID;
        "Transfer Request Date" := TODAY;
        "Transfer Request Date and Time" := CURRENTDATETIME;
        glsetup.TESTFIELD("Finance Department");

        Dimensionvalue.RESET;
        Dimensionvalue.SETFILTER("Global Dimension No.", '%1', 1);
        Dimensionvalue.SETFILTER(Code, glsetup."Finance Department");
        Dimensionvalue.FINDSET;
        "Finance Officer 1" := Dimensionvalue.HOD; */

    end;

    trigger OnModify()
    begin
        // IF Status<>Status::Open THEN BEGIN
        //   //ERROR('You cannot Modify Budget Changes at this stage...');
        // END;
    end;

    var
        glsetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UsersRec: Record "User Setup";
        Empl: Record Employee;
        glaccount: Record "G/L Account";
        Dimensionvalue: Record "Dimension Value";
        //BudgetReallocationLines: Record 51511329;

    [Scope('Personalization')]
    procedure ReqLinesExist(): Boolean
    begin
       /*  BudgetReallocationLines.RESET;
        BudgetReallocationLines.SETRANGE("Approval No", "Approval No");
        EXIT(BudgetReallocationLines.FINDFIRST); */
    end;
}

