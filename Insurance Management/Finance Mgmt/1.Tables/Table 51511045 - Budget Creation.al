table 51511045 "Budget Creation"
{
    // version FINANCE


    fields
    {
        field(1; "Creation No"; Code[20])
        {
        }
        field(2; "Budget Name"; Code[20])
        {
            TableRelation = "G/L Budget Name".Name;
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
        field(9; "Sent consolidated"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Creation No")
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
                Department := Empl."Global Dimension 1 Code";
                dimensionvalue.RESET;
                dimensionvalue.GET('DEPARTMENT', Department);
                //IF USERID <> dimensionvalue.HOD THEN BEGIN
                //    ERROR('Only HOD of the Department can Create the Budget!');
                //END;
            END;
        END;


        glsetup.GET;
        glsetup.TESTFIELD("Budget Creation Nos");
        NoSeriesMgt.InitSeries(glsetup."Budget Creation Nos", xRec."Creation No", 0D, "Creation No", "No. Series");
        //"Budget Name":=glsetup."Current Budget";
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
        ConsolidatedBudget: Record "Consolidated Budget";
        budgetlines: Record "Budget Creation Lines";
        Createdids: Integer;

    procedure CreatedConsolidatedBudget(var budgetCrec: Record "Budget Creation")
    begin
        IF budgetCrec."Sent consolidated" = TRUE THEN
            ERROR('Budget %1 Has Been Sent For Consolidation!', budgetCrec."Creation No");
        budgetlines.RESET;
        budgetlines.SETRANGE("Creation No", budgetCrec."Creation No");
        IF budgetlines.FINDFIRST THEN
            REPEAT
                Createdids := 1;
                ConsolidatedBudget.RESET;
                IF ConsolidatedBudget.FINDLAST THEN
                    Createdids := ConsolidatedBudget.CreationID + 1;
                ConsolidatedBudget.INIT;
                ConsolidatedBudget.CreationID := Createdids;
                ConsolidatedBudget.Amount := budgetlines.Amount;
                ConsolidatedBudget."Budget Name" := budgetCrec."Budget Name";
                ConsolidatedBudget."Creation No" := budgetlines."Creation No";
                ConsolidatedBudget."Date Created" := TODAY;
                ConsolidatedBudget.Department := budgetlines.Department;
                ConsolidatedBudget.Description := budgetlines.Description;
                ConsolidatedBudget."G/L Account" := budgetlines."G/L Account";
                ConsolidatedBudget."G/L Account Name" := budgetlines."G/L Account Name";
                ConsolidatedBudget."No of Budget Periods" := budgetlines."No of Budget Periods";
                ConsolidatedBudget.INSERT;
            UNTIL budgetlines.NEXT = 0;
        //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        MESSAGE('Consolidated Budget Creation Complete...');
        budgetCrec."Sent consolidated" := TRUE;
        budgetCrec.MODIFY;
    end;
}

