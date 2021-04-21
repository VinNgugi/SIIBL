report 51513576 "Policy Renewal Notice"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Policy Renewal Notice.rdl';

    dataset
    {
        dataitem(InsureDebitNote; "Insure Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Policy),
                                      "Action Type" = CONST(New),
                                      "Policy Status" = CONST(Live));
            RequestFilterFields = "Insured No.", "No.";
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
            column(No_InsureDebitNote; InsureDebitNote."No.")
            {
            }
            column(InsuredNo_InsureDebitNote; InsureDebitNote."Insured No.")
            {
            }
            column(PolicyType_InsureDebitNote; InsureDebitNote."Policy Type")
            {
            }
            column(AgentBroker_InsureDebitNote; InsureDebitNote."Agent/Broker")
            {
            }
            column(BrokersName_InsureDebitNote; InsureDebitNote."Brokers Name")
            {
            }
            column(EffectiveStartdate_InsureDebitNote; InsureDebitNote."Effective Start date")
            {
            }
            column(ExpectedRenewalDate_InsureDebitNote; InsureDebitNote."Expected Renewal Date")
            {
            }
            column(TotalSumInsured_InsureDebitNote; InsureDebitNote."Total Sum Insured")
            {
            }
            column(PremiumAmount_InsureDebitNote; InsureDebitNote."Premium Amount")
            {
            }
            column(InsuredName_InsureDebitNote; InsureDebitNote."Insured Name")
            {
            }
            column(PolicyNo_InsureDebitNote; InsureDebitNote."Policy No")
            {
            }
            column(TotalNetPremium_InsureDebitNote; InsureDebitNote."Total Net Premium")
            {
            }
            column(TotalPremiumAmount_InsureDebitNote; InsureDebitNote."Total Premium Amount")
            {
            }
            column(RenewablePremium; RenewablePremium)
            {
            }
            column(TotalAmountDue; TotalAmountDue)
            {
            }
            column(PHCF; PHCF)
            {
            }
            column(TrainingLevy; TrainingLevy)
            {
            }
            column(EmployeeFullName; EmployeeFullName)
            {
            }
            column(CustAddress2; CustAddress2)
            {
            }
            column(CustAddress3; CustAddress3)
            {
            }
            column(AgentAddress; AgentAddress)
            {
            }
            column(Period; Period)
            {
            }
            column(CustAddress; CustAddress)
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Description Type" = CONST("Schedule of Insured"));
                RequestFilterFields = "Registration No.";
                column(RegistrationNo_InsureDebitNoteLines; "Insure Lines"."Registration No.")
                {
                }
                column(Make_InsureDebitNoteLines; "Insure Lines".Make)
                {
                }
                column(YearofManufacture_InsureDebitNoteLines; "Insure Lines"."Year of Manufacture")
                {
                }
                column(TypeofBody_InsureDebitNoteLines; "Insure Lines"."Type of Body")
                {
                }
                column(CubicCapacitycc_InsureDebitNoteLines; "Insure Lines"."Cubic Capacity (cc)")
                {
                }
                column(SeatingCapacity_InsureDebitNoteLines; "Insure Lines"."Seating Capacity")
                {
                }
                column(EngineNo_InsureDebitNoteLines; "Insure Lines"."Engine No.")
                {
                }
                column(ChassisNo_InsureDebitNoteLines; "Insure Lines"."Chassis No.")
                {
                }
                column(Colour_InsureDebitNoteLines; "Insure Lines".Colour)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    /*
                    premiumtable.RESET;
                    RenewablePremium:=0.0;
                    premiumtable.SETRANGE("Policy Type", "Insure Lines"."Policy Type");
                    premiumtable.SETRANGE("Seating Capacity", "Insure Lines"."Seating Capacity");
                    premiumtable.FINDFIRST;
                    TotalAmountDue:=premiumtable."Premium Amount";
                    RenewablePremium:=ROUND(TotalAmountDue/1.0045,1);
                    PHCF:=ROUND(0.0025*RenewablePremium,1);
                    TrainingLevy:=ROUND(0.002*RenewablePremium,1);
                    */

                end;
            }
            dataitem(Taxes; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Description Type" = CONST(Tax));
                column(TaxDescription; Taxes.Description)
                {
                }
                column(TaxAmt; Taxes.Amount)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                InsureDebitNote.CALCFIELDS("Total Net Premium", "Total Sum Insured", "Total Premium Amount");
                RenewablePremium := 0.0;
                PHCF := 0.0;
                TrainingLevy := 0.0;

                //MESSAGE('I am here');
                IF Cust.GET(InsureDebitNote."Insured No.") THEN BEGIN
                    /*
                     CustAddress:=Cust.Address;

                     CustOccupation:=Cust.Occupation;
                     */


                    IF Cust."Address 2" <> '' THEN
                        CustAddress2 := 'P.O BOX' + ' ' + Cust."Address 2";

                    CustAddress3 := Cust."Post Code" + '-' + Cust.City;
                END;

                IF Cust.GET(InsureDebitNote."Agent/Broker") THEN BEGIN
                    AgentAddress := 'P.O BOX' + ' ' + Cust."Address 2";
                    CustAddress := Cust."Post Code" + '-' + Cust.City;
                END;
                FutureExpiryDate := CALCDATE('<1Y>', "Expected Renewal Date");
                Period := 'From ' + FORMAT(InsureDebitNote."Expected Renewal Date") + ' To ' + FORMAT(FutureExpiryDate);

                RenewablePremium := InsureDebitNote."Total Premium Amount";
                PHCF := ROUND(0.0025 * RenewablePremium, 1);
                TrainingLevy := ROUND(0.002 * RenewablePremium, 1);
                TotalAmountDue := ROUND(RenewablePremium + PHCF + TrainingLevy, 1);

                EmployeeFullName := '';
                EmpTitle := '';
                UserSetupDetails.SETRANGE(UserSetupDetails."User ID", InsureDebitNote."Created By");
                IF UserSetupDetails.FINDLAST THEN BEGIN
                    IF Emp.GET(UserSetupDetails.Employee) THEN BEGIN
                        EmployeeFullName := Emp.FullName;
                        EmpTitle := Emp."Job Title";
                    END;
                END;

                // MESSAGE('%1', CALCDATE('<2M>', WORKDATE));

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

    var
        CompInfor: Record 79;
        CustAddress3: Text;
        Cust: Record Customer;
        CustAddress2: Text;
        AgentAddress: Text;
        Period: Text;
        FutureExpiryDate: Date;
        UserSetupDetails: Record "User Setup Details";
        Emp: Record Employee;
        EmpTitle: Text;
        EmployeeFullName: Text;
        premiumtable: Record "Premium table Lines";
        RenewablePremium: Decimal;
        PHCF: Decimal;
        TrainingLevy: Decimal;
        TotalAmountDue: Decimal;
        CustAddress: Text;
}

