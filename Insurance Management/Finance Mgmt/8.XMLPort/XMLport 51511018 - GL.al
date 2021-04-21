xmlport 51511018 GL
{
    // version FINANCE

    Direction = Export;
    Format = Xml;
    FormatEvaluate = Xml;
    //TextEncoding = WINDOWS;

    schema
    {
        textelement(Salary)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'procurement_req';
                fieldelement(EMPNO; "Gen. Journal Line"."Journal Template Name")
                {
                }
                fieldelement(EMPNAME; "Gen. Journal Line"."Journal Batch Name")
                {
                }
                fieldelement(WE; "Gen. Journal Line"."Line No.")
                {
                }
                fieldelement(ER; "Gen. Journal Line"."Account Type")
                {
                }
                fieldelement(AC; "Gen. Journal Line"."Account No.")
                {
                }
                fieldelement(PO; "Gen. Journal Line"."Posting Date")
                {
                }
                fieldelement(DC; "Gen. Journal Line"."Document No.")
                {
                }
                fieldelement(DIS; "Gen. Journal Line".Description)
                {
                }
                fieldelement(AM; "Gen. Journal Line".Amount)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Month Begin Date"; MonthStartDate)
                {
                    Caption = 'Month Begin Date';
                }
            }
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        //Payments.SETRANGE(Payments."Date Posted",Payments."Date Filter");
        //Employee.SETFILTER("Pay Period Filter",'%1',MonthStartDate);
    end;

    var
        BatchNo: Code[20];
        ContributionHeader: Record Payments1;
        LineNo: Integer;
        VendBankAcc: Record "Vendor Bank Account";
        Vend: Record Vendor;
        PVLines: Record "PV Lines1";
        Name: Text;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        NetPay: Decimal;
        BankCode: Code[10];
        RefNo: Date;
        Amount: Text[30];
        //payroll: Codeunit 51511052;
        Amtlen: Integer;
        Space: Text[12];
        i: Integer;
        j: Integer;
        BankAcc: Text[20];
        Amtlen2: Integer;
        Space2: Text[20];
        BankName: Text[50];
        BranchName: Text[50];
        EmpBank: Record "Staff  Bank Account";
        ExcelBuf: Record "Excel Buffer" temporary;
        TotalNet: Decimal;
        BranchCode: Code[10];
        TextRefNo: Text[50];
        //PayrollPeriods: Record 51511105;
        GrossPay: Decimal;
        TotalDeduction: Decimal;
        //Earn: Record "Earnings";
        //Deduct: Record 51511109;
        //AssignMatrix: Record 51511111;
        PositivePAYEManual: Decimal;
        //PayDeduct: Record 51511111;
        LoanBalance: Decimal;
        MonthStartDate: Date;
        Counter: Integer;
        CompInfo: Record "Company Information";
        //SalaryEFT: XMLport "Salary EFT";
        OutStreamx: OutStream;

    procedure GetRecHeader(var ContribHeader: Record Payments1)
    begin
        BatchNo := ContribHeader.No;
        ContributionHeader.COPY(ContribHeader);
    end;

    procedure PayrollRounding(var Amount: Decimal) PayrollRounding: Decimal
    var
        HRsetup: Record "Human Resources Setup";
    begin

        /*  HRsetup.GET;
         IF HRsetup."Payroll Rounding Precision" = 0 THEN
             ERROR('You must specify the rounding precision under HR setup');

         IF HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Nearest THEN
             PayrollRounding := ROUND(Amount, HRsetup."Payroll Rounding Precision", '=');

         IF HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Up THEN
             PayrollRounding := ROUND(Amount, HRsetup."Payroll Rounding Precision", '>');

         IF HRsetup."Payroll Rounding Type" = HRsetup."Payroll Rounding Type"::Down THEN
             PayrollRounding := ROUND(Amount, HRsetup."Payroll Rounding Precision", '<'); */
    end;

    procedure ChckRound(var AmtText: Text[30]) ChckRound: Text[30]
    var
        LenthOfText: Integer;
        DecimalPos: Integer;
        AmtWithoutDec: Text[30];
        DecimalAmt: Text[30];
        Decimalstrlen: Integer;
    begin
        LenthOfText := STRLEN(AmtText);
        DecimalPos := STRPOS(AmtText, '.');
        IF DecimalPos = 0 THEN BEGIN
            AmtWithoutDec := AmtText;
            DecimalAmt := '.00';
        END ELSE BEGIN
            AmtWithoutDec := COPYSTR(AmtText, 1, DecimalPos - 1);
            DecimalAmt := COPYSTR(AmtText, DecimalPos + 1, 2);
            Decimalstrlen := STRLEN(DecimalAmt);
            IF Decimalstrlen < 2 THEN BEGIN
                DecimalAmt := '.' + DecimalAmt + '0';
            END ELSE
                DecimalAmt := '.' + DecimalAmt
        END;
        ChckRound := AmtWithoutDec + DecimalAmt;
    end;
}

