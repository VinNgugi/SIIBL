report 51513024 "Generate Renewal Quotes1"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Generate Renewal Quotes1.rdl';

    dataset
    {
        dataitem("Insure Header"; "Insure Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Policy));
            RequestFilterFields = "Expected Renewal Date", "Agent/Broker";
            column(InsuredNo; "Insure Header"."Insured No.")
            {
            }
            column(InsuredName; "Insure Header"."Insured Name")
            {
            }
            column(PolicyNo; "Insure Header"."Policy No")
            {
            }
            column(fromDate; "Insure Header"."From Date")
            {
            }
            column(toDate; "Insure Header"."To Date")
            {
            }

            trigger OnAfterGetRecord();
            begin
                Window.UPDATE(1, "Insure Header"."Insured Name");
                Insmangt.ConvertPolicy2RenewalQuote("Insure Header");
            end;

            trigger OnPostDataItem();
            begin
                Window.CLOSE;
            end;

            trigger OnPreDataItem();
            begin
                Window.OPEN('##########################################1', ClientName);
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
        InsQuote: Record "Insure Header";
        InsQLines: Record "Insure Lines";
        Policylines: Record "Insure Lines";
        Mindate: Date;
        Noseriesmangement: Codeunit NoSeriesManagement;
        InsuranceSetup: Record "Insurance setup";
        Insmangt: Codeunit "Insurance management";
        Window: Dialog;
        ClientName: Text[250];
}

