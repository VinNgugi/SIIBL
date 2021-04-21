report 51514050 "Master Commission Report New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Master Commission Report New.rdl';

    dataset
    {
        dataitem(DtldCustLedgEntries;379)
        {
            DataItemTableView = SORTING("Posting Date")
                                WHERE("Entry Type"=CONST("Initial Entry"));
            RequestFilterFields = "Posting Date","Currency Code","Document Type","Document No.","Customer No.";
            column(Doc_No_;DtldCustLedgEntries."Document No.")
            {
            }
            column(Invoice_Date;DtldCustLedgEntries."Posting Date")
            {
            }
            column(Insured_Name;Insured)
            {
            }
            column(Date1;Date1)
            {
            }
            column(Date2;Date2)
            {
            }
            column(Basic_Premium;GrossPremium)
            {
            }
            column(Rate;CommissionRate)
            {
            }
            column(Gross_Commission;ROUND(GrossPremium* (CommissionRate/100),1))
            {
            }
            column(Witholding_Tax;ROUND((GrossPremium*(CommissionRate/100))*0.05,1))
            {
            }
            column(Net_Commission;ROUND((GrossPremium*(CommissionRate/100))*0.95,1))
            {
            }
            column(filtered;GETFILTERS)
            {
            }
            column(WTax;WTax)
            {
            }
            column(classname;classname)
            {
            }
            dataitem(DataItem12;79)
            {
                column(Name_CompanyInformation;Name)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin

                Class:='';
                PolicyNumber:='';
                GrossPremium:=0;
                CommissionRate:=0;

                FOR i:=1 TO 10 DO
                BEGIN
                    CLEAR(TaxesArrayVal[i]);
                END;

                IF DebitNote.GET(DtldCustLedgEntries."Document No.",1) THEN
                BEGIN
                         //====================================================================
                         IF PolicyTypeDesc <> '' THEN
                         BEGIN
                            IF PolicyTypeDesc <> DebitNote."Policy Type"
                            THEN
                            BEGIN
                               CurrReport.SKIP;
                            END;
                         END;
                         //====================================================================

                         PolicyType.RESET;
                         PolicyType.SETFILTER(PolicyType.Code,DebitNote."Policy Type");
                         IF PolicyType.FINDSET THEN  Class:=PolicyType.Description;

                         PolicyNumber:=DebitNote."Policy No";
                         Date1:=DebitNote."From Date";
                         Date2:=DebitNote."To Date";
                         DebitNote.CALCFIELDS(DebitNote."Total Premium Amount");


                          GrossPremium:=DtldCustLedgEntries.Amount;//DebitNote."Total Premium Amount";
                          GrossPremium:=DebitNote."Total Premium Amount";
                          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WTax
                          WTax:=(DebitNote."Commission Due"*GrossPremium/100)*5/100;
                          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


                          CommissionRate:=DebitNote."Commission Due";
                          Insured:=DebitNote."Insured Name";

                             FOR i:=1 TO 10 DO BEGIN
                             SalesLine.RESET;
                             SalesLine.SETRANGE(SalesLine."Document No.",DtldCustLedgEntries."Document No.");
                             SalesLine.SETRANGE(SalesLine.Tax,TRUE);
                             SalesLine.SETRANGE(SalesLine.Description,TaxesArraydesc[i]);
                             IF SalesLine.FIND('-') THEN

                             BEGIN
                             REPEAT
                             TaxesArrayVal[i]:=SalesLine.Amount;

                             UNTIL SalesLine.NEXT=0;
                             END;
                             END;
                             //--------------------------------------------------Conversion------------------------

                             IF DebitNote."Currency Code"='USD' THEN
                             BEGIN
                                GrossPremium:=GrossPremium/DebitNote."Currency Factor";
                               // MESSAGE('Test %1',GrossPremium);
                                WTax:=WTax/DebitNote."Currency Factor";

                                IF othercurrency=7 THEN
                                BEGIN
                                   GrossPremium:=GrossPremium * DebitNote."Currency Factor";

                                   WTax:=(DebitNote."Commission Due"*GrossPremium/100)*5/100;
                                END;
                            END;

                             //--------------------------------------------------End Of Conversion-----------------
                 END;



                IF CreditNote.GET(DtldCustLedgEntries."Document No.",1) THEN BEGIN
                         //====================================================================
                         IF PolicyTypeDesc<>'' THEN BEGIN
                            IF PolicyTypeDesc<>CreditNote."Policy Type" THEN BEGIN
                               CurrReport.SKIP;
                            END;
                         END;
                         //====================================================================


                    PolicyType.RESET;
                    PolicyType.SETFILTER(PolicyType.Code,CreditNote."Policy Type");

                    IF PolicyType.FINDSET THEN
                    Class:=PolicyType.Description;
                    PolicyNumber:=CreditNote."Policy No";
                    Insured:=CreditNote."Insured Name";


                    CommissionRate:=CreditNote."Commission Due";
                    //Date1:=CreditNote."From Date";
                    //Date1:=CreditNote."To Date";

                    CreditNote.CALCFIELDS(CreditNote."Total Premium Amount");
                    GrossPremium:=-DtldCustLedgEntries.Amount;//CreditNote."Total Premium Amount";
                    GrossPremium:=0-CreditNote."Total Premium Amount";
                          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WTax
                      IF GrossPremium<>0 THEN BEGIN
                          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++WTax
                          WTax:=(CreditNote."Commission Due"*GrossPremium/100)*5/100;
                          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                             //--------------------------------------------------Conversion------------------------
                             IF CreditNote."Currency Code"='USD' THEN BEGIN
                                GrossPremium:=GrossPremium/CreditNote."Currency Factor";
                                WTax:=WTax/CreditNote."Currency Factor";
                                IF othercurrency=7 THEN BEGIN
                                   GrossPremium:=GrossPremium*CreditNote."Currency Factor";
                                   WTax:=(CreditNote."Commission Due"*GrossPremium/100)*5/100;
                                END;

                             END;
                             //--------------------------------------------------End Of Conversion-----------------


                       END;
                          //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

                END;


                Classrec.RESET;
                classname:='';
                Debitrec.RESET;
                Creditrec.RESET;

                Debitrec.SETFILTER(Debitrec."No.",DtldCustLedgEntries."Document No.");
                IF Debitrec.FINDSET THEN BEGIN
                   Classrec.SETFILTER(Classrec.Code,'%1',Debitrec."Policy Type");
                   IF Classrec.FINDSET THEN BEGIN
                      classname:=Classrec.Description;
                   END;
                END;

                Creditrec.SETFILTER(Creditrec."No.",DtldCustLedgEntries."Document No.");
                IF Creditrec.FINDSET THEN BEGIN
                   Classrec.SETFILTER(Classrec.Code,'%1',Creditrec."Policy Type");
                   IF Classrec.FINDSET THEN BEGIN
                      classname:=Classrec.Description;
                   END;
                END;

                // <<< Added --> 07-NOV-2018

                IF ZeroRateCommission = TRUE THEN
                BEGIN
                    IF CommissionRate <> 0 THEN CurrReport.SKIP;
                END;

                // >>> Added --> 07-NOV-2018
            end;

            trigger OnPreDataItem();
            begin



                 //DtldCustLedgEntries.SETFILTER(DtldCustLedgEntries."Document Type",'<>%1',DtldCustLedgEntries."Document Type"::" ");
                IF GETFILTER(DtldCustLedgEntries."Currency Code")<>'' THEN BEGIN
                    othercurrency:=7;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(PolicyTypeDesc;PolicyTypeDesc)
                    {
                        Caption = 'Select Policy Type:';
                        //TableRelation = "Policy Sub Class".Code;
                    }
                    field(ZeroRateCommission;ZeroRateCommission)
                    {
                        Caption = 'Zero Rate Commission';
                        ToolTip = 'Display entries where the Commission Due is Zero on the Debit Note';
                    }
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
        Insured : Text[250];
        Taxes : Record 51513121;
        TaxesArray : array [10] of Code[10];
        GLSetup : Record 98;
        CompanyInfo : Record 79;
        Cust2 : Record 18;
        Currency : Record 4;
        Currency2 : Record 4 temporary;
        Language : Record 8;
        "Cust. Ledger Entry" : Record 21;
        DtldCustLedgEntries2 : Record 379;
        AgingBandBuf : Record 47 temporary;
        PrintAllHavingEntry : Boolean;
        PrintAllHavingBal : Boolean;
        PrintEntriesDue : Boolean;
        PrintUnappliedEntries : Boolean;
        PrintReversedEntries : Boolean;
        PrintLine : Boolean;
        LogInteraction : Boolean;
        EntriesExists : Boolean;
        StartDate : Date;
        EndDate : Date;
        "Due Date" : Date;
        CustAddr : array [8] of Text[250];
        CompanyAddr : array [8] of Text[250];
        Description : Text[250];
        StartBalance : Decimal;
        CustBalance : Decimal;
        "Remaining Amount" : Decimal;
        FormatAddr : Codeunit 365;
        SegManagement : Codeunit 5051;
        CurrencyCode3 : Code[10];
        PeriodLength : DateFormula;
        PeriodLength2 : DateFormula;
        DateChoice : Option "Due Date","Posting Date";
        AgingDate : array [5] of Date;
        AgingBandEndingDate : Date;
        IncludeAgingBand : Boolean;
        AgingBandCurrencyCode : Code[10];
        DebitNote : Record 51513086;
        PolicyType : Record 51513000;
        Class : Text[250];
        PolicyNumber : Code[100];
        GrossPremium : Decimal;
        i : Integer;
        SalesLine : Record 51513087;
        TaxesArraydesc : array [10] of Text[250];
        TaxesArrayVal : array [10] of Decimal;
        GrossCommission : Decimal;
        CommissionRate : Decimal;
        TotalGrossPremium : Decimal;
        TotalWtx : Decimal;
        TotalNetPremium : Decimal;
        CreditNote : Record 51513088;
        SalesCrLine : Record 51513089;
        TotalCommission : Decimal;
        Date1 : Date;
        Date2 : Date;
        Text000 : Label 'Page %1';
        Text001 : Label 'Entries %1';
        Text002 : Label 'Overdue Entries %1';
        Text003 : Label '"Statement "';
        Text005 : Label 'Multicurrency Application';
        Text006 : Label 'Payment Discount';
        Text007 : Label 'Rounding';
        Text008 : Label 'You must specify the Aging Band Period Length.';
        Text010 : Label 'You must specify Aging Band Ending Date.';
        Text011 : Label 'Aged Summary by %1 (%2 by %3)';
        Text012 : Label 'Period Length is out of range.';
        Text013 : Label 'Due Date,Posting Date';
        Text014 : Label 'Application Writeoffs';
        Detailedvendor : Record 21;
        GLEntry : Record 17;
        WTax : Decimal;
        PolicyTypeDesc : Text;
        othercurrency : Integer;
        Classrec : Record 51513000;
        classname : Text;
        Debitrec : Record 51513086;
        Creditrec : Record 51513088;
        ZeroRateCommission : Boolean;

    local procedure GetDate(PostingDate : Date;DueDate : Date) : Date;
    begin
        IF DateChoice = DateChoice::"Posting Date" THEN
          EXIT(PostingDate)
        ELSE
          EXIT(DueDate);
    end;

    local procedure CalcAgingBandDates();
    begin
        IF NOT IncludeAgingBand THEN
          EXIT;
        IF AgingBandEndingDate = 0D THEN
          ERROR(Text010);
        IF FORMAT(PeriodLength) = '' THEN
          ERROR(Text008);
        EVALUATE(PeriodLength2,'-' + FORMAT(PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CALCDATE(PeriodLength2,AgingDate[5]);
        AgingDate[3] := CALCDATE(PeriodLength2,AgingDate[4]);
        AgingDate[2] := CALCDATE(PeriodLength2,AgingDate[3]);
        AgingDate[1] := CALCDATE(PeriodLength2,AgingDate[2]);
        IF AgingDate[2] <= AgingDate[1] THEN
          ERROR(Text012);
    end;

    local procedure UpdateBuffer(CurrencyCode : Code[10];Date : Date;Amount : Decimal);
    var
        I : Integer;
        GoOn : Boolean;
    begin
        AgingBandBuf.INIT;
        AgingBandBuf."Currency Code" := CurrencyCode;
        IF NOT AgingBandBuf.FIND THEN
          AgingBandBuf.INSERT;
        I := 1;
        GoOn := TRUE;
        WHILE (I <= 5) AND GoOn DO BEGIN
          IF Date <= AgingDate[I] THEN
            IF I = 1 THEN BEGIN
              AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
              GoOn := FALSE;
            END;
          IF Date <= AgingDate[I] THEN
            IF I = 2 THEN BEGIN
              AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
              GoOn := FALSE;
            END;
          IF Date <= AgingDate[I] THEN
            IF I = 3 THEN BEGIN
              AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
              GoOn := FALSE;
            END;
          IF Date <= AgingDate[I] THEN
            IF I = 4 THEN BEGIN
              AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
              GoOn := FALSE;
            END;
          IF Date <= AgingDate[I] THEN
            IF I = 5 THEN BEGIN
              AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
              GoOn := FALSE;
            END;
          I := I + 1;
        END;
        AgingBandBuf.MODIFY;
    end;

    procedure SkipReversedUnapplied(var DtldCustLedgEntries : Record 379) : Boolean;
    var
        CustLedgEntry : Record 21;
    begin
        IF PrintReversedEntries AND PrintUnappliedEntries THEN
          EXIT(FALSE);
        IF NOT PrintUnappliedEntries THEN
          IF DtldCustLedgEntries.Unapplied THEN
            EXIT(TRUE);
        IF NOT PrintReversedEntries THEN BEGIN
          IF CustLedgEntry.GET(DtldCustLedgEntries."Cust. Ledger Entry No.") THEN BEGIN
              IF CustLedgEntry.Reversed THEN
                EXIT(TRUE);
          END;
        END;
        EXIT(FALSE);
    end;
}

