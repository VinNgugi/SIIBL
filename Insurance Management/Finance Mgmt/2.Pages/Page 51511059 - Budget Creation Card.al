page 51511059 "Budget Creation Card"
{
    // version FINANCE

    PageType = Card;
    SourceTable = "Budget Creation";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Creation No"; "Creation No")
                {
                    Editable = false;
                }
                field("Budget Name"; "Budget Name")
                {
                    Editable = true;

                    trigger OnValidate()
                    begin
                        BudgetCreation.RESET;
                        BudgetCreation.SETRANGE("Budget Name", "Budget Name");
                        BudgetCreation.SETRANGE(Department, Department);
                        IF BudgetCreation.FINDFIRST THEN
                            ERROR('Sorry Budget Creation for your Department has Been Done for FY%1!', "Budget Name");
                    end;
                }
                field(Department; Department)
                {
                    Editable = false;
                }
                field("Created By:"; "Created By:")
                {
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
            }
            part("Budget Creation Lines"; "Budget Creation Lines")
            {
                SubPageLink = "Creation No" = FIELD("Creation No"),
                              "Budget Name" = FIELD("Budget Name"),
                              Department = FIELD(Department);
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
                    linesrec.RESET;
                    linesrec.SETFILTER("Creation No", "Creation No");
                    IF NOT linesrec.FINDSET THEN BEGIN
                        ERROR('Please Fill Budget Lines!!!');
                    END;
                    IF linesrec.FINDSET THEN
                        REPEAT
                            linesrec.TESTFIELD(Amount);
                            linesrec.TESTFIELD("G/L Account");
                        UNTIL linesrec.NEXT = 0;
                    //IF approvalsmgmt.CheckBudgetApprovalPossible(Rec) THEN
                    // approvalsmgmt.OnSendBudgetDocForApproval(Rec);
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


                    IF Status <> Status::Released THEN BEGIN
                        // approvalsmgmt.GetApprovalCommentERC(Rec,0,"Creation No");
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

                    GLSetup.GET();
                    Link := GLSetup."DMS Imprest Link" + "Creation No";
                    HYPERLINK(Link);
                end;
            }
            action("Approval Entries")
            {
                Image = Approvals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page 658;
                RunPageMode = View;
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
                action("Create Consolidated")
                {

                    trigger OnAction()
                    begin
                        CreatedConsolidatedBudget(Rec);
                    end;
                }
            }
        }
    }

    var
        OpenApprovalEntriesOnJnlBatchExist: Boolean;
        approvalsmgmt: Codeunit "Approvals Mgmt.";
        approvalentry: Record 454;
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record 454;
        rec2: Record 232;
        GLSetup: Record "Cash Management Setup";
        Link: Text;
        glentry: Record 17;
        batchrec: Record 232;
        GenSetup: Record "General Ledger Setup";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        linesrec: Record "Budget Creation Lines";
        BudgetCreation: Record "Budget Creation";
}

