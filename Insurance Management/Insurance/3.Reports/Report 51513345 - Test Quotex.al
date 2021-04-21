report 51513345 "Test Quotex"
{
    // version AES-INS 1.0

    RDLCLayout = './Insurance/5.Layouts/Test Quotex.rdl';
    DefaultLayout = RDLC;

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            RequestFilterFields = "No.", "Document Type";
            column(DocType; "Insure Header"."Document Type")
            {
            }
            column(No; "Insure Header"."No.")
            {
            }
            column(DocTitle; DocumentName)
            {
            }
            column(PolicyType; ProductDescription)
            {
            }
            column(InsuredPhysicalAddress; "Insure Header"."Insured Address")
            {
            }
            column(InsuredPostalAddress; "Insure Header"."Insured Address 2")
            {
            }
            column(InsuredCity; "Insure Header"."Post Code")
            {
            }
            column(Insurer; "Insure Header"."Underwriter Name")
            {
            }
            column(Form; "Insure Header".Forms)
            {
            }
            column(Period; PeriodDescription)
            {
            }
            dataitem(CopyLoop; 2000000026)
            {

                trigger OnPreDataItem();
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            dataitem(PageLoop; 2000000026)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(OutputNo; OutputNo)
                {
                }
                column(CompanyLogo; CompanyInfo.Picture)
                {
                }
                column(CompanyInfo2Picture; CompanyInfo2.Picture)
                {
                }
                column(PaymentTermsDescription; PaymentTerms.Description)
                {
                }
                column(ShipmentMethodDescription; ShipmentMethod.Description)
                {
                }
                column(CompanyInfo3Picture; CompanyInfo3.Picture)
                {
                }
                column(CompanyInfo1Picture; CompanyInfo1.Picture)
                {
                }
                column(SalesCopyText; STRSUBSTNO(Text004, CopyText))
                {
                }
                column(CustAddr1; CustAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(CustAddr2; CustAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(CustAddr3; CustAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(CustAddr4; CustAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(CustAddr5; CustAddr[5])
                {
                }
                column(CompanyInfoEmail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(CustAddr6; CustAddr[6])
                {
                }
                column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                {
                }
                column(CompanyInfoBankName; CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                {
                }
                column(BilltoCustNo_SalesHeader; "Insure Header"."Insured No.")
                {
                }
                column(DocDate_SalesHeader; FORMAT("Insure Header"."Document Date", 0, 4))
                {
                }
                column(VATNoText; VATNoText)
                {
                }
                column(VATRegNo_SalesHeader; VATNoText)
                {
                }
                column(ShipmentDate_SalesHeader; FORMAT("Insure Header"."Document Date"))
                {
                }
                column(SalesPersonText; SalesPersonText)
                {
                }
                column(SalesPurchPersonName; "Insure Header"."Brokers Name")
                {
                }
                column(No1_SalesHeader; "Insure Header"."No.")
                {
                }
                column(ReferenceText; ReferenceText)
                {
                }
                column(YourReference_SalesHeader; "Insure Header"."Insurer Policy No")
                {
                }
                column(CustAddr7; CustAddr[7])
                {
                }
                column(CustAddr8; CustAddr[8])
                {
                }
                column(CompanyAddr5; CompanyAddr[5])
                {
                }
                column(CompanyAddr6; CompanyAddr[6])
                {
                }
                column(CompanyName; CompanyInfo.Name)
                {
                }
                column(CompanyAddress1; CompanyInfo.Address)
                {
                }
                column(CompanyAddress2; CompanyInfo."Address 2")
                {
                }
                column(CompanyCity; CompanyInfo.City)
                {
                }
                column(CompanyPhoneNo; CompanyInfo."Phone No.")
                {
                }
                column(CompanyEmail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyWebsite; CompanyInfo."Home Page")
                {
                }
                column(PricesIncludingVAT_SalesHdr; VATNoText)
                {
                }
                column(PageCaption; STRSUBSTNO(Text005, ''))
                {
                }
                column(PricesInclVATYesNo_SalesHdr; VATNoText)
                {
                }
                column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                {
                }
                column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
                {
                }
                column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                {
                }
                column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                {
                }
                column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
                {
                }
                column(SalesHeaderShipmentDateCaption; SalesHeaderShipmentDateCaptionLbl)
                {
                }
                column(SalesHeaderNoCaption; SalesHeaderNoCaptionLbl)
                {
                }
                column(BilltoCustNo_SalesHeaderCaption; "Insure Header"."Insured No.")
                {
                }
                column(PricesIncludingVAT_SalesHdrCaption; VATNoText)
                {
                }
            }
            dataitem(InsureLines; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No."),
                               "Document Type" = FIELD("Document Type");
                column(LineDocType; InsureLines."Document Type")
                {
                }
                column(LineDocNo; InsureLines."Document No.")
                {
                }
                column(LinesLineNo; InsureLines."Line No.")
                {
                }
                column(RiskID_InsureLines; InsureLines."Risk ID")
                {
                }
                column(FamilyName_InsureLines; InsureLines."Family Name")
                {
                }
                column(FirstNames_InsureLines; InsureLines."First Name(s)")
                {
                }
                column(Title_InsureLines; InsureLines.Title)
                {
                }
                column(Sex_InsureLines; InsureLines.Sex)
                {
                }
                column(HeightUnit_InsureLines; InsureLines."Height Unit")
                {
                }
                column(Height_InsureLines; InsureLines.Height)
                {
                }
                column(WeightUnit_InsureLines; InsureLines."Weight Unit")
                {
                }
                column(Weight_InsureLines; InsureLines.Weight)
                {
                }
                column(DateofBirth_InsureLines; InsureLines."Date of Birth")
                {
                }
                column(RelationshiptoApplicant_InsureLines; InsureLines."Relationship to Applicant")
                {
                }
                column(Occupation_InsureLines; InsureLines.Occupation)
                {
                }
                column(Nationality_InsureLines; InsureLines.Nationality)
                {
                }
                column(GrossPremium_InsureLines; InsureLines."Gross Premium")
                {
                }
                column(Age_InsureLines; InsureLines.Age)
                {
                }
                column(BMI_InsureLines; InsureLines.BMI)
                {
                }
                column(CoverType_InsureLines; InsureLines."Cover Type")
                {
                }
                column(MemberCode_InsureLines; InsureLines.Colour)
                {
                }
                column(AreaofCover_InsureLines; InsureLines."Area of Cover")
                {
                }
                column(PolicyType_InsureLines; InsureLines."Policy Type")
                {
                }
                column(InsuranceType_InsureLines; InsureLines."Insurance Type")
                {
                }
                column(PremiumAmount_InsureLines; InsureLines."Premium Amount")
                {
                }
                column(Heightm_InsureLines; InsureLines."Height(m)")
                {
                }
                column(WeightKg_InsureLines; InsureLines."Weight(Kg)")
                {
                }
                column(PolicyNo_InsureLines; InsureLines."Policy No")
                {
                }
                column(PremiumPayment_InsureLines; InsureLines."Premium Payment")
                {
                }
                column(Optional_InsureLines; InsureLines.Optional)
                {
                }
                column(CheckMark_InsureLines; InsureLines."Check Mark")
                {
                }
                column(Class_InsureLines; InsureLines.Class)
                {
                }
                column(Loading_InsureLines; InsureLines."Loading %")
                {
                }
                column(Reduction_InsureLines; InsureLines."Rate Discount %")
                {
                }
                column(Loadingamt_InsureLines; InsureLines."Loading amt")
                {
                }
                column(reductionamt_InsureLines; InsureLines."TPO Discount %")
                {
                }
                column(Tax_InsureLines; InsureLines.Tax)
                {
                }
                column(EndorsementDate_InsureLines; InsureLines."Endorsement Date")
                {
                }
                column(MoratoriumDate_InsureLines; InsureLines."Moratorium Date")
                {
                }
                column(DeletionDate_InsureLines; InsureLines."Deletion Date")
                {
                }
                column(CountryofResidence_InsureLines; InsureLines."Country of Residence")
                {
                }
                column(SumInsured_InsureLines; InsureLines."Sum Insured")
                {
                }
                column(Rateage_InsureLines; InsureLines."Rate %age")
                {
                }
                column(RiskCovered_InsureLines; InsureLines."Risk Covered")
                {
                }
                column(NetPremium_InsureLines; InsureLines."Net Premium")
                {
                }
                column(Adjustment_InsureLines; InsureLines."Adjustment %")
                {
                }
                column(MidTermAdjustmentFactor_InsureLines; InsureLines."Mid-Term Adjustment Factor")
                {
                }
                column(CopiedfromNo_InsureLines; InsureLines."Copied from No.")
                {
                }
                column(Status_InsureLines; InsureLines.Status)
                {
                }
                column(CoverDescription_InsureLines; InsureLines."Cover Description")
                {
                }
                column(RegistrationNo_InsureLines; InsureLines."Registration No.")
                {
                }
                column(Make_InsureLines; InsureLines.Make)
                {
                }
                column(YearofManufacture_InsureLines; InsureLines."Year of Manufacture")
                {
                }
                column(TypeofBody_InsureLines; InsureLines."Type of Body")
                {
                }
                column(CubicCapacitycc_InsureLines; InsureLines."Cubic Capacity (cc)")
                {
                }
                column(SeatingCapacity_InsureLines; InsureLines."Seating Capacity")
                {
                }
                column(CarryingCapacity_InsureLines; InsureLines."Carrying Capacity")
                {
                }
                column(NoofEmployees_InsureLines; InsureLines."No. of Employees")
                {
                }
                column(DescriptionType_InsureLines; InsureLines."Description Type")
                {
                }
                column(ft_InsureLines; InsureLines.ft)
                {
                }
                column(Heightft_InsureLines; InsureLines."Height (ft)")
                {
                }
                column(CountryofResidenceDesc_InsureLines; InsureLines."Country of Residence Desc")
                {
                }
                column(NationalityDescription_InsureLines; InsureLines."Nationality Description")
                {
                }
                column(MarkforDeletion_InsureLines; InsureLines."Mark for Deletion")
                {
                }
                column(PurchaseDateofCurrentBenef_InsureLines; InsureLines."Purchase Date of Current Benef")
                {
                }
                column(StartDate_InsureLines; InsureLines."Start Date")
                {
                }
                column(EndDate_InsureLines; InsureLines."End Date")
                {
                }
                column(EstimatedAnnualEarnings_InsureLines; InsureLines."Estimated Annual Earnings")
                {
                }
                column(SerialNo_InsureLines; InsureLines."Serial No")
                {
                }
                column(LimitofLiability_InsureLines; InsureLines."Limit of Liability")
                {
                }
                column(Position_InsureLines; InsureLines.Position)
                {
                }
                column(Category_InsureLines; InsureLines.Category)
                {
                }
                column(EmployeeName_InsureLines; InsureLines."Employee Name")
                {
                }
                column(Windscreen_InsureLines; InsureLines.Windscreen)
                {
                }
                column(RadioCassette_InsureLines; InsureLines."Radio Cassette")
                {
                }
                column(WindscreenRate_InsureLines; InsureLines."Windscreen % Rate")
                {
                }
                column(RadioCassetteRate_InsureLines; InsureLines."Radio Cassette % Rate")
                {
                }
                column(EngineNo_InsureLines; InsureLines."Engine No.")
                {
                }
                column(ChassisNo_InsureLines; InsureLines."Chassis No.")
                {
                }
                column(Death_InsureLines; InsureLines.Death)
                {
                }
                column(PermanentDisability_InsureLines; InsureLines."Permanent Disability")
                {
                }
                column(TemporaryDisability_InsureLines; InsureLines."Temporary Disability")
                {
                }
                column(Medicalexpenses_InsureLines; InsureLines."Medical expenses")
                {
                }
                column(DeathRate_InsureLines; InsureLines."Death Rate")
                {
                }
                column(PDRate_InsureLines; InsureLines."P.D Rate")
                {
                }
                column(TDRate_InsureLines; InsureLines."T.D Rate")
                {
                }
                column(MERate_InsureLines; InsureLines."M.E Rate")
                {
                }
                column(Section_InsureLines; InsureLines.Section)
                {
                }
                column(TextType_InsureLines; InsureLines."Text Type")
                {
                }
                column(LineType_InsureLines; InsureLines."Line Type")
                {
                }
                column(Totaling_InsureLines; InsureLines.Totaling)
                {
                }
                column(ActualValue_InsureLines; InsureLines."Actual Value")
                {
                }
                column(Value_InsureLines; InsureLines.Value)
                {
                }
                column(Commision_InsureLines; InsureLines."Commision %")
                {
                }
                column(Commission_InsureLines; InsureLines.Commission)
                {
                }
                column(FirstLossSumInsured_InsureLines; InsureLines."First Loss Sum Insured")
                {
                }
                column(TotalValueatRisk_InsureLines; InsureLines."Total Value at Risk")
                {
                }
                column(FirstLossRate_InsureLines; InsureLines."First Loss Rate")
                {
                }
                column(TVARate_InsureLines; InsureLines."TVA Rate")
                {
                }
                column(PerCapita_InsureLines; InsureLines."Per Capita")
                {
                }
                column(RateType_InsureLines; InsureLines."Rate Type")
                {
                }
                column(PLL_InsureLines; InsureLines.PLL)
                {
                }
                column(ValuationCurrency_InsureLines; InsureLines."Valuation Currency")
                {
                }
                column(Model_InsureLines; InsureLines.Model)
                {
                }
                column(VehicleUsage_InsureLines; InsureLines."Vehicle Usage")
                {
                }
                column(LineNo_InsureLines; InsureLines."Line No.")
                {
                }
                column(Amount_InsureLines; InsureLines.Amount)
                {
                }
                column(ExtraPremium_InsureLines; InsureLines."Extra Premium")
                {
                }
                column(VehicleTonnage_InsureLines; InsureLines."Vehicle Tonnage")
                {
                }
                column(VehicleLicenseClass_InsureLines; InsureLines."Vehicle License Class")
                {
                }
                column(AccountType_InsureLines; InsureLines."Account Type")
                {
                }
                column(AccountNo_InsureLines; InsureLines."Account No.")
                {
                }
                column(Name_InsureLines; InsureLines.Name)
                {
                }
                column(Description_InsureLines; InsureLines.Description)
                {
                }
                column(TPOPremium_InsureLines; InsureLines."TPO Premium")
                {
                }
                column(SACCOID_InsureLines; InsureLines."SACCO ID")
                {
                }
                column(RouteID_InsureLines; InsureLines."Route ID")
                {
                }
                column(DimensionSetID_InsureLines; InsureLines."Dimension Set ID")
                {
                }
                column(Quantity_InsureLines; InsureLines.Quantity)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin

                IF "Insure Header"."Document Type" = "Insure Header"."Document Type"::Quote THEN BEGIN
                    IF "Insure Header"."Quote Type" = "Insure Header"."Quote Type"::New THEN
                        DocumentName := 'NEW BUSINESS QUOTATION SLIP';

                    IF "Insure Header"."Quote Type" = "Insure Header"."Quote Type"::Renewal THEN
                        DocumentName := 'RENEWAL BUSINESS QUOTATION SLIP';

                    IF "Insure Header"."Quote Type" = "Insure Header"."Quote Type"::Modification THEN
                        DocumentName := 'ENDORSEMENT BUSINESS QUOTATION SLIP';

                END;

                IF PolicyType.GET("Insure Header"."Policy Type") THEN
                    ProductDescription := PolicyType.Description;



                //BKK





                CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");

                //FormatAddr.Company(CompanyAddr,CompanyInfo);

                IF "Insure Header"."From Time" <> '' THEN
                    TimeDescription := STRSUBSTNO('at %1 local standard time', "Insure Header"."From Time")
                ELSE
                    TimeDescription := 'local standard time';

                IF PolicyType.GET("Policy Type") THEN
                    IF NOT PolicyType."Open Cover" THEN
                        PeriodDescription := STRSUBSTNO('From %1 to %2 ,both days inclusive,%3', "From Date", "To Date", TimeDescription)
                    ELSE
                        PeriodDescription := STRSUBSTNO('Permanent open cover with effect from %1', "Insure Header"."From Date");
            end;

            trigger OnPreDataItem();
            begin
                NoOfRecords := COUNT;
                Print := Print OR NOT CurrReport.PREVIEW;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(NoOfCopies; NoOfCopies)
                {
                    Caption = 'No. Of Copies';
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

    trigger OnInitReport();
    begin
        GLSetup.GET;
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
        CompanyInfo1.GET;
        CompanyInfo1.CALCFIELDS(CompanyInfo1.Picture);
    end;

    var
        CompanyInfo: Record 79;
        Cust: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        FormatAddr: Codeunit 365;
        CompanyAddr: array[8] of Text;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text;
        OutputNo: Integer;
        NoOfRecords: Integer;
        Print: Boolean;
        CustAddr: array[8] of Text[50];
        CompanyInfo2: Record 79;
        CompanyInfo3: Record 79;
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record 10;
        CompanyInfo1: Record 79;
        Text000: Label 'Salesperson';
        Text001: Label 'Total %1';
        Text002: Label 'Total %1 Incl. VAT';
        Text003: Label 'COPY';
        Text004: Label 'NEW BUSINESS QUOTATION SLIP';
        Text005: Label 'Page %1';
        Text006: Label 'Total %1 Excl. VAT';
        Text007: Label 'Do you want to create a follow-up to-do?';
        Text008: Label '"VAT Amount Specification in "';
        Text009: Label 'Local Currency';
        Text010: Label 'Exchange rate: %1/%2';
        CompanyInfoPhoneNoCaptionLbl: Label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: Label 'VAT Registration No.';
        CompanyInfoGiroNoCaptionLbl: Label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: Label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: Label 'Account No.';
        SalesHeaderShipmentDateCaptionLbl: Label 'Shipment Date';
        SalesHeaderNoCaptionLbl: Label 'Quote No.';
        HeaderDimensionsCaptionLbl: Label 'Header Dimensions';
        UnitPriceCaptionLbl: Label 'Unit Price';
        SalesLineLineDiscCaptionLbl: Label 'Discount %';
        AmountCaptionLbl: Label 'Amount';
        SalesLineInvDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        SubtotalCaptionLbl: Label 'Subtotal';
        VATDiscountAmountCaptionLbl: Label 'Payment Discount on VAT';
        LineDimensionsCaptionLbl: Label 'Line Dimensions';
        VATAmountLineVATCaptionLbl: Label 'VAT %';
        VATBaseCaptionLbl: Label 'VAT Base';
        VATAmtCaptionLbl: Label 'VAT Amount';
        VATAmountSpecificationCaptionLbl: Label 'VAT Amount Specification';
        LineAmtCaptionLbl: Label 'Line Amount';
        InvoiceDiscBaseAmtCaptionLbl: Label 'Invoice Discount Base Amount';
        InvoiceDiscAmtCaptionLbl: Label 'Invoice Discount Amount';
        TotalCaptionLbl: Label 'Total';
        ShiptoAddressCaptionLbl: Label 'Ship-to Address';
        SalesLineVATIdentifierCaptionLbl: Label 'VAT Identifier';
        PaymentTermsDescriptionCaptionLbl: Label 'Payment Terms';
        ShipmentMethodDescriptionCaptionLbl: Label 'Shipment Method';
        CompanyInfoHomePageCaptionLbl: Label 'Home Page';
        CompanyInfoEmailCaptionLbl: Label 'E-Mail';
        DocumentDateCaptionLbl: Label 'Document Date';
        SalesLineAllowInvoiceDiscCaptionLbl: Label 'Allow Invoice Discount';
        VATNoText: Text;
        SalesPersonText: Text;
        ReferenceText: Text;
        DocumentName: Text;
        GLSetup: Record "General Ledger Setup";
        PolicyType: Record "Policy Type";
        ProductDescription: Text;
        Language: Record 8;
        TimeDescription: Text;
        PeriodDescription: Text;
}

