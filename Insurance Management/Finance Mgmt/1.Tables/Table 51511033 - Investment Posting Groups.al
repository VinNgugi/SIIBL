table 51511033 "Investment Posting Groups"
{
    // version FINANCE

    //DrillDownPageID = 51515528;
    //LookupPageID = 51515528;

    fields
    {
        field(1; "Code"; Code[30])
        {
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Investment Cost Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Investment Revaluation Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Investment Income Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Ledger Code"; Code[30])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Gain/Loss on Disposal Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Capital Reserve Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(9; "Mortgage Arrears Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(10; "Revaluation Gain/Loss"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(11; "Commissions Ac"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Security Cost Ac"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(13; "Other Cost Ac"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(14; "Dividend Receivable AC"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(15; "Dividend Income AC"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(16; "Withholding Tax Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(17; "Unit Trust Members A/c"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(18; "Bonus Income AC"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(19; "Interest Receivable Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(20; "Other Charges A/C"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50000; "Investment Type Code"; Code[30])
        {
            TableRelation = "Investment Types";

            trigger OnValidate()
            begin
                /*
                  IF InvestmentType.GET("Investment Type") THEN
                      BEGIN
                   //"Investment Type Name":=InvestmentType.Description;
                
                   IF "Investment Type Code"='01'THEN
                      BEGIN
                
                     // "Investment Posting Group":='QUOTED EQUITY KENYA';
                      "Purchase Link":= 'QUOTED-BUY';
                      "Sale Link":= 'QUOTE-SALE';
                      "Dividend Link":='DIVIDEND-QUOTED';
                      "RBA Class":='05';
                      END;
                
                 IF  "Investment Type Code"='10'THEN
                       BEGIN
                  "NSE Website":=InvestmentSetup."NSE Website";
                
                      "Investment Posting Group":='UN EQUITIES';
                      "Purchase Link":= 'UNQUOTE-SALE';
                      "Sale Link":= 'UNQUOTED-BUY';
                      "Dividend Link":='DIVIDEND-UNQUOTED';
                      "RBA Class":='06';
                           END;
                
                 IF "Investment Type Code"='06' THEN
                     BEGIN
                     "RBA Class":='05';
                
                     END;
                 IF "Investment Type Code"='07' THEN
                     BEGIN
                       "Investment Posting Group":='COMMPAPERS';
                      "Purchase Link":='COMMPAPER-BUY';
                      "Sale Link":='COMMPAPER-SALE';
                      "Interest Link":='INTCOMMPAPER';
                      "RBA Class":='03';
                      END;
                 IF "Investment Type Code"='08' THEN
                     BEGIN
                     END;
                 IF "Investment Type Code"='12' THEN
                     BEGIN
                      "Investment Posting Group":='CALL DEPOSITS';
                      "Purchase Link":= 'CALLDEPOSIT-BUY';
                      "Sale Link":='CALLDEPOSIT-SALE';
                      "Interest Link":='INT CALL DEPOSITS';
                      "RBA Class":='02';
                
                     END;
                 IF "Investment Type Code"='13' THEN
                     BEGIN
                      "Investment Posting Group":='FIXED DEPOSITS';
                      "Purchase Link":= 'FIXED BUY';
                      "Sale Link":='FIXED SALE';
                      "Interest Link":='INT FIXED DEPOSIT';
                      "RBA Class":='02';
                
                     END;
                 IF "Investment Type Code"='14' THEN
                     BEGIN
                     END;
                 IF "Investment Type Code"='15' THEN
                     BEGIN
                      "Investment Posting Group":='TRESURY BILLS';
                      "Purchase Link":= 'TBILLS BUY';
                      "Sale Link":='TBILLS-SALE';
                      "Interest Link":= 'INT TBILLS';
                      "RBA Class":='04';
                
                     END;
                 IF "Investment Type Code"='16' THEN
                     BEGIN
                      "Investment Posting Group":='COPBOND';
                      "Purchase Link":= 'CORBOND-BUY';
                      "Sale Link":='CORBOND-SALE';
                      "Interest Link":='INT CORPORATE';
                      "RBA Class":='03';
                
                     END;
                
                 IF "Investment Type Code"='17' THEN
                     BEGIN
                      "Investment Posting Group":='OFFSHORE';
                      "Purchase Link":= 'OFFSHORE-BUY';
                      "Sale Link":='OFFSHORE-SALE';
                       "Dividend Link":='OFFSHORE-INCOME';
                      "RBA Class":='07';
                     END;
                
                   END;
                
                 IF "Investment Type Code"='18' THEN
                     BEGIN
                      "Investment Posting Group":='UNIT';
                      "Purchase Link":= 'UNIT-BUY';
                      "Sale Link":='UNIT-SALE';
                      "Interest Link":='INT UNIT TRUST';
                      "RBA Class":='08';
                
                     END;
                
                
                  */


                /*
                 IF InvestmentType."Interest Rate p.a"<>0 THEN
                 "Rate %":=InvestmentType."Interest Rate p.a";
                 "Interest Frequency Period":=InvestmentType."Repayment Frequency";
                 "Grace Period":=InvestmentType."Grace Period";
                END;  */

            end;
        }
        field(50002; "Bond sale type"; Option)
        {
            OptionMembers = " ","Held to Maturity","Available for Sale","Fair Value";
        }
        field(50003; Institution; Code[20])
        {
            TableRelation = Institutions;

            trigger OnValidate()
            begin
                /*
                IF Institutions.GET(Institution) THEN
                BEGIN
                Description:=Institutions."Search Name";
                //"Investment Type":=Institutions."Investment type";
                //"Investment Type Name":=Institutions."Investment Type Name";
                
                
                   IF "Investment Type"='01'THEN
                      BEGIN
                
                
                      "Investment Posting Group":='QUOTED EQUITY KENYA';
                      "Purchase Link":= 'QUOTED-BUY';
                      "Sale Link":= 'QUOTE-SALE';
                      "Dividend Link":='DIVIDEND-QUOTED';
                      "RBA Class":='05';
                      END;
                
                 IF  "Investment Type Name"='10'THEN
                       BEGIN
                  "NSE Website":=InvestmentSetup."NSE Website";
                
                      "Investment Posting Group":='UN EQUITIES';
                      "Purchase Link":= 'UNQUOTE-SALE';
                      "Sale Link":= 'UNQUOTED-BUY';
                      "Dividend Link":='DIVIDEND-UNQUOTED';
                      "RBA Class":='06';
                           END;
                
                 IF "Investment Type Name"='06' THEN
                     BEGIN
                     "RBA Class":='04';
                
                     END;
                 IF "Investment Type Name"='07' THEN
                     BEGIN
                       "Investment Posting Group":='COMMPAPERS';
                      "Purchase Link":='COMMPAPER-BUY';
                      "Sale Link":='COMMPAPER-SALE';
                      "Interest Link":='INTCOMMPAPER';
                      "RBA Class":='03';
                      END;
                 IF "Investment Type Name"='08' THEN
                     BEGIN
                     END;
                 IF "Investment Type Name"='12' THEN
                     BEGIN
                      "Investment Posting Group":='CALL DEPOSITS';
                      "Purchase Link":= 'CALLDEPOSIT-BUY';
                      "Sale Link":='CALLDEPOSIT-SALE';
                      "Interest Link":='INT CALL DEPOSITS';
                      "RBA Class":='02';
                
                     END;
                 IF "Investment Type Name"='13' THEN
                     BEGIN
                      "Investment Posting Group":='FIXED DEPOSITS';
                      "Purchase Link":= 'FIXED BUY';
                      "Sale Link":='FIXED SALE';
                      "Interest Link":='INT FIXED DEPOSIT';
                      "RBA Class":='02';
                
                     END;
                 IF "Investment Type Name"='14' THEN
                     BEGIN
                     END;
                 IF "Investment Type Name"='15' THEN
                     BEGIN
                      "Investment Posting Group":='TRESURY BILLS';
                      "Purchase Link":= 'TBILLS BUY';
                      "Sale Link":='TBILLS-SALE';
                      "Interest Link":= 'INT TBILLS';
                      "RBA Class":='04';
                
                     END;
                 IF "Investment Type Name"='16' THEN
                     BEGIN
                      "Investment Posting Group":='COPBOND';
                      "Purchase Link":= 'CORBOND-BUY';
                      "Sale Link":='CORBOND-SALE';
                      "Interest Link":='INT CORPORATE';
                      "RBA Class":='04';
                
                     END;
                
                 IF "Investment Type Name"='17' THEN
                     BEGIN
                     END;
                END;
                */

            end;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

