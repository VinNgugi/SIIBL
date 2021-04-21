page 51511055 "Budget Approval Card"
{
    // version FINANCE

    Caption = 'Budget Transfer Card';
    PageType = Card;
    SourceTable = "Budget Approval";

    layout
    {
        area(content)
        {
            group(General1)
            {
                field("Approval No"; "Approval No")
                {
                    Editable = false;
                }
                field("Transfer Request Date"; "Transfer Request Date")
                {
                    Editable = false;
                }
                field("Transfer Request Date and Time"; "Transfer Request Date and Time")
                {
                    Editable = false;
                }
                field("Current Budget"; "Current Budget")
                {
                    Editable = false;
                }
                field("Requesting User"; "Requesting User")
                {
                    Caption = 'Requested By';
                    Editable = false;
                }
                field("Source Department"; "Source Department")
                {
                    Caption = 'From Department';
                }
                field("From Station"; "From Station")
                {
                    Caption = 'From Activity';
                }
                field("Destination Department"; "Destination Department")
                {
                    Caption = 'To Department';
                    Enabled = false;
                }
                field("To Station"; "To Station")
                {
                    Caption = 'To Activity';
                    Enabled = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("No of Approvers"; "No of Approvers")
                {
                    Editable = false;
                }
                field("No. Series"; "No. Series")
                {
                    Editable = false;
                }
                field("Reallocation Subject"; "Reallocation Subject")
                {
                    Caption = 'Subject';
                }
                field(Memobody; Memobody)
                {
                    Caption = 'Memo Body';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        "Re-Allocation Message".CREATEOUTSTREAM(outstr);
                        outstr.WRITE(Memobody);
                    end;
                }
                field("Total Amount"; "Total Amount")
                {
                    Editable = false;
                    Style = Strong;
                    StyleExpr = TRUE;
                }
                field("Finance Officer 1"; "Finance Officer 1")
                {
                    Caption = 'Finance Officer';
                    Visible = false;
                }
            }
            /* part("Budget Lines"; "Budget Lines")
            {
                SubPageLink = "Approval No" = FIELD("Approval No");
            } */
        }
    }

    actions
    {
        area(navigation)
        {
            group(general)
            {
                action("Send Approval Request.")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        TESTFIELD("Reallocation Subject");
                        IF Memobody = '' THEN BEGIN
                            ERROR('Please Fill in the Brief Justification in the Memo Body!');
                        END;

                        //TESTFIELD("Reason For Request");
                        //TESTFIELD("Destination G/L");
                        //TESTFIELD("Amount Requested");
                        /* budgetlines.RESET;
                        budgetlines.SETFILTER("Approval No", "Approval No");
                        IF budgetlines.FINDSET THEN
                            REPEAT
                                // budgetlines.TESTFIELD("From Budget Line");
                                //budgetlines.TESTFIELD("To Budget Line");
                                //  budgetlines.TESTFIELD("From Department");
                                //budgetlines.TESTFIELD("To Department");
                                //budgetlines.TESTFIELD("Transfer Amount");
                            //budgetlines.TESTFIELD(Description);

                            UNTIL budgetlines.NEXT = 0; */
                        /* IF ApprovalsMgmt.CheckBudgetApprovalPossible(Rec) THEN
                            ApprovalsMgmt.OnSendBudgetDocForApproval(Rec); */
                    end;
                }
                action("Cancel Approval Request.")
                {
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                       // ApprovalsMgmt.OnCancelBudgetApprovalRequest(Rec);
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
                        //Link := GLSetup."DMS Imprest Link" + "Approval No";
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
                action("Budget Re-Allocation Report")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        reallocationcard.RESET;
                        reallocationcard.SETFILTER("Approval No", "Approval No");
                        IF reallocationcard.FINDSET THEN BEGIN
                            REPORT.RUN(51511008, TRUE, FALSE, reallocationcard);
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
                           /*  budgetlines.RESET;
                            budgetlines.SETFILTER("Approval No", "Approval No"); */
                            //IF budgetlines.FINDSET THEN
                                //REPEAT
                                    /* budgetlines.TESTFIELD("From Budget Line");
                                    budgetlines.TESTFIELD("From Budget Line Name");
                                    budgetlines.TESTFIELD("From Department"); */
                                //UNTIL budgetlines.NEXT = 0;

                            /* budgetlines.RESET;
                            budgetlines.SETFILTER("Approval No", "Approval No"); */
                           /*  IF budgetlines.FINDSET THEN
                                REPEAT
                                    dimvalue.RESET;
                                    dimvalue.GET('DEPARTMENT', budgetlines."From Department");
                                    //dimvalue.TESTFIELD(HOD);
                                    usersetup.RESET;
                                   // usersetup.GET(dimvalue.HOD);

                                    smtprec.RESET;
                                    glrec.RESET;
                                    glrec.GET(budgetlines."From Budget Line");
                                    mailheader := 'ERC BUDGET ALLOCATION: ' + "Approval No";
                                    //mailbody := 'Dear ' + dimvalue.HOD + ',<br><br>';
                                    mailbody := mailbody + 'Please Note that Budget Money has been Moved From Your Department in Budget Line <br>';
                                    mailbody := mailbody + '<b>' + budgetlines."From Budget Line" + '-' + glrec.Name + '</b><br><br>';
                                    mailbody := mailbody + 'Please Access the Budget Re-allocation Request By Going to:<br><br>';
                                    mailbody := mailbody + '<b><b><i>Finance Management -> Budgets -> Budget Reallocations -> Locate the Budget and Suggest Source Accounts.</i></b> <br><br>';
                                    mailbody := mailbody + 'Kind Regards.<br><br>';

                                    approvalentries.RESET;
                                    approvalentries.SETFILTER("Document No.", "Approval No");
                                    approvalentries.SETFILTER(Status, '%1', approvalentries.Status::Open);
                                    IF approvalentries.FINDSET THEN BEGIN
                                        GLSetup.RESET;
                                        GLSetup.GET;
                                        //GLSetup.TESTFIELD("Finance Email");
                                        usersetup.RESET;
                                       // usersetup.GET(dimvalue.HOD);
                                        smtprec.RESET;
                                        smtprec.GET;
                                        smtpcu.CreateMessage('ERC Budget Re-Allocation', smtprec."User ID", usersetup."E-Mail", mailheader, mailbody, TRUE);
                                        //smtpcu.AddBCC('kibetbriann@gmail.com');
                                        //=====Attachment======================
                                        GLSetup.RESET;
                                        GLSetup.GET;
                                        reallocationcard.RESET;
                                        reallocationcard.SETFILTER("Approval No", "Approval No");
                                        IF reallocationcard.FINDSET THEN BEGIN
                                            //ReallocationPDF.SETTABLEVIEW(reallocationcard);
                                            //ReallocationPDF.SAVEASPDF(GLSetup."File Storage"+"Approval No"+'.pdf');
                                        END;
                                        //REPORT.SAVEASPDF(51511300,GLSetup."File Storage"+"Approval No"+'.pdf');
                                        //=====End Of Attachment===============
                                        //smtpcu.AddAttachment(GLSetup."File Storage" + "Approval No" + '.pdf', GLSetup."File Storage" + "Approval No" + '.pdf');
                                        smtpcu.Send;
                                        MESSAGE('E-mail Sent to HOD of Department:' + dimvalue.Name);

                                        commentrec.RESET;
                                        commentrec.SETFILTER("Entry No.", '<>%1', 0);
                                        IF commentrec.FINDLAST THEN BEGIN
                                            commentrec2.INIT;
                                            commentrec2."Entry No." := commentrec."Entry No." + 1;
                                            commentrec2."Record ID to Approve" := RECORDID;
                                            commentmsg := DELCHR(mailbody, '=', '<br>');
                                            commentrec2.Comment := COPYSTR(commentmsg, 1, 250);
                                            commentrec2.Comment := 'Please Note that Budget Money has been Moved From Your Department';
                                            commentrec2."User ID" := USERID;
                                            commentrec2."Date and Time" := CURRENTDATETIME;
                                           // commentrec2."Sent to" := dimvalue.HOD;
                                            //commentrec2."Emailed?" := TRUE;
                                            commentrec2."Table ID" := 51511692;
                                            commentrec2.INSERT;
                                            //CurrPage.CLOSE;
                                        END;
                                    END;
                                UNTIL budgetlines.NEXT = 0; */

                            ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                            CurrPage.CLOSE;
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
                            // ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                            // CurrPage.CLOSE;
                            // ApprovalsMgmt.GetApprovalCommentERC(Rec,1,"Approval No");
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
                            ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                            CurrPage.CLOSE;
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
                            ApprovalsMgmt.GetApprovalComment(Rec);
                        end;
                    }
                    action("Forward to Finance")
                    {
                        Caption = 'Forward to Finance For Suggestions';
                        Image = UnitConversions;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Visible = OpenApprovalEntriesExistForCurrUser;

                        trigger OnAction()
                        begin
                            TESTFIELD("Finance Officer 1");

                            smtprec.RESET;

                            mailheader := 'KCAA BUDGET ALLOCATION: ' + "Approval No";
                            mailbody := 'Dear ' + "Finance Officer 1" + '<br><br>';//mailbody:='Dear Finance Team,<br><br>';
                            mailbody := mailbody + 'Please Suggest where the Budget Lines are to be drawn From in the Reallocation Request above.<br><br>';
                            mailbody := mailbody + 'Access the Budget Re-allocation Request By Going to:<br><br>';
                            mailbody := mailbody + '<b><b><i>Finance Management -> Budgets -> Budget Reallocations -> Locate the Budget and Suggest Source Accounts.</i></b> <br><br>';
                            mailbody := mailbody + 'Kind Regards.<br><br>';


                            GLSetup.RESET;
                            GLSetup.GET;
                            //GLSetup.TESTFIELD("Finance Email");
                            smtprec.RESET;
                            smtprec.GET;
                            //smtpcu.CreateMessage('KCAA Budget Re-Allocation', smtprec."User ID", GLSetup."Finance Email", mailheader, mailbody, TRUE);

                            smtpcu.Send;
                            MESSAGE('E-mail Sent.');

                            commentrec.RESET;
                            commentrec.SETFILTER("Entry No.", '<>%1', 0);
                            IF commentrec.FINDLAST THEN BEGIN
                                commentrec2.INIT;
                                commentrec2."Entry No." := commentrec."Entry No." + 1;
                                commentrec2."Record ID to Approve" := RECORDID;
                                commentmsg := DELCHR(mailbody, '=', '<br>');
                                commentrec2.Comment := COPYSTR(commentmsg, 1, 250);
                                commentrec2.Comment := 'Please Suggest where the Budget Lines are to be drawn From in the Reallocation Request above.';
                                commentrec2."User ID" := USERID;
                                commentrec2."Date and Time" := CURRENTDATETIME;
                                //commentrec2."Sent to" := "Finance Officer 1";//commentrec2."Sent to":='Finance Team';
                               // commentrec2."Emailed?" := TRUE;
                                commentrec2."Table ID" := 51511692;
                                commentrec2."Document No." := "Approval No";
                                commentrec2.INSERT;

                            END;
                        end;
                    }
                    action("Notify DG Of the Source")
                    {
                        Caption = 'Notify DG Of the Source';
                        Image = CopyFromBOM;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Visible = seenotifydg;

                        trigger OnAction()
                        begin
                            /*  budgetlines.RESET;
                            budgetlines.SETFILTER("Approval No", "Approval No"); */
                           // IF budgetlines.FINDSET THEN
                                //REPEAT
                                    /*  budgetlines.TESTFIELD("From Budget Line");
                                    budgetlines.TESTFIELD("From Budget Line Name");
                                    budgetlines.TESTFIELD("From Department"); 
                                UNTIL budgetlines.NEXT = 0; */
 
                            smtprec.RESET;
                            mailheader := 'KCAA BUDGET ALLOCATION: ' + "Approval No";
                            mailbody := 'Dear Sir,<br><br>';
                            mailbody := mailbody + 'I have suggested the Budget Sources stated. Please Confirm with Source Department<br><br>';
                            //mailbody:=mailbody+'Access the Budget Re-allocation Request By Going to:<br><br>';
                            //mailbody:=mailbody+'<b><b><i>Finance Management -> Budgets -> Budget Reallocations -> Locate the Budget and Suggest Source Accounts.</i></b> <br><br>';
                            mailbody := mailbody + 'Kind Regards.<br><br>';

                            approvalentries.RESET;
                            GLSetup.GET;
                               // GLSetup.TESTFIELD("Finance Email");
                                usersetup.RESET;
                                usersetup.GET(approvalentries."Approver ID");
                                smtprec.RESET;
                                smtprec.GET;
                                smtpcu.CreateMessage('KCAA Budget Re-Allocation', smtprec."User ID", usersetup."E-Mail", mailheader, mailbody, TRUE);

                                smtpcu.Send;
                                MESSAGE('E-mail Sent.');

                                commentrec.RESET;
                                commentrec.SETFILTER("Entry No.", '<>%1', 0);
                                IF commentrec.FINDLAST THEN BEGIN
                                    commentrec2.INIT;
                                    commentrec2."Entry No." := commentrec."Entry No." + 1;
                                    commentrec2."Record ID to Approve" := RECORDID;
                                    commentmsg := DELCHR(mailbody, '=', '<br>');
                                    commentrec2.Comment := COPYSTR(commentmsg, 1, 250);
                                    commentrec2.Comment := 'I have suggested the Budget Sources stated. Please Confirm with Source Department';
                                    commentrec2."User ID" := USERID;
                                    commentrec2."Date and Time" := CURRENTDATETIME;
                                   //commentrec2."Sent to" := approvalentries."Approver ID";
                                    //commentrec2."Emailed?" := TRUE;
                                    commentrec2."Table ID" := 51511692;
                                    commentrec2."Document No." := "Approval No";
                                    commentrec2.INSERT;
                                    CurrPage.CLOSE;
                                END;
                            //END;
                        end;
                    }
                    action("Notify Budget Sources")
                    {
                        Caption = 'Notify Budget Holder';
                        Image = CreateLinesFromJob;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Visible = OpenApprovalEntriesExistForCurrUser3;

                        trigger OnAction()
                        begin
                           /*  budgetlines.RESET;
                            budgetlines.SETFILTER("Approval No", "Approval No"); */
                           /* IF budgetlines.FINDSET THEN
                                REPEAT
                                     budgetlines.TESTFIELD("From Budget Line");
                                    budgetlines.TESTFIELD("From Budget Line Name");
                                    budgetlines.TESTFIELD("From Department"); 
                                UNTIL budgetlines.NEXT = 0;

                            budgetlines.RESET;
                            budgetlines.SETFILTER("Approval No", "Approval No");
                            IF budgetlines.FINDSET THEN
                                REPEAT
                                    dimvalue.RESET;
                                    dimvalue.GET('DEPARTMENT', budgetlines."From Department");
                                    //dimvalue.TESTFIELD(HOD);
                                    usersetup.RESET;
                                    //usersetup.GET(dimvalue.HOD);
                                    smtprec.RESET;
                                    glrec.RESET;
                                    glrec.GET(budgetlines."From Budget Line");
                                    mailheader := 'KCAA BUDGET ALLOCATION: ' + "Approval No";
                                   // mailbody := 'Dear ' + dimvalue.HOD + ',<br><br>';
                                    mailbody := mailbody + 'Please Note that there is a Suggestion to get Budget Money From Your Department in Budget Line <br>';
                                    mailbody := mailbody + '<b>' + budgetlines."From Budget Line" + '-' + glrec.Name + '</b><br><br>';
                                    mailbody := mailbody + 'Please Access the Budget Re-allocation Request By Going to:<br><br>';
                                    mailbody := mailbody + '<b><b><i>Finance Management -> Budgets -> Budget Reallocations -> Locate the Budget and Suggest Source Accounts.</i></b> <br><br>';
                                    mailbody := mailbody + 'Kind Regards.<br><br>';

                                    approvalentries.RESET;
                                    approvalentries.SETFILTER("Document No.", "Approval No");
                                    approvalentries.SETFILTER(Status, '%1', approvalentries.Status::Open);
                                    IF approvalentries.FINDSET THEN BEGIN
                                        GLSetup.RESET;
                                        GLSetup.GET;
                                       // GLSetup.TESTFIELD("Finance Email");
                                        usersetup.RESET;
                                        //usersetup.GET(dimvalue.HOD);
                                        smtprec.RESET;
                                        smtprec.GET;
                                        smtpcu.CreateMessage('KCAA Budget Re-Allocation', smtprec."User ID", usersetup."E-Mail", mailheader, mailbody, TRUE);

                                        smtpcu.Send;
                                        MESSAGE('E-mail Sent.');

                                        commentrec.RESET;
                                        commentrec.SETFILTER("Entry No.", '<>%1', 0);
                                        IF commentrec.FINDLAST THEN BEGIN
                                            commentrec2.INIT;
                                            commentrec2."Entry No." := commentrec."Entry No." + 1;
                                            commentrec2."Record ID to Approve" := RECORDID;
                                            commentmsg := DELCHR(mailbody, '=', '<br>');
                                            commentrec2.Comment := COPYSTR(commentmsg, 1, 250);
                                            commentrec2.Comment := 'Please Note that there is a Suggestion to get Budget Money From Your Department';
                                            commentrec2."User ID" := USERID;
                                            commentrec2."Date and Time" := CURRENTDATETIME;
                                          //  commentrec2."Sent to" := dimvalue.HOD;
                                           // commentrec2."Emailed?" := TRUE;
                                            commentrec2."Table ID" := 51511692;
                                            commentrec2."Document No." := "Approval No";
                                            commentrec2.INSERT;
                                            CurrPage.CLOSE;
                                        END;
                                    END;
                                UNTIL budgetlines.NEXT = 0;*/
                        end;
                    }
                    action("Comment..")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Comments';
                        Image = ViewComments;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Category4;

                        trigger OnAction()
                        var
                            ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        begin
                            ApprovalsMgmt.GetApprovalComment(Rec);
                        end;
                    }
                    action(ReOpen)
                    {
                        Image = ReOpen;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Visible = ReleasedVisible;

                        trigger OnAction()
                        begin

                            TESTFIELD(Status, Status::Released);
                            IF NOT CONFIRM('Are you sure you want to reopen the document') THEN
                                EXIT;

                            Status := Status::Open;
                            MODIFY(TRUE);
                            MESSAGE('Document successfully Reopened');
                            CurrPage.CLOSE();
                        end;
                    }
                    action("Post Reallocation")
                    {
                        Image = BOM;
                        Promoted = true;
                        PromotedOnly = true;

                        trigger OnAction()
                        begin
                            TESTFIELD("Source Department");
                            TESTFIELD("Destination Department");
                            TESTFIELD("Re-Allocation Posted", FALSE);
                            GLSetup.GET;
                            IF NOT CONFIRM('Are you sure you want to post this Reallocation?') THEN
                                EXIT;


                            //budgetlines.RESET;
                           // budgetlines.SETRANGE("Approval No", "Approval No");
                            /* IF budgetlines.FINDSET THEN BEGIN
                                IF budgetlines."Available Amount" < budgetlines."Transfer Amount" THEN
                                    ERROR('This transaction of Budget Line %1 will result to a negative budget', budgetlines."From Budget Line");
                                REPEAT

                                    GLBudgetEntry.SETCURRENTKEY("Entry No.");
                                    IF GLBudgetEntry.FINDLAST THEN BEGIN
                                        GLBudgetEntry.INIT;
                                        GLBudgetEntry.LOCKTABLE;
                                        GLBudgetEntry."Entry No." := GLBudgetEntry."Entry No." + 1;
                                        GLBudgetEntry.Amount := budgetlines."Transfer Amount";
                                        GLBudgetEntry."Budget Name" := budgetlines."Current Budget";
                                        // IF
                                        GLBudgetEntry.Date := budgetlines."To Budget Date";
                                        GLBudgetEntry."Global Dimension 1 Code" := budgetlines."To Department";
                                        GLBudgetEntry."Global Dimension 2 Code" := budgetlines."To Station";
                                        GLBudgetEntry."G/L Account No." := budgetlines."To Budget Line";

                                        GLBudgetEntry."User ID" := USERID;
                                        GLBudgetEntry.Description := 'Budget Reallocation from Department ' + FORMAT(budgetlines."From Department") + ' and station ' +
                                                                    FORMAT(budgetlines."From Station") + ' to department ' + FORMAT(budgetlines."To Department") + ' and station ' +
                                                                    FORMAT(budgetlines."To Station");
                                        //."Description 2" := "Reallocation Subject";
                                        IF GLBudgetEntry.Amount <> 0 THEN
                                            GLBudgetEntry.INSERT;
                                        GLBudgetEntry."Entry No." := GLBudgetEntry."Entry No." + 1;
                                        GLBudgetEntry.Amount := -budgetlines."Transfer Amount";
                                        GLBudgetEntry."Budget Name" := budgetlines."Current Budget";
                                        GLBudgetEntry.Date := budgetlines."From Budget Date";
                                        GLBudgetEntry."Global Dimension 1 Code" := budgetlines."From Department";
                                        GLBudgetEntry."Global Dimension 2 Code" := budgetlines."From Station";
                                        GLBudgetEntry."G/L Account No." := budgetlines."From Budget Line";

                                        GLBudgetEntry.Description := 'Budget Reallocation from Department ' + FORMAT(budgetlines."From Department") + ' and station ' +
                                                                    FORMAT(budgetlines."From Station") + ' to department ' + FORMAT(budgetlines."To Department") + ' and station ' +
                                                                    FORMAT(budgetlines."To Station");
                                        //GLBudgetEntry."Description 2" := "Reallocation Subject";
                                        IF GLBudgetEntry.Amount <> 0 THEN
                                            GLBudgetEntry.INSERT;
                                    END;
                                UNTIL budgetlines.NEXT = 0;

                            END; */
                            "Re-Allocation Posted" := TRUE;
                            MODIFY;
                            MESSAGE('Re-Allocation %1 Posted Successfully', "Approval No");

                        end;
                    }
                }
                group(Attachement)
                {
                    action(Attachements)
                    {
                        Image = Document;
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        //RunObject = Page 51511658;
                        //RunPageLink = No = FIELD("Approval No");
                    }
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CALCFIELDS("Re-Allocation Message");
        "Re-Allocation Message".CREATEINSTREAM(instr);
        instr.READ(Memobody);
        FromVisible();
    end;

    trigger OnAfterGetRecord()
    begin
        CALCFIELDS("Re-Allocation Message");
        "Re-Allocation Message".CREATEINSTREAM(instr);
        instr.READ(Memobody);
        FromVisible();
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        FromVisible();
    end;

    trigger OnOpenPage()
    begin
        FromVisible();
    end;

    var
        ApprovalMgt: Codeunit 1531;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        approvalentry: Record 454;
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record 454;
        rec2: Record 232;
        GLSetup: Record "General Ledger Setup";
        Link: Text;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
       // budgetlines: Record 51511329;
        smtpcu: Codeunit 400;
        smtprec: Record 409;
        mailheader: Text;
        mailbody: Text;
        commentrec: Record 455;
        commentrec2: Record 455;
        commentmsg: Text;
        seenotifydg: Boolean;
        reallocationcard: Record 51511031;
        usersetup: Record "User Setup";
        emprec: Record Employee;
        OpenApprovalEntriesExistForCurrUser3: Boolean;
        dimvalue: Record "Dimension Value";
        glrec: Record "G/L Account";
        Memobody: Text;
        instr: InStream;
        outstr: OutStream;
        seefinanceofficers: Boolean;
        Editfinanceofficers: Boolean;
        reaalocationcard: Record 51511031;
        GLBudgetEntry: Record 96;
        Text0001: Label 'Are you sure you want to transfer budget from department  %1 to Department %2';
        recepient: Text;
        FromDetails: Boolean;
        Factory: Codeunit 51511015;
        ReleasedVisible: Boolean;

    procedure FromVisible()
    begin
        FromDetails := TRUE;
        ReleasedVisible := TRUE;
        IF Status <> Status::Released THEN BEGIN
            FromDetails := FALSE;
            ReleasedVisible := FALSE;
        END;
    end;
}

