report 51511014 "Imprest-Claim Voucher"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Imprest-Claim Voucher.rdl';

    dataset
    {
        dataitem("Request Header"; "Request Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.";
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(STRSUBSTNO_TXT002_CompanyInfo_Address_CompanyInfo__Post_Code__CompanyInfo_City_; STRSUBSTNO(TXT002, CompanyInfo.Address, CompanyInfo."Post Code", CompanyInfo.City))
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(Request_Header1__No__; "No.")
            {
            }
            column(Request_Header1__Request_Date_; "Request Date")
            {
            }
            column(Request_Header1__Employee_Name_; "Employee Name")
            {
            }
            column(CompName; CompName)
            {
            }
            column(TripNo_RequestHeader1; "Request Header"."Trip No")
            {
            }
            column(EmployeeNo_RequestHeader1; "Request Header"."Employee No")
            {
            }
            column(TripStartDate_RequestHeader1; "Request Header"."Trip Start Date")
            {
            }
            column(TripExpectedEndDate_RequestHeader1; "Request Header"."Trip Expected End Date")
            {
            }
            column(NoofDays_RequestHeader1; "Request Header"."No. of Days")
            {
            }
            column(PurposeofImprest_RequestHeader; "Request Header"."Purpose of Imprest")
            {
            }
            column(BankAccount_RequestHeader1; "Request Header"."Bank Account")
            {
            }
            column(CustomerAC_RequestHeader1; "Request Header"."Customer A/C")
            {
            }
            column(ImprestAmount_RequestHeader1; "Request Header"."Imprest Amount")
            {
            }
            column(TotalAmountRequested_RequestHeader1; "Request Header"."Total Amount Requested")
            {
            }
            column(ChequeNo_RequestHeader1; "Request Header"."Cheque No")
            {
            }
            column(PayMode_RequestHeader1; "Request Header"."Pay Mode")
            {
            }
            column(IMPREST_CLAIM_FORMCaption; ReportTitle)
            {
            }
            column(Request_Header1__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Request_Header1__Request_Date_Caption; FIELDCAPTION("Request Date"))
            {
            }
            column(Request_Header1__Employee_Name_Caption; FIELDCAPTION("Employee Name"))
            {
            }
            column(Department_Caption; Department_CaptionLbl)
            {
            }
            column(NumberText1; NumberText[1])
            {
            }
            column(NumberText2; NumberText[2])
            {
            }
            column(Amount_In_Words; STRSUBSTNO('%1  %2', CurrencyCodeText, "Imprest Amount"))
            {
            }
            column(Designation22; Designation)
            {
            }
            dataitem("Request Lines"; "Request Lines")
            {
                DataItemLink = "Document No" = FIELD("No.");
                DataItemTableView = SORTING("Document No", "Line No.");
                column(Request_Lines1_Description; Description)
                {
                }
                column(Request_Lines1__Request_Lines1___Requested_Amount_; "Requested Amount")
                {
                }
                column(Request_Lines1__Account_No_; "Account No")
                {
                }
                column(Destination_RequestLines; "Request Lines".Destination)
                {
                }
                column(BudgetBalance; BudgetBalance)
                {
                }
                column(STRSUBSTNO___1__2__CurrencyCodeText__Request_Lines1___Requested_Amount__; STRSUBSTNO('%1 %2', CurrencyCodeText, "Request Lines".Amount))
                {
                }
                column(STRSUBSTNO___1__2__CurrencyCodeText__Request_Header1___Imprest_Amount__; STRSUBSTNO('%1 %2', CurrencyCodeText, "Request Header"."Actual Amount"))
                {
                }
                column(STRSUBSTNO___1__2__CurrencyCodeText_Netamt_; STRSUBSTNO('%1 %2', CurrencyCodeText, Netamt))
                {
                }
                column(EmptyString; '____________________')
                {
                }
                /*column(UserRecApp3_Picture; UserRecApp3.Picture)
                {
                }*/
                column(V3rdapproverdate_; "3rdapproverdate")
                {
                }
                column(V3rdapprover_; "3rdapprover")
                {
                }
                /*column(UserRecApp2_Picture; UserRecApp2.Picture)
                {
                }*/
                column(V2ndapprover_; "2ndapprover")
                {
                }
                column(V2ndapproverdate_; "2ndapproverdate")
                {
                }
                column(V1stapprover_; "1stapprover")
                {
                }
                /*column(UserRecApp1_Picture; UserRecApp1.Picture)
                {
                }*/
                column(V1stapproverdate_; "1stapproverdate")
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(AmountCaption; AmountCaptionLbl)
                {
                }
                column(Request_Lines1__Account_No_Caption; FIELDCAPTION("Account No"))
                {
                }
                column(TOTAL_EXPENSESCaption; TOTAL_EXPENSESCaptionLbl)
                {
                }
                column(LESS__ADVANCECaption; LESS__ADVANCECaptionLbl)
                {
                }
                column(AMOUNT_DUE_TO__FROM__EMPLOYEECaption; AMOUNT_DUE_TO__FROM__EMPLOYEECaptionLbl)
                {
                }
                column(PAYMENT_RECEIVED_BYCaption; PAYMENT_RECEIVED_BYCaptionLbl)
                {
                }
                column(SIGNATURE__________________________________________________Caption; SIGNATURE__________________________________________________CaptionLbl)
                {
                }
                column(DATE__________________________________________________Caption; DATE__________________________________________________CaptionLbl)
                {
                }
                column(APPROVED_BY_Caption; APPROVED_BY_CaptionLbl)
                {
                }
                column(SIGNATURE_Caption; SIGNATURE_CaptionLbl)
                {
                }
                column(DATE__________________________________________________Caption_Control1000000036; DATE__________________________________________________Caption_Control1000000036Lbl)
                {
                }
                column(CHECKED_BY_Caption; CHECKED_BY_CaptionLbl)
                {
                }
                column(SIGNATURECaption; SIGNATURECaptionLbl)
                {
                }
                column(DATE__________________________________________________Caption_Control1000000042; DATE__________________________________________________Caption_Control1000000042Lbl)
                {
                }
                column(PREPARED_BYCaption; PREPARED_BYCaptionLbl)
                {
                }
                column(SIGNATURECaption_Control1000000055; SIGNATURECaption_Control1000000055Lbl)
                {
                }
                column(DATE__________________________________________________Caption_Control1000000062; DATE__________________________________________________Caption_Control1000000062Lbl)
                {
                }
                column(APPROVALCaption; APPROVALCaptionLbl)
                {
                }
                column(Request_Lines1_Document_No; "Document No")
                {
                }
                column(Request_Lines1_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord()
                var
                    GLAccount: Record "G/L Account";
                begin
                    BudgetBalance := 0;
                    GLAccount.RESET;
                    GLAccount.SETRANGE("No.", "Request Lines"."Account No");
                    //GLAccount.SETFILTER("Date Filter",'..%1',"Request Header"."Request Date");
                    IF GLAccount.FIND('-') THEN BEGIN
                        //GLAccount.CALCFIELDS("Budget Balance");
                        //BudgetBalance := GLAccount."Budget Balance";
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                Netamt := 0;

                DimValues.RESET;
                DimValues.SETRANGE(DimValues."Dimension Code", 'DEPARTMENT');
                DimValues.SETRANGE(DimValues.Code, "Global Dimension 1 Code");
                IF DimValues.FIND('-') THEN BEGIN
                    CompName := DimValues.Name;
                END
                ELSE BEGIN
                    CompName := '';
                END;

                IF Type = Type::Imprest THEN
                    ReportTitle := IMPREST_CLAIM_FORMCaptionLbl
                ELSE
                    IF Type = Type::PettyCash THEN
                        ReportTitle := PETTY_CASH_VOUCHERCaptionLbl;

                /*IF Payments.Currency<>'' THEN
                CurrencyCodeText:=Payments.Currency
                ELSE*/
                CurrencyCodeText := GLsetup."LCY Code";

                /*Banks.RESET;
                Banks.SETRANGE(Banks."No.",Payments."KBA Bank Code");
                IF Banks.FIND('-') THEN BEGIN
                BankName:=Banks.Name;
                END
                ELSE BEGIN
                BankName:='';
                END;
                
                Bank.RESET;
                Bank.SETRANGE(Bank."No.",Payments."Paying Bank Account");
                IF Bank.FIND('-') THEN BEGIN
                PayeeBankName:=Bank.Name;
                END
                ELSE BEGIN
                PayeeBankName:='';
                END;
                
                PGAccount:='';
                
                IF Payments."Account Type"=Payments."Account Type"::"G/L Account" THEN BEGIN
                PGAccount:=Payments."Account No.";
                END;
                
                IF Payments."Account Type"=Payments."Account Type"::"Bank Account" THEN BEGIN
                Bank.RESET;
                Bank.SETRANGE(Bank."No.",Payments."Account No.");
                IF Bank.FIND('-') THEN BEGIN
                Bank.TESTFIELD(Bank."Bank Acc. Posting Group");
                BankPG.RESET;
                BankPG.SETRANGE(BankPG.Code,Bank."Bank Acc. Posting Group");
                IF BankPG.FIND('-') THEN BEGIN
                PGAccount:=BankPG."G/L Bank Account No.";
                END;
                END;
                END;
                
                IF Payments."Account Type"=Payments."Account Type"::Vendor THEN BEGIN
                Vend.RESET;
                Vend.SETRANGE(Vend."No.",Payments."Account No.");
                IF Vend.FIND('-') THEN BEGIN
                Vend.TESTFIELD(Vend."Vendor Posting Group");
                VendorPG.RESET;
                VendorPG.SETRANGE(VendorPG.Code,Vend."Vendor Posting Group");
                IF VendorPG.FIND('-') THEN BEGIN
                PGAccount:=VendorPG."Payables Account";
                END;
                END;
                END;
                
                IF Payments."Account Type"=Payments."Account Type"::Customer THEN BEGIN
                Cust.RESET;
                Cust.SETRANGE(Cust."No.",Payments."Account No.");
                IF Cust.FIND('-') THEN BEGIN
                Cust.TESTFIELD(Cust."Customer Posting Group");
                CustPG.RESET;
                CustPG.SETRANGE(CustPG.Code,Cust."Customer Posting Group");
                IF CustPG.FIND('-') THEN BEGIN
                PGAccount:=CustPG."Receivables Account";
                END;
                END;
                END;
                
                IF Payments."Account Type"=Payments."Account Type"::"Fixed Asset" THEN BEGIN
                FA.RESET;
                FA.SETRANGE(FA."FA No.",Payments."Account No.");
                IF FA.FIND('-') THEN BEGIN
                FA.TESTFIELD(FA."FA Posting Group");
                FAPG.RESET;
                FAPG.SETRANGE(FAPG.Code,FA."FA Posting Group");
                IF FAPG.FIND('-') THEN BEGIN
                PGAccount:=FAPG."Acquisition Cost Account";
                END;
                END;
                END;
                
                BankAccountUsed:='';
                //Payments.TESTFIELD(Payments."Pay Mode");
                IF Payments."Pay Mode"='CASH' THEN BEGIN
                BankAccountUsed:=Payments."Cashier Bank Account";
                END
                ELSE BEGIN
                BankAccountUsed:=Payments."Paying Bank Account";
                END;
                
                BankAccountUsedName:='';
                Bank.RESET;
                Bank.SETRANGE(Bank."No.",BankAccountUsed);
                IF Bank.FIND('-') THEN BEGIN
                Bank.TESTFIELD(Bank."Bank Acc. Posting Group");
                BankPG.RESET;
                BankPG.SETRANGE(BankPG.Code,Bank."Bank Acc. Posting Group");
                IF BankPG.FIND('-') THEN BEGIN
                BankAccountUsed:=BankPG."G/L Bank Account No.";
                END;
                //BankAccountUsedName:=Bank.Name;
                END;
                
                GLAccount.RESET;
                GLAccount.SETRANGE(GLAccount."No.",BankAccountUsed);
                IF GLAccount.FIND('-') THEN BEGIN
                BankAccountUsedName:=GLAccount.Name;
                END;
                
                
                PGAccountUsedName:='';
                GLAccount.RESET;
                GLAccount.SETRANGE(GLAccount."No.",PGAccount);
                IF GLAccount.FIND('-') THEN BEGIN
                PGAccountUsedName:=GLAccount.Name;
                END;
                { IF UserRec.GET(Payments.Cashier) THEN
                 BEGIN
                 //MESSAGE('%1',Payments.Cashier);
                 UserRec.CALCFIELDS(UserRec.Picture);
                 END;} */


                ApprovalEntries.RESET;
                ApprovalEntries.SETRANGE(ApprovalEntries."Table ID", 51511126);
                ApprovalEntries.SETRANGE(ApprovalEntries."Document No.", "No.");
                ApprovalEntries.SETRANGE(ApprovalEntries.Status, ApprovalEntries.Status::Approved);
                IF ApprovalEntries.FINDFIRST THEN BEGIN
                    i := 0;
                    REPEAT
                        i := i + 1;
                        IF i = 1 THEN BEGIN
                            "1stapprover" := ApprovalEntries."Sender ID";
                            "1stapproverdate" := ApprovalEntries."Date-Time Sent for Approval";
                            IF UserRecApp1.GET("1stapprover") THEN
                                IF EmpRec.GET(UserRecApp1."Employee No.") THEN
                                    EmpRec.CALCFIELDS(Picture);
                            //UserRecApp1.Picture := EmpRec.Picture;
                            //get HOD
                            IF UserRecApp2.GET(ApprovalEntries."Approver ID") THEN BEGIN
                                "2ndapprover" := ApprovalEntries."Approver ID";
                                "2ndapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF EmpRec.GET(UserRecApp2."Employee No.") THEN
                                    EmpRec.CALCFIELDS(Picture);
                                // UserRecApp2.Picture := EmpRec.Picture;
                            END;

                        END;
                        /*
                        IF i=2 THEN
                        BEGIN


                        "2ndapprover":=ApprovalEntries."Approver ID";
                        "2ndapproverdate":=ApprovalEntries."Last Date-Time Modified";
                         IF UserRecApp2.GET("2ndapprover") THEN
                          IF EmpRec.GET(UserRecApp2."Employee No." ) THEN
                            EmpRec.CALCFIELDS(Signature );
                            UserRecApp3.Picture:=EmpRec.Signature;
                        END;
                        */

                        IF EmpRec.GET("Request Header"."Account No.") THEN
                            Designation := EmpRec."Job Title";









                        IF i = 2 THEN BEGIN
                            "3rdapprover" := ApprovalEntries."Approver ID";
                            "3rdapproverdate" := ApprovalEntries."Last Date-Time Modified";
                            IF UserRecApp3.GET("3rdapprover") THEN
                                IF EmpRec.GET(UserRecApp3."Employee No.") THEN
                                    //UserRecApp2.CALCFIELDS(UserRecApp2.Picture);
                                    EmpRec.CALCFIELDS(Picture);
                            //UserRecApp3.Picture := EmpRec.Picture;


                        END;

                    UNTIL ApprovalEntries.NEXT = 0;
                END;
                CALCFIELDS(Balance, "Imprest Amount", "Actual Amount");
                Netamt := "Imprest Amount" - "Actual Amount";

            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(CompanyInfo.Picture);
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
        Name = 'Name of applicant';
        Designation = 'Designation';
        StaffNo = 'Personal Number';
        Dept = 'Branch/Dept';
        ApplyText = 'I apply for standing/Temporary/Special * imprest of Kshs';
        InWords = 'In Words';
        PurposesText = 'For the following purposes:';
        NatureOfDuty = 'Nature of duty.';
        ItineraryLbl = 'Proposed Itinerary';
        NoOfDaysLbl = 'Estimated Number of days away from station';
        DateLbl = 'Date';
        ApplSignatureLbl = 'Signature of Applicant';
        AuthorizeText = '(i) I hereby authorize and confirm that funds are available to meet the expenses and that the amount is realistic and proper charge against public funds';
        CertifyText = '(ii) I Certify that the applicant is an employee of the Authority';
        DFACmmnts = 'DFA Comments';
        DGDFALbl = 'Head of Department';
        ImprestAccountantIC = 'Accountant -in-charge Imprest';
        VBCAccountantText = 'I certify that the amount has been noted in the imprest register/Votebook No:.........................';
        VBCAccountantICLbl = 'Accountant -in-charge';
        AuthorizationLbl = 'Authorization:';
        ChiefAccountantLbl = 'Head of Finance / Designate';
        PostingLbl = 'Receipient:';
        PostedByLbl = 'Received  by';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        SalesSetup.GET;
        GLsetup.GET;
        CASE SalesSetup."Logo Position on Documents" OF
            SalesSetup."Logo Position on Documents"::"No Logo":
                ;
            SalesSetup."Logo Position on Documents"::Left:
                BEGIN
                    CompanyInfo.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Center:
                BEGIN
                    CompanyInfo.GET;
                    CompanyInfo.CALCFIELDS(Picture);
                END;
            SalesSetup."Logo Position on Documents"::Right:
                BEGIN
                    CompanyInfo.GET;
                    CompanyInfo.CALCFIELDS(Picture);
                END;
        END;
    end;

    var
        DimValues: Record "Dimension Value";
        CompName: Text[100];
        TypeOfDoc: Text[100];
        RecPayTypes: Record "Receipts Header";
        BankName: Text[100];
        Banks: Record "Bank Account";
        Bank: Record "Bank Account";
        PayeeBankName: Text[100];
        VendorPG: Record "Vendor Posting Group";
        CustPG: Record "Customer Posting Group";
        FAPG: Record "FA Posting Group";
        BankPG: Record "Bank Account Posting Group";
        PGAccount: Text[50];
        Vend: Record Vendor;
        Cust: Record Customer;
        FA: Record "FA Depreciation Book";
        BankAccountUsed: Text[50];
        BankAccountUsedName: Text[100];
        PGAccountUsedName: Text[50];
        GLAccount: Record "G/L Account";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        GLsetup: Record "General Ledger Setup";
        NumberText: array[2] of Text[80];
        CurrencyCodeText: Code[10];
        TXT001: Label '%1 %2';
        TXT002: Label '%1, %2  %3';
        ApprovalEntries: Record "Approval Entry";
        "1stapprover": Text[30];
        "2ndapprover": Text[30];
        i: Integer;
        "1stapproverdate": DateTime;
        "2ndapproverdate": DateTime;
        UserRec: Record "User Setup";
        UserRecApp1: Record "User Setup";
        UserRecApp2: Record "User Setup";
        UserRecApp3: Record "User Setup";
        "3rdapprover": Text[30];
        "3rdapproverdate": DateTime;
        Netamt: Decimal;
        IMPREST_CLAIM_FORMCaptionLbl: Label 'IMPREST ';
        PETTY_CASH_VOUCHERCaptionLbl: Label 'PETTY CASH VOUCHER';
        Department_CaptionLbl: Label 'Department ';
        DescriptionCaptionLbl: Label 'Description';
        AmountCaptionLbl: Label 'Amount';
        TOTAL_EXPENSESCaptionLbl: Label 'TOTAL ADVANCE';
        LESS__ADVANCECaptionLbl: Label 'LESS: TOTAL EXPENSES';
        AMOUNT_DUE_TO__FROM__EMPLOYEECaptionLbl: Label 'AMOUNT DUE TO/(FROM) EMPLOYEE';
        PAYMENT_RECEIVED_BYCaptionLbl: Label 'PAYMENT RECEIVED BY';
        SIGNATURE__________________________________________________CaptionLbl: Label 'SIGNATURE';
        DATE__________________________________________________CaptionLbl: Label 'DATE ';
        APPROVED_BY_CaptionLbl: Label 'APPROVED BY ';
        SIGNATURE_CaptionLbl: Label 'SIGNATURE ';
        DATE__________________________________________________Caption_Control1000000036Lbl: Label 'DATE';
        CHECKED_BY_CaptionLbl: Label 'CHECKED BY ';
        SIGNATURECaptionLbl: Label 'SIGNATURE';
        DATE__________________________________________________Caption_Control1000000042Lbl: Label 'DATE';
        PREPARED_BYCaptionLbl: Label 'PREPARED BY';
        SIGNATURECaption_Control1000000055Lbl: Label 'SIGNATURE';
        DATE__________________________________________________Caption_Control1000000062Lbl: Label 'DATE ';
        APPROVALCaptionLbl: Label 'APPROVAL';
        ReportTitle: Text[50];
        EmpRec: Record Employee;
        Designation: Text;
        BudgetBalance: Decimal;
}

