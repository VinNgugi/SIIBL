report 51513188 IBNR
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/IBNR.rdl';

    dataset
    {
        dataitem("IBNR Setup"; "IBNR Setup")
        {
            RequestFilterFields = "Date Filter", Class, "Year No.", "Sub Class";
            column(Class; "IBNR Setup".Class)
            {
            }
            column(Year; "IBNR Setup"."Year No.")
            {
            }
            column(NetPremium; "IBNR Setup"."Net Premium Sub Class")
            {
            }
            column(SubclassName; "IBNR Setup"."Product Name")
            {
            }
            column(LastMonthIBNR; LastMonthIBNR)
            {
            }
            column(PStart; PStart)
            {
            }
            column(PEnd; PEnd)
            {
            }
            dataitem("IBNR Lines"; "IBNR Lines")
            {
                DataItemLink = "Sub Class" = FIELD("Sub Class"),
                               "Year No." = FIELD("Year No.");
                column(YearPrev; "IBNR Lines"."Year Look Up")
                {
                }
                column(Subclass; "IBNR Lines"."Sub Class")
                {
                }
                column(PercentagePrev; "IBNR Lines"."% Age")
                {
                }
                column(Netpremium1; NetPremium)
                {
                }
                column(IBNRVal; NetPremium * ("IBNR Lines"."% Age" / 100))
                {
                }
                column(LastMonth_IBNR; LastMonthIBNR)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    InsSetup.GET;
                    GLMapping.RESET;
                    GLMapping.SETRANGE(GLMapping."Class Code", "IBNR Setup"."Sub Class");
                    IF GLMapping.FINDFIRST THEN BEGIN


                        IBNRSetupCopy.COPY("IBNR Setup");
                        IBNRSetupCopy1.COPY("IBNR Setup");

                        PeriodStart := CALCDATE("IBNR Lines"."Period Comparison", "IBNR Setup".GETRANGEMIN("IBNR Setup"."Date Filter"));
                        PeriodEnd := CALCDATE("IBNR Lines"."Period Comparison", "IBNR Setup".GETRANGEMAX("IBNR Setup"."Date Filter"));
                        LastMonthStartDate := CALCDATE('-1M', PeriodStart);
                        LastMonthEndDate := CALCDATE('-1M', PeriodEnd);

                        IBNRSetupCopy1.SETRANGE(IBNRSetupCopy1."Date Filter", LastMonthStartDate, LastMonthEndDate);
                        IBNRSetupCopy1.CALCFIELDS(IBNRSetupCopy1."Posted IBNR");
                        LastMonthIBNR := IBNRSetupCopy1."Posted IBNR";

                        IBNRSetupCopy.SETRANGE(IBNRSetupCopy."Date Filter", PeriodStart, PeriodEnd);
                        IBNRSetupCopy.CALCFIELDS(IBNRSetupCopy."Net Premium", IBNRSetupCopy."Net Premium Sub Class", IBNRSetupCopy."Posted IBNR");
                        NetPremium := IBNRSetupCopy."Net Premium Sub Class";

                        Branches.RESET;
                        Branches.SETRANGE(Branches."Global Dimension No.", 1);
                        IF Branches.FINDFIRST THEN BEGIN

                            REPEAT
                                IBNRSetupCopy.SETRANGE(IBNRSetupCopy."Date Filter", PeriodStart, PeriodEnd);
                                IBNRSetupCopy.SETRANGE(IBNRSetupCopy."Global Dimension 1 Filter", Branches.Code);
                                IBNRSetupCopy.CALCFIELDS(IBNRSetupCopy."Net Premium", IBNRSetupCopy."Net Premium Sub Class", IBNRSetupCopy."Posted IBNR");
                                GenJnline.INIT;
                                GenJnline."Journal Template Name" := InsSetup."Insurance Template";
                                GenJnline."Journal Batch Name" := 'IBNR';
                                GenJnline."Line No." := GenJnline."Line No." + 10000;
                                GenJnline."Document No." := FORMAT("IBNR Setup"."Year No.") + '-' + "IBNR Setup".Class;
                                GenJnline."Posting Date" := PEnd;
                                GenJnline."Account Type" := GenJnline."Account Type"::"G/L Account";
                                GenJnline."Account No." := GLMapping."IBNR Expense";
                                GenJnline.Description := STRSUBSTNO('IBNR Sub Class %1 period: %2..%3', "IBNR Setup"."Sub Class", PeriodStart, PeriodEnd);
                                GenJnline."Insurance Trans Type" := GenJnline."Insurance Trans Type"::IBNR;
                                GenJnline.Amount := -ROUND(IBNRSetupCopy."Net Premium Sub Class" * ("IBNR Lines"."% Age" / 100)) + IBNRSetupCopy."Posted IBNR";
                                IBNRVal := -ROUND(IBNRSetupCopy."Net Premium Sub Class" * ("IBNR Lines"."% Age" / 100)) + IBNRSetupCopy."Posted IBNR";
                                IBNRAmt := IBNRAmt + GenJnline.Amount;
                                GenJnline."Shortcut Dimension 1 Code" := Branches.Code;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                                GenJnline."Policy Type" := "IBNR Lines"."Sub Class";
                                GenJnline."Shortcut Dimension 3 Code" := "IBNR Setup".Class;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 3 Code");

                                IF GenJnline.Amount <> 0 THEN
                                    GenJnline.INSERT;

                                //***Balancing
                                GenJnline.INIT;
                                GenJnline."Journal Template Name" := InsSetup."Insurance Template";
                                GenJnline."Journal Batch Name" := 'IBNR';
                                GenJnline."Line No." := GenJnline."Line No." + 10000;
                                GenJnline."Document No." := FORMAT("IBNR Setup"."Year No.") + '-' + "IBNR Setup".Class;
                                GenJnline."Posting Date" := PEnd;
                                GenJnline."Account Type" := GenJnline."Account Type"::"G/L Account";
                                GenJnline."Account No." := GLMapping."IBNR Reserve";
                                GenJnline.Description := STRSUBSTNO('IBNR Sub Class %1 period: %2..%3', "IBNR Setup"."Sub Class", PeriodStart, PeriodEnd);
                                // GenJnline."Insurance Trans Type":=GenJnline."Insurance Trans Type"::IBNR;
                                GenJnline.Amount := ROUND(IBNRSetupCopy."Net Premium Sub Class" * ("IBNR Lines"."% Age" / 100)) + IBNRSetupCopy."Posted IBNR";
                                IBNRAmt := IBNRAmt + GenJnline.Amount;
                                GenJnline."Shortcut Dimension 1 Code" := Branches.Code;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                                GenJnline."Policy Type" := "IBNR Lines"."Sub Class";
                                GenJnline."Shortcut Dimension 3 Code" := "IBNR Setup".Class;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 3 Code");

                                IF GenJnline.Amount <> 0 THEN
                                    GenJnline.INSERT;



                            //*****
                            UNTIL Branches.NEXT = 0;
                        END;
                    END;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                NetPremium := 0;
                IBNRAmt := 0;
                /*InsSetup.GET;
                GLMapping.RESET;
                GLMapping.SETRANGE(GLMapping."Class Code","IBNR Setup"."Sub Class");
                IF GLMapping.FINDFIRST THEN
                   BEGIN
                   Branches.RESET;
                   Branches.SETRANGE(Branches."Global Dimension No.",1);
                   IF Branches.FINDFIRST THEN
                     REPEAT
                
                
                   "IBNR Setup".SETRANGE("IBNR Setup"."Date Filter",PeriodStart,PeriodEnd);
                   "IBNR Setup".SETRANGE("IBNR Setup"."Global Dimension 1 Filter",Branches.Code);
                   "IBNR Setup".CALCFIELDS("IBNR Setup"."Net Premium Sub Class");
                   //"IBNR Setup".CALCFIELDS("IBNR Setup"."Net Premium");
                   MESSAGE('Branch=%1 and Amount=%2',Branches.Code,"IBNR Setup"."Net Premium Sub Class");
                   GenJnline.INIT;
                   GenJnline."Journal Template Name":=InsSetup."Insurance Template";
                   GenJnline."Journal Batch Name":='IBNR';
                   GenJnline."Line No.":=GenJnline."Line No."+10000;
                   GenJnline."Document No.":=FORMAT("IBNR Setup"."Year No.")+'-'+"IBNR Setup".Class;
                   GenJnline."Posting Date":=TODAY;
                   GenJnline."Account Type":=GenJnline."Account Type"::"G/L Account";
                   GenJnline."Account No.":=GLMapping."IBNR Expense";
                   GenJnline.Description:=STRSUBSTNO('IBNR Sub Class %1 Period:%2..%3',"IBNR Setup"."Sub Class",PeriodStart,PeriodEnd);
                   GenJnline."Policy Type":="IBNR Lines"."Sub Class";
                   GenJnline."Shortcut Dimension 1 Code":=Branches.Code;
                   GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                   GenJnline."Shortcut Dimension 3 Code":="IBNR Setup".Class;
                   GenJnline.VALIDATE(GenJnline."Shortcut Dimension 3 Code");
                   GenJnline."Policy Type":="IBNR Setup"."Sub Class";
                   GenJnline.Amount:=-ROUND("IBNR Setup"."Net Premium Sub Class"*("IBNR Setup"."IBNR Percentage"/100));
                
                   GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
                   GenJnline."Bal. Account No.":=GLMapping."IBNR Reserve";
                   IF GenJnline.Amount<>0 THEN
                   GenJnline.INSERT;
                
                  UNTIL Branches.NEXT=0;
                  {IF GLacc.GET("IBNR Setup"."Reinsurance Premium Account") THEN
                  BEGIN
                   GLacc.SETRANGE(GLacc."Date Filter","IBNR Setup"."Date Filter");
                   GLacc.CALCFIELDS(GLacc."Net Change");
                   "IBNR Setup".CALCFIELDS("IBNR Setup"."Net Premium");
                   GenJnline.INIT;
                   GenJnline."Journal Template Name":=InsSetup."Insurance Template";
                   GenJnline."Journal Batch Name":='IBNR -Reinsurance';
                   GenJnline."Line No.":=GenJnline."Line No."+10000;
                   GenJnline."Document No.":=FORMAT("IBNR Setup"."Year No.")+'-'+"IBNR Setup".Class;
                   GenJnline."Posting Date":=TODAY;
                   GenJnline."Account Type":=GenJnline."Account Type"::"G/L Account";
                   GenJnline."Account No.":=GLMapping."IBNR Expense";
                   GenJnline.Description:='IBNR';
                   GenJnline.Amount:=-"IBNR Setup"."Net Premium"*("IBNR Setup"."IBNR Percentage"/100);
                   GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
                   GenJnline."Bal. Account No.":=GLMapping."IBNR Reserve";
                   IF GenJnline.Amount<>0 THEN
                   GenJnline.INSERT;
                  END;}
                  END;*/

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        PeriodStart := "IBNR Setup".GETRANGEMIN("IBNR Setup"."Date Filter");
        PeriodEnd := "IBNR Setup".GETRANGEMAX("IBNR Setup"."Date Filter");

        PStart := PeriodStart;
        PEnd := PeriodEnd;
    end;

    var
        GenJnline: Record "Gen. Journal Line";
        GLacc: Record "G/L Account";
        GLMapping: Record "Insurance Accounting Mappings";
        InsSetup: Record "Insurance setup";
        PeriodStart: Date;
        PeriodEnd: Date;
        IBNRSetupCopy: Record 51513456;
        Branches: Record "Dimension Value";
        IBNRAmt: Decimal;
        NetPremium: Decimal;
        LastMonthStartDate: Date;
        LastMonthEndDate: Date;
        LastMonthIBNR: Decimal;
        IBNRSetupCopy1: Record 51513456;
        PStart: Date;
        PEnd: Date;
        IBNRVal: Decimal;
}

