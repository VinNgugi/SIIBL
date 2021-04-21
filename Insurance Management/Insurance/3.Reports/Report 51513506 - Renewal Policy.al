report 51513506 "Renewal Policy"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Renewal Policy.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Document Type" = FILTER(Policy),
                                      "Insured No." = FILTER(<> ''),
                                      "Policy No" = FILTER(<> ''));
            RequestFilterFields = "Shortcut Dimension 1 Code", "Agent/Broker";
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
            column(No_InsureHeader; "Insure Header"."No.")
            {
            }
            column(InsuredNo_InsureHeader; "Insure Header"."Insured No.")
            {
            }
            column(AgentBroker_InsureHeader; "Insure Header"."Agent/Broker")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(FromDate_InsureHeader; "Insure Header"."From Date")
            {
            }
            column(ToDate_InsureHeader; "Insure Header"."To Date")
            {
            }
            column(PolicyStatus_InsureHeader; "Insure Header"."Policy Status")
            {
            }
            column(PolicyClass_InsureHeader; "Insure Header"."Policy Class")
            {
            }
            column(RenewalDate_InsureHeader; "Insure Header"."Renewal Date")
            {
            }
            column(TotalSumInsured_InsureHeader; "Insure Header"."Total Sum Insured")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(BranchName; BranchName)
            {
            }
            column(BranchAgent; BranchAgent)
            {
            }
            column(CertNo; CertNo)
            {
            }
            column(FutureAnnualPremium; FutureAnnualPremium)
            {
            }
            column(AgentMobile; AgentMobile)
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document No." = FIELD("No."),
                               "Document Type" = FIELD("Document Type");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Description Type" = CONST("Schedule of Insured"));
                column(DocumentType_InsureLines; "Insure Lines"."Document Type")
                {
                }
                column(DocumentNo_InsureLines; "Insure Lines"."Document No.")
                {
                }
                column(PolicyType_InsureLines; "Insure Lines"."Policy Type")
                {
                }
                column(PremiumAmount_InsureLines; "Insure Lines"."Premium Amount")
                {
                }
                column(PolicyNo_InsureLines; "Insure Lines"."Policy No")
                {
                }
                column(PremiumPayment_InsureLines; "Insure Lines"."Premium Payment")
                {
                }
                column(SumInsured_InsureLines; "Insure Lines"."Sum Insured")
                {
                }
                column(NetPremium_InsureLines; "Insure Lines"."Net Premium")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                Genledgsetup.GET;
                BranchCode := "Insure Header"."Shortcut Dimension 1 Code";
                IF DimValue.GET(Genledgsetup."Global Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                IF "Insure Header"."Total Net Premium" <> 0 THEN
                    FutureAnnualPremium := "Insure Header"."Total Net Premium" - 40;

                IF "Insure Header"."Agent/Broker" <> '' THEN
                    Cust.GET("Insure Header"."Agent/Broker");
                AgentMobile := Cust."Phone No.";
                BranchAgent := Cust.Name;


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
        Cust: Record Customer;
        CustomerName: Text;
        AgentMobile: Text;
        BranchAgent: Text;
        BranchName: Text;
        DimValue: Record "Dimension Value";
        Dimensions: Record 348;
        ClassName: Text;
        CertPrinting: Record "Certificate Printing";
        CertNo: Code[30];
        Genledgsetup: Record "General Ledger Setup";
        BranchCode: Code[30];
        FutureAnnualPremium: Decimal;
}

