xmlport 50100 Dimensions
{
    // version FINANCE

    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Xml;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Dimensions)
        {
            tableelement("Dimension Value"; "Dimension Value")
            {
                XmlName = 'Activity';
                fieldelement(Code; "Dimension Value".Code)
                {
                }
                fieldelement(name; "Dimension Value".Name)
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    "Dimension Value"."Dimension Code" := 'SUB-ITEM';
                    "Dimension Value"."Global Dimension No." := 3;
                end;
            }
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
        //  PayDeduct: Record 51511111;
        LoanBalance: Decimal;
        MonthStartDate: Date;
        Counter: Integer;
        CompInfo: Record "Company Information";
        //SalaryEFT: XMLport 51511014;
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

