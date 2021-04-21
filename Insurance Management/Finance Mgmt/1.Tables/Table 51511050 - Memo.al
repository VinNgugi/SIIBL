table 51511050 Memo
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
        field(4; "Created By:"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(5; "Date Created"; Date)
        {
        }
        field(6; "No. Series"; Code[20])
        {
        }
        field(7; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Released';
            OptionMembers = Open,"Pending Approval",Released;
        }
        field(8; "No. of Approvers"; Integer)
        {
        }
        field(9; "Memo Header"; Text[250])
        {
        }
        field(10; "Memo Body"; Text[250])
        {
        }
        field(11; "Customer No:"; Code[20])
        {
            TableRelation = Customer;
        }
        field(12; "Memo Amount"; Decimal)
        {
            CalcFormula = Sum("Memo Lines".Amount WHERE("Memo No" = FIELD("Memo No")));
            FieldClass = FlowField;
        }
        field(13; "Employee No."; Code[20])
        {
            TableRelation = Employee;
        }
        field(14; "Amount in Commitment"; Decimal)
        {
            CalcFormula = Sum("Commitment Entries".Amount WHERE("Document No." = FIELD("Memo No"),
                                                                 Memo = CONST(True)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Memo No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF UsersRec.GET(USERID) THEN BEGIN

            IF Empl.GET(UsersRec."Employee No.") THEN BEGIN
                "Employee No." := "Employee No.";
                Department := Empl."Global Dimension 1 Code";
                dimensionvalue.RESET;
                dimensionvalue.GET('DEPARTMENT', Department);
                //IF USERID <> dimensionvalue.HOD THEN BEGIN
                //    ERROR('Only HOD of the Department can Create the Budget!');
                //END;
                /*empmap.RESET;
                empmap.SETFILTER("Employee No.", Empl."No.");
                empmap.SETFILTER("Loan Type", 'IMPREST');
                IF empmap.FINDSET THEN BEGIN
                    "Customer No:" := empmap."Customer A/c";
                END;*/
            END;
        END;


        glsetup.GET; //error('3....99');
        glsetup.TESTFIELD("ERC Memo Nos");
        NoSeriesMgt.InitSeries(glsetup."ERC Memo Nos", xRec."Memo No", 0D, "Memo No", "No. Series");
        "Budget Name" := glsetup."Current Budget";
        "Created By:" := USERID;
        "Date Created" := TODAY;
    end;

    var
        glsetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UsersRec: Record "User Setup";
        Empl: Record Employee;
        glaccount: Record "G/L Account";
        dimensionvalue: Record "Dimension Value";
        //empmap: Record "Employee Account Mapping";
        i: Integer;
        commitrec1: Record "Commitment Entries";
        commitrec2: Record "Commitment Entries";
        Memolines: Record "Memo Lines";


    procedure CommitMemo(MemoRec: Record Memo)
    var

    begin

        MemoRec.CALCFIELDS("Memo Amount");
        glsetup.RESET;
        glsetup.GET;
        commitrec1.RESET;
        commitrec1.SETFILTER("Entry No", '<>%1', 0);
        IF commitrec1.FINDLAST THEN BEGIN
            IF MemoRec."Memo Amount" <> 0 THEN BEGIN
                Memolines.RESET;
                Memolines.SETRANGE("Memo No", MemoRec."Memo No");
                IF Memolines.FINDSET THEN
                    REPEAT
                        i += 1;
                        commitrec2.INIT;
                        commitrec2."Entry No" := commitrec1."Entry No" + i;
                        commitrec2."Commitment Date" := TODAY;
                        commitrec2."Commitment No" := MemoRec."Memo No";
                        commitrec2."Document No." := MemoRec."Memo No";
                        commitrec2.Amount := Memolines.Amount;
                        commitrec2."Budget Line" := glsetup."Current Budget";
                        commitrec2."Budget Year" := glsetup."Current Budget";
                        commitrec2."Global Dimension 1 Code" := Memolines.Department;
                        commitrec2.Description := 'Memo :' + Memolines."Memo No" + '- ' + MemoRec."Memo Header";
                        commitrec2.GLAccount := Memolines."G/L Account";
                        commitrec2.Memo := TRUE;
                        commitrec2."Memo Member" := Memolines.Member;
                        commitrec2.INSERT;

                    UNTIL Memolines.NEXT = 0;

            END;

        END;
    end;

    procedure DeCommitMemoDSA(MemoRec: Record Memo; ImprestHeader: Record "Request Header")
    var

    begin

        MemoRec.CALCFIELDS("Memo Amount");
        glsetup.RESET;
        glsetup.GET;
        commitrec1.RESET;
        commitrec1.SETFILTER("Entry No", '<>%1', 0);
        IF commitrec1.FINDLAST THEN BEGIN
            IF MemoRec."Memo Amount" <> 0 THEN BEGIN
                Memolines.RESET;
                Memolines.SETRANGE("Memo No", MemoRec."Memo No");
                Memolines.SETRANGE(Member, ImprestHeader."User ID");
                IF Memolines.FINDSET THEN
                    REPEAT
                        i += 1;
                        commitrec2.INIT;
                        commitrec2."Entry No" := commitrec1."Entry No" + i;
                        commitrec2."Commitment Date" := TODAY;
                        commitrec2."Commitment No" := MemoRec."Memo No";
                        commitrec2."Document No." := MemoRec."Memo No";
                        commitrec2.Amount := -Memolines.Amount;
                        commitrec2."Budget Line" := glsetup."Current Budget";
                        commitrec2."Budget Year" := glsetup."Current Budget";
                        commitrec2."Global Dimension 1 Code" := Memolines.Department;
                        commitrec2.Description := 'Memo :' + Memolines."Memo No" + '- ' + MemoRec."Memo Header";
                        commitrec2.GLAccount := Memolines."G/L Account";
                        commitrec2.Memo := TRUE;
                        commitrec2."Memo Member" := Memolines.Member;
                        commitrec2.INSERT;

                    UNTIL Memolines.NEXT = 0;

            END;

        END;
    end;
}

