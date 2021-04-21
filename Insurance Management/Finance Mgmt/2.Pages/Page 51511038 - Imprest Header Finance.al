page 51511038 "Imprest Header Finance"
{
    // version FINANCE

    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = "Request Header";
    SourceTableView = WHERE(Type = CONST(Imprest),
                            Status = CONST(Released));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; "No.")
                {
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
                    Caption = 'Department';
                    Editable = true;
                }
                field("Deadline for Return"; "Deadline for Return")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                    Editable = false;
                }
                field(External; External)
                {
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
                    Visible = true;
                }
                field("Attached to PV No"; "Attached to PV No")
                {
                }
            }
            part("Imprest_claim Lines"; 51511016)
            {
                Caption = 'Imprest_claim Lines';
                SubPageLink = "Document No" = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Partial Issue")
            {
                Caption = 'Partial Issue';
                Image = MachineCenterLoad;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    PartialImprest.INIT;
                    PartialImprest."Imprest No" := "No.";
                    PartialImprest."Line No" := GetPartialImprestNo("No.");
                    PartialImprest."Employee No" := "Employee No";
                    PartialImprest.Date := WORKDATE;
                    CALCFIELDS("Imprest Amount");
                    PartialImprest."Approved Amount" := "Imprest Amount";
                    PartialImprest."Amount Already Issued" := GetAmountIssued("No.");
                    PartialImprest."Remaining Amount" := PartialImprest."Approved Amount" - PartialImprest."Amount Already Issued";
                    PartialImprest."User ID" := USERID;
                    PartialImprest.Partial := TRUE;
                    PartialImprest.INSERT;
                    PAGE.RUN(51511902, PartialImprest);
                end;
            }
            action("Partial Issues")
            {
                Caption = 'Partial Issues';
                Image = MachineCenterLoad;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page 51511039;
                RunPageLink = "Imprest No" = FIELD("No.");
                Visible = false;
            }
            action(Print1)
            {
                Caption = 'Print';
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                begin
                    IF Posted = FALSE THEN
                        ERROR('Payment Voucher No %1 has not been posted', "No.");

                    RESET;
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51511014, TRUE, TRUE, Rec);
                    RESET;
                end;
            }
            action("Cash Voucher")
            {
                Caption = 'Cash Voucher';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                Visible = false;

                trigger OnAction()
                begin
                    IF Posted = FALSE THEN
                        ERROR('Payment Voucher No %1 has not been posted', "No.");

                    RESET;
                    SETFILTER("No.", "No.");
                    REPORT.RUN(51511005, TRUE, TRUE, Rec);
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
                        IF "Transaction Type" = '' THEN
                            ERROR('You must select the transaction type');

                        //IF ApprovalMgt.SendImprestApprovalRequest(Rec) THEN;
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
                        //CommittmentMgt.CreatePV(Rec);
                        CurrPage.CLOSE;
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
                action(Print)
                {
                    Caption = 'Print';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        IF Posted = FALSE THEN
                            ERROR('Payment Voucher No %1 has not been posted', "No.");

                        RESET;
                        SETFILTER("No.", "No.");
                        REPORT.RUN(51511005, TRUE, TRUE, Rec);
                        RESET;
                    end;
                }
                action("Create PV")
                {
                    Caption = 'Create PV';
                    Image = Payment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = false;

                    trigger OnAction()
                    begin
                        //CommittmentMgt.ImprestPaidWithPV(Rec);
                    end;
                }
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin

        /*IF Status<>Status::Open THEN
        ERROR('You cannot make changes at this stage');  */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Type := Type::Imprest;
    end;

    trigger OnOpenPage()
    var
        Text000: Label 'The Imprest Account Holder no %1, has %2 yet to be Surrendered. The Transaction will therefore Terminate!';
        ImprestHeaderRec: Record "Request Header";
        CustLedge: Record "Cust. Ledger Entry";
        ImpNo: Integer;
    begin
        /*
        SETRANGE("User ID",USERID);

        IF UserSetup.GET(USERID) THEN
        BEGIN

        IF UserSetup."Approver ID"=USERID THEN
        SETRANGE("User ID");
        ApprovalTemplate.RESET;
        ApprovalTemplate.SETRANGE(ApprovalTemplate."Table ID",DATABASE::Table59018);
        ApprovalTemplate.SETRANGE(ApprovalTemplate.Enabled,TRUE);
        IF ApprovalTemplate.FIND('-') THEN
        BEGIN
        AdditionalApprovers.RESET;
        AdditionalApprovers.SETRANGE(AdditionalApprovers."Approval Code",ApprovalTemplate."Approval Code");
        AdditionalApprovers.SETRANGE(AdditionalApprovers."Approver ID",USERID);
        IF AdditionalApprovers.FIND('+') THEN
        SETRANGE("User ID");
        END;
        IF ApprovalSetup.GET THEN
        IF ApprovalSetup."Approval Administrator"=USERID THEN
        SETRANGE("User ID");


        ApprovalTemplate.RESET;
        ApprovalTemplate.SETRANGE(ApprovalTemplate."Table ID",DATABASE::Table59018);
        ApprovalTemplate.SETRANGE(ApprovalTemplate.Enabled,TRUE);
        IF ApprovalTemplate.FIND('-') THEN
        BEGIN
        AdditionalApprovers.RESET;
        AdditionalApprovers.SETRANGE(AdditionalApprovers."Approval Code",ApprovalTemplate."Approval Code");
        IF AdditionalApprovers.FIND('-') THEN
        REPEAT

         UserSetupRec.RESET;
         UserSetupRec.SETRANGE(UserSetupRec.Substitute,AdditionalApprovers."Approver ID");
         UserSetupRec.SETRANGE(UserSetupRec."User ID",USERID);
         IF UserSetupRec.FIND('-') THEN
         SETRANGE("User ID");
        UNTIL AdditionalApprovers.NEXT=0;

        END;




        END;

        IF ApprovalSetup.GET THEN
        IF ApprovalSetup."Approval Administrator"=UPPERCASE(USERID) THEN
        SETRANGE("User ID");
        */
        //Error For Unserrendered Imprests
        RequestHeader2.RESET;
        RequestHeader2.SETRANGE(Posted, TRUE);
        RequestHeader2.SETRANGE(Surrendered, FALSE);
        RequestHeader2.SETRANGE("Customer A/C", "Customer A/C");
        RequestHeader2.SETFILTER(Type, '=%1', RequestHeader2.Type::Imprest);
        RequestHeader2.SETFILTER("Deadline for Return", '<%1', TODAY);
        /* IF RequestHeader2.FIND('-') THEN BEGIN

         //Message(format(RequestHeader2."No."));
         ImpNo:=0;
           REPEAT
           CustLedge.RESET;
           CustLedge.SETRANGE(Open,TRUE);
           CustLedge.SETRANGE("Document No.",RequestHeader2."No.");
           CustLedge.SETRANGE("Customer No.",RequestHeader2."Customer A/C");
           CustLedge.SETRANGE("Due Date",RequestHeader2."Deadline for Imprest Return");
           IF CustLedge.FIND('-') THEN
           ImpNo:=ImpNo+1;
           UNTIL RequestHeader2.NEXT = 0;
           IF ImpNo > 0 THEN
           ERROR(Text000,"Customer A/C",ImpNo);
         END; */
        //Error End

    end;

    var
        ApprovalMgt: Codeunit 40;
        PV: Record "Request Header";
        PVlines: Record 51511001;
        //loanapplication: Record 51511113;
        D: Date;
        UserSetup: Record "User Setup";
        ApprovalSetup: Record Customer;
        UserSetupRec: Record "User Setup";
        RequestHeader: Record "Request Header";
        GLSetup: Record "General Ledger Setup";
        Link: Text[250];
        PartialImprest: Record 51511023;
        RequestHeader2: Record "Request Header";

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
        Partial: Record "Partial Imprest Issue";
        Requests: Record "Request Header";
    begin
        AmountIssued := 0;
        /*
        Partial.RESET;
        Partial.SETCURRENTKEY("Imprest No","Line No");
        Partial.SETRANGE("Imprest No",ImpNo);
        Partial.SETRANGE(Posted,TRUE);
        IF Partial.FIND('-') THEN BEGIN REPEAT
        AmountIssued := AmountIssued + Partial."Amount Issued";
        UNTIL Partial.NEXT = 0;
        END ELSE
        AmountIssued := 0;
        */
        IF Requests.GET(ImpNo) THEN BEGIN
            //Requests.CALCFIELDS("Issued Amount");
            AmountIssued := "Issued Amount";
        END;

    end;
}

