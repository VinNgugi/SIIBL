page 51511056 "Budget Options"
{
    // version FINANCE

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    ShowFilter = false;
    SourceTable = "Select Budget Options";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Budget Name"; "Budget Name")
                {
                }
                field(Department; Department)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Load Budget")
            {
                Image = Price;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    TESTFIELD("Budget Name");
                    TESTFIELD(Department);

                    DIMVALUE.RESET;
                    DIMVALUE.SETFILTER("Dimension Code", 'DEPARTMENT');
                    DIMVALUE.SETFILTER(Code, Department);
                    IF DIMVALUE.FINDSET THEN BEGIN
                        /* IF (DIMVALUE.HOD <> USERID) THEN BEGIN
                            IF (DIMVALUE."HOD Substitute" <> USERID) THEN BEGIN
                                MESSAGE('You are not the HOD of Department ' + Department + '. So you cannot view this Budget!!!');
                                EXIT;
                            END;
                        END; */
                    END;

                    GL.RESET;
                    //GL.SETFILTER("Budgeted Amount2", '>%1', 0);
                    GL.SETFILTER("Budget Filter", "Budget Name");
                    GL.SETFILTER("Global Dimension 1 Filter", Department);
                    IF GL.FINDSET THEN BEGIN
                        PAGE.RUN(51511234, GL);
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF UsersRec.GET(USERID) THEN BEGIN
            IF Empl.GET(UsersRec."Employee No.") THEN BEGIN
                Department := Empl."Global Dimension 1 Code"; //MESSAGE(Department);
            END;
        END;
    end;

    trigger OnOpenPage()
    begin
        IF UsersRec.GET(USERID) THEN BEGIN
            IF Empl.GET(UsersRec."Employee No.") THEN BEGIN
                Department := Empl."Global Dimension 1 Code"; //MESSAGE(Department);
            END;
        END;
    end;

    var
        UsersRec: Record "User Setup";
        Empl: Record Employee;
        DIMVALUE: Record "Dimension Value";
        GL: Record "G/L Account";
}

