page 51513021 Claim
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim";

    layout
    {
        area(content)
        {
            group(Insured)
            {
                field("Claim No"; "Claim No")
                {
                }
                field("Policy No"; "Policy No")
                {
                }
                field("Name of Insured"; "Name of Insured")
                {
                    Editable = false;
                }
                field("Premium Balance"; "Premium Balance")
                {
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Renewal Date"; "Renewal Date")
                {
                }
                field("ID Number"; "ID Number")
                {
                    Editable = false;
                }
                field("Insured Telephone No."; "Insured Telephone No.")
                {
                    Editable = false;
                }
                field("Date of Birth"; "Date of Birth")
                {
                    Editable = false;
                }
                field(Sex; Sex)
                {
                    Editable = false;
                }
                field("Insured Address"; "Insured Address")
                {
                    Editable = false;
                }
                field(Occupation; Occupation)
                {
                    Editable = false;
                }
                field("Loss Type"; "Loss Type")
                {

                    trigger OnValidate();
                    begin
                        IF LossTypeRec.GET("Loss Type") THEN BEGIN
                            IF (LossTypeRec.Type = LossTypeRec.Type::"Accident+Third Party") OR
                              (LossTypeRec.Type = LossTypeRec.Type::"Own Damage") THEN BEGIN
                                ShowAccident := TRUE;
                                ShowDriver := TRUE;
                                ShowThirdParty := TRUE;
                            END;

                            IF (LossTypeRec.Type = LossTypeRec.Type::Theft) THEN BEGIN
                                ShowAccident := FALSE;
                                ShowDriver := TRUE;
                                ShowThirdParty := FALSE;

                            END;
                        END;
                    end;
                }
                field("Loss Type Description"; "Loss Type Description")
                {
                    Editable = false;
                }
                field(Class; Class)
                {
                    Editable = false;
                }
                field("Class Description"; "Class Description")
                {
                }
                field("Date of Occurence"; "Date of Occurence")
                {
                }
                field("Amount Settled"; "Amount Settled")
                {
                }
                field("Reserve Amount"; "Reserve Amount")
                {
                }
                field("Excess Amount"; "Excess Amount")
                {
                    Caption = 'Excess Paid';
                }
                field("Salvage Recovery"; "Salvage Recovery")
                {
                }
                field("Treaty Claim Recoveries"; "Treaty Claim Recoveries")
                {
                }
                field("XOL Claim Recoveries"; "XOL Claim Recoveries")
                {
                }
                field("Ultimate Net Loss"; "Ultimate Net Loss")
                {
                }
            }
            group(Vehicle)
            {
                field(RiskID; RiskID)
                {
                    Caption = 'RiskID';
                }
                field("Registration No."; "Registration No.")
                {
                }
                field(Make; Make)
                {
                }
                field("Year of Manufacture"; "Year of Manufacture")
                {
                }
                field("Cubic Capacity c.c"; "Cubic Capacity c.c")
                {
                }
                field("Certificate No."; "Certificate No.")
                {
                }
            }
            group(Theft)
            {
                Visible = ShowTheft;
                field("Method of Entry to Premises"; "Method of Entry to Premises")
                {
                    Visible = ShowTheft;
                }
                field("Was Alarm Fitted Working"; "Was Alarm Fitted Working")
                {
                    Visible = ShowTheft;
                }
                field("If Not Reasons"; "If Not Reasons")
                {
                    Visible = ShowTheft;
                }
                field("Are Guards Employed"; "Are Guards Employed")
                {
                    Visible = ShowTheft;
                }
                field("Name of Guard Firm"; "Name of Guard Firm")
                {
                    Visible = ShowTheft;
                }
            }
            group(ThirdParty)
            {
                Caption = 'Third Party';
                Visible = ShowThirdParty;
                field("Details of Third Party Claims"; "Details of Third Party Claims")
                {
                    Visible = ShowThirdParty;
                }
                field("Name of third party"; "Name of third party")
                {
                    Visible = ShowThirdParty;
                }
                field("Address of 3rd Party"; "Address of 3rd Party")
                {
                    Visible = ShowThirdParty;
                }
                field("3rd Party Policy No."; "3rd Party Policy No.")
                {
                    Visible = ShowThirdParty;
                }
            }
            group("The Driver")
            {
                Visible = ShowDriver;
                field("Driver's Name"; "Driver's Name")
                {
                    Visible = ShowDriver;
                }
                field("Driver's Age"; "Driver's Age")
                {
                    Visible = ShowDriver;
                }
                field("Drivers Address"; "Drivers Address")
                {
                    Visible = ShowDriver;
                }
                field("Driver's Occupation"; "Driver's Occupation")
                {
                    Visible = ShowDriver;
                }
                field("Other Details"; "Other Details")
                {
                    Caption = 'Driving License No.';
                    Visible = ShowDriver;
                }
            }
            group("The Accident")
            {
                Visible = Showaccident;
                field("When Reported"; "When Reported")
                {
                    Visible = ShowAccident;
                }
                field("Purpose at time of Accident"; "Purpose at time of Accident")
                {
                    Visible = ShowAccident;
                }
                field(Time; Time)
                {
                    Visible = ShowAccident;
                }
                field(Place; Place)
                {
                    Visible = ShowAccident;
                }
                field("Cause ID"; "Cause ID")
                {
                    Visible = ShowAccident;
                }
                field("Cause Description"; "Cause Description")
                {
                    Visible = ShowAccident;
                }
                field("Est. Cost of Repairs"; "Est. Cost of Repairs")
                {
                    Visible = ShowAccident;
                }
                field("Reported to Police"; "Reported to Police")
                {
                    Visible = ShowAccident;
                }
                field("Date Reported"; "Date Reported")
                {
                    Visible = ShowAccident;
                }
                field("Report Reference No"; "Report Reference No")
                {
                    Visible = ShowAccident;
                }
                field("Action Taken by Police"; "Action Taken by Police")
                {
                    Visible = ShowAccident;
                }
                field("Location of Inspection"; "Location of Inspection")
                {
                    Visible = ShowAccident;
                }
                field("Name of Police Station"; "Name of Police Station")
                {
                    Visible = ShowAccident;
                }
                field("Details of damage"; "Details of damage")
                {
                    Visible = ShowAccident;
                }
            }
            group(Closure)
            {
                Caption = 'Closure';
                field("Closure Reason"; "Closure Reason")
                {
                }
                field("Claim Closure Date"; "Claim Closure Date")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Insurance Comment Sheet";
                RunPageLink = "Table Name" = CONST(Claim),
                              "No." = FIELD("Claim No");
            }
            action(Claimants)
            {
                RunObject = Page "Claim involved parties List";
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            action("Effect Minimum Reserves")
            {

                trigger OnAction();
                begin
                    insmgt.GenerateReserve(Rec);
                end;
            }
            action("Dispatch Service/Towing")
            {
            }
            action("Online Map")
            {
                Caption = 'Online Map';
                Image = Map;

                trigger OnAction();
                begin
                    DisplayMap;
                end;
            }
            action("View Policy")
            {
                RunObject = Page "Policy Card CRM";
                RunPageLink = "No." = FIELD("Policy No"),
                              "Document Type" = CONST(Policy);
            }
            action("Assign Service Provider")
            {
                RunObject = Page "Service Provider Appointments";
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            action("Assessor's Report")
            {
                RunObject = Page "Claim Report List";
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            action("Assign Garage")
            {
                RunObject = Page "Claim Garage";
                RunPageLink = "Appointment No." = FIELD("Claim No");
            }
            action("Documents Required")
            {
                RunObject = Page "Claim Documents";
                RunPageLink = "Document Type" = CONST(claim),
                              "Document No" = FIELD("Claim No");
            }
            action("Claim Memorandum")
            {

                trigger OnAction();
                begin
                    ClaimMemo.GetClaimID("Claim No");
                    ClaimMemo.RUN;
                end;
            }
            action("Close Claim")
            {

                trigger OnAction();
                begin
                    IF "Closure Reason" = '' THEN
                        ERROR('Please select the reason for closing the claim')
                    ELSE BEGIN

                        "Claim Closure Date" := WORKDATE;
                        "Claim Status" := "Claim Status"::Closed;
                        VALIDATE("Claim Status");

                        MODIFY;
                        MESSAGE('Claim %1 closed', "Claim No");
                    END;
                end;
            }
            action("Open Claim")
            {

                trigger OnAction();
                begin
                    IF "Claim Status" = "Claim Status"::Open THEN
                        ERROR('The claim is open already')
                    ELSE BEGIN
                        "Claim Status" := "Claim Status"::Open;
                        "Claim Closure Date" := 0D;
                        "Closure Reason" := '';
                        MODIFY;

                    END;
                end;
            }
            action("Claim Reservation")
            {
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Claim Reservation List";
                RunPageLink = "Claim No." = FIELD("Claim No");
            }
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistCurrUser;

                    trigger OnAction();
                    var
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                    begin
                        //IF ApprovalsMgmt.CheckClaimApprovalsWorkflowEnabled(Rec) THEN
                        //    ApprovalsMgmt.OnSendClaimDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = OpenApprovalEntriesExist;
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction();
                    var
                    begin
                        //ApprovalsMgmt.OnCancelClaimApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Claim Type" := "Claim Type"::Motor;
    end;

    var
        insmgt: Codeunit "Insurance management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ClaimMemo: Report "Claim memorandum";
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        ShowAccident: Boolean;
        ShowDriver: Boolean;
        ShowTheft: Boolean;
        LossTypeRec: Record "Loss Type";
        ShowThirdParty: Boolean;
}

