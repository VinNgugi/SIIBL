page 51511061 "Consolidated Budget"
{
    // version FINANCE

    PageType = List;
    SourceTable = "Consolidated Budget";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Commision Approved"; "Commision Approved")
                {

                    trigger OnValidate()
                    begin
                        /*IF "Commision Approved"=TRUE THEN
                          IF CONFIRM('Are You Sure You Want To Transfer This Record To Budget?',FALSE)=TRUE THEN
                        
                        
                        
                        
                        
                            MESSAGE('Exellent!')
                            */

                    end;
                }
                field("Budget Name"; "Budget Name")
                {
                }
                field("Department Code"; Department)
                {
                }
                field("G/L Account"; "G/L Account")
                {
                }
                field("G/L Account Name"; "G/L Account Name")
                {
                }
                field("Date Created"; "Date Created")
                {
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
                field("No of Budget Periods"; "No of Budget Periods")
                {
                }
                field("Posted To Budget"; Trasfered)
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Post To Budget")
            {
                Image = BankAccountLedger;

                trigger OnAction()
                begin
                    IF CONFIRM('Are You Sure You Want To Transfer This Record To Budget?', FALSE) = TRUE THEN BEGIN
                        ConsolidatedBudget.RESET;
                        ConsolidatedBudget.SETRANGE(Trasfered, FALSE);
                        ConsolidatedBudget.SETRANGE("Commision Approved", TRUE);
                        IF ConsolidatedBudget.FINDFIRST THEN BEGIN
                            REPEAT
                                IF (ConsolidatedBudget."No of Budget Periods" = ConsolidatedBudget."No of Budget Periods"::"1") THEN BEGIN
                                    budgetentries.RESET;
                                    budgetentries.SETFILTER("Entry No.", '<>%1', 0);
                                    IF budgetentries.FINDLAST THEN BEGIN
                                        glbudgetrec.RESET;
                                        glbudgetrec.GET(ConsolidatedBudget."Budget Name");
                                        budgetentries2.INIT;
                                        budgetentries2."Budget Name" := ConsolidatedBudget."Budget Name";
                                        budgetentries2."Entry No." := budgetentries."Entry No." + 1;
                                        budgetentries2."G/L Account No." := ConsolidatedBudget."G/L Account";
                                        //glbudgetrec.TESTFIELD("Start Date");
                                       // budgetentries2.Date := glbudgetrec."Start Date";
                                        budgetentries2."Global Dimension 1 Code" := ConsolidatedBudget.Department;
                                        budgetentries2.Amount := ConsolidatedBudget.Amount;
                                        budgetentries2.Description := 'Budget Added By Department: ' + ConsolidatedBudget.Department + ' after Approval';
                                        //budgetentries2."Description 2" := ConsolidatedBudget.Description;
                                        budgetentries2."User ID" := USERID;
                                        budgetentries2.INSERT;
                                    END;
                                END;
                                IF (ConsolidatedBudget."No of Budget Periods" = ConsolidatedBudget."No of Budget Periods"::"2") THEN BEGIN
                                    FOR i := 1 TO 2 DO BEGIN
                                        budgetentries.RESET;
                                        budgetentries.SETFILTER("Entry No.", '<>%1', 0);
                                        IF budgetentries.FINDLAST THEN BEGIN
                                            glbudgetrec.RESET;
                                            glbudgetrec.GET(ConsolidatedBudget."Budget Name");
                                            budgetentries2.INIT;
                                            budgetentries2."Budget Name" := ConsolidatedBudget."Budget Name";
                                            budgetentries2."Entry No." := budgetentries."Entry No." + 1;
                                            budgetentries2."G/L Account No." := ConsolidatedBudget."G/L Account";
                                            //glbudgetrec.TESTFIELD("Start Date");
                                            IF i = 1 THEN BEGIN
                                               //budgetentries2.Date := glbudgetrec."Start Date";
                                            END;
                                            IF i = 2 THEN BEGIN
                                                //budgetentries2.Date := CALCDATE('6M', glbudgetrec."Start Date");
                                            END;
                                            budgetentries2."Global Dimension 1 Code" := ConsolidatedBudget.Department;
                                            budgetentries2.Amount := ConsolidatedBudget.Amount / 2;
                                            budgetentries2.Description := 'Budget Added By Department: ' + ConsolidatedBudget.Department + ' after Approval';
                                            //budgetentries2."Description 2" := ConsolidatedBudget.Description;
                                            budgetentries2."User ID" := USERID;
                                            budgetentries2.INSERT;
                                        END;
                                    END;
                                END;
                                IF (ConsolidatedBudget."No of Budget Periods" = ConsolidatedBudget."No of Budget Periods"::"4") THEN BEGIN
                                    FOR i := 1 TO 4 DO BEGIN
                                        budgetentries.RESET;
                                        budgetentries.SETFILTER("Entry No.", '<>%1', 0);
                                        IF budgetentries.FINDLAST THEN BEGIN
                                            glbudgetrec.RESET;
                                            glbudgetrec.GET(ConsolidatedBudget."Budget Name");
                                            budgetentries2.INIT;
                                            budgetentries2."Budget Name" := ConsolidatedBudget."Budget Name";
                                            budgetentries2."Entry No." := budgetentries."Entry No." + 1;
                                            budgetentries2."G/L Account No." := ConsolidatedBudget."G/L Account";
                                           // glbudgetrec.TESTFIELD("Start Date");
                                            IF i = 1 THEN BEGIN
                                               // budgetentries2.Date := glbudgetrec."Start Date";
                                            END;
                                            IF i = 2 THEN BEGIN
                                               // budgetentries2.Date := CALCDATE('3M', glbudgetrec."Start Date");
                                            END;
                                            IF i = 3 THEN BEGIN
                                                //budgetentries2.Date := CALCDATE('6M', glbudgetrec."Start Date");
                                            END;
                                            IF i = 4 THEN BEGIN
                                               // budgetentries2.Date := CALCDATE('9M', glbudgetrec."Start Date");
                                            END;
                                            budgetentries2."Global Dimension 1 Code" := ConsolidatedBudget.Department;
                                            budgetentries2.Amount := ConsolidatedBudget.Amount / 4;
                                            budgetentries2.Description := 'Budget Added By Department: ' + ConsolidatedBudget.Department + ' after Approval';
                                            //budgetentries2."Description 2" := ConsolidatedBudget.Description;
                                            budgetentries2."User ID" := USERID;
                                            budgetentries2.INSERT;
                                        END;
                                    END;
                                END;
                                IF (ConsolidatedBudget."No of Budget Periods" = ConsolidatedBudget."No of Budget Periods"::"12") THEN BEGIN
                                    FOR i := 1 TO 12 DO BEGIN
                                        budgetentries.RESET;
                                        budgetentries.SETFILTER("Entry No.", '<>%1', 0);
                                        IF budgetentries.FINDLAST THEN BEGIN
                                            glbudgetrec.RESET;
                                            glbudgetrec.GET(ConsolidatedBudget."Budget Name");
                                            budgetentries2.INIT;
                                            budgetentries2."Budget Name" := ConsolidatedBudget."Budget Name";
                                            budgetentries2."Entry No." := budgetentries."Entry No." + 1;
                                            budgetentries2."G/L Account No." := ConsolidatedBudget."G/L Account";
                                            //glbudgetrec.TESTFIELD("Start Date");
                                            IF i = 1 THEN BEGIN
                                              //  budgetentries2.Date := glbudgetrec."Start Date";
                                            END;
                                            IF i > 1 THEN BEGIN
                                                j := i - 1;
                                                //budgetentries2.Date := CALCDATE(FORMAT(j) + 'M', glbudgetrec."Start Date");
                                            END;
                                            budgetentries2."Global Dimension 1 Code" := ConsolidatedBudget.Department;
                                            budgetentries2.Amount := ConsolidatedBudget.Amount / 12;
                                            budgetentries2.Description := 'Budget Added By Department: ' + ConsolidatedBudget.Department + ' after Approval';
                                            //budgetentries2."Description 2" := ConsolidatedBudget.Description;
                                            budgetentries2."User ID" := USERID;
                                            budgetentries2.INSERT;
                                        END;
                                    END;
                                END;
                                ConsolidatedBudget.Trasfered := TRUE;
                                ConsolidatedBudget.MODIFY;
                            UNTIL ConsolidatedBudget.NEXT = 0;
                            MESSAGE('Budget Creation Complete...');
                        END
                        ELSE BEGIN
                            MESSAGE('No Open Line(s) To Post To Budget!');
                        END;
                    END;
                end;
            }
        }
    }

    var
        budgetentries: Record 96;
        budgetentries2: Record 96;
        i: Integer;
        glbudgetrec: Record 95;
        j: Integer;
        ConsolidatedBudget: Record "Consolidated Budget";
}

