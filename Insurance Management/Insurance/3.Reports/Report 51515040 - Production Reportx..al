report 51515040 "Production Reportx."
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Production Reportx..rdl';

    dataset
    {
        dataitem(DataItem1;21)
        {
            //DataItemTableView = '';
            RequestFilterFields = "Posting Date";
            column(GrossPremium;GrossPremium)
            {
            }
            column(Amt;Amt)
            {
            }
            column(TransactionTypeS;TransactionTypeS)
            {
            }
            column(PostingDate;"Posting Date")
            {
            }
            column(InsuredNAme;InsuredNAme)
            {
            }
            column(ClassOfInsurance;ClassOfInsurance)
            {
            }
            column(POlicyNo;POlicyNo)
            {
            }
            column(NetPremium;NetPremium)
            {
            }
            column(Insurer;Insurer)
            {
            }
            column(ITL;ITL)
            {
            }
            column(PCF;PCF)
            {
            }
            column(SD;SD)
            {
            }
            column(filtered;GETFILTERS)
            {
            }
            column(Debitno;Debitno)
            {
            }
            dataitem(DataItem2;79)
            {
                column(Name_CompanyInformation;Name)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                //==============================================
                ITL:=0;
                SD:=0;
                PCF:=0;
                Insurer:='';
                //==============================================
                PostedDebitNote.RESET;
                PostedDebitNote.SETFILTER(PostedDebitNote."No.",'%1',"Document No.");
                IF PostedDebitNote.FINDSET THEN BEGIN
                            Debitno:=PostedDebitNote."No.";
                            InsuredNAme:=PostedDebitNote."Insured Name" ;
                            PolicyRec.RESET;
                            PolicyRec.SETFILTER(PolicyRec.Code,PostedDebitNote."Policy Type");
                            IF PolicyRec.FINDSET THEN
                               ClassOfInsurance:=PolicyRec.Description;

                            Insurer:=PostedDebitNote."Undewriter Name";
                            POlicyNo:=PostedDebitNote."Policy No";
                            IF PostedDebitNote."Quote Type"=PostedDebitNote."Quote Type"::New THEN
                            TransactionTypeS:='NB';
                            IF PostedDebitNote."Quote Type"=PostedDebitNote."Quote Type"::Renewal THEN
                            TransactionTypeS:='REN';

                            IF PostedDebitNote."Quote Type"=PostedDebitNote."Quote Type"::Modification THEN
                            IF PostedDebitNote."Modification Type"=PostedDebitNote."Modification Type"::Addition THEN
                            TransactionTypeS:='END';

                            PostedDebitNote.CALCFIELDS(PostedDebitNote."Total Premium Amount");
                            NetPremium:=ROUND(PostedDebitNote."Total Premium Amount",1);
                            IF PostedDebitNote."Currency Code"='USD' THEN BEGIN
                              IF Othercurrency=0 THEN BEGIN
                                 NetPremium:=NetPremium/PostedDebitNote."Currency Factor";
                              END;
                            END;

                            PostedDebitNoteLines.RESET;
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines."Document No.",PostedDebitNote."No.");
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines.Tax,'%1',TRUE);
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines.Description,'Training Levy');
                            IF PostedDebitNoteLines.FINDSET THEN BEGIN
                               ITL:=PostedDebitNoteLines.Amount;
                               IF PostedDebitNote."Currency Code"='USD' THEN BEGIN
                                  IF Othercurrency=0 THEN BEGIN
                                     ITL:=ITL/PostedDebitNote."Currency Factor";
                                  END
                               END;
                            END;

                            PostedDebitNoteLines.RESET;
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines."Document No.",PostedDebitNote."No.");
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines.Tax,'%1',TRUE);
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines.Description,'PCF');
                            IF PostedDebitNoteLines.FINDSET THEN BEGIN
                               PCF:=PostedDebitNoteLines.Amount;
                               IF PostedDebitNote."Currency Code"='USD' THEN BEGIN
                                  IF Othercurrency=0 THEN BEGIN
                                     PCF:=PCF/PostedDebitNote."Currency Factor";
                                  END;
                               END;
                            END;

                            PostedDebitNoteLines.RESET;
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines."Document No.",PostedDebitNote."No.");
                            PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines.Tax,'%1',TRUE);
                            //PostedDebitNoteLines.SETFILTER(PostedDebitNoteLines.Description,'Stamp Duty');
                            IF PostedDebitNoteLines.FINDSET THEN BEGIN
                               REPEAT
                                  IF PostedDebitNoteLines.Description<>'PCF' THEN BEGIN
                                     IF PostedDebitNoteLines.Description<>'Training Levy' THEN BEGIN
                                        SD:=SD+PostedDebitNoteLines.Amount;
                                     END;
                                  END;
                               UNTIL PostedDebitNoteLines.NEXT=0;
                                    IF PostedDebitNote."Currency Code"='USD' THEN BEGIN
                                       IF Othercurrency=0 THEN BEGIN
                                          SD:=SD/PostedDebitNote."Currency Factor";
                                       END;
                                    END;

                            END;


                  END;


                creditnote.SETRANGE(creditnote."No.","Document No.");
                IF creditnote.FINDSET THEN BEGIN
                        Debitno:=creditnote."No.";
                        TransactionTypeS:='END';
                        InsuredNAme:=creditnote."Insured Name";

                        PolicyRec.RESET;
                        PolicyRec.SETFILTER(PolicyRec.Code,creditnote."Policy Type");
                        IF PolicyRec.FINDSET THEN
                        ClassOfInsurance:=PolicyRec.Description;

                        Insurer:=creditnote."Undewriter Name";
                        POlicyNo:=creditnote."Policy No";

                        creditnote.CALCFIELDS(creditnote."Total Premium Amount");
                        NetPremium:=-ROUND(creditnote."Total Premium Amount",1);
                        IF creditnote."Currency Code"='USD' THEN BEGIN
                           IF Othercurrency=0 THEN BEGIN
                              NetPremium:=NetPremium/creditnote."Currency Factor";
                           END;
                        END;


                          creditnoteLines.RESET;
                          creditnoteLines.SETFILTER(creditnoteLines."Document No.",creditnote."No.");
                          creditnoteLines.SETFILTER(creditnoteLines.Tax,'%1',TRUE);
                          creditnoteLines.SETFILTER(creditnoteLines.Description,'Training Levy');
                          IF creditnoteLines.FINDSET THEN BEGIN
                             ITL:=-creditnoteLines.Amount;
                              IF creditnote."Currency Code"='USD' THEN BEGIN
                                 IF Othercurrency=0 THEN BEGIN
                                    ITL:=ITL/creditnote."Currency Factor";
                                 END;
                              END;
                          END;

                          creditnoteLines.RESET;
                          creditnoteLines.SETFILTER(creditnoteLines."Document No.",creditnote."No.");
                          creditnoteLines.SETFILTER(creditnoteLines.Tax,'%1',TRUE);
                          creditnoteLines.SETFILTER(creditnoteLines.Description,'PCF');
                          IF creditnoteLines.FINDSET THEN BEGIN
                             PCF:=-creditnoteLines.Amount;
                              IF creditnote."Currency Code"='USD' THEN BEGIN
                                 IF Othercurrency=0 THEN BEGIN
                                    PCF:=PCF/creditnote."Currency Factor";
                                 END;
                              END;
                          END;

                          creditnoteLines.RESET;
                          creditnoteLines.SETFILTER(creditnoteLines."Document No.",creditnote."No.");
                          creditnoteLines.SETFILTER(creditnoteLines.Tax,'%1',TRUE);
                          creditnoteLines.SETFILTER(creditnoteLines.Description,'Stamp Duty');
                          IF creditnoteLines.FINDSET THEN BEGIN
                               REPEAT
                                  IF creditnoteLines.Description<>'PCF' THEN BEGIN
                                     IF creditnoteLines.Description<>'Training Levy' THEN BEGIN
                                        SD:=SD+ABS(creditnoteLines.Amount);
                                     END;
                                  END;
                               UNTIL creditnoteLines.NEXT=0;

                            // SD:=-creditnoteLines.Amount;
                            SD:=0-SD;
                              IF creditnote."Currency Code"='USD' THEN BEGIN
                                 IF Othercurrency=0 THEN BEGIN
                                    SD:=SD/creditnote."Currency Factor";
                                 END;
                              END;

                          END;


                 END;
                GrossPremium:=NetPremium+ITL+PCF+SD;
                ClassOfInsurance:=COPYSTR(ClassOfInsurance,1,15);
                Insurer:=COPYSTR(Insurer,1,18);
                InsuredNAme:=COPYSTR(InsuredNAme,1,20);
                //Message('%1',"Document No.");
                IF Insurer='' THEN BEGIN
                   CurrReport.SKIP;
                END;
            end;

            trigger OnPreDataItem();
            begin


                //LastFieldNo := FIELDNO("Customer No.");
                //CurrReport.CREATETOTALS(GrossPremium,TaxesArrayVal,Amt);

                IF GETFILTER("Currency Code")<>'' THEN BEGIN
                   Othercurrency:=7;
                END;
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
          CompInfor.GET;
          CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor : Record 79;
        LastFieldNo : Integer;
        FooterPrinted : Boolean;
        PostedDebitNote : Record 51513086;
        PostedDebitNoteLines : Record 51513087;
        Taxes : Record 5630;
        TaxesArray : array [10] of Code[10];
        TaxesArrayVal : array [10] of Decimal;
        i : Integer;
        SalesLine : Record 51513017;
        GrossPremium : Decimal;
        NetPremium : Decimal;
        TaxesArraydesc : array [10] of Text[30];
        TransactionTypeS : Text[50];
        InsuredNAme : Text[250];
        ClassOfInsurance : Text[250];
        POlicyNo : Code[30];
        Insurer : Text[250];
        creditnote : Record 51513088;
        creditnoteLines : Record 51513089;
        SalesCRLine : Record 51513017;
        PolicyRec : Record 51513000;
        Amt : Decimal;
        ITL : Decimal;
        PCF : Decimal;
        SD : Decimal;
        Debitno : Code[20];
        Othercurrency : Integer;
}

