report 51513301 "Commission Statement by Insure"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Commission Statement by Insure.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            RequestFilterFields = "No.", "Date Filter";
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
            dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No." = FIELD("No.");
                column(Picture; CompInfor.Picture)
                {
                }
                column(PostingDate; "Vendor Ledger Entry"."Posting Date")
                {
                }
                column(DocumentNo; "Vendor Ledger Entry"."Document No.")
                {
                }
                column(Class; Class)
                {
                }
                column(ClientName; ClientName)
                {
                }
                column(Clientnames; Clientnames)
                {
                }
                column(WitholdingTax; WitholdingTax)
                {
                }
                column(Commission; Commission)
                {
                }
                column(TotalGross; TotalGross)
                {
                }
                column(TotalRemaining; TotalRemaining)
                {
                }
                column(TotalNet; TotalNet)
                {
                }
                column(NetCommission; NetCommission)
                {
                }
                column(Amount; "Vendor Ledger Entry".Amount)
                {
                }
                column(RemainingAmount; "Vendor Ledger Entry"."Remaining Amount")
                {
                }
                column(TotalPremiumAmount; DebitNote."Total Premium Amount")
                {
                }
                column(CommisiionDue; DebitNote."Commission Due")
                {
                }

                trigger OnAfterGetRecord();
                begin

                    WitholdingTax := 0;
                    Commission := 0;

                    DebitNote.SETRANGE(DebitNote."No.", "Vendor Ledger Entry"."Document No.");
                    DebitNote.SETRANGE(DebitNote."Document Type", DebitNote."Document Type"::"Debit Note");
                    IF DebitNote.FIND('-') THEN BEGIN


                        Class := DebitNote."Policy Type";
                        Clientnames := DebitNote."Insured Name";
                        IF policyType.GET(DebitNote."Policy Type") THEN
                            Class := policyType.Description;
                        PolicyNumber := DebitNote."Policy No";
                        DebitNote.CALCFIELDS(DebitNote."Total Premium Amount");
                        "Vendor Ledger Entry".CALCFIELDS("Vendor Ledger Entry"."Remaining Amount", "Vendor Ledger Entry".Amount);
                        Commission := "Vendor Ledger Entry".Amount;
                        TotalRemaining := TotalRemaining + "Vendor Ledger Entry"."Remaining Amount";

                    END;


                    CreditNote.SETRANGE(CreditNote."No.", "Vendor Ledger Entry"."Document No.");
                    CreditNote.SETRANGE(CreditNote."Document Type", CreditNote."Document Type"::"Credit Note");
                    IF CreditNote.FIND('-') THEN BEGIN

                        Class := CreditNote."Policy Type";
                        Clientnames := CreditNote."Insured Name";
                        IF policyType.GET(CreditNote."Policy Type") THEN
                            Class := policyType.Description;
                        PolicyNumber := CreditNote."Policy No";
                        CreditNote.CALCFIELDS(CreditNote."Total Premium Amount");
                        "Vendor Ledger Entry".CALCFIELDS("Vendor Ledger Entry"."Remaining Amount", "Vendor Ledger Entry".Amount);
                        Commission := "Vendor Ledger Entry".Amount;
                        TotalRemaining := TotalRemaining + "Vendor Ledger Entry"."Remaining Amount";

                    END;


                    TotalGross := TotalGross + "Vendor Ledger Entry".Amount;
                    vendledger.RESET;
                    vendledger.SETRANGE(vendledger."Vendor No.", "Vendor Ledger Entry"."Vendor No.");
                    vendledger.SETRANGE(vendledger."Document No.", "Vendor Ledger Entry"."Document No.");
                    vendledger.SETRANGE(vendledger."Posting Date", "Vendor Ledger Entry"."Posting Date");
                    vendledger.SETRANGE(vendledger."Bal. Account No.", '4030');

                    IF vendledger.FIND('-') THEN BEGIN
                        vendledger.CALCFIELDS(vendledger.Amount);
                        WitholdingTax := vendledger.Amount;

                    END;
                    NetCommission := "Vendor Ledger Entry".Amount + WitholdingTax;


                    TotalWtx := TotalWtx + WitholdingTax;
                    TotalNet := TotalNet + NetCommission;
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
        DebitNote: Record "Insure Header";
        GLAcc: Record "G/L Account";
        Class: Text[130];
        PolicyNumber: Code[20];
        ClientName: Text[200];
        WitholdingTax: Decimal;
        NetCommission: Decimal;
        vendledger: Record "Vendor Ledger Entry";
        PolicyDescription: Text[230];
        policyType: Record "Policy Type";
        Clientnames: Text[130];
        CompanyAddr: array[8] of Text[60];
        companyInfo: Record 79;
        FormatAddr: Codeunit 365;
        TotalGross: Decimal;
        TotalWtx: Decimal;
        TotalNet: Decimal;
        TotalRemaining: Decimal;
        Commission: Decimal;
        CreditNote: Record "Insure Header";
}

