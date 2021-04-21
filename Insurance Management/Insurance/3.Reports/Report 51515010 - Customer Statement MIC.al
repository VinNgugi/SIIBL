report 51515010 "Customer Statement MIC"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Customer Statement MIC.rdl';

    dataset
    {
        dataitem(DataItem1;18)
        {
            RequestFilterFields = "No.","Date Filter";
            column(No_Customer;"No.")
            {
            }
            column(Statement_No;"Last Statement No.")
            {
            }
            column(startdate;startdate)
            {
            }
            column(enddate;enddate)
            {
            }
            column(custaddr1;custaddr[1])
            {
            }
            column(custaddr2;custaddr[2])
            {
            }
            column(custaddr3;custaddr[3])
            {
            }
            column(custaddr4;custaddr[4])
            {
            }
            column(custaddr5;custaddr[5])
            {
            }
            column(openingbal;openingbal)
            {
            }
            column(closingbal;closingbal)
            {
            }
            column(BalatopeningKSH;BalatopeningKSH)
            {
            }
            column(BalatopeningUSD;BalatopeningUSD)
            {
            }
            column(BalatclosingKSH;BalatclosingKSH)
            {
            }
            column(BalatclosingUSD;BalatclosingUSD)
            {
            }
            column(CurrCode;CurrCode)
            {
            }
            dataitem(DataItem3;21)
            {
                DataItemLink = "Customer No."=FIELD("No.");
                DataItemTableView = SORTING("Customer No.","Posting Date","Currency Code")
                                    ORDER(Ascending);
                column(Description_CustLedgerEntry;Description)
                {
                }
                column(PostingDate_CustLedgerEntry;"Posting Date")
                {
                }
                column(DocumentNo_CustLedgerEntry;"Document No.")
                {
                }
                column(policyno;policyno)
                {
                }
                column(OriginalAmount_CustLedgerEntry;"Original Amount")
                {
                }
                column(TL;TL)
                {
                }
                column(PCF;PCF)
                {
                }
                column(SD;SD)
                {
                }
                column(Gross_Premium;"Original Amount")
                {
                }
                column(Amount_Paid;amountpaid)
                {
                }
                column(oustandingpremiums;oustandingpremiums)
                {
                }
                column(grosspremum2;grosspremium)
                {
                }
                column(basicpremium;basicpremium)
                {
                }
                column(USD;USD)
                {
                }
                column(sum1;sum1)
                {
                }
                column(sum2;sum2)
                {
                }
                column(rembal;rembal)
                {
                }
                column(rembalUSD;rembalUSD)
                {
                }
                column(Paidamount77;Paidamount77)
                {
                }
                column(Paidamount77USD;Paidamount77USD)
                {
                }
                column(RunningBalanceUSD_;RunningBalanceUSD)
                {
                }
                column(RunningBalance_;RunningBalance)
                {
                }
                dataitem(DataItem25;79)
                {
                    column(FaxNo_CompanyInformation;"Fax No.")
                    {
                    }
                    column(Name_CompanyInformation;Name)
                    {
                    }
                    column(Address_CompanyInformation;Address)
                    {
                    }
                    column(Address2_CompanyInformation;"Address 2")
                    {
                    }
                    column(City_CompanyInformation;"City")
                    {
                    }
                    column(PhoneNo_CompanyInformation;"Phone No.")
                    {
                    }
                    column(EMail_CompanyInformation;"E-Mail")
                    {
                    }
                    column(HomePage_CompanyInformation;"Home Page")
                    {
                    }
                    column(CompanyPic2_CompanyInformation;"Picture")
                    {
                    }
                }

                trigger OnAfterGetRecord();
                begin
                     // Message('Check: %1\%2\%3',check,"Document No.","Original Amount");
                      Description:='';
                       check:=0;
                       TL:=0;
                       SD:=0;
                       PCF:=0;
                       policyno:='';
                       basicpremium:=0;
                       USD:=0;
                       rembal:=0;
                       rembalUSD:=0;
                       Paidamount77:=0;
                       Paidamount77USD:=0;

                     //Checkking If USD
                     IF "Currency Code"='USD' THEN BEGIN
                         USD:=7;
                     END;
                     IF "Currency Code"<>'USD' THEN BEGIN
                         //SUM1+="Remaining Amount";
                     END;

                     //End Checking If USD

                      custledgerentry2.RESET;
                      IF custledgerentry2.GET("Entry No.") THEN BEGIN
                         //Message('%1',"Document No.");
                         insuredebitnote.RESET;
                         insuredebitnote.SETFILTER(insuredebitnote."No.","Document No.");
                              IF insuredebitnote.FINDSET THEN BEGIN
                                  check:=7;//If it existed in Debit notes
                                  // Message('*%1',"Document No.");
                                  insuredebitnote.CALCFIELDS(insuredebitnote."Total Premium Amount");
                                  basicpremium:=insuredebitnote."Total Premium Amount";
                                  policyno:=insuredebitnote."Policy No";

                                        policytypetb.RESET;
                                        policytypetb.SETFILTER(policytypetb.Code,insuredebitnote."Policy Type");
                                        IF policytypetb.FINDSET THEN BEGIN
                                           Description:=policytypetb.Description;
                                        END;


                                     insuredebitnotelines.RESET;
                                     insuredebitnotelines.SETFILTER(insuredebitnotelines."Document No.",insuredebitnote."No.");
                                     insuredebitnotelines.SETFILTER(insuredebitnotelines.Tax,'%1',TRUE);
                                     IF insuredebitnotelines.FINDSET THEN REPEAT
                                        IF insuredebitnotelines.Description='Training Levy' THEN BEGIN
                                           TL:=insuredebitnotelines.Amount;
                                        END;
                                        IF insuredebitnotelines.Description='PCF' THEN BEGIN
                                           PCF:=insuredebitnotelines.Amount;
                                        END;
                                        IF ((insuredebitnotelines.Description<>'Training Levy') AND (insuredebitnotelines.Description<>'PCF')) THEN BEGIN
                                           SD:=insuredebitnotelines.Amount;
                                        END;

                                     UNTIL insuredebitnotelines.NEXT=0;
                              END;
                              IF check=0 THEN BEGIN

                                        insurecreditnote.RESET;
                                        insurecreditnote.SETFILTER(insurecreditnote."No.","Document No.");
                                         IF insurecreditnote.FINDSET THEN BEGIN
                                             check:=2;                      //if credits exist
                                             insurecreditnote.CALCFIELDS(insurecreditnote."Total Premium Amount");
                                             basicpremium:=-insurecreditnote."Total Premium Amount";
                                             policyno:=insurecreditnote."Policy No";

                                                   policytypetb.RESET;
                                                   policytypetb.SETFILTER(policytypetb.Code,insurecreditnote."Policy Type");
                                                   IF policytypetb.FINDSET THEN BEGIN
                                                      Description:=policytypetb.Description;
                                                   END;


                                                insurecreditnotelines.RESET;
                                                insurecreditnotelines.SETFILTER(insurecreditnotelines."Document No.",insurecreditnote."No.");
                                                insurecreditnotelines.SETFILTER(insurecreditnotelines.Tax,'%1',TRUE);
                                                IF insurecreditnotelines.FINDSET THEN REPEAT
                                                   IF insurecreditnotelines.Description='Training Levy' THEN BEGIN
                                                      TL:=-insurecreditnotelines.Amount;
                                                   END;
                                                   IF insurecreditnotelines.Description='PCF' THEN BEGIN
                                                      PCF:=-insurecreditnotelines.Amount;
                                                   END;
                                                   IF ((insurecreditnotelines.Description<>'Training Levy') AND (insurecreditnotelines.Description<>'PCF') )THEN BEGIN
                                                      SD:=-insurecreditnotelines.Amount;
                                                   END;

                                                UNTIL insurecreditnotelines.NEXT=0;
                                         END;

                              END;
                      END;


                     IF "Original Amount">0 THEN BEGIN
                         amountpaid:=0;
                     END;
                     IF "Original Amount"<0 THEN BEGIN
                         amountpaid:="Original Amount";
                       //  amountpaid:="Remaining Amount";
                     END;



                    IF check=2 THEN BEGIN
                       oustandingpremiums:="Original Amount"+TL+PCF+SD;
                     //  oustandingpremiums:="Remaining Amount"+TL+PCF+SD;
                       amountpaid:=0;
                       grosspremium:=oustandingpremiums;
                    END;

                    IF check=0 THEN BEGIN
                       oustandingpremiums:="Original Amount"+TL+PCF+SD;
                     //  oustandingpremiums:="Remaining Amount"+TL+PCF+SD;
                       grosspremium:=0;
                      // "Original Amount":=0;
                       oustandingpremiums:=amountpaid;
                       IF "Original Amount">0 THEN BEGIN
                           oustandingpremiums:="Original Amount";
                         //    oustandingpremiums:="Remaining Amount";
                       END;
                    END;

                    IF Description<>'' THEN  BEGIN
                        oustandingpremiums:="Original Amount"-amountpaid;
                      //    oustandingpremiums:="Remaining Amount"-amountpaid;
                        "Original Amount":="Original Amount"-TL-PCF-SD;
                      // "Remaining Amount":="Remaining Amount"-TL-PCF-SD;
                        IF "Original Amount"<0 THEN BEGIN
                             "Original Amount":=0;
                          // "Remaining Amount":=0;
                        END;
                    END;

                    grosspremium:=oustandingpremiums;

                    IF check=0 THEN BEGIN
                       IF grosspremium<0 THEN  BEGIN
                          grosspremium:=0;
                       END;
                    END;

                    //MESSAGE('Check: %1\%2\%3',check,"Document No.","Original Amount");
                    //oustandingpremiums:=grosspremium;
                    // Message('%1\%2\%3\%4\%5',"Original Amount",tl,pcf,sd,oustandingpremiums);
                     Description:= COPYSTR(Description, 1, 25);
                    //Message('%1\%2',"Document No.",USD);

                     IF "Currency Code"<>'USD' THEN BEGIN
                       sum1+=oustandingpremiums; //Message('KES T: %1',sum1);
                    END;
                    IF USD=7 THEN BEGIN
                       sum2+=oustandingpremiums; //Message('USD T:%1',sum2);
                    END;

                    CALCFIELDS("Remaining Amount");
                    IF "Currency Code"='' THEN
                    rembal:="Remaining Amount"
                    ELSE
                    rembalUSD:="Remaining Amount";

                    Paidamount77:=grosspremium-rembal;
                    Paidamount77USD:=grosspremium-rembalUSD;
                    //MESSAGE('%1',"Document No.");
                    IF basicpremium=0 THEN BEGIN

                       CALCFIELDS("Original Amount","Remaining Amount");
                       basicpremium:="Original Amount";
                       grosspremium:=basicpremium;
                       IF "Currency Code"='' THEN BEGIN
                       Paidamount77:="Original Amount"-"Remaining Amount";
                       rembal:="Remaining Amount";
                       END ELSE BEGIN
                       Paidamount77USD:="Original Amount"-"Remaining Amount";
                       rembalUSD:="Remaining Amount";
                       END;
                    END;

                    IF "Currency Code"='' THEN BEGIN //lcy
                        IF (Paidamount77<>0) AND (grosspremium>0) THEN BEGIN
                            Paidamount77:=0-ABS(Paidamount77);
                        END;
                        IF (Paidamount77<>0) AND (grosspremium<0) THEN BEGIN
                            Paidamount77:=ABS(Paidamount77);
                        END;
                    END ELSE BEGIN //USD
                        IF (Paidamount77USD<>0) AND (grosspremium>0) THEN BEGIN
                            Paidamount77USD:=0-ABS(Paidamount77USD);
                        END;
                        IF (Paidamount77USD<>0) AND (grosspremium<0) THEN BEGIN
                            Paidamount77USD:=ABS(Paidamount77USD);
                        END;
                    END;


                    rembal:=grosspremium+Paidamount77;
                    rembalUSD:=grosspremium+Paidamount77USD;
                    IF "Currency Code"='' THEN  //lcy
                     RunningBalance:=RunningBalance+rembal//KSH
                    ELSE
                     RunningBalanceUSD:=RunningBalanceUSD+rembalUSD;
                    // MESSAGE('Runing bal USD %1 RemBal %2 Currency Code %3', RunningBalanceUSD,rembalUSD,"Currency Code");
                end;

                trigger OnPreDataItem();
                begin
                       SETFILTER("Posting Date",'%1..%2',startdate,enddate);
                       IF alltransactions=TRUE THEN BEGIN
                         //SETFILTER(Reversed,'%1',TRUE);
                         SETFILTER(Reversed,'%1|%2',FALSE,TRUE);
                         SETFILTER(Open,'%1|%2',TRUE,FALSE);
                         SETFILTER("Posting Date",'%1..%2',startdate,enddate);
                       END;
                       IF alltransactions=FALSE THEN BEGIN
                         SETFILTER(Reversed,'%1',FALSE);
                         SETFILTER(Open,'%1',TRUE);
                         SETFILTER("Posting Date",'%1..%2',startdate,enddate);
                       END;

                     RunningBalance:=BalatopeningKSH;
                     RunningBalanceUSD:=BalatopeningUSD;
                    //SETFILTER("Document No.",'RCTP05437');
                end;
            }

            trigger OnAfterGetRecord();
            var
                custledgerentries99 : Record 379;
            begin

                cust2.RESET;
                IF cust2.GET("No.") THEN BEGIN
                    cust2.SETFILTER(cust2."Date Filter",'%1..%2',0D,startdate);
                    cust2.CALCFIELDS(cust2."Net Change (LCY)");
                    openingbal:=cust2."Net Change (LCY)";
                END;
                IF cust2.GET("No.") THEN BEGIN
                    cust2.RESET;
                    cust2.CALCFIELDS(cust2."Net Change","Net Change (LCY)");
                    cust2.SETFILTER(cust2."Date Filter",'%1..%2',0D,enddate);
                    cust2.CALCFIELDS(cust2."Net Change","Net Change (LCY)");
                    closingbal:=cust2."Net Change (LCY)";
                END;


                 formatadd.Customer(custaddr,cust2);
                //Message('%1',openingbal);
                //message('%1',startdate);
                //=========================================================================BD
                BalatopeningKSH:=0;
                Custledgerentries.RESET;
                Custledgerentries.SETFILTER(Custledgerentries."Customer No.","No.");
                Custledgerentries.SETFILTER(Custledgerentries."Posting Date",'%1..%2',0D,startdate-1);
                Custledgerentries.SETFILTER(Custledgerentries."Currency Code",'%1','');
                IF Custledgerentries.FINDSET THEN REPEAT
                   Custledgerentries.CALCFIELDS(Custledgerentries."Amount (LCY)",Custledgerentries."Original Amt. (LCY)",Custledgerentries."Remaining Amount",Custledgerentries."Original Amount",Custledgerentries."Remaining Amt. (LCY)");
                   BalatopeningKSH+=Custledgerentries."Original Amt. (LCY)";//Custledgerentries."Remaining Amt. (LCY)";

                UNTIL Custledgerentries.NEXT=0;     //Message('%1',BalatopeningKSH);
                 //  RunningBalance:=BalatopeningKSH;
                BalatopeningUSD:=0;
                Custledgerentries.RESET;
                Custledgerentries.SETFILTER(Custledgerentries."Customer No.","No.");
                Custledgerentries.SETFILTER(Custledgerentries."Posting Date",'%1..%2',0D,startdate-1);

                Custledgerentries.SETFILTER(Custledgerentries."Currency Code",'%1','USD');
                IF Custledgerentries.FINDSET THEN REPEAT
                   Custledgerentries.CALCFIELDS(Custledgerentries."Original Amount",Custledgerentries."Remaining Amount",Custledgerentries."Remaining Amt. (LCY)",Custledgerentries.Amount);
                   BalatopeningUSD+=Custledgerentries.Amount;//Custledgerentries."Original Amount";
                UNTIL Custledgerentries.NEXT=0;


                BalatclosingKSH:=0;
                Custledgerentries.RESET;
                Custledgerentries.SETFILTER(Custledgerentries."Customer No.","No.");
                //Custledgerentries.SETFILTER(Custledgerentries."Posting Date",'%1..%2',startdate,enddate);
                Custledgerentries.SETFILTER(Custledgerentries."Posting Date",'%1..%2',0D,enddate);

                Custledgerentries.SETFILTER(Custledgerentries."Currency Code",'%1','');
                IF Custledgerentries.FINDSET THEN REPEAT
                   Custledgerentries.CALCFIELDS(Custledgerentries."Original Amt. (LCY)");
                   IF Custledgerentries."Currency Code"='' THEN BEGIN
                      BalatclosingKSH+=Custledgerentries."Original Amt. (LCY)";
                   END;
                UNTIL Custledgerentries.NEXT=0;  // BalatclosingKSH+=BalatopeningKSH; //MESSAGE('%1',BalatclosingKSH);

                BalatclosingUSD:=0;
                Custledgerentries.RESET;
                Custledgerentries.SETFILTER(Custledgerentries."Customer No.","No.");
                //Custledgerentries.SETFILTER(Custledgerentries."Posting Date",'%1..%2',startdate,enddate);
                Custledgerentries.SETFILTER(Custledgerentries."Posting Date",'%1..%2',0D,enddate);

                Custledgerentries.SETFILTER(Custledgerentries."Currency Code",'%1','USD');
                IF Custledgerentries.FINDSET THEN REPEAT
                   Custledgerentries.CALCFIELDS(Custledgerentries."Original Amount");
                   BalatclosingUSD+=Custledgerentries."Original Amount";
                   CurrCode:='USD';//Customer.GETFILTER("Currency Filter");
                   //Message('%1',Custledgerentries."Original Amount");
                UNTIL Custledgerentries.NEXT=0; //BalatclosingUSD+=BalatopeningUSD; // MESSAGE('%1',BalatclosingUSD);

                //=========================================================================
                //Message('%1..%2\%3..%4',BalatopeningKSH,BalatclosingKSH,BalatopeningUSD,BalatclosingUSD);
                //MESSAGE('%1',BalatclosingKSH);
                //BalatclosingKSH:=BalatopeningKSH;
            end;

            trigger OnPreDataItem();
            begin
                //Customer.SETFILTER(Customer."No.",'%1',CustNo);
                startdate:=GETRANGEMIN("Date Filter");
                enddate:=GETRANGEMAX("Date Filter");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
               //07.04.21 Caption = 'Customer Statement MIC';
                field(CustNo;CustNo)
                {
                    Caption = 'Customer No:';
                    TableRelation = Customer."No.";
                    Visible = false;
                }
                field(startdate;startdate)
                {
                    Caption = 'Start Date:';
                    Visible = false;
                }
                field(enddate;enddate)
                {
                    Caption = 'End Date:';
                    Visible = false;
                }
                field(alltransactions;alltransactions)
                {
                    Caption = 'Detailed Statement:';
                }
                field(includeunappliedentries;includeunappliedentries)
                {
                    Caption = 'Include UnApplied Entries:';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        startdate : Date;
        enddate : Date;
        insureheader : Record 51513016;
        insuredebitnote : Record 51513086;
        insurecreditnote : Record 51513088;
        custledgerentry2 : Record 21;
        policytypetb : Record 51513000;
        policyno : Code[50];
        basicpremium : Decimal;
        grosspremium : Decimal;
        insuredebitnotelines : Record 51513087;
        insurecreditnotelines : Record 51513089;
        TL : Decimal;
        PCF : Decimal;
        SD : Decimal;
        amountpaid : Decimal;
        oustandingpremiums : Decimal;
        openingbal : Decimal;
        closingbal : Decimal;
        formatadd : Codeunit 365;
        cust2 : Record 18;
        custaddr : array [10] of Text[100];
        check : Integer;
        alltransactions : Boolean;
        includeunappliedentries : Boolean;
        CustNo : Code[20];
        CustRec : Record 18;
        USD : Integer;
        sum1 : Decimal;
        sum2 : Decimal;
        check2 : Integer;
        BalatopeningKSH : Decimal;
        BalatopeningUSD : Decimal;
        BalatclosingKSH : Decimal;
        BalatclosingUSD : Decimal;
        Custledgerentries : Record 21;
        rembal : Decimal;
        Paidamount77 : Decimal;
        runningtot : Decimal;
        CurrCode : Code[10];
        RunningBalance : Decimal;
        OpeningBalanceadded : Boolean;
        StartBalance : Decimal;
        RunningBalanceUSD : Decimal;
        rembalUSD : Decimal;
        Paidamount77USD : Decimal;
}

