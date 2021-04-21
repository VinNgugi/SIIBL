page 51511006 "Imprest Header"
{
    // version FINANCE

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(Imprest));

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
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Visible = false;
                }
                field("Employee No"; "Employee No")
                {
                    Editable = false;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Caption = 'Directorate';
                    Editable = false;
                }
                field("Department Name"; "Department Name")
                {
                    Editable = false;
                }
                field("Purpose of Imprest"; "Purpose of Imprest")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Activity End Date"; "Activity End Date")
                {
                }
                field(Training; Training)
                {
                    Visible = true;

                    trigger OnValidate()
                    begin
                        IF Training = TRUE THEN
                            ShowTr := TRUE ELSE
                            ShowTr := FALSE;
                    end;
                }
                field(Travel; Travel)
                {

                    trigger OnValidate()
                    begin
                        IF Travel = TRUE THEN
                            ShowTrv := TRUE ELSE
                            ShowTrv := FALSE;
                    end;
                }
                group(general2)
                {
                    Visible = ShowTr;
                    field("Training Code"; "Training Code")
                    {
                    }
                }
                group(general3)
                {
                    Visible = ShowTrv;
                    field("Trip No"; "Trip No")
                    {
                    }
                }
                field("Trip Start Date"; "Trip Start Date")
                {
                    Enabled = "Transaction Type" = 'IMPREST';
                }
                field("Trip Expected End Date"; "Trip Expected End Date")
                {
                    Enabled = "Transaction Type" = 'IMPREST';
                }
                field("No. of Days"; "No. of Days")
                {
                    Editable = false;
                    Enabled = "Transaction Type" = 'IMPREST';
                    Visible = true;
                }
                field("Days Allowed"; "Days Allowed")
                {
                    Caption = 'Days Allowed for Reapplication of Imprest';
                    Editable = false;
                }
                field("Deadline for Return"; "Deadline for Return")
                {
                    Editable = false;
                    Enabled = "Transaction Type" = 'IMPREST';
                }
                group(general)
                {
                    Visible = ShowPym;
                    field("Bank Account"; "Bank Account")
                    {
                    }
                    field("Pay Mode"; "Pay Mode")
                    {
                    }
                    field("Cheque No"; "Cheque No")
                    {
                    }
                    field("Cheque Date"; "Cheque Date")
                    {
                    }
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                    Editable = false;
                }
                field("Total Amount Requested"; "Total Amount Requested")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Balance; Balance)
                {
                    Caption = 'Customer Balance';
                    Editable = false;
                }
                field("Activity Date"; "Activity Date")
                {
                    Visible = false;
                }
                field(External; External)
                {
                    Caption = 'External Application';
                    Visible = false;
                }
                field("Customer A/C"; "Customer A/C")
                {
                    Visible = false;
                }
                field("Job Group"; "Job Group")
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
                    Editable = false;
                    ExtendedDatatype = URL;
                    Visible = false;
                }
                field("Imprest Type"; "Imprest Type")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        IF "Imprest Type" = "Imprest Type"::Group THEN
                            GroupImprest := TRUE
                        ELSE
                            GroupImprest := FALSE;
                    end;
                }
                field("Imprest Purpose"; "Imprest Purpose")
                {
                    Visible = false;

                    trigger OnValidate()
                    begin
                        /*ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No","No.");
                        IF ImprestLines.FIND('-') THEN BEGIN
                        REPEAT
                        ImprestLines."Imprest Purpose":="Imprest Purpose";
                        ImprestLines.MODIFY;
                        UNTIL ImprestLines.NEXT=0;
                        END;
                        
                        
                        GroupLines.RESET;
                        GroupLines.SETRANGE("Imprest No","No.");
                        IF GroupLines.FIND('-') THEN BEGIN
                        REPEAT
                        GroupLines."Imprest Purpose":="Imprest Purpose";
                        GroupLines.MODIFY;
                        UNTIL GroupLines.NEXT=0;
                        END;
                        */

                    end;
                }
                field(Attachement; Attachement)
                {
                    Visible = false;
                }
                field("Attached to PV No"; "Attached to PV No")
                {
                    Editable = false;
                }
                field(Memo; Memo)
                {
                    Editable = false;
                    Visible = false;
                }
                group("Memo Details")
                {
                    Caption = 'Memo Details';
                    Visible = false;
                    field("Memo No"; "Memo No")
                    {
                        Editable = false;
                        Visible = false;
                    }
                }
            }
            part("Imprest Lines"; 51511016)
            {
                Caption = 'Imprest Lines';
                SubPageLink = "Document No" = FIELD("No.");
                Visible = "International Travel" = FALSE;
            }
            part("Advance Claim Lines"; "Advance Claim Lines")
            {
                Editable = GroupImprest;
                SubPageLink = "Document No" = FIELD("No.");
                Visible = "Transaction Type" = 'ADVANCE';
            }
            part("International Imprest Lines"; 51511015)
            {
                Caption = 'International Imprest Lines';
                SubPageLink = "Document No" = FIELD("No.");
                Visible = "International Travel" = TRUE;
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
                    //REPORT.RUN(51511014,TRUE,TRUE,Rec);
                    //REPORT.RUN(51511003,TRUE,TRUE,Rec);51511229
                    REPORT.RUN(51511014, TRUE, TRUE, Rec); //Government Format
                    //REPORT.RUN(51511229,TRUE,TRUE,Rec); //Attain Format

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
                        CreatePV(Rec);


                        TESTFIELD("Customer A/C");
                        ERROR("Customer A/C");
                        IF "Customer A/C" = '' THEN BEGIN
                            ERROR('Please Select Customer No.');
                        END;
                        IF "Customer A/C" = ' ' THEN BEGIN
                            ERROR('Please Select Customer No.');
                        END;
                        IF "Purpose of Imprest" = '' THEN
                            //ERROR('You must enter Purpose of imprest');

                            //Check Empty Lines
                            ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No", "No.");
                        IF NOT ImprestLines.FIND('-') THEN
                            ERROR('The Imprest Has NO Lines');

                        //Check Details
                        ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No", "No.");
                        IF ImprestLines.FIND('-') THEN BEGIN
                            ImprestLines.TESTFIELD(Activity);
                            ImprestLines.TESTFIELD(Quantity);
                            ImprestLines.TESTFIELD("Unit Price");
                        END;

                        //BKK
                        IF Status <> Status::Open THEN
                            ERROR('This request has been sent for approval');
                        /* IF approvalsmgmt.CheckImprestRequestApprovalPossible(Rec) THEN
                            approvalsmgmt.OnSendImprestRequestDocForApproval(Rec); */
                        //CurrPage.CLOSE;

                        //Commit Imprest
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
                        /* IF approvalsmgmt.CheckImprestRequestApprovalPossible(Rec) THEN
                            approvalsmgmt.OnCancelImprestRequestApprovalRequest(Rec); */
                        CurrPage.CLOSE;
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
                       /*  loanapplication.INIT;
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
            group(Attachment)
            {
                Caption = 'Attachment';
                Image = Attachments;
                action(Open)
                {
                    Caption = 'Open';
                    Image = Edit;
                    Promoted = true;
                    ShortCutKey = 'Return';
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        OpenAttachment
                        //CreatePV(Rec);
                    end;
                }
                action(Create)
                {
                    Caption = 'Create';
                    Image = New;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        CreateAttachment;
                    end;
                }
                action(Import)
                {
                    Caption = 'Import';
                    Image = Import;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        ImportAttachment;
                    end;
                }
                action(Export)
                {
                    Caption = 'Export';
                    Image = Export;
                    Promoted = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    Caption = 'Remove';
                    Image = Cancel;
                    Visible = false;

                    trigger OnAction()
                    begin
                        "Interaction Template Code" := "No." + '-' + FORMAT(Type);
                        RemoveAttachment(FALSE);
                    end;
                }
                action("E&xport File2")
                {
                    Caption = 'E&xport File2';
                    Image = ExportFile;
                    Visible = false;

                    trigger OnAction()
                    var
                        SegLineLocal: Record 5077;
                    begin
                        SegLineLocal.SETRANGE("Segment No.", "No.");
                        XMLPORT.RUN(XMLPORT::"Export Segment Contact", FALSE, FALSE, SegLineLocal);
                    end;
                }
                action("Update Line GL")
                {

                    trigger OnAction()
                    begin
                        RESET;
                        CALCFIELDS("Imprest Amount");
                        approvalentries.SETRANGE("Document No.", "No.");
                        IF approvalentries.FINDFIRST THEN BEGIN
                            REPEAT
                                //IF approvalentries."Amount (LCY)"=0 THEN
                                approvalentries."Amount (LCY)" := "Imprest Amount";
                                approvalentries.MODIFY;
                                MESSAGE('Successfully Updated')
UNTIL approvalentries.NEXT = 0;
                        END;
                        /*ImprestLines.RESET;
                        IF ImprestLines.FINDFIRST THEN BEGIN
                        REPEAT
                        IF ImprestLines."Account No"='' THEN
                          IF ImprestLines.Activity<>'' THEN
                            ImprestLines."Account No":=ImprestLines.Activity;
                          ImprestLines.MODIFY;
                        UNTIL ImprestLines.NEXT=0;
                        END;
                        */
                        /*
                        RequestHeader.RESET;
                        RequestHeader.SETFILTER(Status,'<>%1|<>%2',RequestHeader.Status::Rejected,RequestHeader.Status::Released);
                        IF RequestHeader.FINDFIRST THEN BEGIN
                        REPEAT
                        ImprestLines.RESET;
                          ImprestLines.SETRANGE("Document No",RequestHeader."No.");
                          ImprestLines.CALCSUMS("Requested Amount");
                          approvalentries.SETRANGE("Document No.",RequestHeader."No.");
                          IF approvalentries.FINDFIRST THEN BEGIN REPEAT
                            IF approvalentries."Amount (LCY)"=0 THEN
                              approvalentries."Amount (LCY)":=ImprestLines."Requested Amount";
                             approvalentries.MODIFY;
                             UNTIL  approvalentries.NEXT=0;
                             END;
                          UNTIL RequestHeader.NEXT=0;
                          END;
                          */

                    end;
                }
            }
        }
        area(creation)
        {
            action("Send Approval Request.")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin

                    //=====================================DBMS Connections====================================================
                    /*
                    "Attached?":=FALSE;
                    GLSetup.RESET;
                    GLSetup.GET;
                    GLSetup.TESTFIELD("DBMS Host Server");
                    GLSetup.TESTFIELD("DMS DB Link");
                    GLSetup.TESTFIELD("DBMS Staging DB");
                    GLSetup.TESTFIELD("Imprest DB Table");
                    
                    ServerName:=GLSetup."DBMS Host Server";
                    NAVDB:=GLSetup."DBMS Staging DB";
                    //ServerName:='192.168.230.11';
                    //BDUserID:='navdb';
                    //BDUserID:='LAPTOP-L7NM5T6N\Attain';
                    //BDPW:='100Bags!';
                    //ERROR('%1..%2',ServerName,NAVDB);
                    //ConnectionString:='Data Source='+ServerName+'Initial Catalog='+NAVDB+'Trusted_Connection=True';
                    ConnectionString:='Data Source='+ServerName+';Initial Catalog='+NAVDB+';Trusted_Connection=True';
                    //ConnectionString:='Data Source='+ServerName+';Initial Catalog='+NAVDB+';UID='+BDUserID+';Pwd='+BDPW+';';
                    
                    SQLConnection:=SQLConnection.SqlConnection(ConnectionString);
                    SQLConnection.Open;
                    //ERROR('...');
                    SQLCommand:=SQLConnection.CreateCommand();
                    Docnobd2:=STRSUBSTNO(Docnobd,"No.");
                    SQLStt:=STRSUBSTNO(BDSTT,GLSetup."DMS DB Link",GLSetup."Imprest DB Table",Docnobd2);
                    //ERROR(SQLStt);//sql statement
                    SQLCommand.CommandText:=SQLStt;
                    SQReader:=SQLCommand.ExecuteReader;
                    WHILE SQReader.Read() DO BEGIN
                        //MESSAGE('%1...%2',FORMAT(SQReader.GetString(1)),FORMAT(SQReader.GetString(2)));
                        "Attached?":=TRUE;
                    END;
                    
                    SQLConnection.Close;
                    CLEAR(SQReader);
                    CLEAR(SQLCommand);
                    CLEAR(SQLConnection);
                    //ERROR('');
                    IF "Attached?"=FALSE THEN BEGIN
                       ERROR('Please add attachments First!');
                    END;
                    //========================================================================================================
                    
                    */
                    /*
                    IF "Request Date"<TODAY
                      THEN BEGIN
                      ERROR('Please ensure the request date is the same as todays date');
                      END;
                    TESTFIELD("Customer A/C");
                    CUST.RESET;
                    CUST.GET("Customer A/C");
                    CUST.CALCFIELDS(CUST.Balance);
                    IF CUST.Balance>0 THEN BEGIN
                     //  ERROR('Customer %1 has an Outstanding Balance of %2\You cannot Raise new Imprest till the oustanding Amount is Surrendered!!!',"Customer A/C",CUST.Balance);
                    END;
                    
                    IF "Customer A/C"='' THEN BEGIN
                       ERROR('Please Select Customer No.');
                    END;
                    IF "Customer A/C"=' ' THEN BEGIN
                       ERROR('Please Select Customer No.');
                    END;
                    
                    
                    
                    IF "Purpose of Imprest"='' THEN
                    //ERROR('You must enter Purpose of imprest');
                    
                    //Check Empty Lines
                    ImprestLines.RESET;
                    ImprestLines.SETRANGE("Document No","No.");
                    IF NOT ImprestLines.FIND('-') THEN
                    ERROR('The Imprest Has NO Lines');
                    
                    //Check Details
                    IF "Transaction Type"<>'ADVANCE' THEN BEGIN
                        i:=0;
                        ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No","No.");
                        IF ImprestLines.FIND('-') THEN REPEAT
                                    i:=i+1;
                                  //ImprestLines.TESTFIELD(Activity);
                                  ImprestLines.TESTFIELD(Quantity);
                                  ImprestLines.TESTFIELD("Unit Price");
                                  IF ImprestLines."Account No"='' THEN BEGIN
                                     ERROR('Imprest No. %1 is Missing  Account No. in  Line %2',"No.",i);
                                  END;
                                  IF "International Travel"=TRUE THEN BEGIN
                                      ImprestLines.TESTFIELD("USD Amount");
                                      ImprestLines.TESTFIELD("Exchange Rate");
                                      ImprestLines.TESTFIELD(Amount);
                                  END;
                        UNTIL ImprestLines.NEXT=0;
                    END;
                    IF "Transaction Type"='ADVANCE' THEN BEGIN
                        i:=0;
                        ImprestLines.RESET;
                        ImprestLines.SETRANGE("Document No","No.");
                        IF ImprestLines.FIND('-') THEN REPEAT
                          i:=i+1;
                        //ImprestLines.TESTFIELD(Activity);
                        ImprestLines.TESTFIELD(Amount);
                        ImprestLines.TESTFIELD("Salary Advance Installlments");
                        ImprestLines.TESTFIELD("Salary Advance Start Date");
                        ImprestLines.TESTFIELD("Salary Advance End Date");
                    
                        UNTIL ImprestLines.NEXT=0;
                    END;
                    */
                    ImprestLines.RESET;
                    ImprestLines.SETRANGE("Document No", "No.");
                    IF ImprestLines.FIND('-') THEN BEGIN
                        REPEAT

                            ImprestLines.TESTFIELD(Amount);

                        UNTIL ImprestLines.NEXT = 0;
                    END;

                    IF Status IN [Status, Status::Open] THEN BEGIN
                        /* IF approvalsmgmt.CheckImprestRequestApprovalPossible(Rec) THEN
                            ApprovalMgt.OnSendImprestRequestDocForApproval(Rec) */;
                    END;

                    //Commit Entries
                    ReqLines.RESET;
                    ReqLines.SETRANGE("Document No", "No.");
                    IF ReqLines.FIND('-') THEN BEGIN
                        REPEAT
                            CashManagementSetup.GET;
                        //GLSetup.GET;
                        Factory.FnCommitAmount(ReqLines.Amount,ReqLines."Account No",CashManagementSetup."Current Budget",ReqLines."Document No",
                                            CommitmentEntries."Commitment Type"::IMPREST,"Global Dimension 1 Code","Global Dimension 2 Code","Request Date",CommitmentEntries.Type::Committed,ReqLines."Global Dimension 3 Code");
                        UNTIL ReqLines.NEXT = 0;
                    END;
                    CurrPage.CLOSE;

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
                    IF Status IN [Status, Status::"Pending Approval"] THEN BEGIN
                        /* IF approvalsmgmt.CheckImprestRequestApprovalPossible(Rec) THEN
                            ApprovalMgt.OnCancelImprestRequestApprovalRequest(Rec) */;
                    END;

                    //Decomommit Entries
                    ReqLines.RESET;
                    ReqLines.SETRANGE("Document No", "No.");
                    IF ReqLines.FIND('-') THEN BEGIN
                        REPEAT
                            CashManagementSetup.GET;
                        //GLSetup.GET;
                        Factory.FnCommitAmount(-ReqLines.Amount,ReqLines."Account No",CashManagementSetup."Current Budget",ReqLines."Document No",
                                               CommitmentEntries."Commitment Type"::IMPREST,"Global Dimension 1 Code","Global Dimension 2 Code","Request Date",CommitmentEntries.Type::Reversal,
                                               ReqLines."Global Dimension 3 Code");
                        UNTIL ReqLines.NEXT = 0;
                    END;
                    CurrPage.CLOSE;
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
                    Link:=GLSetup."DMS Imprest Link"+"No.";
                    HYPERLINK(Link);
                    */

                end;
            }
            action(Approvals)
            {
                Image = Approvals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;

                trigger OnAction()
                begin
                    approvalsmgmt.OpenApprovalEntriesPage(RECORDID)
                end;
            }
            action(Post)
            {
                Caption = 'Post';
                Image = post;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Select: Integer;
                    TXT0001: Label 'Payment Voucher,Petty Cash';
                begin
                    IF Status <> Status::Released THEN
                        ERROR('The document is not approved');
                    TESTFIELD("Pay Mode");
                    IF "Pay Mode" <> 'CASH' THEN BEGIN
                        TESTFIELD("Cheque Date");
                        TESTFIELD("Cheque No");
                    END;

                    Select := DIALOG.STRMENU(TXT0001, 1, 'Pay Via: ');
                    IF Select = 1 THEN
                        CreatePV1(Rec)
                    ELSE
                        CreatePV(Rec);

                    CurrPage.CLOSE;
                end;
            }
            group(Approval)
            {
                Caption = 'Approval';
                Image = Alerts;
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
                        /*
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
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
                        //ApprovalsMgmt.GetApprovalCommentERC(Rec,1,"No.");
                        //CurrPage.CLOSE;
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
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    Visible = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF "International Travel" = TRUE THEN BEGIN
            Internationalsee := TRUE;
            Localsee := FALSE;
        END;

        IF "International Travel" = FALSE THEN BEGIN
            Internationalsee := FALSE;
            Localsee := TRUE;
        END;

        IF "Imprest Type" = "Imprest Type"::Group THEN
            GroupImprest := TRUE;

        ShowPym := FALSE;
        IF Status = Status::Released THEN
            ShowPym := TRUE;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        IF Status <> Status::Open THEN
            ERROR('You cannot make changes at this stage');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::Imprest;
        //ERROR('...');
    end;

    trigger OnOpenPage()
    begin
        /*
        approvalentry.RESET;
        approvalentry.SETFILTER(approvalentry.Status,'%1',approvalentry.Status::Open);
        approvalentry.SETFILTER(approvalentry."Document Type",'%1',approvalentry."Document Type"::Imprest);
        approvalentry.SETFILTER(approvalentry."Approver ID",'%1',USERID);
        approvalentry.SETFILTER(approvalentry."Document No.","No.");
        IF approvalentry.FINDSET THEN BEGIN
           OpenApprovalEntriesExistForCurrUser:=TRUE;
          //MESSAGE('Approver...');
        END;
        IF NOT approvalentry.FINDSET THEN BEGIN
           OpenApprovalEntriesExistForCurrUser2:=TRUE;
          // MESSAGE('Not an Approver...');
        END;
        IF OpenApprovalEntriesExistForCurrUser=TRUE THEN BEGIN
           OpenApprovalEntriesExistForCurrUser2:=FALSE;
        END;
        
        IF "Imprest Type"="Imprest Type"::Group THEN
          GroupImprest:=TRUE;
          */
        ShowTr := FALSE;
        ShowTrv := FALSE;
        ShowPym := FALSE;
        IF Status = Status::Released THEN
            ShowPym := TRUE;

    end;

    var
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        PV: Record Payments1;
        PVlines: Record "PV Lines1";
        //loanapplication: Record 51511113;
        D: Date;
        UserSetup: Record "User Setup";
        ApprovalSetup: Record 39;
        UserSetupRec: Record "User Setup";
        RequestHeader: Record "Request Header";
        GLSetup: Record "General Ledger Setup";
        Link: Text[250];
        [InDataSet]
        GroupImprest: Boolean;
        PartialImprest: Record "Partial Imprest Issue";
        Path: Text;
        ServerFileName: Text;
        [RunOnClient]
        FileInfo: DotNet FileInfo;
        ImprestLines: Record "Request Lines";
        [InDataSet]
        JobQueueVisible: Boolean;
        approvalsmgmt: Codeunit "Approvals Mgmt.";
        OpenApprovalEntriesExistForCurrUser: Boolean;
        approvalentry: Record "Approval Entry";
        OpenApprovalEntriesExistForCurrUser2: Boolean;
        i: Integer;
        approvalentries: Record "Approval Entry";
        CUST: Record Customer;
        Internationalsee: Boolean;
        Localsee: Boolean;
        //dotnetvalue: DotNet Interaction;
        commentmsg: Text;
        commentline: Record 455;
        //SQLConnection: DotNet SqlConnection;
        //SQLCommand: DotNet SqlCommand;
        //SQReader: DotNet SqlDataReader;
        ServerName: Text;
        NAVDB: Text;
        ConnectionString: Text;
        BDUserID: Text;
        BDPW: Text;
        SQLStt: Text;
        BDSTT: Label 'SELECT * FROM %1%2 WHERE [CONTACTS]=''%3''';
        BDSTT2: Label 'SELECT * FROM [ERC2017].dbo.[ERC$Customer] where [No_]=''%1''';
        BDSTT3: Label 'SELECT * FROM [192.168.230.11].[DMSDB].[dbo].[CF_IMPREST]';
        BDSTT4: Label 'SELECT * FROM OPENQUERY([192.168.230.11],''%1'')';
        BDSTT41: Label 'SELECT * FROM [DMSDB].[dbo].[CF_IMPREST]';
        "Attached?": Boolean;
        Docnobd: Label '%1';
        Docnobd2: Text;
        ReqLines: Record "Request Lines";
        Factory: Codeunit 51511015;
        CashManagementSetup: Record "Cash Management Setup";
        CommitmentEntries: Record "Commitment Entries";
        ShowTr: Boolean;
        ShowTrv: Boolean;
        ShowPym: Boolean;

    procedure GetPartialImprestNo(var ImpNo: Code[20]) LineNo: Integer
    var
        Partial: Record "Partial Imprest Issue";
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
        Partial: Record "Partial Imprest Issue";
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

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        /*
        JobQueueVisible := "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting";
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        CreateIncomingDocumentEnabled := (NOT HasIncomingDocument) AND ("No." <> '');
        SetExtDocNoMandatoryCondition;
        
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
        */

    end;

    /* trigger SQLCommand::StatementCompleted(sender: Variant; e: DotNet StatementCompletedEventArgs)
    begin
    end;

    trigger SQLCommand::Disposed(sender: Variant; e: DotNet EventArgs)
    begin
    end;

    trigger SQLConnection::InfoMessage(sender: Variant; e: DotNet SqlInfoMessageEventArgs)
    begin
    end;

    trigger SQLConnection::StateChange(sender: Variant; e: DotNet StateChangeEventArgs)
    begin
    end;

    trigger SQLConnection::Disposed(sender: Variant; e: DotNet EventArgs)
    begin
    end; */
}

