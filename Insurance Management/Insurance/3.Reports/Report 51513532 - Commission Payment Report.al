report 51513532 "Commission Payment Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Commission Payment Report.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Customer Type" = FILTER("Agent/Broker"),
                                      "Customer Posting Group" = FILTER(<> 'DIRECT'),
                                      Name = FILTER(<> ''));
            RequestFilterFields = "Global Dimension 1 Code";
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
            column(GrossPremium_Customer; Customer."Gross Premium")
            {
            }
            column(Receipts_Customer; Customer.Receipts)
            {
            }
            column(Commission_Customer; Customer.Commission)
            {
            }
            column(Wht_Customer; Customer.Wht)
            {
            }
            column(NetCommission_Customer; Customer."Net Commission")
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(TotalCommission2Pay; TotalCommission2Pay)
            {
            }
            column(PeriodStartDate; PeriodStartDate)
            {
            }
            column(PeriodEndDate; PeriodEndDate)
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            dataitem("Customer Bank Account"; "Customer Bank Account")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                column(Code_CustomerBankAccount; "Customer Bank Account".Code)
                {
                }
                column(Name_CustomerBankAccount; "Customer Bank Account".Name)
                {
                }
                column(BankBranchNo_CustomerBankAccount; "Customer Bank Account"."Bank Branch No.")
                {
                }
                column(BankAccountNo_CustomerBankAccount; "Customer Bank Account"."Bank Account No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CompInfor.CALCFIELDS(CompInfor.Picture);
                //Customer.SETRANGE("Date Filter", );
                TotalCommission2Pay := 0;
                Customer.CALCFIELDS(Customer."Net Commission");
                CustLedger1.RESET;
                CustLedger1.SETRANGE("Posting Date", PeriodStartDate, PeriodEndDate);
                CustLedger1.SETRANGE(CustLedger1."Customer No.", Customer."No.");
                //CustLedger.SETFILTER(CustLedger."Insurance Trans Type",'%1|%2',CustLedger."Insurance Trans Type"::Commission,CustLedger."Insurance Trans Type"::Wht);
                CustLedger1.SETRANGE(CustLedger1."Insurance Trans Type", CustLedger1."Insurance Trans Type"::"Net Premium");
                IF CustLedger1.FINDFIRST THEN
                    REPEAT


                        CustLedger1.CALCFIELDS(CustLedger1."Remaining Amount");
                        IF CustLedger1."Remaining Amount" = 0 THEN BEGIN
                            CustLedgerCopy1.RESET;
                            CustLedgerCopy1.SETRANGE(CustLedgerCopy1."Posting Date", CustLedger1."Posting Date");
                            CustLedgerCopy1.SETRANGE(CustLedgerCopy1."Document No.", CustLedger1."Document No.");
                            CustLedgerCopy1.SETFILTER(CustLedgerCopy1."Insurance Trans Type", '%1|%2', CustLedgerCopy1."Insurance Trans Type"::Commission, CustLedgerCopy1."Insurance Trans Type"::Wht);

                            IF CustLedgerCopy1.FINDFIRST THEN BEGIN

                                REPEAT

                                    CustLedgerCopy1.CALCFIELDS(CustLedgerCopy1."Remaining Amount");

                                    TotalCommission2Pay := TotalCommission2Pay + CustLedgerCopy1."Remaining Amount";
                                // MESSAGE('%1 %2',CustLedgerCopy1."Document No.",TotalCommission2Pay);
                                UNTIL CustLedgerCopy1.NEXT = 0;
                            END;

                        END;
                    UNTIL CustLedger1.NEXT = 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("Starting Date"; PeriodStartDate)
                    {
                        Caption = 'Stard Date';
                    }
                    field("Ending Date"; PeriodEndDate)
                    {
                        Caption = 'End Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            PeriodStartDate := WORKDATE;
            PeriodEndDate := WORKDATE;
        end;
    }

    labels
    {
    }

    var
        CompInfor: Record 79;
        BlankStartDateErr: Label '" Date must have a value."';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Date value is a future date';
        PeriodStartDate: Date;
        PeriodEndDate: Date;
        CustLedgerCopy: Record "Cust. Ledger Entry";
        CustLedger1: Record "Cust. Ledger Entry";
        Custledger1Copy: Record "Cust. Ledger Entry";
        TotalCommission2Pay: Decimal;
        CustLedgerCopy1: Record "Cust. Ledger Entry";

    procedure InitializeRequest(StartDate: Date; EndDate: Date);
    begin
        PeriodStartDate := StartDate;
        PeriodEndDate := EndDate;
    end;

    local procedure VerifyDates();
    begin
        IF PeriodStartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF PeriodStartDate > WORKDATE THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;
}

