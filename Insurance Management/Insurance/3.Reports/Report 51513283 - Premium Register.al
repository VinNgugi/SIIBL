report 51513283 "Premium Register"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Premium Register.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.";
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
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No."), "Posting Date" = FIELD("Date Filter");
                //DataItemTableView = '';
                column(PostingDate; "Cust. Ledger Entry"."Posting Date")
                {
                }
                column(DocumentType; "Cust. Ledger Entry"."Document Type")
                {
                }
                column(DocumentNo; "Cust. Ledger Entry"."Document No.")
                {
                }
                column(GrossPremium; GrossPremium)
                {
                }
                column(NetPremium; NetPremium)
                {
                }
                column(Amount; "Cust. Ledger Entry".Amount)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    PostedDebitNote.SETRANGE(PostedDebitNote."No.", "Cust. Ledger Entry"."Document No.");
                    PostedDebitNote.SETRANGE(PostedDebitNote."Document Type", PostedDebitNote."Document Type"::"Debit Note");
                    IF PostedDebitNote.FIND('-') THEN BEGIN

                        PostedDebitNote.CALCFIELDS(PostedDebitNote."Total Premium Amount");
                        GrossPremium := PostedDebitNote."Total Premium Amount";
                    END;
                end;

                trigger OnPreDataItem();
                begin
                    LastFieldNo := FIELDNO("Customer No.");
                end;
            }
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

    trigger OnPreReport();
    begin
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        CompInfor: Record 79;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        PostedDebitNote: Record "Insure Header";
        Taxes: Record 5630;
        TaxesArray: array[10] of Code[50];
        TaxesArrayVal: array[10] of Decimal;
        i: Integer;
        SalesLine: Record "Insure Lines";
        GrossPremium: Decimal;
        NetPremium: Decimal;
        TaxesArraydesc: array[10] of Text[100];
}

