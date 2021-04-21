page 51511008 "Finance Claim Header"
{
    // version FINANCE

    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST("Claim-Accounting"));

    layout
    {
        area(content)
        {
            group(General1)
            {
                Caption = 'General';
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Request Date"; "Request Date")
                {
                    Caption = 'Claim/Accounting Date';
                }
                field("Employee No"; "Employee No")
                {
                    Editable = true;
                }
                field("Employee Name"; "Employee Name")
                {
                }
                field("Imprest/Advance No"; "Imprest/Advance No")
                {
                    TableRelation = "Request Header" WHERE(Type = FILTER(Imprest | PettyCash),
                                                          //  "Customer A/C" = FIELD("Customer A / C"),
                                                           // "Transaction Type" = FILTER(<> ADVANCE),
                                                            Status = FILTER(Released));
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                    Editable = false;
                    Visible = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        "Applies-to Doc. No." := '';
                        //"Apply to ID":='';

                        Amt := 0;
                        //"VAT Amount":=0;
                        //"WTX Amount":=0;


                        CustLedger.RESET;
                        CustLedger.SETCURRENTKEY(CustLedger."Customer No.", Open, "Document No.");
                        CustLedger.SETRANGE(CustLedger."Customer No.", "Customer A/C");
                        CustLedger.SETRANGE(Open, TRUE);
                        //CustLedger.SETRANGE(CustLedger."Transaction Type",CustLedger."Transaction Type"::"Down Payment");
                        CustLedger.CALCFIELDS(CustLedger.Amount);
                        IF PAGE.RUNMODAL(25, CustLedger) = ACTION::LookupOK THEN BEGIN

                            IF CustLedger."Applies-to ID" <> '' THEN BEGIN
                                CustLedger1.RESET;
                                CustLedger1.SETCURRENTKEY(CustLedger1."Customer No.", Open, "Applies-to ID");
                                CustLedger1.SETRANGE(CustLedger1."Customer No.", "Customer A/C");
                                CustLedger1.SETRANGE(Open, TRUE);
                                //CustLedger1.SETRANGE("Transaction Type",CustLedger1."Transaction Type"::"Down Payment");
                                CustLedger1.SETRANGE("Applies-to ID", CustLedger."Applies-to ID");
                                IF CustLedger1.FIND('-') THEN BEGIN
                                    REPEAT
                                        CustLedger1.CALCFIELDS(CustLedger1.Amount);
                                        Amt := Amt + ABS(CustLedger1.Amount);
                                    UNTIL CustLedger1.NEXT = 0;
                                END;

                                IF Amt <> Amt THEN
                                    //ERROR('Amount is not equal to the amount applied on the application form');
                                    IF "Total Amount Requested" = 0 THEN
                                        "Total Amount Requested" := Amt;


                                "Applies-to Doc. No." := CustLedger."Document No.";
                                //"Apply to ID":=CustLedger."Applies-to ID";
                            END ELSE BEGIN
                                IF "Total Amount Requested" <> ABS(CustLedger.Amount) THEN
                                    CustLedger.CALCFIELDS(CustLedger."Remaining Amount");
                                IF "Total Amount Requested" = 0 THEN
                                    "Total Amount Requested" := ABS(CustLedger."Remaining Amount");
                                //VALIDATE(Amount);
                                //ERROR('Amount is not equal to the amount applied on the application form');

                                "Applies-to Doc. No." := CustLedger."Document No.";
                                RequestLines.INIT;
                                RequestLines."Document No" := "No.";
                                RequestLines."Line No." := 1000;
                                RequestLines.Amount := CustLedger."Original Amount";
                                IF NOT RequestLines.GET("No.", RequestLines."Line No.") THEN
                                    RequestLines.INSERT(TRUE)
                                ELSE
                                    RequestLines.MODIFY;

                                // "Apply to ID":=CustLedger."Applies-to ID";

                            END;
                        END;

                        //IF "Apply to ID" <> '' THEN
                        //"Apply to":='';

                        //VALIDATE("Total Amount Requested");
                        //END;
                    end;
                }
                field("Trip No"; "Trip No")
                {
                    Visible = false;
                }
                field("Trip Start Date"; "Trip Start Date")
                {
                    Visible = false;
                }
                field("Trip End Date"; "Trip Expected End Date")
                {
                    Caption = 'Trip End Date';
                    Visible = false;
                }
                field("No. of Days"; "No. of Days")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Caption = 'Directorate';
                    Editable = true;
                    Visible = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Caption = 'Department';
                    Editable = false;
                    Visible = false;
                }
                field("Purpose of Imprest"; "Purpose of Imprest")
                {
                    Visible = false;
                }
                field("Deadline for Return"; "Deadline for Return")
                {
                    Visible = false;
                }
                field(Status; Status)
                {
                }
                field(Balance; Balance)
                {
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                    Editable = false;
                }
                field("Actual Amount"; "Actual Amount")
                {
                    Editable = false;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    Editable = false;
                }
                field("No of Approvals"; "No of Approvals")
                {
                    Editable = false;
                }
                field(External; External)
                {
                }
                field("Customer A/C"; "Customer A/C")
                {
                    Editable = true;
                }
                field(Attachement; Attachement)
                {
                    Caption = 'Attachment Done ?';
                    Editable = false;
                    Visible = false;
                }
                field("CBK Website Address"; "CBK Website Address")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Type; Type)
                {
                    Visible = false;
                }
                field(Training; Training)
                {
                    Editable = false;
                }
                group(general)
                {
                    Enabled = false;
                    Visible = "Training" = TRUE;
                    field("Local Travel"; "Local Travel")
                    {
                    }
                    field("International Travel"; "International Travel")
                    {
                    }
                    group("Local Travel Details")
                    {
                        Caption = 'Local Travel Details';
                        Visible = "Local Travel" = TRUE;
                        field("Destination City"; "Destination City")
                        {
                        }
                    }
                    group("International Training Details")
                    {
                        Caption = 'International Training Details';
                        Visible = "International Travel" = TRUE;
                        field("Destination Country"; "Destination Country")
                        {
                        }
                    }
                }
                group("Training Evaluation1")
                {
                    Caption = 'Training Evaluation';
                    Visible = "Training" = TRUE;
                    field("Training Evaluation"; "Training Evaluation")
                    {
                    }
                }
            }
            part("Claim Accounting Lines"; "Claim Accounting Lines")
            {
                SubPageLink = "Document No" = FIELD("No.");
                Visible = "International Travel" = FALSE;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Attachment)
            {
                Caption = 'Attachment';
                action(Open)
                {
                    Caption = 'Open';
                    ShortCutKey = 'Return';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record 5103;
                    begin
                        IF InteractTemplLanguage.GET("No.", "Language Code (Default)") THEN
                            InteractTemplLanguage.OpenAttachment;
                    end;
                }
                action(Create)
                {
                    Caption = 'Create';
                    Ellipsis = true;
                    Visible = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record 5103;
                    begin
                        IF NOT InteractTemplLanguage.GET("No.", "Language Code (Default)") THEN BEGIN
                            InteractTemplLanguage.INIT;
                            InteractTemplLanguage."Interaction Template Code" := "No.";
                            InteractTemplLanguage."Language Code" := "Language Code (Default)";
                            //InteractTemplLanguage.Description := Description;
                        END;
                        InteractTemplLanguage.CreateAttachment;
                        CurrPage.UPDATE;
                        Attachement := Attachement::Yes;
                        MODIFY;
                    end;
                }
                action("Copy &from")
                {
                    Caption = 'Copy &from';
                    Ellipsis = true;
                    Visible = false;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record 5103;
                    begin
                        IF NOT InteractTemplLanguage.GET("No.", "Language Code (Default)") THEN BEGIN
                            InteractTemplLanguage.INIT;
                            InteractTemplLanguage."Interaction Template Code" := "No.";
                            InteractTemplLanguage."Language Code" := "Language Code (Default)";
                            //InteractTemplLanguage.Description := Description;
                            InteractTemplLanguage.INSERT;
                            COMMIT;
                        END;
                        InteractTemplLanguage.CopyFromAttachment;
                        CurrPage.UPDATE;
                        Attachement := Attachement::Yes;
                        MODIFY;
                    end;
                }
                action(Import)
                {
                    Caption = 'Import';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record 5103;
                    begin
                        IF NOT InteractTemplLanguage.GET("No.", "Language Code (Default)") THEN BEGIN
                            InteractTemplLanguage.INIT;
                            InteractTemplLanguage."Interaction Template Code" := "No.";
                            InteractTemplLanguage."Language Code" := "Language Code (Default)";
                            //InteractTemplLanguage.Description := Description;
                            InteractTemplLanguage.INSERT;
                        END;
                        InteractTemplLanguage.ImportAttachment;
                        CurrPage.UPDATE;
                        Attachement := Attachement::Yes;
                        MODIFY;
                    end;
                }
                action("E&xport")
                {
                    Caption = 'E&xport';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record 5103;
                    begin
                        IF InteractTemplLanguage.GET("No.", "Language Code (Default)") THEN
                            InteractTemplLanguage.ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    Caption = 'Remove';
                    Ellipsis = true;

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record 5103;
                    begin
                        IF InteractTemplLanguage.GET("No.", "Language Code (Default)") THEN BEGIN
                            InteractTemplLanguage.RemoveAttachment(TRUE);
                            Attachement := Attachement::No;
                            MODIFY;
                        END;
                    end;
                }
            }
        }
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
                    REPORT.RUN(51511041, TRUE, TRUE, Rec);
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
                        RequestLines.RESET;
                        RequestLines.SETRANGE(RequestLines."Document No", "No.");
                        RequestLines.SETFILTER(RequestLines.Amount, '<>%1', 0);
                        IF RequestLines.FIND('-') THEN BEGIN
                            REPEAT
                                IF RequestLines."Account No" = '' THEN
                                    ERROR('You must select an account for %1', RequestLines.Description);

                                IF RequestLines."Actual Spent" = 0 THEN
                                    ERROR('You must fill the actual amount spent');

                                IF RequestLines."Actual Spent" > RequestLines.Amount THEN BEGIN
                                    ERROR('Amount Spent is More than Amount Given for Line %1', RequestLines."Line No.");
                                END;
                                IF "Imprest/Advance No" = '' THEN BEGIN
                                    ERROR('You must Fill Imprest/Advance No Field!!!');
                                END;

                            UNTIL RequestLines.NEXT = 0;
                        END;

                        //IF ApprovalMgt.SendImprestApprovalRequest(Rec) THEN
                        CurrPage.CLOSE;
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
                        // IF ApprovalMgt.CancelImprestApprovalRequest(Rec,TRUE,TRUE) THEN;
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
                action(Post1)
                {
                    Caption = 'Post';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = true;

                    trigger OnAction()
                    begin

                        //IF Status<>Status::Released THEN
                        //ERROR('The Document cannot be posted before it is fully approved');

                        CreatePV(Rec);

                        /*
                        CALCFIELDS("Total Amount Requested");
                        
                        GenjnLine.INIT;
                        GenjnLine."Journal Template Name":='GENERAL';
                        GenjnLine."Journal Batch Name":='CLAIMS';
                        GenjnLine."Line No.":=GenjnLine."Line No."+10000;
                        GenjnLine."Account Type":=GenjnLine."Account Type"::Customer;
                        GenjnLine."Account No.":="Customer A/C";
                        GenjnLine.Description:='Imprest/Advance Accounting';
                        GenjnLine.Amount:="Total Amount Requested";
                        GenjnLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                        GenjnLine."Document No.":="No.";
                        GenjnLine."Posting Date":="Request Date";
                        IF GenjnLine.Amount<>0 THEN
                        GenjnLine.INSERT;
                        
                        ClaimLines.RESET;
                        ClaimLines.SETRANGE(ClaimLines."Document No","No.");
                        IF ClaimLines.FIND('-') THEN
                        REPEAT
                        
                        GenjnLine.INIT;
                        GenjnLine."Journal Template Name":='GENERAL';
                        GenjnLine."Journal Batch Name":='CLAIMS';
                        GenjnLine."Line No.":=GenjnLine."Line No."+10000;
                        GenjnLine."Account Type":=ClaimLines."Account Type";
                        GenjnLine."Account No.":=ClaimLines."Account No";
                        GenjnLine.Description:=ClaimLines.Description;
                        GenjnLine.Amount:=ClaimLines."Requested Amount";
                        GenjnLine."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                        GenjnLine."Document No.":="No.";
                        GenjnLine."Posting Date":="Request Date";
                        GenjnLine."External Document No.":=ClaimLines."Reference No";
                        IF GenjnLine.Amount<>0 THEN
                        GenjnLine.INSERT;
                        
                        
                        
                        
                        UNTIL ClaimLines.NEXT=0;
                        
                        GenjnLine.RESET;
                        GenjnLine.SETRANGE(GenjnLine."Journal Template Name",'GENERAL');
                        GenjnLine.SETRANGE(GenjnLine."Journal Batch Name",'CLAIMS');
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenjnLine);
                        
                        */
                        /*
                       //UnCommit Entries

                       RequestLines.SETRANGE(RequestLines."Document No","Imprest/Advance No");
                       IF RequestLines.FINDFIRST THEN BEGIN
                         IF CommittmentEntries.FINDLAST THEN
                         LastEntry:=CommittmentEntries."Entry No";
                        REPEAT
                          LastEntry:=LastEntry+1;
                          CommittmentEntries.INIT;
                          CommittmentEntries."Entry No":=LastEntry;
                          CommittmentEntries."Commitment Date":="Request Date";
                          CommittmentEntries."Document No.":="Imprest/Advance No";
                          CommittmentEntries.Amount:=-RequestLines."Requested Amount";
                          CommittmentEntries."Global Dimension 1 Code":="Global Dimension 1 Code";
                          CommittmentEntries."Commitment Type":=CommittmentEntries."Commitment Type"::IMPREST;
                          CommittmentEntries."Budget Line":=RequestLines."Account No";
                          CommittmentEntries."Global Dimension 2 Code":="Global Dimension 2 Code";
                          CommittmentEntries."User ID":=USERID;
                          CommittmentEntries."Time Stamp":=TIME;
                          CommittmentEntries.Description:=RequestLines.Description;
                          CommittmentEntries.INSERT;
                        UNTIL RequestLines.NEXT=0;
                       END;

                       //End of Commit;

                       //UnCommit Entries

                       //Find the last approver entries

                       ApprovalEntries.RESET;
                       ApprovalEntries.SETRANGE(ApprovalEntries."Table ID",51511126);
                       ApprovalEntries.SETRANGE(ApprovalEntries."Document No.","No.");
                       ApprovalEntries.SETRANGE(ApprovalEntries.Status,ApprovalEntries.Status::Approved);
                       IF ApprovalEntries.FIND('-') THEN
                       BEGIN
                       i:=0;
                       REPEAT
                       i:=i+1;
                       IF i=3 THEN
                       BEGIN
                       EVALUATE(lastApprovalDate,
                       COPYSTR(FORMAT(ApprovalEntries."Last Date-Time Modified"),1,8));

                       //UnCommit Entries
                       RequestLines.SETRANGE(RequestLines."Document No","No.");
                       IF RequestLines.FINDFIRST THEN BEGIN
                         IF CommittmentEntries.FINDLAST THEN
                         LastEntry:=CommittmentEntries."Commitment No";
                        REPEAT
                          LastEntry:=LastEntry+1;
                          CommittmentEntries.INIT;
                          CommittmentEntries."Commitment No":=LastEntry;
                          CommittmentEntries."Commitment Date":=lastApprovalDate;
                          CommittmentEntries."Commitment Type":="No.";
                          CommittmentEntries.Account:=-RequestLines."Requested Amount";
                          CommittmentEntries.User:="Global Dimension 1 Code";
                          CommittmentEntries."Document No":=CommittmentEntries."Document No"::"3";
                          CommittmentEntries."Committed Amount":=RequestLines."Account No";
                          CommittmentEntries.InvoiceNo:="Global Dimension 2 Code";
                          CommittmentEntries.No:=USERID;
                          CommittmentEntries."Entry No":=TIME;
                          CommittmentEntries."Global Dimension 1":=RequestLines.Description;
                          CommittmentEntries.INSERT;
                        UNTIL RequestLines.NEXT=0;
                       END;
                       END;

                       UNTIL ApprovalEntries.NEXT=0;
                       END;
                        */
                        /////===========================================================

                        IF CommittmentEntries.FIND('-') THEN BEGIN
                            //Posted:=TRUE;
                            //"Date Posted":=TODAY;
                            //"Time Posted":=TIME;
                            //"Posted By":=USERID;
                            //MODIFY;
                        END;

                        //End of Commit;

                    end;
                }
                action(Test)
                {
                    Caption = 'Test';
                    Visible = false;

                    trigger OnAction()
                    begin
                        CreatePV(Rec);
                    end;
                }
                action(Post)
                {
                    Image = Error;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = showposting;

                    trigger OnAction()
                    begin
                        PostImpestsurrenderlines;
                    end;
                }
                action("Send Approval Request.")
                {
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser2;

                    trigger OnAction()
                    begin
                        /*IF Training=TRUE THEN BEGIN
                           IF "Training Evaluation"='' THEN BEGIN
                               ERROR('Please Fill the Training Evaluation Field!!');
                           END;
                        END;
                        RequestLines.RESET;
                        RequestLines.SETRANGE(RequestLines."Document No","No.");
                        RequestLines.SETFILTER(RequestLines.Amount,'<>%1',0);
                        IF RequestLines.FIND('-') THEN BEGIN  REPEAT
                                  IF RequestLines."Account No"='' THEN
                                  ERROR('You must select an account for %1',RequestLines.Description);
                        
                                  IF RequestLines."Actual Spent"=0 THEN
                                  ERROR('You must fill the actual amount spent');
                        
                                  IF RequestLines."Actual Spent">RequestLines.Amount THEN BEGIN
                                     ERROR('Amount Spent is More than Amount Given for Line %1',RequestLines."Line No.");
                                  END;
                                  IF "Imprest/Advance No"='' THEN BEGIN
                                      ERROR('You must Fill Imprest/Advance No Field!!!');
                                  END;
                        
                        UNTIL RequestLines.NEXT=0;
                        END;
                        
                        IF approvalsmgmt.CheckERCImprestApprovalsWorkflowEnabled(Rec) THEN
                          approvalsmgmt.OnSendERCImprestForApproval(Rec);
                          */

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
                        /*IF Status<>Status::Released THEN
                        approvalsmgmt.GetApprovalCommentERC(Rec,0,"No.");
                        */

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
                        Link:=GLSetup."DMS Imprest Claim Link"+"No.";
                        HYPERLINK(Link);
                        */

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
                            /*ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                            CurrPage.CLOSE;
                            */

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
                            //ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                            //CurrPage.CLOSE;
                            //ApprovalsMgmt.GetApprovalCommentERC(Rec,1,"No.");
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
                            /*ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                            CurrPage.CLOSE;
                            */

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
                            //ApprovalsMgmt.GetApprovalComment(Rec);
                        end;
                    }
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        IF "Imprest Type" = "Imprest Type"::Group THEN
            GroupImprest := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        /*IF Status<>Status::Open THEN
        ERROR('You cannot make changes at this stage');
         */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::"Claim-Accounting";
    end;

    trigger OnOpenPage()
    begin
        /*usersetup2.RESET;
        usersetup2.GET(USERID);
        //Message(usersetup2.Department);
        
        DIMvalue.RESET;
        DIMvalue.SETFILTER(DIMvalue.Name,'Finance');
        IF DIMvalue.FINDSET THEN BEGIN
           //Message('%1',DIMvalue.Code);
           IF DIMvalue.Code=usersetup2."Transport Approver" THEN BEGIN
              //Message('...');
              showposting:=TRUE;
           END;
        END;
        
        ApprovalEntry.SETFILTER(ApprovalEntry.Status,'%1',ApprovalEntry.Status::Open);
        //ApprovalEntry.SETFILTER(ApprovalEntry."Document Type",'%1',ApprovalEntry."Document Type"::"Imprest Surrenders");
        ApprovalEntry.SETFILTER(ApprovalEntry."Approver ID",'%1',USERID);
        ApprovalEntry.SETFILTER(ApprovalEntry."Document No.","No.");
        IF ApprovalEntry.FINDSET THEN BEGIN
        IF (ApprovalEntry."Document Type"=ApprovalEntry."Document Type"::"Imprest Surrenders") OR (ApprovalEntry."Document Type"=ApprovalEntry."Document Type"::"Claim Refunds") THEN
           OpenApprovalEntriesExistForCurrUser:=TRUE;
          //MESSAGE('Approver...');
        END;
        IF NOT ApprovalEntry.FINDSET THEN BEGIN
        IF (ApprovalEntry."Document Type"=ApprovalEntry."Document Type"::"Imprest Surrenders") OR (ApprovalEntry."Document Type"=ApprovalEntry."Document Type"::"Claim Refunds") THEN
           OpenApprovalEntriesExistForCurrUser2:=TRUE;
          // MESSAGE('Not an Approver...');
        END;
        IF OpenApprovalEntriesExistForCurrUser=TRUE THEN BEGIN
           OpenApprovalEntriesExistForCurrUser2:=FALSE;
        END;
        
        IF "Imprest Type"="Imprest Type"::Group THEN
          GroupImprest:=TRUE;
          */

    end;

    var
        D: Date;
        GenjnLine: Record 81;
        ClaimLines: Record 51511004;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        ApprovalEntry: Record 454;
        UserSetup: Record "User Setup";
        ApprovalSetup: Record 454;
        UserSetupRec: Record "User Setup";
        RequestLines: Record 51511004;
        Amt: Decimal;
        CustLedger: Record 21;
        CustLedger1: Record 21;
        RequestHeader: Record "Request Header";
        CommittmentEntries: Record "Commitment Entries";
        LastEntry: Integer;
        Link: Text[250];
        GLSetup: Record 98;
        ApprovalEntries: Record 454;
        lastApprovalDate: Date;
        i2: Integer;
        "G/LAccount": Record "G/L Account";
        "Request Header": Record "Request Header";
        [InDataSet]
        GroupImprest: Boolean;
        JnlBatch: Record 232;
        CompanyInfo: Record 79;
        PartialRec: Record 51511023;
        CashMgt: Record "Cash Management Setup";
        Cust: Record Customer;
        NoofUnsurrenderedImp: Integer;
        ImpRates: Record 51511021;
        PostRec: Record 225;
        usersetup2: Record "User Setup";
        usersetup3: Record "User Setup";
        DIMvalue: Record "Dimension Value";
        showposting: Boolean;
        approvalsmgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        CUST2: Record Customer;

    local procedure PostImpestsurrenderlines()
    var
        ReqLines: Record 51511004;
        PV: Record 51511000;
        PVlines: Record 51511001;
        GenJnline: Record 81;
        GLSetup: Record 98;
        GenJnlineCopy: Record 81;
        LastImprestNo: Integer;
        LastClaimNo: Integer;
        GenJnlBatch: Record 232;
        ReceiptHeader: Record 51511027;
        ReceiptLine: Record 51511028;
        Selection: Integer;
        Window: Dialog;
        PVPayee: Text[80];
        BankAccount: Code[20];
        PayMode: Code[20];
        ChequeNo: Code[20];
        ChequeDate: Date;
        GLEntry: Record 17;
        LineNo: Integer;
        ReqHead: Record "Request Header";
        RequestHeader1: Record "Request Header";
        TotalSurrendered: Decimal;
        PartialImprest: Record 51511023;
        ImprestHeaderRec: Record "Request Header";
        ImprestLinesRec: Record 51511004;
        //WorkPlanActivities: Record 51511205;
        CMSetup: Record "Cash Management Setup";
        Customer: Record Customer;
    begin
        //Message('%1',Type);
        /*
        GLSetup.GET;
        RequestHeader.CALCFIELDS(RequestHeader."Imprest Amount");
        IF Type=Type::Imprest THEN
        BEGIN
        
        //IF RequestHeader."Total Amount Requested">GLSetup."Cash Limit" THEN
        //BEGIN
        
        IF Posted <> TRUE THEN
        BEGIN
        
          PV.INIT;
          PV.No:='';
          PV.Date:=TODAY;
          PV.Payee:="Employee Name";
        
          IF Type = Type::Imprest THEN
          PV.Remarks:='Imprest';
          IF Type = Type::PettyCash THEN
          PV.Remarks:='Petty Cash';
        
        
          PV."PO/INV No":="No.";
          PV."Paying Bank Account":="Bank Account";//GLSetup."Default Bank Account";
          PV."Account Type":=PV."Account Type"::"Bank Account";
          PV."Account No.":="Bank Account";
          PV.Status:=PV.Status::Released;
          PV."Global Dimension 1 Code":="Global Dimension 1 Code";
          PV.VALIDATE("Global Dimension 1 Code");
          PV."Global Dimension 2 Code":="Global Dimension 2 Code";
          PV.VALIDATE("Global Dimension 2 Code");
        
                //Map Acitivty Codes to PV Header
                ReqLines.RESET;
                ReqLines.SETRANGE("Document No","No.");
                IF ReqLines.FIND('-') THEN BEGIN
                  CASE ReqLines."Activity Type" OF
                   ReqLines."Activity Type"::WorkPlan:
                    BEGIN
                    PV."Activity Type":=PV."Activity Type"::WorkPlan;
                    PV.Activity:=ReqLines.Activity;
                    END;
                   ReqLines."Activity Type"::"Admin & PE":
                    BEGIN
                    PV."Activity Type":=PV."Activity Type"::"P&E";
                    PV.Activity:=ReqLines.Activity;
                    END;
                  END;
                END;
        
          //PV."Account Name":=;
          PV.INSERT(TRUE);
        
          CALCFIELDS("Imprest Amount");
          PVlines.INIT;
          PVlines."PV No":=PV.No;
          PVlines."Line No":=PVlines."Line No"+10000;
          PVlines."Account Type":=PVlines."Account Type"::Customer;
          PVlines."Account No":="Customer A/C";
          Customer.RESET;
          IF Customer.GET("Customer A/C") THEN
          PVlines."Account Name":=Customer.Name;
          PVlines."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
          PVlines.VALIDATE("Shortcut Dimension 1 Code");
          PVlines."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
          PVlines.VALIDATE("Shortcut Dimension 2 Code");
          PVlines.Description:="Employee Name"+'-Imprest';
          PVlines.Amount:="Imprest Amount";
          PVlines."Loan No":="No.";
        
                //Map Acitivty Codes to PV Lines
                ReqLines.RESET;
                ReqLines.SETRANGE("Document No","No.");
                IF ReqLines.FIND('-') THEN BEGIN
                  CASE ReqLines."Activity Type" OF
                   ReqLines."Activity Type"::WorkPlan:
                    BEGIN
                    PVlines."Activity Type___":=PVlines."Activity Type___"::WorkPlan;
                    PVlines.Activity:=ReqLines.Activity;
                    END;
                   ReqLines."Activity Type"::"Admin & PE":
                    BEGIN
                    PVlines."Activity Type___":=PVlines."Activity Type___"::"P&E";
                    PVlines.Activity:=ReqLines.Activity;
                    END;
                  END;
                END;
        
          PVlines.INSERT;
        
        
          Posted:=TRUE;
          MODIFY;
        
          MESSAGE('Payment Voucher %1 has been created for '+FORMAT(Type)+' %2',PV.No,"No.");
        END ELSE
         ERROR('A Payment Voucher has already been created '+FORMAT(Type)+' %1',"No.");
        
        END;
        
        
        
        
        IF Type=Type::"Claim-Accounting" THEN
        BEGIN
                //message('...');
                CALCFIELDS("Remaining Amount","Actual Amount");
                TESTFIELD("Customer A/C");
                TESTFIELD("Request Date");
                //Check if the imprest Lines have been populated
        
                ReqLines.RESET;
                ReqLines.SETRANGE(ReqLines."Document No","No.");
                ReqLines.SETRANGE(Surrender,TRUE);
                IF NOT ReqLines.FINDLAST  THEN
                 ERROR('The Imprest Surrender Lines are empty');
        
                ReqLines.RESET;
                ReqLines.SETRANGE(ReqLines."Document No","No.");
                ReqLines.SETRANGE(Surrender,TRUE);
                ReqLines.CALCSUMS("Actual Spent");
                IF ReqLines."Actual Spent"=0 THEN
                 ERROR('Actual Spent Amount cannot be zero');
        
                IF Surrendered THEN
                 ERROR('Imprest %1 has been surrendered',"No.");
        
                 GLSetup.GET;
        
                 //CMSetup.GET();
                // Delete Lines Present on the General Journal Line
                GenJnline.RESET;
                GenJnline.SETRANGE(GenJnline."Journal Template Name",'GENERAL');
                GenJnline.SETRANGE(GenJnline."Journal Batch Name","No.");
                GenJnline.DELETEALL;
        
                GenJnlBatch.INIT;
                //IF CMSetup.GET() THEN
                GenJnlBatch."Journal Template Name":='GENERAL';
                GenJnlBatch.Name:="No.";
                IF NOT GenJnlBatch.GET(GenJnlBatch."Journal Template Name",GenJnlBatch.Name) THEN
                GenJnlBatch.INSERT;
        
        
                //Staff entries
                LineNo:=10000;
                ReqLines.RESET;
                ReqLines.SETRANGE(ReqLines."Document No","No.");
                ReqLines.CALCSUMS("Actual Spent");
                GenJnline.INIT;
                GenJnline."Journal Template Name":='GENERAL';
                GenJnline."Journal Batch Name":="No.";
                GenJnline."Line No.":=LineNo;
                GenJnline."Account Type":=GenJnline."Account Type"::Customer;
                GenJnline."Account No.":="Customer A/C";//"Account No.";
                GenJnline."Posting Date":="Request Date";
                GenJnline."Document No.":="No.";
                //GenJnLine."External Document No.":="Cheque No";
                GenJnline.Description:="Purpose of Imprest";
                GenJnline.Amount:=-"Actual Amount";
                GenJnline.VALIDATE(Amount);
                GenJnline."Applies-to Doc. No.":="Applies-to Doc. No.";
                GenJnline."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                GenJnline.VALIDATE("Shortcut Dimension 1 Code");
                GenJnline."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                GenJnline.VALIDATE("Shortcut Dimension 2 Code");
        
        
                //Map Acitivty Codes to table 81
                  ReqLines.RESET;
                  ReqLines.SETRANGE("Document No","No.");
                  IF ReqLines.FIND('-') THEN BEGIN
                  CASE ReqLines."Activity Type" OF
                   ReqLines."Activity Type"::WorkPlan:
                    BEGIN
                    GenJnline."Work Plan Activity Code":=ReqLines.Activity;
                    END;
                   ReqLines."Activity Type"::"Admin & PE":
                    BEGIN
                    GenJnline."PE Activity Code":=ReqLines.Activity;
                    END;
                  END;
                END;
        
        
                  IF GenJnline.Amount<>0 THEN
                    GenJnline.INSERT;
               {
                 //Create Receipt IF Chosen
                IF Selection=1 THEN BEGIN
                    //Insert Header
                    CALCFIELDS("Remaining Amount");
                    IF "Remaining Amount">0 THEN BEGIN
                    IF "Receipt Created"=FALSE THEN BEGIN
        
                    ReceiptHeader.INIT;
                    ReceiptHeader."No.":=NoSeriesMgt.GetNextNo(GLSetup."Receipt No",TODAY,TRUE);
                    ReceiptHeader.Date:=TODAY;//"Imprest Surrender Date";
                    ReceiptHeader."Received From":=PVPayee;
                   // ReceiptHeader."On Behalf Of":=;
                    ReceiptHeader."Global Dimension 1 Code":="Global Dimension 1 Code";
                    ReceiptHeader."Global Dimension 2 Code":="Global Dimension 2 Code";
                    IF NOT ReceiptHeader.GET(ReceiptHeader."No.") THEN
                    ReceiptHeader.INSERT;
        
                    END;
                    END;
                END;
                 }
        
                 //Expenses
                 ReqLines.RESET;
                 ReqLines.SETRANGE(ReqLines."Document No","No.");
                 ReqLines.SETRANGE(Surrender,TRUE);
                 IF ReqLines.FIND('-') THEN BEGIN
                  REPEAT
                  LineNo:=LineNo+10000;
                  GenJnline.INIT;
                  GenJnline."Journal Template Name":='GENERAL';
                  GenJnline."Journal Batch Name":="No.";
                  GenJnline."Line No.":=LineNo;
                  GenJnline."Account Type":=ReqLines."Account Type";
                    IF GenJnline."Account Type" = ReqLines."Account Type"::"Fixed Asset" THEN
                    GenJnline."FA Posting Type":=GenJnline."FA Posting Type"::"Acquisition Cost";
                  GenJnline."Account No.":=ReqLines."Account No";
                  GenJnline.VALIDATE("Account No.");
                  GenJnline."Posting Date":="Request Date";
                  GenJnline."Document No.":="No.";
                  GenJnline.Description:=ReqLines.Description;
                  GenJnline.Amount:=ReqLines."Actual Spent";
                  GenJnline.VALIDATE(Amount);
                  //Set these fields to blanks
                  GenJnline."Gen. Posting Type":=GenJnline."Gen. Posting Type"::" ";
                  GenJnline.VALIDATE("Gen. Posting Type");
                  GenJnline."Gen. Bus. Posting Group":='';
                  GenJnline.VALIDATE("Gen. Bus. Posting Group");
                  GenJnline."Gen. Prod. Posting Group":='';
                  GenJnline.VALIDATE("Gen. Prod. Posting Group");
                  GenJnline."VAT Bus. Posting Group":='';
                  GenJnline.VALIDATE("VAT Bus. Posting Group");
                  GenJnline."VAT Prod. Posting Group":='';
                  GenJnline.VALIDATE("VAT Prod. Posting Group");
                  //
                  GenJnline."Shortcut Dimension 1 Code":="Global Dimension 1 Code";
                  GenJnline.VALIDATE("Shortcut Dimension 1 Code");
                  GenJnline."Shortcut Dimension 2 Code":="Global Dimension 2 Code";
                  GenJnline.VALIDATE("Shortcut Dimension 2 Code");
        
                  //Map Acitivty Codes to table 81
                    ReqLines.RESET;
                    ReqLines.SETRANGE("Document No","No.");
                    IF ReqLines.FIND('-') THEN BEGIN
                    CASE ReqLines."Activity Type" OF
                     ReqLines."Activity Type"::WorkPlan:
                      BEGIN
                      GenJnline."Work Plan Activity Code":=ReqLines.Activity;
                      END;
                     ReqLines."Activity Type"::"Admin & PE":
                      BEGIN
                      GenJnline."PE Activity Code":=ReqLines.Activity;
                      END;
                    END;
                  END;
        
                  IF GenJnline.Amount<>0 THEN
                    GenJnline.INSERT;
                {
                  //Insert Receipt Lines
                  IF Selection=1 THEN BEGIN
                     IF ReqLines."Remaining Amount">0 THEN BEGIN
                        IF "Receipt Created"=FALSE THEN BEGIN
        
                        ReceiptLine.INIT;
                        ReceiptLine."Line No":=LineNo;
                        ReceiptLine."Receipt No.":=ReceiptHeader."No.";
                        ReceiptLine."Account Type":=ReceiptLine."Account Type"::Customer;
                        ReceiptLine."Account No.":="Customer A/C";
                        IF Customer.GET("Customer A/C") THEN
                        ReceiptLine."Account Name":=Customer.Name;
                        ReceiptLine.Description:=ReqLines.Description;
                        ReceiptLine.Amount:=ReqLines."Remaining Amount";
                        ReceiptLine."Net Amount":=ReqLines."Remaining Amount";
                        ReceiptLine."Global Dimension 1 Code":="Global Dimension 1 Code";;
                        ReceiptLine."Global Dimension 2 Code":="Global Dimension 2 Code";;
        
                        IF NOT ReceiptLine.GET(ReceiptLine."Line No",ReceiptHeader."No.") THEN
                        ReceiptLine.INSERT;
        
                        END;
                     END;
                  END;
               }
                  UNTIL ReqLines.NEXT=0;
                END;
        
          // message('*%1',CMSetup."Donor Accounting");
        
        //If transaction is from work plan then create Back ground entries for the Donor against the income account;
                                                                                      IF CMSetup."Donor Accounting" THEN BEGIN
        
                                                                                          ImprestHeaderRec.RESET;
                                                                                          ImprestHeaderRec.SETRANGE(Posted,TRUE);
                                                                                          ImprestHeaderRec.SETRANGE(Type,ImprestHeaderRec.Type::PettyCash);
                                                                                          ImprestHeaderRec.SETRANGE(ImprestHeaderRec."No.","Imprest/Advance No");
                                                                                          IF ImprestHeaderRec.FIND ('-') THEN BEGIN
        
                                                                                              //Debit Petty Cash Expense Accounts
                                                                                              ImprestLinesRec.RESET;
                                                                                              ImprestLinesRec.SETRANGE("Document No",ImprestHeaderRec."No.");
                                                                                              ImprestLinesRec.SETRANGE("Activity Type" ,ImprestLinesRec."Activity Type"::WorkPlan);
                                                                                              IF ImprestLinesRec.FIND('-') THEN BEGIN
                                                                                              REPEAT
                                                                                              WorkPlanActivities.RESET;
                                                                                              WorkPlanActivities.SETRANGE(Code,ImprestLinesRec.Activity);
                                                                                              IF WorkPlanActivities.FIND('-') THEN BEGIN
                                                                                              //Debit the Source Funds
                                                                                              LineNo:=LineNo+1000;
                                                                                              GenJnline.INIT;
                                                                                              GenJnline."Journal Template Name":='GENERAL';
                                                                                              GenJnline."Journal Batch Name":="No.";
                                                                                              GenJnline."Line No.":=LineNo;
                                                                                              GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
                                                                                              GenJnline."Account No.":=WorkPlanActivities."Source of Funds";
                                                                                              GenJnline.VALIDATE("Account No.");
                                                                                              GenJnline."Posting Date":="Request Date";
                                                                                              GenJnline."Document No.":="No.";
                                                                                              GenJnline.Description:="Purpose of Imprest"+ 'Acitivity'+ ImprestLinesRec.Activity;
                                                                                              GenJnline.Amount:="Actual Amount";
                                                                                              GenJnline.VALIDATE(GenJnline.Amount);
                                                                                              GenJnline."Shortcut Dimension 1 Code":=ImprestLinesRec."Global Dimension 1 Code";
                                                                                              GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                                                                                              GenJnline."Shortcut Dimension 2 Code":=ImprestLinesRec."Global Dimension 2 Code";
                                                                                              GenJnline.VALIDATE(GenJnline."Shortcut Dimension 2 Code");
                                                                                              //Map Acitivty Codes to table 81
                                                                                              GenJnline."Work Plan Activity Code":=ImprestLinesRec.Activity;
        
                                                                                              IF GenJnline.Amount<>0 THEN
                                                                                              GenJnline.INSERT;
        
                                                                                              //Credit the Donor's Receipt Income Account
                                                                                              LineNo:=LineNo+1000;
                                                                                              GenJnline.INIT;
                                                                                              GenJnline."Journal Template Name":='GENERAL';
                                                                                              GenJnline."Journal Batch Name":=RequestHeader."No.";
                                                                                              GenJnline."Line No.":=LineNo;
                                                                                              GenJnline."Account Type":=GenJnline."Account Type"::"G/L Account";
                                                                                              GenJnline."Account No.":=CMSetup."Donor's Income Account";
                                                                                              GenJnline.VALIDATE("Account No.");
                                                                                              GenJnline."Posting Date":="Request Date";
                                                                                              GenJnline."Document No.":="No.";
                                                                                              GenJnline.Description:="Purpose of Imprest"+ 'Activity'+ ImprestLinesRec.Activity;
                                                                                              GenJnline.Amount:=-"Actual Amount";
                                                                                              GenJnline.VALIDATE(GenJnline.Amount);
                                                                                              GenJnline."Shortcut Dimension 1 Code":=ImprestLinesRec."Global Dimension 1 Code";
                                                                                              GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                                                                                              GenJnline."Shortcut Dimension 2 Code":=ImprestLinesRec."Global Dimension 2 Code";
                                                                                              GenJnline.VALIDATE(GenJnline."Shortcut Dimension 2 Code");
                                                                                              //Map Acitivty Codes to table 81
                                                                                              GenJnline."Work Plan Activity Code":=ImprestLinesRec.Activity;
        
                                                                                              IF GenJnline.Amount<>0 THEN
                                                                                              GenJnline.INSERT;
                                                                                              END;
                                                                                              UNTIL ImprestLinesRec.NEXT = 0;
                                                                                              END;
                                                                                          END;
        
                                                                                      END;
                                                                                      //End**********
        
        
                  //IF Type = Type::"Claim-Accounting" THEN
                  //CommitMngt.ImprestUnCommittment(RequestHeader);
        
                  //message('sema boss');
        
               CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post",GenJnline);
        
               GLEntry.RESET;
               GLEntry.SETRANGE(GLEntry."Document No.","No.");
               GLEntry.SETRANGE(GLEntry.Reversed,FALSE);
               GLEntry.SETRANGE("Posting Date","Request Date");
               IF GLEntry.FIND('-') THEN BEGIN
               //Uncommit Entries made to the various expenses accounts
        
                 Posted:=TRUE;
                 Surrendered:=TRUE;
                 //Message(format(Posted));
        
                  // Mark Imprest as Surrendered
                  ReqHead.RESET;
                  ReqHead.SETRANGE("No.","Imprest/Advance No");
                  ReqHead.SETRANGE(Type,ReqHead.Type::Imprest);
                  ReqHead.SETRANGE(Posted,TRUE);
                  IF ReqHead.FIND('-')THEN BEGIN
        
                    IF NOT ReqHead.Partial THEN  //Mark Full Imprest Surrendered
                    ReqHead.Surrendered:=TRUE
        
                    ELSE BEGIN
                    RequestHeader1.RESET;
                    RequestHeader1.SETRANGE("Imprest/Advance No","Imprest/Advance No");
                    RequestHeader1.SETRANGE(Type,RequestHeader1.Type::"Claim-Accounting");
                    RequestHeader1.SETRANGE(Posted,TRUE);
                    IF RequestHeader1.FIND('-') THEN BEGIN
                    REPEAT
                    TotalSurrendered:=TotalSurrendered+RequestHeader1."Actual Amount";
                    UNTIL RequestHeader1.NEXT = 0;
                    END;
        
                    IF PartialImprest.GET("Partial Imprests",PartialImprest."Line No") THEN BEGIN // Mark the Particular Partial Imprest Surrendered
                    PartialImprest.Surrendered:=TRUE;
                    PartialImprest.MODIFY;
                    END;
        
                    IF ReqHead."Issued Amount" = TotalSurrendered THEN //Mark the Partial Imprest Surrendered(Header)
                       ReqHead.Surrendered:=TRUE;
                    END;
        
        
                  ReqHead.MODIFY;
        
                  END;
        
                  IF Selection=1 THEN
                  "Receipt Created":=TRUE;
                  MODIFY;
        
                 END;
             END;
              //END; //Imprest
        
        IF Type=Type::"Leave Application" THEN
        BEGIN
          PV.INIT;
          PV.No:='';
          PV.Date:=TODAY;
          PV.Payee:="Employee Name";
          PV.Remarks:='Refund';
          PV."PO/INV No":="No.";
          PV."Paying Bank Account":=GLSetup."Default Bank Account";
                //Map Acitivty Codes to PV Header
                ReqLines.RESET;
                ReqLines.SETRANGE("Document No","No.");
                IF ReqLines.FIND('-') THEN BEGIN
                  CASE ReqLines."Activity Type" OF
                   ReqLines."Activity Type"::WorkPlan:
                    BEGIN
                    PV."Activity Type":=PV."Activity Type"::WorkPlan;
                    PV.Activity:=ReqLines.Activity;
                    END;
                   ReqLines."Activity Type"::"Admin & PE":
                    BEGIN
                    PV."Activity Type":=PV."Activity Type"::"P&E";
                    PV.Activity:=ReqLines.Activity;
                    END;
                  END;
                END;
        
          PV.INSERT(TRUE);
          CALCFIELDS("Imprest Amount");
        
          PVlines.INIT;
          PVlines."PV No":=PV.No;
          PVlines."Line No":=PVlines."Line No"+10000;
          PVlines."Account Type":=PVlines."Account Type"::Customer;
          PVlines."Account No":="Customer A/C";
          PVlines.Description:="Employee Name"+'-Refund';
          PVlines.Amount:="Actual Amount" - "Imprest Amount";
          PVlines."Loan No":="No.";
                //Map Acitivty Codes to PV Lines
                ReqLines.RESET;
                ReqLines.SETRANGE("Document No","No.");
                IF ReqLines.FIND('-') THEN BEGIN
                  CASE ReqLines."Activity Type" OF
                   ReqLines."Activity Type"::WorkPlan:
                    BEGIN
                    PVlines."Activity Type___":=PVlines."Activity Type___"::WorkPlan;
                    PVlines.Activity:=ReqLines.Activity;
                    END;
                   ReqLines."Activity Type"::"Admin & PE":
                    BEGIN
                    PVlines."Activity Type___":=PVlines."Activity Type___"::"P&E";
                    PVlines.Activity:=ReqLines.Activity;
                    END;
                  END;
                END;
        
          PVlines.INSERT;
        
        MESSAGE('Payment Voucher %1 has been created for the claim refund %2',PV.No,"No.");
        END;
        */

    end;
}

