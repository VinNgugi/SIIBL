page 51511021 "Cash Management Setup"
{
    // version FINANCE

    PageType = Card;
    SourceTable = "Cash Management Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Payment Voucher Template"; "Payment Voucher Template")
                {
                    Editable = true;
                }
                field("Imprest Template"; "Imprest Template")
                {
                    Editable = true;
                }
                field("Imprest Surrender Template"; "Imprest Surrender Template")
                {
                    Editable = true;
                }
                field("Petty Cash Template"; "Petty Cash Template")
                {
                    Editable = true;
                }
                field("Receipt Template"; "Receipt Template")
                {
                    Editable = true;
                }
                field("Post VAT"; "Post VAT")
                {
                }
                field("Post PAYEE"; "Post PAYEE")
                {
                    Editable = false;
                }
                field("Rounding Type"; "Rounding Type")
                {
                    Editable = false;
                }
                field("Current Budget"; "Current Budget")
                {
                }
                field("Budget Start Date"; "Budget Start Date")
                {
                }
                field("Budget End Date"; "Budget End Date")
                {
                }
                field("Rounding Precision"; "Rounding Precision")
                {
                }
                field("Imprest Limit"; "Imprest Limit")
                {
                }
                field("Imprest Reconciliation Account"; "Imprest Reconciliation Account")
                {
                    Editable = true;
                }
                field("Imprest Due Date"; "Imprest Due Date")
                {
                }
                field("Petty Cash Limit"; "Petty Cash Limit")
                {
                    Editable = false;
                }
                field("PettyC Reconciliation Account"; "PettyC Reconciliation Account")
                {
                    Editable = false;
                    Enabled = true;
                }
                field("Petty Cash Due Date"; "Petty Cash Due Date")
                {
                    Editable = false;
                }
                field("Check Petty Cash Debit Balance"; "Check Petty Cash Debit Balance")
                {
                    Editable = false;
                }
                field("Use Budget and Commit Setup"; "Use Budget and Commit Setup")
                {
                    Editable = false;
                }
                field("Donor's Income Account"; "Donor's Income Account")
                {
                    Editable = false;
                }
                field("Donor Accounting"; "Donor Accounting")
                {
                    Editable = true;
                }
                field("Imprest Accountant"; "Imprest Accountant")
                {
                    Editable = false;
                }
                field("Finance Email"; "Finance Email")
                {
                    Editable = false;
                }
                field("Finance Admin"; "Finance Admin")
                {
                    Editable = seefinanceadmin;
                }
                field("Except from Activity"; "Except from Activity")
                {
                }
                field("Except Series From Activity"; "Except Series From Activity")
                {
                }
                field("Cash Limit"; "Cash Limit")
                {
                }
                field("Budget DMS Link"; "Budget DMS Link")
                {
                }
                field("Petty Cash No"; "Petty Cash No")
                {
                }
                field("Default Cash Account"; "Default Cash Account")
                {
                }
                field("Payments No"; "Payments No")
                {
                }
                field("Per Diem Account"; "Per Diem Account")
                {
                }
                field("Imprest Payments Bank Account"; "Imprest Payments Bank Account")
                {
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Receipt No"; "Receipt No")
                {
                }
                field("Salary Advace"; "Salary Advace")
                {
                }
                field("Memo- Salary Advance Nos"; "Memo- Salary Advance Nos")
                {
                }
                field("Underwriter Receipt Nos"; "Underwriter Receipt Nos.")
                {
                }
                field("Posted Receipt Nos."; "Posted Receipt Nos.")
                {
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Receipts)
            {
                action("Underwriter Receipts")
                {
                    Caption = 'Underwriter Receipts List';
                    Image = Receipt;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    RunObject = page "Underwriter Receipts List";
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        seefinanceadmin := FALSE;
        //cashsetup.GET;
        IF cashsetup."Finance Admin" = USERID THEN BEGIN
            seefinanceadmin := TRUE;
        END;
        usersetup.GET(USERID);
        /* IF usersetup."Transport Approver" = '003-DIR-300' THEN BEGIN
            seefinanceadmin := TRUE; */
        //END;
        //seefinanceadmin:=TRUE;
    end;

    var
        seefinanceadmin: Boolean;
        cashsetup: Record "Cash Management Setup";
        usersetup: Record "User Setup";
}

