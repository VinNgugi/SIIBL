report 51513299 "Outstanding Customer Balances"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Outstanding Customer Balances.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
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
            column(Picture; CompInfor.Picture)
            {
            }
            column(Address_Customer; Customer.Address)
            {
            }
            column(Address2_Customer; Customer."Address 2")
            {
            }
            column(City_Customer; Customer.City)
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(NetChange_Customer; Customer."Net Change")
            {
            }
            column(NetChangeLCY_Customer; Customer."Net Change (LCY)")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }

            trigger OnAfterGetRecord();
            begin

                //IF Customer."Customer Posting Group"<>'GENERAL' THEN
                //CurrReport.SKIP;

                CALCFIELDS("Balance (LCY)", Customer."Net Change (LCY)");
                FormatAddr.FormatAddr(
                  CustAddr, Name, "Name 2", '', Address, "Address 2",
                  City, "Post Code", County, "Country/Region Code");
            end;

            trigger OnPreDataItem();
            begin

                CurrReport.CREATETOTALS("Balance (LCY)", Customer."Net Change (LCY)");
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

    trigger OnInitReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    trigger OnPreReport();
    begin
        CustFilter := Customer.GETFILTERS;
    end;

    var
        CustFilter: Text[250];
        CustAddr: array[8] of Text[250];
        FormatAddr: Codeunit 365;
        CompInfor: Record 79;
}

