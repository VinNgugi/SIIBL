page 51511066 "Memo Card"
{
    // version FINANCE

    PageType = Card;
    SourceTable = "Memo";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Memo No"; "Memo No")
                {
                    Caption = 'REF';
                    Editable = false;
                }
                field("Budget Name"; "Budget Name")
                {
                    Editable = false;
                }
                field(Department; Department)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Created By:"; "Created By:")
                {
                    Caption = 'From';
                    Editable = false;
                }
                field("Date Created"; "Date Created")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("No. of Approvers"; "No. of Approvers")
                {
                    Editable = false;
                }
                field("Customer No:"; "Customer No:")
                {
                    Visible = false;
                }
                field("Memo Amount"; "Memo Amount")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Memo Header"; "Memo Header")
                {
                    Caption = 'Subject';
                    Editable = editit;
                }
                field("Memo Body"; "Memo Body")
                {
                    Caption = 'Memo Description';
                    Editable = editit;
                    MultiLine = true;
                }
            }
            part("Memo Lines"; "Memo Lines")
            {
                /* SubPageLink = " Memo No" = FIELD("Memo No"),
                              "Budget Name" = FIELD("Budget Name"); */
            }
            part("Memo Members"; "Memo Members")
            {
                SubPageLink = "Memo No" = FIELD("Memo No");
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Approval Request.")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenApprovalEntriesExistForCurrUser2;

                trigger OnAction()
                begin
                    TESTFIELD("Memo Header");
                    TESTFIELD("Memo Body");
                    linesrec.RESET;
                    linesrec.SETFILTER("Memo No", "Memo No");
                    IF NOT linesrec.FINDSET THEN BEGIN
                        ERROR('Please Fill Memo Lines!!!');
                    END;
                    IF linesrec.FINDSET THEN
                        REPEAT
                            linesrec.TESTFIELD(Amount);
                            linesrec.TESTFIELD("G/L Account");
                            linesrec.TESTFIELD(Quantity);
                            linesrec.TESTFIELD("Unit Price");
                            // linesrec.TESTFIELD("Unit of Measure");
                            linesrec.TESTFIELD(Description);
                            linesrec.TESTFIELD(linesrec.Member);
                        UNTIL linesrec.NEXT = 0;
                end;
            }
            action("Cancel Approval Request.")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = OpenApprovalEntriesExistForCurrUser2;

                trigger OnAction()
                begin
                    IF Status = Status::Released THEN BEGIN
                        ERROR('This Memo is already Released!');
                    END;

                end;
            }
            action("DMS Link")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    /*
                    GLSetup.GET();
                    Link:=GLSetup."DMS Imprest Link"+"Creation No";
                    HYPERLINK(Link);
                    */

                end;
            }
            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    memorec.RESET;
                    memorec.SETFILTER("Memo No", "Memo No");
                    IF memorec.FINDSET THEN BEGIN
                        REPORT.RUN(51511009, TRUE, FALSE, memorec);
                    END;
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        //=================================Brian K
        approvalentry.RESET;
        approvalentry.SETFILTER(approvalentry.Status, '%1', approvalentry.Status::Open);
        // approvalentry.SETFILTER(approvalentry."Document Type",'%1',approvalentry."Document Type"::"ERC Memo");
        approvalentry.SETFILTER(approvalentry."Approver ID", '%1', USERID);
        approvalentry.SETFILTER(approvalentry."Document No.", "Memo No");
        IF approvalentry.FINDSET THEN BEGIN
            OpenApprovalEntriesExistForCurrUser := TRUE;
            //MESSAGE('Approver...');
        END;
        IF NOT approvalentry.FINDSET THEN BEGIN
            OpenApprovalEntriesExistForCurrUser2 := TRUE;
            // MESSAGE('Not an Approver...');
        END;
        IF OpenApprovalEntriesExistForCurrUser = TRUE THEN BEGIN
            OpenApprovalEntriesExistForCurrUser2 := FALSE;
        END;
        //=========================================
        IF Status = Status::Open THEN BEGIN
            editit := TRUE;
        END;
        IF Status <> Status::Open THEN BEGIN
            editit := FALSE
        END;
    end;

    var
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        approvalsmgmt: Codeunit "Approvals Mgmt.";
        approvalentry: Record 454;
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record 454;
        rec2: Record 232;
        GLSetup: Record "General Ledger Setup";
        Link: Text;
        glentry: Record 17;
        batchrec: Record 232;
        GenSetup: Record "General Ledger Setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        linesrec: Record "Memo Lines";
        editit: Boolean;
        memorec: Record Memo;
}

