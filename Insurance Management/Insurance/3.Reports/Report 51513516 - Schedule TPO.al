report 51513516 "Schedule TPO"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Schedule TPO.rdl';

    dataset
    {
        dataitem("Insure Debit Note"; "Insure Debit Note")
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Document Type" = CONST("Debit Note"),
                                     "Action Type" = CONST(New));
            RequestFilterFields = "Shortcut Dimension 1 Code", "Policy No";
            column(TotalNetPremium_InsureDebitNote; "Insure Debit Note"."Total Net Premium")
            {
            }
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
            column(PeriodofInsurance; PeriodofInsurance)
            {
            }
            column(MoreCommentsPeriod; MoreCommentsPeriod)
            {
            }
            column(EndorsementNo1; "Insure Debit Note"."Endorsement Policy No.")
            {
            }
            column(No_InsureHeader; "Insure Debit Note"."No.")
            {
            }
            column(InsuredNo_InsureHeader; "Insure Debit Note"."Insured No.")
            {
            }
            column(CoverPeriod_InsureHeader; "Insure Debit Note"."Cover Period")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Debit Note"."Policy No")
            {
            }
            column(PolicyDescription_InsureDebitNote; "Insure Debit Note"."Policy Description")
            {
            }
            column(CoverTypeDescription_InsureDebitNote; "Insure Debit Note"."Cover Type Description")
            {
            }
            column(PostingDate_InsureDebitNote; "Insure Debit Note"."Posting Date")
            {
            }
            column(TotalSumInsured_InsureDebitNote; "Insure Debit Note"."Total Sum Insured")
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
            column(CreatedBy_InsureDebitNote; "Insure Debit Note"."Created By")
            {
            }
            column(FamilyName_InsureHeader; "Insure Debit Note"."Family Name")
            {
            }
            column(FirstNamess_InsureHeader; "Insure Debit Note"."First Names(s)")
            {
            }
            column(PremiumAmount_InsureDebitNote; "Insure Debit Note"."Premium Amount")
            {
            }
            column(Title_InsureHeader; "Insure Debit Note".Title)
            {
            }
            column(UndewriterName_InsureHeader; "Insure Debit Note"."Undewriter Name")
            {
            }
            column(AgentBroker_InsureDebitNote; "Insure Debit Note"."Agent/Broker")
            {
            }
            column(BrokersName_InsureDebitNote; "Insure Debit Note"."Brokers Name")
            {
            }
            column(CoverStartDate_InsureDebitNote; "Insure Debit Note"."Cover Start Date")
            {
            }
            column(CoverEndDate_InsureDebitNote; "Insure Debit Note"."Cover End Date")
            {
            }
            column(ShowVehicle; ShowVehicle)
            {
            }
            column(ShowWorkmen; ShowWorkmenCompensation)
            {
            }
            column(ShowAllRisks; ShowAllRisks)
            {
            }
            column(ShowMoneyInsurance; ShowMoneyInsurance)
            {
            }
            column(ShowGPA; ShowGroupPersonal)
            {
            }
            column(ShowFidelity; ShowFidelity)
            {
            }
            column(ShowEmployerLiability; ShowEmployerLiability)
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(AgentAddress; AgentAddress)
            {
            }
            column(DocumentDate_InsureDebitNote; "Insure Debit Note"."Document Date")
            {
            }
            column(ClassName; ClassName)
            {
            }
            column(EndorsementNo; EndorsementNo)
            {
            }
            column(NumberText1; NumberText[1])
            {
            }
            column(NumberText2; NumberText[2])
            {
            }
            column(CustOccupation; CustOccupation)
            {
            }
            column(ShowMedical; ShowMedical)
            {
            }
            column(Occupation_InsureDebitNote; "Insure Debit Note".Occupation)
            {
            }
            column(EffectiveStartdate_InsureDebitNote; "Insure Debit Note"."Effective Start date")
            {
            }
            column(PolicyDescription; PolicyDescription)
            {
            }
            column(PolicyActualAmount; PolicyActualAmount)
            {
            }
            dataitem(MotorVehicles; "Insure Debit Note Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Description Type" = CONST("Schedule of Insured"),
                                          "Registration No." = FILTER(<> ' '));
                column(SumInsured_InsureLines; MotorVehicles."Sum Insured")
                {
                }
                column(NetPremium_InsureLines; MotorVehicles."Net Premium")
                {
                }
                column(StartDate_InsureLines; MotorVehicles."Start Date")
                {
                }
                column(EndDate_InsureLines; MotorVehicles."End Date")
                {
                }
                column(YearofManufacture_InsureLines; MotorVehicles."Year of Manufacture")
                {
                }
                column(RiskID_InsureLines; MotorVehicles."Risk ID")
                {
                }
                column(VehicleTonnage_InsureLines; MotorVehicles."Vehicle Tonnage")
                {
                }
                column(VehicleLicenseClass_InsureLines; MotorVehicles."Vehicle License Class")
                {
                }
                column(Model_InsureLines; MotorVehicles.Model)
                {
                }
                column(VehicleUsage_InsureLines; MotorVehicles."Vehicle Usage")
                {
                }
                column(PremiumAmount_InsureLines; MotorVehicles."Premium Amount")
                {
                }
                column(CoverDescription_InsureLines; MotorVehicles."Cover Description")
                {
                }
                column(RegistrationNo_InsureLines; MotorVehicles."Registration No.")
                {
                }
                column(Make_InsureLines; MotorVehicles.Make)
                {
                }
                column(RadioCassette_InsureLines; MotorVehicles."Radio Cassette")
                {
                }
                column(Windscreen_InsureLines; MotorVehicles.Windscreen)
                {
                }
                column(CoverType_InsureLines; MotorVehicles."Cover Type")
                {
                }
                column(AreaofCover_InsureLines; MotorVehicles."Area of Cover")
                {
                }
                column(PolicyType_InsureLines; MotorVehicles."Policy Type")
                {
                }
                column(Amt; MotorVehicles.Amount)
                {
                }
                column(NoOfEmployees; MotorVehicles."No. of Employees")
                {
                }
                column(EstAnnualEarnings; MotorVehicles."Estimated Annual Earnings")
                {
                }
                column(Description; MotorVehicles.Description)
                {
                }
                column(LimitOfLiability; MotorVehicles."Limit of Liability")
                {
                }
                column(Position; MotorVehicles.Position)
                {
                }
                column(Category; MotorVehicles.Category)
                {
                }
                column(EmployeeName; MotorVehicles."Employee Name")
                {
                }
                column(Death; MotorVehicles.Death)
                {
                }
                column(PD; MotorVehicles."Permanent Disability")
                {
                }
                column(TD; MotorVehicles."Temporary Disability")
                {
                }
                column(ME; MotorVehicles."Medical expenses")
                {
                }
                column(TPOPremium_MotorVehicles; MotorVehicles."TPO Premium")
                {
                }
                column(AccountNo_MotorVehicles; MotorVehicles."Account No.")
                {
                }
                column(YearofManufacture_MotorVehicles; MotorVehicles."Year of Manufacture")
                {
                }
                column(TypeofBody_MotorVehicles; MotorVehicles."Type of Body")
                {
                }
                column(CubicCapacitycc_MotorVehicles; MotorVehicles."Cubic Capacity (cc)")
                {
                }
                column(SeatingCapacity_MotorVehicles; MotorVehicles."Seating Capacity")
                {
                }
                column(Name_MotorVehicles; MotorVehicles.Name)
                {
                }
                column(TVA; MotorVehicles."Total Value at Risk")
                {
                }
                column(Relationship2Applicants; MotorVehicles."Relationship to Applicant")
                {
                }
                column(FamilyName; MotorVehicles."Family Name")
                {
                }
                column(FirstName; MotorVehicles."First Name(s)")
                {
                }
                column(Title; MotorVehicles.Title)
                {
                }
                column(Sex; MotorVehicles.Sex)
                {
                }
                column(DOB; MotorVehicles."Date of Birth")
                {
                }
                column(Age; MotorVehicles.Age)
                {
                }
                column(Occupation; MotorVehicles.Occupation)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    // MESSAGE('%1 =%2',MotorVehicles.Description,MotorVehicles.Amount);
                    //MotorVehicles.CALCFIELDS(MotorVehicles."Sum Insured");
                    MotorVehicles.SETRANGE(MotorVehicles."Document No.", MotorVehicles."Document No.");
                    MotorVehicles.FINDLAST;

                    MotorVehicles.SETRANGE(MotorVehicles."Document No.");
                end;
            }
            dataitem(Taxes; "Insure Debit Note Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.")
                                    WHERE("Description Type" = FILTER(Tax),
                                          Amount = FILTER(<> 0));
                column(TaxDescription; Taxes.Description)
                {
                }
                column(TaxAmt; Taxes.Amount)
                {
                }
            }
            dataitem("Policy Details"; "Policy Details")
            {
                DataItemLink = "Policy Type" = FIELD("Policy Type");
                DataItemTableView = SORTING("Policy Type", "Description Type", "No.", "Line No")
                                    WHERE("Description Type" = FILTER(Limits));
                column(Description_PolicyDetails; "Policy Details".Description)
                {
                }
                column(Value_PolicyDetails; "Policy Details".Value)
                {
                }
                column(ActualValue_PolicyDetails; "Policy Details"."Actual Value")
                {
                }
            }
            dataitem(Excess; "Policy Details")
            {
                DataItemLink = "Policy Type" = FIELD("Policy Type");
                DataItemTableView = SORTING("Policy Type", "Description Type", "No.", "Line No")
                                    WHERE("Description Type" = FILTER(Excess));
                column(ActualValue_Excess; Excess."Actual Value")
                {
                }
                column(Description_Excess; Excess.Description)
                {
                }
                column(Value_Excess; Excess.Value)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //MESSAGE('%1',Excess."Actual Value");
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                "Insure Debit Note".SETRANGE("Insure Debit Note"."No.", "Insure Debit Note"."No.");
                "Insure Debit Note".SETRANGE("Insure Debit Note"."Posting Date", "Insure Debit Note"."Posting Date");
                "Insure Debit Note".FINDLAST;
                IF Cust.GET("Insure Debit Note"."Insured No.") THEN
                    CustAddress := Cust.Address;
                CustAddress3 := Cust.City;
                CustOccupation := Cust.Occupation;
                IF Cust."Address 2" <> '' THEN
                    CustAddress2 := 'P.O BOX' + ' ' + Cust."Address 2" + '-' + Cust."Post Code";



                ShowVehicle := FALSE;
                ShowMedical := FALSE;
                ShowWorkmenCompensation := FALSE;
                ShowMoneyInsurance := FALSE;
                ShowGroupPersonal := FALSE;
                ShowFidelity := FALSE;
                ShowPersonalAccident := FALSE;
                ShowBond := FALSE;

                //Period Of Insurance
                PeriodofInsurance := '(a)' + 'From:' + FORMAT("Insure Debit Note"."Cover Start Date") + ' ' + 'To:' + FORMAT("Insure Debit Note"."Cover End Date") + ' ' + '(both dates inclusive)';
                MoreCommentsPeriod := '(b) Any subsequent period for which the insured shall pay and the company shall agree to accept a renewal premium';
                GenLedgSetup.GET;
                BranchCode := "Insure Debit Note"."Shortcut Dimension 1 Code";
                IF DimValue.GET(GenLedgSetup."Global Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                //MESSAGE('%1 %2',BranchName,"Insure Debit Note"."Shortcut Dimension 1 Code");
                Cust.SETRANGE(Cust."No.", "Insure Debit Note"."Insured No.");
                //CustName:=Cust.Name;
                //CustAddress:=Cust.Address;

                //Agent Address
                Cust.RESET;
                Cust.SETRANGE(Cust."No.", "Insure Debit Note"."Agent/Broker");
                IF Cust.FIND('-') THEN
                    AgentAddress := Cust.Address;

                InitTextVariable;
                FormatNoText(NumberText, "Total Net Premium", CurrencyCodeText);



                IF PolicyType.GET("Insure Debit Note"."Policy Type") THEN BEGIN
                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Vehicle THEN
                        ShowVehicle := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Medical THEN
                        ShowMedical := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Other THEN
                        ShowAllRisks := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Fidelity THEN
                        ShowFidelity := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Workmen THEN
                        ShowWorkmenCompensation := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Money THEN
                        ShowMoneyInsurance := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Group Personal" THEN
                        ShowGroupPersonal := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::"Personal Accident" THEN
                        ShowPersonalAccident := TRUE;

                    IF PolicyType."Schedule Subform" = PolicyType."Schedule Subform"::Bond THEN
                        ShowBond := TRUE;




                END;
                //MESSAGE('Vehicle =%1 and Workmen=%2',ShowVehicle,ShowWorkmenCompensation);
                "Insure Debit Note".SETRANGE("Insure Debit Note"."No.");
                "Insure Debit Note".SETRANGE("Insure Debit Note"."Posting Date");
            end;

            trigger OnPreDataItem();
            begin
                //"Insure Header".SETRANGE("Insure Header"."Insured No.",Cust."No.");
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
        ClassLbl = 'Class:'; DebitNoteNo = 'NO:'; BrachLbl = 'Branch:'; AgencyLbl = 'Acount Name:'; AccountnoLbl = 'Agency No:'; AddressLbl = 'Address:'; DateLbl = 'Date of issue'; PolicynoLbl = 'Policy No.'; InsuredLbl = 'Insured Name:'; EndorsementnoLbl = 'Endors. Number'; Coverfromlbl = 'Cover from:'; ToLbl = 'To:'; ReferencenoLbl = 'Reference no.'; ParticularsLbl = 'Particulars of Risk:'; CurrencyLbl = 'Currency:'; KshLbl = 'Kenya Shillings'; SecondCopyLbl = 'Second copy'; BeingRefundPremium = 'Being: Refiund premium on the above policy'; AmountInWordsLbl = 'Amount In words:'; TotalLbl = 'Total to your account'; ForLbl = 'For: MANAGING DIRECTOR'; IssuedByLbl = 'Issued by:'; CheckedbyLbl = 'Checked by:'; SignatureLbl = 'Signature:'; onthisdateLbl = 'on this date'; ReportTitle = 'DEBIT NOTE'; BusinessLbl = 'Business'; FromLbl = 'Period From'; PeriodToLbl = 'Period To'; EffectiveFromLbl = 'Effective From'; PlaceLbl = 'Place of Issue'; UnderWritingMngLbl = 'UNDERWRITING MANAGER'; ReportTitleLbl = 'Policy Schedule';
    }

    var
        CompInfor: Record 79;
        Cust: Record Customer;
        CustAddress: Text;
        CustAddress2: Text;
        CustOccupation: Text;
        CustAddress3: Text;
        ShowVehicle: Boolean;
        ShowWorkmenCompensation: Boolean;
        ShowAllRisks: Boolean;
        ShowMoneyInsurance: Boolean;
        ShowGroupPersonal: Boolean;
        ShowFidelity: Boolean;
        ShowEmployerLiability: Boolean;
        ShowMedical: Boolean;
        PolicyType: Record "Policy Type";
        ShowBond: Boolean;
        ShowPersonalAccident: Boolean;
        DimValue: Record "Dimension Value";
        BranchName: Text;
        InsuranceClass: Record "Insurance Class";
        ClassName: Text;
        CustName: Text;
        GenLedgSetup: Record "General Ledger Setup";
        EndorsementNo: Code[10];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        NumberText: array[2] of Text[80];
        CurrencyCodeText: Code[10];
        AgentAddress: Text;
        BranchCode: Code[10];
        AllFilters: Text;
        DepartmentCode: Code[10];
        DepartmentName: Text;
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
        PeriodofInsurance: Text;
        MoreCommentsPeriod: Text;
        PolicyDetails: Record "Policy Details";
        PolicyDescription: Text;
        PolicyActualAmount: Text;

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

