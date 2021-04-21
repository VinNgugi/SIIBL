page 51511026 "Posted Petty Cash"
{
    // version FINANCE

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(PettyCash),
                            Status = FILTER(Released),
                            Posted = FILTER(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Petty Cash Serials"; "Petty Cash Serials")
                {
                    Caption = 'Petty Cash No.';
                }
                field("Imprest/Advance No"; "Imprest/Advance No")
                {
                    Caption = 'Imprest Source';
                    Editable = false;
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Trip No"; "Trip No")
                {
                    Visible = false;
                }
                field("Employee No"; "Employee No")
                {
                    Editable = false;
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Trip Start Date"; "Trip Start Date")
                {
                    Visible = false;
                }
                field("Trip Expected End Date"; "Trip Expected End Date")
                {
                    Visible = false;
                }
                field("No. of Days"; "No. of Days")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Caption = 'Directorate';
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Caption = 'Department';
                    Editable = false;
                }
                field("Purpose of Imprest"; "Purpose of Imprest")
                {
                    Caption = 'Purpose of Petty Cash';
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                    Caption = 'Amount';
                    Editable = false;
                }
                field(Country; Country)
                {
                    Visible = false;
                }
                field("Activity Date"; "Activity Date")
                {
                }
                field("Customer A/C"; "Customer A/C")
                {
                    Editable = false;
                }
                field(City; City)
                {
                    Visible = false;
                }
                field("Job Group"; "Job Group")
                {
                    Visible = false;
                }
                field("External Application"; "External Application")
                {
                    Visible = false;
                }
                field("No of Approvals"; "No of Approvals")
                {
                    Caption = 'Approval Status';
                    Editable = false;
                }
                field("CBK Website Address"; "CBK Website Address")
                {
                    Visible = false;
                }
                field("Bank Account"; "Bank Account")
                {
                }
                field(Posted; Posted)
                {
                }
            }
            part("Petty Cash Lines"; "Petty Cash Lines")
            {
                SubPageLink = "Document No"=FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    RESET;
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51511037, TRUE, TRUE, Rec);
                    RESET;
                end;
            }
            group(Functions)
            {
                Caption = 'Functions';
                action("Send Approval Request")
                {
                    Caption = 'Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF "Purpose of Imprest" = '' THEN
                            ERROR('You must enter Purpose of Petty Cash');

                        //IF ApprovalMgt.SendImprestApprovalRequest(Rec) THEN;
                        //CurrPage.CLOSE;
                    end;
                }
                action("Cancel Approval Request")
                {
                    Caption = 'Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //  IF ApprovalMgt.CancelImprestApprovalRequest(Rec,TRUE,TRUE) THEN;
                    end;
                }
                action(Post)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        // CommitMngt.PostPettyCashPayment(Rec);
                        //CurrPage.CLOSE;
                    end;
                }
                action(Submit)
                {
                    Caption = 'Submit';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CreatePV(Rec);
                    end;
                }
                action("Payroll Recovery")
                {
                    Caption = 'Payroll Recovery';
                    Visible = false;

                    trigger OnAction()
                    begin
                        /* loanapplication.INIT;
                        loanapplication."Loan No" := '';
                        loanapplication."Loan Product Type" := "Transaction Type";
                        loanapplication."Application Date" := TODAY;
                        loanapplication."Amount Requested" := Balance;
                        loanapplication."Approved Amount" := Balance;
                        loanapplication."Employee No" := "Employee No";
                        loanapplication."Loan Status" := loanapplication."Loan Status"::Approved;
                        //loanapplication."Issued Date":=
                        loanapplication.INSERT(TRUE); */
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        /*IF Status<>Status::Open THEN
        ERROR('You cannot make changes at this stage');
        */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::PettyCash;
    end;

    var
        ApprovalMgt: Codeunit 40;
        PV: Record Payments1;
        PVlines: Record 51511001;
        //loanapplication: Record 51511113;
        D: Date;
        UserSetup: Record "User Setup";
        ApprovalSetup: Record "G/L Account";
        UserSetupRec: Record "User Setup";
        RequestHeader: Record "Request Header";
        GLSetup: Record "General Ledger Setup";
        Link: Text[250];
        [InDataSet]
        GroupImprest: Boolean;
        PartialImprest: Record 51511023;

    procedure GetPartialImprestNo(var ImpNo: Code[20]) LineNo: Integer
    var
        Partial: Record 51511023;
    begin
        Partial.RESET;
        Partial.SETCURRENTKEY("Imprest No", "Line No");
        Partial.SETRANGE("Imprest No", ImpNo);
        IF Partial.FINDLAST THEN
            LineNo := Partial."Line No" + 1
        ELSE
            LineNo := 1;
    end;

    procedure GetAmountIssued(var ImpNo: Code[20]) AmountIssued: Decimal
    var
        Partial: Record 51511023;
    begin
        Partial.RESET;
        Partial.SETCURRENTKEY("Imprest No", "Line No");
        Partial.SETRANGE("Imprest No", ImpNo);
        Partial.SETRANGE(Posted, TRUE);
        IF Partial.FIND('-') THEN BEGIN
            REPEAT
                AmountIssued := AmountIssued + Partial."Amount Already Issued";
            UNTIL Partial.NEXT = 0;
        END ELSE
            AmountIssued := 0;
    end;
}

