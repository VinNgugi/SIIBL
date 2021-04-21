report 51513514 Quote
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Quote.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
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
            column(DocumentType_InsureHeader; "Insure Header"."Document Type")
            {
            }
            column(No_InsureHeader; "Insure Header"."No.")
            {
            }
            column(InsuredNo_InsureHeader; "Insure Header"."Insured No.")
            {
            }
            column(FamilyName_InsureHeader; "Insure Header"."Family Name")
            {
            }
            column(PolicyType_InsureHeader; "Insure Header"."Policy Type")
            {
            }
            column(AgentBroker_InsureHeader; "Insure Header"."Agent/Broker")
            {
            }
            column(UndewriterName_InsureHeader; "Insure Header"."Underwriter Name")
            {
            }
            column(PremiumAmount_InsureHeader; "Insure Header"."Premium Amount")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(TotalPremiumAmount_InsureHeader; "Insure Header"."Total Premium Amount")
            {
            }
            column(PolicyStatus_InsureHeader; "Insure Header"."Policy Status")
            {
            }
            column(PolicyDescription_InsureHeader; "Insure Header"."Policy Description")
            {
            }
            column(DocumentDate_InsureHeader; "Insure Header"."Document Date")
            {
            }
            column(CoverTypeDescription_InsureHeader; "Insure Header"."Cover Type Description")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Header"."Total Sum Insured")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
            {
            }
            column(QuotationNo_InsureHeader; "Insure Header"."Quotation No.")
            {
            }
            column(CreatedBy_InsureHeader; "Insure Header"."Created By")
            {
            }
            column(EmployeeFullName; EmployeeFullName)
            {
            }
            column(QuoteExpiryDate_InsureHeader; "Insure Header"."Quote Expiry Date")
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Description Type" = CONST("Schedule of Insured"));
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(Make_InsureLines; "Insure Lines".Make)
                {
                }
                column(YearofManufacture_InsureLines; "Insure Lines"."Year of Manufacture")
                {
                }
                column(TypeofBody_InsureLines; "Insure Lines"."Type of Body")
                {
                }
                column(CubicCapacitycc_InsureLines; "Insure Lines"."Cubic Capacity (cc)")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
                column(Rateage_InsureLines; "Insure Lines"."Rate %age")
                {
                }
                column(Windscreen_InsureLines; "Insure Lines".Windscreen)
                {
                }
                column(RadioCassette_InsureLines; "Insure Lines"."Radio Cassette")
                {
                }
                column(WindscreenRate_InsureLines; "Insure Lines"."Windscreen % Rate")
                {
                }
                column(RadioCassetteRate_InsureLines; "Insure Lines"."Radio Cassette % Rate")
                {
                }
            }
            dataitem(Taxes; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Risk ID", "Line No.")
                                    WHERE("Description Type" = FILTER(Tax),
                                          Amount = FILTER(<> 0));
                column(TaxDescription; Taxes.Description)
                {
                }
                column(ratecharged; ratecharged)
                {
                }
                column(TaxAmt; Taxes.Amount)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    DiscAndLoading.SETRANGE(DiscAndLoading.Description, Taxes.Description);
                    IF DiscAndLoading.FINDFIRST THEN
                        ratecharged := DiscAndLoading."Loading Percentage";
                end;
            }
            dataitem(Limits; "Policy Details")
            {
                DataItemLink = "Policy Type" = FIELD("Policy Type");
                DataItemTableView = SORTING("Policy Type", "Description Type", "No.", "Line No")
                                    WHERE("Description Type" = FILTER(Limits));
                column(DescriptionType_Limits; Limits."Description Type")
                {
                }
                column(Description_Limits; Limits.Description)
                {
                }
                column(ActualValue_Limits; Limits."Actual Value")
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
                column(DescriptionType_Excess; Excess."Description Type")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);

                //Issued By Details
                EmployeeFullName := '';
                EmpTitle := '';
                UserSetupDetails.SETRANGE(UserSetupDetails."User ID", "Insure Header"."Created By");
                IF UserSetupDetails.FINDLAST THEN BEGIN
                    IF Emp.GET(UserSetupDetails.Employee) THEN BEGIN
                        EmployeeFullName := Emp.FullName;
                        EmpTitle := Emp."Job Title";
                    END;
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
        ReportTitle = 'QUOTATION'; ClientNameLbl = 'CLIENT NAME:'; DaysValidLbl = 'DATE OF EXPIRY'; AuthorisedByLbl = 'AUTHORISED BY'; PreparedbyLbl = 'PREPARED BY'; LimitsLbl = 'Limits of Indemnity';
    }

    var
        CompInfor: Record 79;
        InsureHeader: Record "Insure Header";
        DiscAndLoading: Record "Loading and Discounts Setup";
        ratecharged: Decimal;
        UserSetupDetails: Record "User Setup Details";
        Emp: Record Employee;
        EmpTitle: Text;
        EmployeeFullName: Text;
}

