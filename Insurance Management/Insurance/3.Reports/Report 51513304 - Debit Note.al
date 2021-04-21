report 51513304 "Debit Note"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Debit Note.rdl';

    dataset
    {
        dataitem("Insure Debit Note"; "Insure Debit Note")
        {
            DataItemTableView = WHERE("Document Type" = CONST("Debit Note"));
            RequestFilterFields = "No.", "Insured No.";
            column(Picture; CompInfor.Picture)
            {
            }
            column(CName; CompInfor.Name)
            {
            }
            column(CAddress; CompInfor.Address)
            {
            }
            column(CAdd2; CompInfor."Address 2")
            {
            }
            column(CCity; CompInfor.City)
            {
            }
            column(CPhoneNo; CompInfor."Phone No.")
            {
            }
            column(CEmail; CompInfor."E-Mail")
            {
            }
            column(CWeb; CompInfor."Home Page")
            {
            }
            column(CFaxno; CompInfor."Fax No.")
            {
            }
            column(CustAddress; CustAddress)
            {
            }
            column(CustAddress2; CustAddress2)
            {
            }
            column(CustAddress3; CustAddress3)
            {
            }
            column(No_InsureHeader; "No.")
            {
            }
            column(InsuredNo_InsureHeader; "Insured No.")
            {
            }
            column(CoverPeriod_InsureHeader; "Insure Debit Note"."Cover Period")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Debit Note"."Policy No")
            {
            }
            column(CoverType_InsureHeader; "Insure Debit Note"."Cover Type")
            {
            }
            column(CoverTypeDescription_InsureHeader; "Insure Debit Note"."Cover Type Description")
            {
            }
            column(PolicyClass_InsureHeader; "Insure Debit Note"."Policy Class")
            {
            }
            column(InsuredName_InsureHeader; "Insure Debit Note"."Insured Name")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Debit Note"."Total Sum Insured")
            {
            }
            column(TotalPremiumAmount_InsureHeader; "Insure Debit Note"."Total Premium Amount")
            {
            }
            column(TotalDiscountAmount_InsureHeader; "Insure Debit Note"."Total  Discount Amount")
            {
            }
            column(TotalCommissionDue_InsureHeader; "Insure Debit Note"."Total Commission Due")
            {
            }
            column(TotalCommissionOwed_InsureHeader; "Insure Debit Note"."Total Commission Owed")
            {
            }
            column(TotalTrainingLevy_InsureHeader; "Insure Debit Note"."Total Training Levy")
            {
            }
            column(TotalStampDuty_InsureHeader; "Insure Debit Note"."Total Stamp Duty")
            {
            }
            column(TotalTax_InsureHeader; "Insure Debit Note"."Total Tax")
            {
            }
            column(FamilyName_InsureHeader; "Insure Debit Note"."Family Name")
            {
            }
            column(Title_InsureHeader; "Insure Debit Note".Title)
            {
            }
            column(NumberText1; NumberText[1])
            {
            }
            column(NumberText2; NumberText[2])
            {
            }
            column(CoverStartDate_InsureHeader; "Insure Debit Note"."Cover Start Date")
            {
            }
            column(CoverEndDate_InsureHeader; "Insure Debit Note"."Cover End Date")
            {
            }
            column(BrokersName_InsureHeader; "Insure Debit Note"."Brokers Name")
            {
            }
            column(BranchNameCaption; BranchName)
            {
            }
            column(UndewriterName_InsureHeader; "Insure Debit Note"."Underwriter")
            {
            }
            dataitem("Insure Debit Note Lines"; "Insure Debit Note Lines")
            {
                DataItemLink = "Document No." = FIELD("No."),
                               "Document Type" = FIELD("Document Type");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Description Type" = FILTER("Schedule of Insured" | Tax),
                                          Amount = FILTER(<> 0));
                column(SumInsured_InsureLines; "Insure Debit Note Lines"."Sum Insured")
                {
                }
                column(NetPremium_InsureLines; "Insure Debit Note Lines"."Net Premium")
                {
                }
                column(AccountNo_InsureLines; "Insure Debit Note Lines"."Account No.")
                {
                }
                column(StartDate_InsureLines; "Insure Debit Note Lines"."Start Date")
                {
                }
                column(EndDate_InsureLines; "Insure Debit Note Lines"."End Date")
                {
                }
                column(Commission_InsureLines; "Insure Debit Note Lines".Commission)
                {
                }
                column(YearofManufacture_InsureLines; "Insure Debit Note Lines"."Year of Manufacture")
                {
                }
                column(RiskID_InsureLines; "Insure Debit Note Lines"."Risk ID")
                {
                }
                column(VehicleTonnage_InsureLines; "Insure Debit Note Lines"."Vehicle Tonnage")
                {
                }
                column(VehicleLicenseClass_InsureLines; "Insure Debit Note Lines"."Vehicle License Class")
                {
                }
                column(Model_InsureLines; "Insure Debit Note Lines".Model)
                {
                }
                column(VehicleUsage_InsureLines; "Insure Debit Note Lines"."Vehicle Usage")
                {
                }
                column(CoverDescription_InsureLines; "Insure Debit Note Lines"."Cover Description")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Debit Note Lines"."Registration No.")
                {
                }
                column(Make_InsureLines; "Insure Debit Note Lines".Make)
                {
                }
                column(RadioCassette_InsureLines; "Insure Debit Note Lines"."Radio Cassette")
                {
                }
                column(Windscreen_InsureLines; "Insure Debit Note Lines".Windscreen)
                {
                }
                column(CoverType_InsureLines; "Insure Debit Note Lines"."Cover Type")
                {
                }
                column(MemberCode_InsureLines; "Insure Debit Note Lines".Colour)
                {
                }
                column(AreaofCover_InsureLines; "Insure Debit Note Lines"."Area of Cover")
                {
                }
                column(PolicyType_InsureLines; "Insure Debit Note Lines"."Policy Type")
                {
                }
                column(Amt; "Insure Debit Note Lines".Amount)
                {
                }
                column(Tax_InsureLines; "Insure Debit Note Lines".Tax)
                {
                }
                column(GrossPremium_InsureLines; "Insure Debit Note Lines"."Gross Premium")
                {
                }
                column(DocumentType_InsureLines; "Insure Debit Note Lines"."Document Type")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                IF Cust.GET("Insure Debit Note"."Insured No.") THEN
                    CustAddress := Cust.Address;
                CustAddress2 := Cust."Address 2";
                CustAddress3 := Cust.City;
                //Branch
                IF DimValue.GET("Insure Debit Note"."Shortcut Dimension 1 Code") THEN
                    BranchName := DimValue.Name;

                InitTextVariable;
                FormatNoText(NumberText, "Total Net Premium", CurrencyCodeText);
            end;

            trigger OnPreDataItem();
            begin
                //"Insure Debit Note".SETRANGE("Insure Debit Note"."Insured No.",Cust."No.");
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
        ClassLbl = 'Class:'; DebitNoteNo = 'Debit note no.'; BrachLbl = 'Branch:'; AgencyLbl = 'Agency:'; AccountnoLbl = 'Account number:'; AddressLbl = 'Address:'; DateLbl = 'Date'; PolicynoLbl = 'Policy number'; InsuredLbl = 'Insured:'; EndorsementnoLbl = 'Endors. Number'; Coverfromlbl = 'Cover from:'; ToLbl = 'to:'; ReferencenoLbl = 'Reference no.'; ParticularsLbl = 'Particulars:'; CurrencyLbl = 'Currency:'; KshLbl = 'KSHS First copy'; SecondCopyLbl = 'Second copy'; BeingRefundPremium = 'Being: Refiund premium on the above policy'; AmountInWordsLbl = 'Amount In words:'; TotalLbl = 'Total to your account'; ForLbl = 'For & on behalf of Transco op insurance company'; IssuedByLbl = 'Issued by:'; CheckedbyLbl = 'Checked by:'; SignatureLbl = 'Signature:'; onthisdateLbl = 'on this date';
    }

    trigger OnInitReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor: Record 79;
        Cust: Record Customer;
        CustAddress: Text;
        CustAddress2: Text;
        CustAddress3: Text;
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        ReceiptCaptiononLbl: Label 'Receipt';
        Text000: Label 'Preview is not allowed.';
        TXT002: Label '%1, %2 %3';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label '" is already applied to %1 %2 for customer %3."';
        Text031: Label '" is already applied to %1 %2 for vendor %3."';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        NumberText: array[2] of Text[80];
        CurrencyCodeText: Code[10];
        DimValue: Record "Dimension Value";
        BranchName: Text;

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;
}

