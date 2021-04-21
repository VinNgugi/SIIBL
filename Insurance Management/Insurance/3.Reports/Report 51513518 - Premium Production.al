report 51513518 "Premium Production"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Premium Production.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = SORTING("Document Type", "No.")
                                WHERE("Policy No" = FILTER(<> ''));
            RequestFilterFields = "Document Date", "Shortcut Dimension 1 Code";
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
            column(BranchName; BranchName)
            {
            }
            column(PolicyDescription; PolicyDescription)
            {
            }
            column(TelephoneContact; TelephoneContact)
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
            column(AgentBroker_InsureHeader; "Insure Header"."Agent/Broker")
            {
            }
            column(BrokersName_InsureHeader; "Insure Header"."Brokers Name")
            {
            }
            column(UndewriterName_InsureHeader; "Insure Header"."Underwriter Name")
            {
            }
            column(PolicyNo_InsureHeader; "Insure Header"."Policy No")
            {
            }
            column(TotalNetPremium_InsureHeader; "Insure Header"."Total Net Premium")
            {
            }
            column(InsuredName_InsureHeader; "Insure Header"."Insured Name")
            {
            }
            column(DocumentDate_InsureHeader; "Insure Header"."Document Date")
            {
            }
            column(EndorsementPolicyNo_InsureHeader; "Insure Header"."Endorsement Policy No.")
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "Document Type" = FIELD("Document Type"),
                               "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Description Type" = CONST("Schedule of Insured"),
                                          "Registration No." = FILTER(<> ''));
                column(DocumentType_InsureLines; "Insure Lines"."Document Type")
                {
                }
                column(DocumentNo_InsureLines; "Insure Lines"."Document No.")
                {
                }
                column(SumInsured_InsureLines; "Insure Lines"."Sum Insured")
                {
                }
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
                column(CertificateNo_InsureLines; "Insure Lines"."Certificate No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.GET;
                CompInfor.CALCFIELDS(CompInfor.Picture);
                BranchCode := "Insure Header"."Shortcut Dimension 1 Code";
                GenLedgSetup.GET;
                IF DimValue.GET(GenLedgSetup."Shortcut Dimension 1 Code", BranchCode) THEN
                    BranchName := DimValue.Name;
                IF PolicyType.GET("Policy Type") THEN
                    PolicyDescription := PolicyType.Description;
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
        BranchName: Text;
        GenLedgSetup: Record "General Ledger Setup";
        BranchCode: Code[30];
        DimValue: Record "Dimension Value";
        TelephoneContact: Code[30];
        Cust: Record Customer;
        PolicyType: Record "Policy Type";
        PolicyDescription: Text;
}

