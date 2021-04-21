report 51515000 "Quote Slip"

{
    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Quote Slip.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            CalcFields = "Total Premium Amount";

            RequestFilterFields = "No.";
            column(No_InsureHeader; "No.")
            {

            }
            column(InsuredNo_InsureHeader; "Insured No.")
            {
            }
            column(PolicyDescription_InsureHeader; policytypedesc)
            {
            }
            column(InsuredAddress_InsureHeader; "Insured Address")
            {
            }
            column(InsuredAddress2_InsureHeader; "Insured Address 2")
            {
            }
            column(PostCode_InsureHeader; "Post Code")
            {
            }
            column(InsuredName_InsureHeader; "Insured Name")
            {
            }
            column(Forms_InsureHeader; Forms)
            {
            }
            column(FromDate_InsureHeader; FORMAT("From Date", 0, '<day>-<Month>-<Year4>'))
            {
            }
            column(ToDate_InsureHeader; FORMAT("To Date", 0, '<day>-<Month>-<Year4>'))
            {
            }
            column(UndewriterName_InsureHeader; "Underwriter Name")
            {
            }
            column(NatureOfBusiness_InsureHeader; Occupation)
            {
            }
            column(TotalPremiumAmount_InsureHeader; "Total Net Premium")
            {
            }
            column(CurrencyCode_InsureHeader; "Currency Code")
            {
            }
            column(ShowTotal_InsureHeader; "Total Premium Amount")
            {
            }

            dataitem("Company Information"; "Company Information")
            {
                column(FaxNo_CompanyInformation; "Fax No.")
                {
                }
                column(Name_CompanyInformation; Name)
                {
                }
                column(Address_CompanyInformation; Address)
                {
                }
                column(Address2_CompanyInformation; "Address 2")
                {
                }
                column(City_CompanyInformation; City)
                {
                }
                column(PhoneNo_CompanyInformation; "Phone No.")
                {
                }
                column(EMail_CompanyInformation; "E-Mail")
                {
                }
                column(HomePage_CompanyInformation; "Home Page")
                {
                }
                column(CompanyPic2_CompanyInformation; Picture)
                {
                }
            }
            dataitem(CLGS; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER(Cover));
                column(Description_CLGS; CLGS.Description)
                {
                }
                column(DescriptionType_CLGS; CLGS."Description Type")
                {
                }
                column(LineNo_CLGS; CLGS."Line No.")
                {
                }
                column(TextType_CLGS; CLGS."Text Type")
                {
                }
                column(Rateage_CLGS; CLGS."Rate %age")
                {
                }
                column(SumInsured_CLGS; CLGS."Sum Insured")
                {
                }
                column(Amount_CLGS; CLGS.Amount)
                {
                }
                column(suminsuredcheck; suminsuredcheck)
                {
                }
                column(showbold1; showbold[1])
                {
                }
                column(ActualValue_CLGS; CLGS."Actual Value")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    suminsuredcheck := 0;
                    showbold[1] := 0;
                    //MESSAGE('Req No %1', "Insure Header"."No.");
                    IF CLGS."Description Type" = CLGS."Description Type"::"Schedule of Insured" THEN BEGIN
                        suminsuredcheck := 1;
                    END;
                    IF CLGS."Description Type" = CLGS."Description Type"::Tax THEN BEGIN
                        suminsuredcheck := 1;
                    END;

                    IF CLGS."Text Type" = CLGS."Text Type"::Bold THEN BEGIN
                        showbold[1] := 1;    // Message(CLGS.Description);
                    END;
                end;
            }
            dataitem(Interest; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER(Interest));
                column(Description_Interest; Interest.Description)
                {
                }
                column(DescriptionType_Interest; Interest."Description Type")
                {
                }
                column(TextType_Interest; Interest."Text Type")
                {
                }
                column(showbold2; showbold[2])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    suminsuredcheck := 0;
                    showbold[2] := 0;
                    IF CLGS."Description Type" = CLGS."Description Type"::"Schedule of Insured" THEN BEGIN
                        suminsuredcheck := 1;
                    END;
                    IF CLGS."Description Type" = CLGS."Description Type"::Tax THEN BEGIN
                        suminsuredcheck := 1;
                    END;

                    IF Interest."Text Type" = Interest."Text Type"::Bold THEN BEGIN
                        showbold[2] := 1;    // Message(CLGS.Description);
                    END;
                end;
            }
            dataitem(SumInsured; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER("Schedule of Insured"));
                column(Description_SumInsured; SumInsured.Description)
                {
                }
                column(RegistrationNo_SumInsured; SumInsured."Registration No.")
                {
                }
                column(SerialNo_SumInsured; SumInsured."Serial No")
                {
                }
                column(SumInsured_SumInsured; SumInsured."Sum Insured")
                {
                }
                column(showbold3; showbold[3])
                {
                }
                column(FirstLoss_SumInsured; SumInsured."Sum Insured")
                {
                }
                column(RateType_SumInsured; SumInsured."Rate Type")
                {
                }
                column(Rateage_SumInsured; SumInsured."Rate %age")
                {
                }
                column(Showtotal_2; Showtotal)
                {
                }
                column(MaxSumInsured_SumInsured; SumInsured."Sum Insured")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    //Message(SumInsured.Description);
                    suminsuredcheck := 0;
                    showbold[3] := 0;

                    IF SumInsured."Text Type" = SumInsured."Text Type"::Bold THEN BEGIN
                        showbold[3] := 1;    // Message(CLGS.Description);
                    END;

                    //IF SumInsured."Max Sum Insured"=TRUE THEN BEGIN
                    //  Showtotal:=7; //Message('..99');
                    //END;
                end;
            }
            dataitem(Geographical; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER(Geographic));
                column(Description_Geographical; Geographical.Description)
                {
                }
                column(showbold4; showbold[4])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    suminsuredcheck := 0;
                    showbold[4] := 0;
                    IF Geographical."Text Type" = Geographical."Text Type"::Bold THEN BEGIN
                        showbold[4] := 1;    // Message(CLGS.Description);
                    END;
                end;
            }
            dataitem(clauses; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER(Clauses));
                column(Description_clauses; clauses.Description)
                {
                }
                column(showbold5; showbold[5])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    suminsuredcheck := 0;
                    showbold[5] := 0;

                    IF clauses."Text Type" = clauses."Text Type"::Bold THEN BEGIN
                        showbold[5] := 1;    // Message(CLGS.Description);
                    END;
                end;
            }
            dataitem(Basis; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER("Basis of Settlement"));
                column(Description_Basis; Basis.Description)
                {
                }
                column(ActualValue_Basis; Basis."Actual Value")
                {
                }
                column(showbold6; showbold[6])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    suminsuredcheck := 0;
                    showbold[6] := 0;

                    IF Basis."Text Type" = Basis."Text Type"::Bold THEN BEGIN
                        showbold[6] := 1;    // Message(CLGS.Description);
                    END;
                end;
            }
            dataitem(Limits; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER(Limits));
                column(Description_Limits; Limits.Description)
                {
                }
                column(ActualValue_Limits; Limits."Actual Value")
                {
                }
                column(showbold8; showbold[8])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    suminsuredcheck := 0;
                    showbold[8] := 0;

                    IF Limits."Text Type" = Limits."Text Type"::Bold THEN BEGIN
                        showbold[8] := 1;    // Message(CLGS.Description);
                    END;
                end;
            }
            dataitem(Excess; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = WHERE("Description Type" = FILTER(Excess));
                column(Description_Excess; Excess.Description)
                {
                }
                column(ActualValue_Excess; Excess."Actual Value")
                {
                }
                column(showbold7; showbold[7])
                {
                }

                trigger OnAfterGetRecord();
                begin
                    suminsuredcheck := 0;
                    showbold[7] := 0;

                    IF Excess."Text Type" = Excess."Text Type"::Bold THEN BEGIN
                        showbold[7] := 1;    // Message(CLGS.Description);
                    END;
                end;
            }
            dataitem("Coinsurance Reinsurance Lines"; "Coinsurance Reinsurance Lines")
            {
                DataItemLink = "No." = FIELD("No.");
                column(Name_CoinsuranceReinsuranceLines; Name)
                {
                }
                column(CoInsurance_CoinsuranceReinsuranceLines; "Claim Reserve Amount")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin

                policytypertb.RESET;
                policytypertb.SETFILTER(policytypertb.Code, "Policy Type");
                policytypertb.SEtrange(policytypertb."Underwriter Code",Underwriter);
                IF policytypertb.FINDSET THEN BEGIN
                    policytypedesc := policytypertb.Description;
                END;

                IF "Currency Code" = '' THEN BEGIN
                    IF GenLedgerSetup.GET THEN
                    "Currency Code" := GenLedgerSetup."LCY Code";
                END;
                IF "Insured No."='' then
                begin
                "Insured No.":="Contact No.";
                "Insured Name":="Contact Name";
                end;
            end;

            trigger OnPostDataItem();
            begin

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
        policytypedesc: Text;
        policytypertb: Record "Underwriter Policy Types";
        suminsuredcheck: Integer;
        showbold: array[10] of Integer;
        Showtotal: Integer;
        GenLedgerSetup: Record "General Ledger Setup";
}

