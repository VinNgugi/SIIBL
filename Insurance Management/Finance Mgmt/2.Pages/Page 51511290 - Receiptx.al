page 51511290 Receiptx
{
    // version CSHBK

    PageType = Card;
    SourceTable = 51513110;
    //SourceTableView = WHERE(Posted = CONST(false));

    layout
    {
        area(content)
        {
            group(Receipt)
            {
                Caption = 'Receipt';
                field("No."; "No.")
                {
                }
                field("Receipt Type"; "Receipt Type")
                {
                }
                field("Default Posting Group"; "Default Posting Group")
                {
                }
                field("Receipt Date"; "Receipt Date")
                {
                }
                field("Pay Mode"; "Pay Mode")
                {
                }
                field(Amount; Amount)
                {
                    Visible = false;
                }
                field("Cheque No"; "Cheque No")
                {
                }
                field("REF NO."; "REF NO.")
                {
                }
                field("KBA Bank Code"; "KBA Bank Code")
                {
                    Caption = 'Drawer Bank Code';
                }
                field("Drawer Bank"; "Drawer Bank")
                {
                }
                field("Drawer Name"; "Drawer Name")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Received From"; "Received From")
                {
                }
                field("Reference Period"; "Reference Period")
                {
                }
                field("On Behalf Of"; "On Behalf Of")
                {
                    Caption = 'On Behalf';
                }
                field("Payments for"; "Payments for")
                {
                }
                field("Bank Code"; "Bank Code")
                {
                }
                field("Agent Code"; "Agent Code")
                {
                }
                field("Cheque Date"; "Cheque Date")
                {
                    Editable = true;
                }
                field("Currency Code"; "Currency Code")
                {

                    trigger OnAssistEdit()
                    begin
                        CLEAR(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WORKDATE);
                        IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
                            VALIDATE("Currency Factor", ChangeExchangeRate.GetParameter);
                            CurrPage.UPDATE;
                        END;
                        CLEAR(ChangeExchangeRate);
                    end;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Receipt Amount type"; "Receipt Amount type")
                {
                }
                field(Cashier; Cashier)
                {
                    Editable = false;
                }
                field(Posted; Posted)
                {
                }
                field("Posted Date"; "Posted Date")
                {
                }
                field("Posted Time"; "Posted Time")
                {
                }
                field("Posted By"; "Posted By")
                {
                }
                field("Total Amount"; "Total Amount")
                {
                }
                field("Amount(LCY)"; "Amount(LCY)")
                {
                    Visible = false;
                }
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
            }
            part(receiptlineS; 51511291)
            {
                SubPageLink = "Receipt No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                action("Generate Expected Repayments")
                {

                    trigger OnAction()
                    begin
                        // Loanmngt.GenerateExpectedRepayments(Rec);
                    end;
                }
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        PostRcpt.PostReceipt(Rec);

                        CertPrintCode.CertPrinting("No.");
                        /*
                       IF GET(PolicyNo) THEN

                       //InsuranceHeader.RESET;
                       //InsuranceHeader.SETCURRENTKEY("Document Type","No.");
                       InsuranceHeader.SETRANGE(InsuranceHeader."Policy No",PolicyNo);
                       InsuranceLine.SETRANGE(InsuranceLine."Policy No",InsuranceHeader."Policy No");
                       MESSAGE('this is %1',PolicyNo);
                       MESSAGE('this is %1',InsuranceHeader."Policy No");

                        IF InsuranceLine.FIND('-') THEN BEGIN REPEAT

                           CertPrint.INIT;
                           //CertPrint."Cert Printing No.":=NoSeriesMgt.GetNextNo(InsuranceSetup."Cert Printing No",TODAY,TRUE);


                           CertPrint."Policy No.":=InsuranceLine."Policy No";
                           CertPrint."Debit Note No.":=InsuranceHeader."No.";
                           CertPrint."Receipt No.":="No.";
                           CertPrint."Registration No.":= InsuranceLine."Registration No.";
                           CertPrint."Cover Type":=InsuranceLine."Cover Type";
                           CertPrint."Insured Id":=InsuranceHeader."Insured No.";
                           CertPrint."Cover Start Date":=InsuranceHeader."From Date";
                           CertPrint."Cover End Date":=InsuranceHeader."To Date";
                           // CertPrint."Cover Start Time":=Format(InsuranceHeader."From Time"); convert from text to time
                           // CertPrint."Cover End Time":=InsuranceHeader."To Time";
                           CertPrint."Insurer ID":=InsuranceHeader."Insurer ID";
                           CertPrint."Passenger Seating Capacity":=InsuranceLine."Seating Capacity";
                           CertPrint.Status:=CertPrint.Status::Open;
                           CertPrint.INSERT(TRUE);


                           InsuranceLine.Status:= InsuranceLine.Status::Sent_toPrint;
                           InsuranceLine.MODIFY(TRUE);


                       UNTIL InsuranceLine.NEXT=0;

                       END;
                         */

                    end;
                }

                action("Post Dated Cheques")
                {
                    /*RunObject = Page 51513054;
                    RunPageLink = "Document Type" = CONST("Post dated Cheque"),
                                  "Document No." = FIELD("No.");
                    */

                    trigger OnAction()
                    begin
                        InsMngt.DrawPostedDatedChequesRec(Rec);
                    end;
                }
                action("Import List ")
                {
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        ReceiptsImport.GetReceipt(Rec);
                        ReceiptsImport.RUN;
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Posted := FALSE;
    end;

    var
        PostRcpt: Codeunit 51513113;
        BankLedgerEntry: Record 271;
        InsuranceLine: Record 51513017;
        InsuranceHeader: Record 51513016;
        CertPrint: Record 51513071;
        InsuranceSetup: Record 51513014;
        NoSeriesMgt: Codeunit 396;
        RecLine: Record 51513111;
        CertPrintCode: Codeunit 51513120;
        ChangeExchangeRate: Page 511;
        InsMngt: Codeunit 51513000;
        ReceiptsImport: XMLport 51513112;
}

