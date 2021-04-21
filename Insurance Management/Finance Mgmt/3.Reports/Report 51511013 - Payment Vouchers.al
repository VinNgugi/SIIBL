report 51511013 "Payment Vouchers"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Payment Vouchers.rdl';

    dataset
    {
        dataitem("Payments"; "Payments1")
        {
            DataItemTableView = SORTING(No)
                                ORDER(Ascending);
            RequestFilterFields = No;
            column(CompanyInfo_Name; UPPERCASE(CompanyInfo.Name))
            {
            }
            column(STRSUBSTNO_TXT002_CompanyInfo_Address_CompanyInfo__Post_Code__CompanyInfo_City_; STRSUBSTNO(TXT002, CompanyInfo.Address, CompanyInfo."Post Code", CompanyInfo.City))
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(PayeeBankName; PayeeBankName)
            {
            }
            column(PayingBankAccount_Payments; Payments."Paying Bank Account")
            {
            }
            column(Payments_Payments_No; Payments.No)
            {
            }
            column(Payments_Payments__Cheque_No_; Payments."Cheque No")
            {
            }
            column(Payments_Payments_Date; Payments.Date)
            {
            }
            column(PayMode_Payments; Payments."Pay Mode")
            {
            }
            column(Payments_Payments_Payee; Payments.Payee)
            {
            }
            column(PayeeAddress; PayeeAddress)
            {
            }
            column(NumberText_1_; NumberText[1])
            {
            }
            column(NumberText_2_; NumberText[2])
            {
            }
            column(CurrentBudget; CurrentBudget)
            {
            }
            column(PreparedbyName; Payments.Cashier)
            {
            }
            column(AuthorizedName; AuthorizedName)
            {
            }
            column(V1stapprover_; "1stapprover")
            {
            }
            column(EmptyString; '_______________________________________')
            {
            }
            column(V2ndapprover_; "2ndapprover")
            {
            }
            column(V2ndapproverdate_; "2ndapproverdate")
            {
            }
            column(V3rdapproverdate_; "3rdapproverdate")
            {
            }
            /*column(UserRecApp1_Picture; UserRecApp1.Picture)
            {
            }
            column(UserRecApp2_Picture; UserRecApp2.Picture)
            {
            }*/
            column(ChequeNo_Payments; Payments."Cheque No")
            {
            }
            column(V3rdapprover_; "3rdapprover")
            {
            }
            /*column(UserRecApp3_Picture; UserRecApp3.Picture)
            {
            }*/
            column(Designation_1; Designation1)
            {
            }
            column(Designation_2; Designation2)
            {
            }
            column(Designation_3; Designation3)
            {
            }
            column(V1stapproverdate_; "1stapproverdate")
            {
            }
            column(PAYMENT_VOUCHERCaption; PAYMENT_VOUCHERCaptionLbl)
            {
            }
            column(BANK_NAMECaption; BANK_NAMECaptionLbl)
            {
            }
            column(VOUCHER_NOCaption; VOUCHER_NOCaptionLbl)
            {
            }
            column(CHEQUE_NOCaption; CHEQUE_NOCaptionLbl)
            {
            }
            column(PAYEECaption; PAYEECaptionLbl)
            {
            }
            column(PREPARED_BYCaption; PREPARED_BYCaptionLbl)
            {
            }
            column(CHECKED_BY_Caption; CHECKED_BY_CaptionLbl)
            {
            }
            column(SIGNATURECaption; SIGNATURECaptionLbl)
            {
            }
            column(DATE__________________________________________________Caption; DATE__________________________________________________CaptionLbl)
            {
            }
            column(PAYMENT_RECEIVED_BYCaption; PAYMENT_RECEIVED_BYCaptionLbl)
            {
            }
            column(SIGNATURE__________________________________________________Caption; SIGNATURE__________________________________________________CaptionLbl)
            {
            }
            column(DATE__________________________________________________Caption_Control1000000073; DATE__________________________________________________Caption_Control1000000073Lbl)
            {
            }
            column(APPROVALCaption; APPROVALCaptionLbl)
            {
            }
            column(SIGNATURECaption_Control1000000001; SIGNATURECaption_Control1000000001Lbl)
            {
            }
            column(DATE__________________________________________________Caption_Control1000000003; DATE__________________________________________________Caption_Control1000000003Lbl)
            {
            }
            column(Payment_Approved_By_Head_of_Finance_Caption; APPROVED_BY_CaptionLbl)
            {
            }
            column(SIGNATURE_Caption; SIGNATURE_CaptionLbl)
            {
            }
            column(DATE__________________________________________________Caption_Control1000000021; DATE__________________________________________________Caption_Control1000000021Lbl)
            {
            }
            column(Payecode; PAYECODE)
            {
            }
            column(WhtCode; WHTACC)
            {
            }
            column(ContactInfo; STRSUBSTNO(Text100, CompanyInfo."Phone No.", CompanyInfo."Phone No. 2", /*CompanyInfo."Finance Email",*/ CompanyInfo."Home Page"))
            {
            }
            column(PaymentAccountNo; Payments."Account No.")
            {
            }
            column(TotalAmount; Payments."Total Amount")
            {
            }
            column(Remarks; Payments.Remarks)
            {
            }
            column(V4thapproverdate; "4thapproverdate")
            {
            }
            column(V4thapprover; "4thapprover")
            {
            }
            /*column(UserRecApp4_Picture; UserRecApp4.Picture)
            {
            }*/
            column(Designation_4; Designation4)
            {
            }
            column(V5thapproverdate; "5thapproverdate")
            {
            }
            column(V5thapprover; "5thapprover")
            {
            }
            /*column(UserRecApp5_Picture; UserRecApp5.Picture)
            {
            }*/
            column(Designation_5; Designation5)
            {
            }
            column(BankAccountNo; BankAccountNo)
            {
            }
            column(VBCCertLbl; VBCCertLbl)
            {
            }
            column(VBCCertText; VBCCertText)
            {
            }
            column(AIEHolderCertLbl; AIEHolderCertLbl)
            {
            }
            column(AIEHolderCertText; AIEHolderCertText)
            {
            }
            column(AuthorizationLbl; AuthorizationLbl)
            {
            }
            column(AuthorizationText1; AuthorizationText1)
            {
            }
            column(AuthorizationText2; AuthorizationText2)
            {
            }
            column(VoteLbl; VoteLbl)
            {
            }
            column(HeadLbl; HeadLbl)
            {
            }
            column(SubHeadLbl; SubHeadLbl)
            {
            }
            column(ItemLbl; ItemLbl)
            {
            }
            column(AIENoLbl; AIENoLbl)
            {
            }
            column(AccNoLbl; AccNoLbl)
            {
            }
            column(DeptVchLbl; DeptVchLbl)
            {
            }
            column(StationLbl; StationLbl)
            {
            }
            column(CshBkLbl; CshBkLbl)
            {
            }
            column(AmtLbl; AmtLbl)
            {
            }
            column(VchLbl; VchLbl)
            {
            }
            column(ShLbl; ShLbl)
            {
            }
            column(CtsLbl; CtsLbl)
            {
            }
            column(LPODescription; LPODescription)
            {
            }
            column(InvoiceNoLbl; InvoiceNo)
            {
            }
            dataitem("PV Lines"; "PV Lines1")
            {
                DataItemLink = "PV No" = FIELD(No);
                column(PV_Lines1_Description; Description)
                {
                }
                column(PV_Lines1_Amount; Amount)
                {
                }
                column(PV_Lines1__Shortcut_Dimension_1_Code_; "Shortcut Dimension 1 Code")
                {
                }
                column(PV_Lines1__Account_Type_; "Account Type")
                {
                }
                column(PV_Lines1__Account_No__; "Account No")
                {
                }
                column(PV_Lines1__Shortcut_Dimension_2_Code_; "Shortcut Dimension 2 Code")
                {
                }
                column(STRSUBSTNO___1__2__CurrencyCodeText_Amount_; STRSUBSTNO('%1 %2', CurrencyCodeText, Amount))
                {
                }
                column(PV_Lines1_AmountCaption; FIELDCAPTION(Amount))
                {
                }
                column(PV_Lines1__Shortcut_Dimension_1_Code_Caption; FIELDCAPTION("Shortcut Dimension 1 Code"))
                {
                }
                column(PV_Lines1__Account_Type_Caption; FIELDCAPTION("Account Type"))
                {
                }
                column(PV_Lines1__Account_No__Caption; FIELDCAPTION("Account No"))
                {
                }
                column(PV_Lines1__Shortcut_Dimension_2_Code_Caption; FIELDCAPTION("Shortcut Dimension 2 Code"))
                {
                }
                column(PV_Lines1_PV_No; "PV No")
                {
                }
                column(PV_Lines1_Line_No; "Line No")
                {
                }
                column(PV_Lines1_VAT_Amount; "PV Lines"."VAT Amount")
                {
                }
                //column(PV_Lines1_WVAT_Amount; "PV Lines"."W/VAT Amount")
                //{
                //}
                column(PV_Lines1_Net_Amount; "PV Lines"."Net Amount")
                {
                }
                column(VATAmount; VATAmount)
                {
                }
                column(WTaxAmount; WTaxAmount)
                {
                }
                column(NetAmount; NetAmount)
                {
                }
                column(PV_Lines1_Retention_Amount; "PV Lines"."Retention Amount")
                {
                }
                column(RetentionAmount; RetentionAmount)
                {
                }
                column(AppliestoDocNo_PVLines1; "PV Lines"."Applies to Doc. No")
                {
                }
                column(AccountNo_PVLines1; "PV Lines"."Account No")
                {
                }
                column(Budgeted_Amount; GLAccount."Budget at Date")
                {
                }
                column(Net_Change; GLAccount."Net Change")
                {
                }
                column(Budgeted_Amount_Debit; GLAccount."Budgeted Debit Amount")
                {
                }
                column(UncommitedBalance_; UncommitedBalance)
                {
                }
                column(RunnigExpenditure_; RunnigExpenditure)
                {
                }
                column(ApprovedVoteEstimate_; ApprovedVoteEstimate)
                {
                }
                column(PV_Lines1_WTax_Amount; "PV Lines"."W/Tax Amount")
                {
                }
                column(WVATAMountLbl_; WVATAMountLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATSetup.RESET;
                    //VATSetup.SETRANGE(VATSetup."VAT Prod. Posting Group", "PV Lines"."W/VAT Code");
                    //VATSetup.SETRANGE(VATSetup."VAT Prod. Posting Group",'PAYE');
                    IF VATSetup.FIND('-')
                      THEN BEGIN
                        WHTACC := VATSetup."Purchase VAT Account";
                    END;
                    //Get Gl account for the account types vendor and bank
                    PGAccount := '';
                    IF "PV Lines"."Account Type" = "PV Lines"."Account Type"::"G/L Account" THEN BEGIN
                        PGAccount := "PV Lines"."Account No";
                    END;

                    IF "PV Lines"."Account Type" = "PV Lines"."Account Type"::"Bank Account" THEN BEGIN
                        Bank.RESET;
                        Bank.SETRANGE(Bank."No.", "PV Lines"."Account No");
                        IF Bank.FIND('-') THEN BEGIN
                            Bank.TESTFIELD(Bank."Bank Acc. Posting Group");
                            BankPG.RESET;
                            BankPG.SETRANGE(BankPG.Code, Bank."Bank Acc. Posting Group");
                            IF BankPG.FIND('-') THEN BEGIN
                                PGAccount := BankPG."G/L Bank Account No.";
                            END;
                        END;
                    END;

                    IF "PV Lines"."Account Type" = "PV Lines"."Account Type"::Vendor THEN BEGIN
                        Vend.RESET;
                        Vend.SETRANGE(Vend."No.", "PV Lines"."Account No");
                        IF Vend.FIND('-') THEN BEGIN
                            Vend.TESTFIELD(Vend."Vendor Posting Group");
                            VendorPG.RESET;
                            VendorPG.SETRANGE(VendorPG.Code, Vend."Vendor Posting Group");
                            IF VendorPG.FIND('-') THEN BEGIN
                                PGAccount := VendorPG."Payables Account";
                            END;
                        END;
                    END;


                    IF PvLines1."Account Type" = "PV Lines"."Account Type"::Customer THEN BEGIN
                        Cust.RESET;
                        Cust.SETRANGE(Cust."No.", "PV Lines"."Account No");
                        IF Cust.FIND('-') THEN BEGIN
                            Cust.TESTFIELD(Cust."Customer Posting Group");
                            CustPG.RESET;
                            CustPG.SETRANGE(CustPG.Code, Cust."Customer Posting Group");
                            IF CustPG.FIND('-') THEN BEGIN
                                PGAccount := CustPG."Receivables Account";
                            END;
                        END;
                    END;

                    IF PvLines1."Account Type" = "PV Lines"."Account Type"::"Fixed Asset" THEN BEGIN
                        FA.RESET;
                        FA.SETRANGE(FA."FA No.", "PV Lines"."Account No");
                        IF FA.FIND('-') THEN BEGIN
                            FA.TESTFIELD(FA."FA Posting Group");
                            FAPG.RESET;
                            FAPG.SETRANGE(FAPG.Code, FA."FA Posting Group");
                            IF FAPG.FIND('-') THEN BEGIN
                                PGAccount := FAPG."Acquisition Cost Account";
                            END;
                        END;
                    END;
                    //Get the Budgeted amount for the votehead..KKB

                    ApprovedVoteEstimate := 0;
                    RunnigExpenditure := 0;
                    UncommitedBalance := 0;
                    //IF GLAccount.GET(PGAccount) THEN
                    //BEGIN
                    GLAccountCopy.RESET;
                    GLAccountCopy.SETRANGE(GLAccountCopy."No.", PGAccount);
                    GLAccountCopy.SETRANGE(GLAccountCopy."Budget Filter", CurrentBudget);
                    IF GLAccountCopy.FINDLAST THEN BEGIN
                        // GLAccountCopy.CALCFIELDS(GLAccountCopy."Budgeted Amount", GLAccountCopy."Net Change", GLAccountCopy."Commited Amount");
                        ApprovedVoteEstimate := GLAccountCopy."Budgeted Amount";
                        RunnigExpenditure := GLAccountCopy."Net Change";
                        //CommitmentAmount := GLAccount."Commited Amount";
                        UncommitedBalance := ApprovedVoteEstimate - (RunnigExpenditure + CommitmentAmount);
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            var
                PVLines: Record "PV Lines1";
            begin



                DimValues.RESET;
                DimValues.SETRANGE(DimValues."Dimension Code", 'BRANCHES');
                DimValues.SETRANGE(DimValues.Code, Payments."Branch Code");

                IF DimValues.FIND('-') THEN BEGIN
                    CompName := DimValues.Name;
                END
                ELSE BEGIN
                    CompName := '';
                END;

                CurrentBudget := CashManagementSetup."Current Budget";

                IF Payments.Currency <> '' THEN
                    CurrencyCodeText := Payments.Currency
                ELSE
                    CurrencyCodeText := GLsetup."LCY Code";
                Payments.CALCFIELDS("Total Amount");
                InitTextVariable;
                FormatNoText(NumberText, "Total Amount", '');

                Banks.RESET;
                Banks.SETRANGE(Banks."No.", Payments."KBA Bank Code");
                IF Banks.FIND('-') THEN BEGIN
                    BankName := Banks.Name;
                END
                ELSE BEGIN
                    BankName := '';
                END;

                Bank.RESET;
                Bank.SETRANGE(Bank."No.", Payments."Paying Bank Account");
                IF Bank.FIND('-') THEN BEGIN
                    PayeeBankName := Bank.Name;
                    BankAccountNo := Bank."Bank Account No.";
                END
                ELSE BEGIN
                    PayeeBankName := '';
                END;


                BankAccountUsed := '';
                //Payments.TESTFIELD(Payments."Pay Mode");
                IF Payments."Pay Mode" = 'CASH' THEN BEGIN
                    BankAccountUsed := Payments."Cashier Bank Account";
                END
                ELSE BEGIN
                    BankAccountUsed := Payments."Paying Bank Account";
                END;

                BankAccountUsedName := '';
                Bank.RESET;
                Bank.SETRANGE(Bank."No.", BankAccountUsed);
                IF Bank.FIND('-') THEN BEGIN
                    Bank.TESTFIELD(Bank."Bank Acc. Posting Group");
                    BankPG.RESET;
                    BankPG.SETRANGE(BankPG.Code, Bank."Bank Acc. Posting Group");
                    IF BankPG.FIND('-') THEN BEGIN
                        BankAccountUsed := BankPG."G/L Bank Account No.";
                    END;
                    //BankAccountUsedName:=Bank.Name;
                END;

                GLAccount.RESET;
                GLAccount.SETRANGE(GLAccount."No.", BankAccountUsed);
                IF GLAccount.FIND('-') THEN BEGIN
                    BankAccountUsedName := GLAccount.Name;
                END;


                PGAccountUsedName := '';
                GLAccount.RESET;
                GLAccount.SETRANGE(GLAccount."No.", PGAccount);
                IF GLAccount.FIND('-') THEN BEGIN
                    PGAccountUsedName := GLAccount.Name;
                END;
                /* IF UserRec.GET(Payments.Cashier) THEN
                 BEGIN
                 //MESSAGE('%1',Payments.Cashier);
                 UserRec.CALCFIELDS(UserRec.Picture);
                 END;*/


                ApprovalEntries.RESET;
                ApprovalEntries.SETRANGE(ApprovalEntries."Table ID", 51511003);
                ApprovalEntries.SETRANGE(ApprovalEntries."Document No.", Payments.No);
                ApprovalEntries.SETRANGE(ApprovalEntries.Status, ApprovalEntries.Status::Approved);
                TotalApprovals := ApprovalEntries.COUNT;
                IF ApprovalEntries.FIND('-') THEN BEGIN
                    REPEAT
                        i := i + 1;
                        IF i = 1 THEN BEGIN
                            "1stapprover" := ApprovalEntries."Sender ID";
                            "1stapproverdate" := ApprovalEntries."Last Date-Time Modified";
                            IF UserRecApp1.GET("1stapprover") THEN
                                //UserRecApp1.CALCFIELDS(UserRecApp1.Picture);
                            IF EmpRec.GET(UserRecApp1."Employee No.") THEN BEGIN
                                    Designation1 := EmpRec."Job Title";
                                    EmpRec.CALCFIELDS(EmpRec.Picture);
                                END;
                            //
                            IF TotalApprovals < 4 THEN BEGIN
                                "2ndapprover" := ApprovalEntries."Approver ID";
                                "2ndapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF UserRecApp2.GET("2ndapprover") THEN
                                    //UserRecApp2.CALCFIELDS(UserRecApp2.Picture);
                                IF EmpRec.GET(UserRecApp2."Employee No.") THEN BEGIN
                                        Designation2 := EmpRec."Job Title";
                                        EmpRec.CALCFIELDS(EmpRec.Picture);
                                    END;
                            END;
                        END;

                        IF i = 2 THEN BEGIN
                            IF TotalApprovals >= 4 THEN BEGIN
                                "2ndapprover" := ApprovalEntries."Approver ID";
                                "2ndapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF UserRecApp2.GET("2ndapprover") THEN
                                    //UserRecApp2.CALCFIELDS(UserRecApp2.Picture);
                                IF EmpRec.GET(UserRecApp2."Employee No.") THEN BEGIN
                                        Designation2 := EmpRec."Job Title";
                                        EmpRec.CALCFIELDS(EmpRec.Picture);
                                    END;
                            END ELSE BEGIN
                                "3rdapprover" := ApprovalEntries."Approver ID";
                                "3rdapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF UserRecApp3.GET("3rdapprover") THEN
                                    //UserRecApp3.CALCFIELDS(UserRecApp3.Picture);
                                IF EmpRec.GET(UserRecApp3."Employee No.") THEN BEGIN
                                        Designation3 := EmpRec."Job Title";
                                        EmpRec.CALCFIELDS(EmpRec.Picture);
                                    END;
                            END;
                        END;

                        IF i = 3 THEN BEGIN
                            IF TotalApprovals >= 4 THEN BEGIN
                                "3rdapprover" := ApprovalEntries."Approver ID";
                                "3rdapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF UserRecApp3.GET("3rdapprover") THEN
                                    // UserRecApp3.CALCFIELDS(UserRecApp3.Picture);
                                    IF EmpRec.GET(UserRecApp3."Employee No.") THEN BEGIN
                                        Designation3 := EmpRec."Job Title";
                                        EmpRec.CALCFIELDS(EmpRec.Picture);
                                    END;
                            END ELSE BEGIN
                                "4thapprover" := ApprovalEntries."Approver ID";
                                "4thapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF UserRecApp4.GET("4thapprover") THEN
                                    //UserRecApp4.CALCFIELDS(UserRecApp4.Picture);
                                IF EmpRec.GET(UserRecApp4."Employee No.") THEN BEGIN
                                        Designation4 := EmpRec."Job Title";
                                        EmpRec.CALCFIELDS(EmpRec.Picture);
                                    END;
                            END;
                        END;

                        IF i = 4 THEN BEGIN
                            IF TotalApprovals >= 5 THEN BEGIN
                                "4thapprover" := ApprovalEntries."Approver ID";
                                "4thapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF UserRecApp4.GET("4thapprover") THEN
                                    // UserRecApp4.CALCFIELDS(UserRecApp4.Picture);
                                    IF EmpRec.GET(UserRecApp4."Employee No.") THEN BEGIN
                                        Designation4 := EmpRec."Job Title";
                                        EmpRec.CALCFIELDS(EmpRec.Picture);
                                    END;
                            END ELSE BEGIN
                                "5thapprover" := ApprovalEntries."Approver ID";
                                "5thapproverdate" := ApprovalEntries."Last Date-Time Modified";
                                IF UserRecApp5.GET("5thapprover") THEN
                                    // UserRecApp5.CALCFIELDS(UserRecApp5.Picture);
                                    IF EmpRec.GET(UserRecApp4."Employee No.") THEN BEGIN
                                        Designation5 := EmpRec."Job Title";
                                        EmpRec.CALCFIELDS(EmpRec.Picture);
                                    END;
                            END;
                        END;

                        IF i = 5 THEN BEGIN
                            "5thapprover" := ApprovalEntries."Approver ID";
                            "5thapproverdate" := ApprovalEntries."Last Date-Time Modified";
                            IF UserRecApp5.GET("4thapprover") THEN
                                //UserRecApp5.CALCFIELDS(UserRecApp5.Picture);
                            IF EmpRec.GET(UserRecApp5."Employee No.") THEN BEGIN
                                    Designation5 := EmpRec."Job Title";
                                    EmpRec.CALCFIELDS(EmpRec.Picture);
                                END;
                        END;

                    UNTIL ApprovalEntries.NEXT = 0;
                END;

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
        SerialNo = 'VOUCHER NO:';
        PayeeLabel = 'PAYEE:';
        Particulars = 'Particulars';
        LpoNo = 'LPO/Description';
        InvoiceNo = 'Invoice No.';
        AmountLabel = 'Amount';
        AmountsInwords = 'Amount Payable (in words)';
        AuthorizedBy = 'Approved by:';
        Naration = 'I Certify that, the Invoice(s) above are for incured expendirue and authorized purpose';
        Total = 'TOTAL Ksh.';
        Dr = 'AC (Dr)';
        Cr = 'AC (Cr)';
        Designation = 'Designation';
        Sign = 'Signature';
        ChequeNo = 'CHEQUE NO:';
        AccountNo = 'Account #:';
        Description = 'Description:';
        QTY = 'QTY';
        UNITCOST = 'UNIT COST';
        TotalCost = 'TOTAL COST';
        Date = 'DATE:';
        Accountant = 'Accountant i/c VBC/EXAMINATION';
        FM = 'Finance Manager';
        DDFM = 'Deputy Director Finance';
        DFM = 'DIRECTOR GENERAL/DF&A';
        Receipient = 'Received By:';
        ID = 'ID Number:';
        Footer = 'THANK YOU FOR YOUR VALUED SERVICES';
        SAccountant = '/CHIEF ACCOUNTANT';
        DVC = 'DVC FAP';
        RecommendedBy = 'Recommended by:';
        Name = 'Name';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        SalesSetup.GET;
        GLsetup.GET;
        CashManagementSetup.GET;

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
        PreparedbyName: Text[100];
        AuthorizedName: Text[100];
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
        TXT002: Label '%1 %2 - %3';
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
        PAYMENT_VOUCHERCaptionLbl: Label 'PAYMENT VOUCHER';
        BANK_NAMECaptionLbl: Label 'BANK NAME';
        VOUCHER_NOCaptionLbl: Label 'VOUCHER NO';
        CHEQUE_NOCaptionLbl: Label 'CHEQUE NO';
        PAYEECaptionLbl: Label 'PAYEE';
        PREPARED_BYCaptionLbl: Label 'PREPARED BY:';
        CHECKED_BY_CaptionLbl: Label 'CHECKED BY:';
        SIGNATURECaptionLbl: Label 'SIGNATURE';
        DATE__________________________________________________CaptionLbl: Label 'DATE';
        PAYMENT_RECEIVED_BYCaptionLbl: Label 'PAYMENT RECEIVED BY';
        SIGNATURE__________________________________________________CaptionLbl: Label 'SIGNATURE';
        DATE__________________________________________________Caption_Control1000000073Lbl: Label 'DATE';
        APPROVALCaptionLbl: Label 'APPROVAL';
        SIGNATURECaption_Control1000000001Lbl: Label 'SIGNATURE';
        DATE__________________________________________________Caption_Control1000000003Lbl: Label 'DATE';
        APPROVED_BY_CaptionLbl: Label 'APPROVED BY';
        SIGNATURE_CaptionLbl: Label 'SIGNATURE';
        DATE__________________________________________________Caption_Control1000000021Lbl: Label 'DATE';
        VATAmount: Label 'VAT Amount';
        WTaxAmount: Label 'W/Tax Amount';
        NetAmount: Label 'Net Amount';
        RetentionAmount: Label 'Retention Amount';
        PayeeAddress: Text[250];
        OrderNo: Code[50];
        PostedInvoice: Record 122;
        Text000: Label 'Preview is not allowed.';
        Text001: Label 'Last Check No. must be filled in.';
        Text002: Label 'Filters on %1 and %2 are not allowed.';
        Text003: Label 'XXXXXXXXXXXXXXXX';
        Text004: Label 'must be entered.';
        Text005: Label 'The Bank Account and the General Journal Line must have the same currency.';
        Text006: Label 'Salesperson';
        Text007: Label 'Purchaser';
        Text008: Label 'Both Bank Accounts must have the same currency.';
        Text009: Label 'Our Contact';
        Text010: Label 'XXXXXXXXXX';
        Text011: Label 'XXXX';
        Text012: Label 'XX.XXXXXXXXXX.XXXX';
        Text013: Label '%1 already exists.';
        Text014: Label 'Check for %1 %2';
        Text015: Label 'Payment';
        Text016: Label 'In the Check report, One Check per Vendor and Document No.\';
        Text017: Label 'must not be activated when Applies-to ID is specified in the journal lines.';
        Text018: Label 'XXX';
        Text019: Label 'Total';
        Text020: Label 'The total amount of check %1 is %2. The amount must be positive.';
        Text021: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID';
        Text022: Label 'NON-NEGOTIABLE';
        Text023: Label 'Test print';
        Text024: Label 'XXXX.XX';
        Text025: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX';
        Text026: Label 'ZERO';
        Text027: Label 'HUNDRED';
        Text028: Label 'AND';
        Text029: Label '%1 results in a written number that is too long.';
        Text030: Label ' is already applied to %1 %2 for customer %3.';
        Text031: Label ' is already applied to %1 %2 for vendor %3.';
        Text032: Label 'ONE';
        Text033: Label 'TWO';
        Text034: Label 'THREE';
        Text035: Label 'FOUR';
        Text036: Label 'FIVE';
        Text037: Label 'SIX';
        Text038: Label 'SEVEN';
        Text039: Label 'EIGHT';
        Text040: Label 'NINE';
        Text041: Label 'TEN';
        Text042: Label 'ELEVEN';
        Text043: Label 'TWELVE';
        Text044: Label 'THIRTEEN';
        Text045: Label 'FOURTEEN';
        Text046: Label 'FIFTEEN';
        Text047: Label 'SIXTEEN';
        Text048: Label 'SEVENTEEN';
        Text049: Label 'EIGHTEEN';
        Text050: Label 'NINETEEN';
        Text051: Label 'TWENTY';
        Text052: Label 'THIRTY';
        Text053: Label 'FORTY';
        Text054: Label 'FIFTY';
        Text055: Label 'SIXTY';
        Text056: Label 'SEVENTY';
        Text057: Label 'EIGHTY';
        Text058: Label 'NINETY';
        Text059: Label 'THOUSAND';
        Text060: Label 'MILLION';
        Text061: Label 'BILLION';
        Text062: Label 'G/L Account,Customer,Vendor,Bank Account';
        Text063: Label 'Net Amount %1';
        Text064: Label '%1 must not be %2 for %3 %4.';
        ApprovalName: Text;
        UserSetup: Record 2000000120;
        Designation1: Text[50];
        Designation2: Text[50];
        Designation3: Text[50];
        VATSetup: Record "VAT Posting Setup";
        WHTACC: Code[20];
        PAYECODE: Code[20];
        EmpRec: Record Employee;
        Text100: Label 'Telephone: %1 | Mobile Phone: %2 | Email: %3 | Website: %4';
        UserRecApp4: Record "User Setup";
        "4thapprover": Text[30];
        "4thapproverdate": DateTime;
        Designation4: Text[50];
        BankAccountNo: Code[20];
        TotalApprovals: Integer;
        UserRecApp5: Record "User Setup";
        "5thapprover": Text[30];
        Designation5: Text[50];
        "5thapproverdate": DateTime;
        VBCCertLbl: Label 'PREPARATION/VBC/EXAMINATION';
        VBCCertText: Label 'I certify that the expenditure has been entered in the vote book and that adequate funds to cover it are available against the chargeable items as shown here below';
        AIEHolderCertLbl: Label 'A.I.E HOLDER CERTIFICATE';
        AIEHolderCertText: Label 'I certify that the expenditure detailed above has been incurrred for the authorized purpose and should be charged to the item shown here below';
        AuthorizationLbl: Label 'AUTHORIZATION';
        AuthorizationText1: Label 'I certify that the rate/price charged is/are according to regulations/contract, fair and reasonable that the expenditure has been incurred on proper authority and should be charged as under. Where appropriate a certificate overleaf has been completed.';
        AuthorizationText2: Label 'I hereby authorize payment of the amount shown above without any alteration.';
        EstimatesAllocationLbl: Label 'Approved Estimates/Allocation';
        InternalAuditLbl: Label 'INTERNAL AUDIT';
        LPODescription: Label 'LPO/Description';
        InvoiceNo: Label 'Invoice No.';
        VoteLbl: Label 'Vote';
        HeadLbl: Label 'Head';
        SubHeadLbl: Label 'Sub-Head';
        ItemLbl: Label 'Item';
        AIENoLbl: Label 'A.I.E No.';
        AccNoLbl: Label 'Account No.';
        DeptVchLbl: Label 'Dept. Vch.';
        StationLbl: Label 'Station';
        CshBkLbl: Label 'CASH BOOK';
        AmtLbl: Label 'AMOUNT';
        VchLbl: Label 'Vch.';
        ShLbl: Label 'Sh.';
        CtsLbl: Label 'Cts.';
        CurrentBudget: Code[30];
        ApprovedVoteEstimate: Decimal;
        RunnigExpenditure: Decimal;
        UncommitedBalance: Decimal;
        GLAccountCopy: Record "G/L Account";
        PvLines1: Record "PV Lines1";
        WVATAMountLbl: Label 'W/VAT Amount';
        CommitmentAmount: Decimal;
        CashManagementSetup: Record "Cash Management Setup";

    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text027);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;

        AddToNoText(NoText, NoTextIndex, PrintExponent, Text028);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + ' Cents');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text029, AddText);
        END;

        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure InitTextVariable()
    begin
        OnesText[1] := Text032;
        OnesText[2] := Text033;
        OnesText[3] := Text034;
        OnesText[4] := Text035;
        OnesText[5] := Text036;
        OnesText[6] := Text037;
        OnesText[7] := Text038;
        OnesText[8] := Text039;
        OnesText[9] := Text040;
        OnesText[10] := Text041;
        OnesText[11] := Text042;
        OnesText[12] := Text043;
        OnesText[13] := Text044;
        OnesText[14] := Text045;
        OnesText[15] := Text046;
        OnesText[16] := Text047;
        OnesText[17] := Text048;
        OnesText[18] := Text049;
        OnesText[19] := Text050;

        TensText[1] := '';
        TensText[2] := Text051;
        TensText[3] := Text052;
        TensText[4] := Text053;
        TensText[5] := Text054;
        TensText[6] := Text055;
        TensText[7] := Text056;
        TensText[8] := Text057;
        TensText[9] := Text058;

        ExponentText[1] := '';
        ExponentText[2] := Text059;
        ExponentText[3] := Text060;
        ExponentText[4] := Text061;
    end;
}

