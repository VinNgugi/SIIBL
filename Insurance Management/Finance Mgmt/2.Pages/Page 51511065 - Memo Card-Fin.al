page 51511065 "Memo Card-Fin"
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
                field("Amount in Commitment"; "Amount in Commitment")
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
                SubPageLink = "Memo No" = FIELD("Memo No"),
                              "Budget Name" = FIELD("Budget Name");
            }
            part("Memo Members"; "Memo Members"
)
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
            action("Release Commited Amount")
            {
                Image = RefreshVoucher;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    conf := CONFIRM('Please Note that this function makes it impossible for Members in the memo who have not created Imprest from Creating Imprest for it releases the Amounts Held.\Are you sure you want to Proceed?');
                    IF FORMAT(conf) = 'Yes' THEN BEGIN
                        commitrec1.RESET;
                        commitrec1.SETRANGE(Memo, TRUE);
                        commitrec1.SETRANGE("Document No.", "Memo No");
                        IF commitrec1.FINDSET THEN
                            REPEAT
                                commitrec1.CALCFIELDS(Committed);
                                IF commitrec1.Committed <> 0 THEN BEGIN
                                    commitrec2.RESET;
                                    commitrec2.SETFILTER("Entry No", '<>%1', 0);
                                    IF commitrec2.FINDLAST THEN BEGIN
                                        commitrec3.RESET;
                                        commitrec3.INIT;
                                        commitrec3.COPY(commitrec1);
                                        commitrec3."Entry No" := commitrec2."Entry No" + 1;
                                        commitrec3.Amount := 0 - commitrec3.Amount;
                                        commitrec3."Finance Release Entry" := TRUE;
                                        commitrec3.INSERT;

                                        commitrec1."Finance Released" := TRUE;
                                        commitrec1.MODIFY;
                                    END;
                                END;
                            UNTIL commitrec1.NEXT = 0;
                        MESSAGE('Successfully Released');
                    END;
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
        }
    }

    trigger OnOpenPage()
    begin

        //=================================Brian K
        approvalentry.RESET;
        approvalentry.SETFILTER(approvalentry.Status, '%1', approvalentry.Status::Open);
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
        conf: Boolean;
        commitrec1: Record "Commitment Entries";
        commitrec2: Record "Commitment Entries";
        commitrec3: Record "Commitment Entries";
        memorec: Record Memo;
}

