table 51511003 "Request Header"
{
    // version FINANCE

    //LookupPageID = 51511889;

    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnLookup()
            begin

                IF Type = Type::Imprest THEN BEGIN
                    IF Posted THEN
                        PAGE.RUNMODAL(51511910, Rec);
                END ELSE
                    IF Type = Type::PettyCash THEN BEGIN
                        IF Posted THEN
                            PAGE.RUNMODAL(51511996, Rec)
                        /*ELSE
                        PAGE.RUNMODAL(51507245,Rec);*/
                    END;

            end;
        }
        field(2; "Request Date"; Date)
        {
        }
        field(3; "Trip No"; Code[20])
        {
            /* TableRelation = "Travelling Employees"."Request No." WHERE("Employee No." = FIELD("Employee No"),
                                                                         Status = CONST(Released),
                                                                         Used = CONST(False));*/

            trigger OnValidate()
            begin
                /* travelrec.RESET;
                 travelrec.SETRANGE("Request No.", "Trip No");
                 IF travelrec.FIND('-') THEN BEGIN
                     "Local Travel" := travelrec."Local Travel";
                     "International Travel" := travelrec."International Travel";
                     "Destination City" := travelrec."Local Destination";
                     "Destination Country" := travelrec."International Destination";
                     "Trip Start Date" := travelrec."Trip Planned Start Date";
                     "Trip Expected End Date" := travelrec."Trip Planned End Date";
                 END;

                 travelrec.RESET;
                 travelrec.SETRANGE("Request No.", "Trip No");
                 IF travelrec.FIND('-') THEN BEGIN
                     TransType.RESET;
                     TransType.SETRANGE("Per Diem", TRUE);
                     IF TransType.FINDFIRST THEN BEGIN
                         RequestLineRec.RESET;
                         RequestLineRec.SETRANGE("Document No", "No.");
                         RequestLineRec.SETRANGE(Type, TransType.Code);
                         IF NOT RequestLineRec.FIND('-') THEN BEGIN
                             RequestLineRecopy.INIT;
                             RequestLineRecopy."Document No" := "No.";
                             RequestLineRecopy.VALIDATE("Document No");
                             RequestLineRecopy."Line No." := RequestLineRec."Line No." + 10;
                             RequestLineRecopy.Type := TransType.Code;
                             RequestLineRecopy."Transaction Type" := TransType.Code;
                             RequestLineRecopy.Description := travelrec."Reason for Travel";
                             RequestLineRecopy.VALIDATE("Transaction Type");
                             IF "Local Travel" = TRUE THEN BEGIN
                                 RequestLineRecopy."Travel Type" := RequestLineRecopy."Travel Type"::"Local Travel";
                                 RequestLineRecopy.Destination := "Destination City";
                             END;
                             IF "International Travel" = TRUE THEN BEGIN
                                 RequestLineRecopy."Travel Type" := RequestLineRecopy."Travel Type"::"International Travel";
                                 RequestLineRecopy.Destination := "Destination Country";
                             END;

                             RequestLineRec."Unit of Measure" := 'DAYS';
                             RequestLineRecopy.Quantity := "No. of Days";
                             RequestLineRecopy.VALIDATE(Destination);
                             RequestLineRecopy.INSERT;
                         END;
                     END;
                 END;*/
            end;
        }
        field(4; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                /*IF Empl.GET("Employee No") THEN BEGIN
                    "Employee Name" := Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name";
                    "Global Dimension 1 Code" := Empl."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Empl."Global Dimension 2 Code";
                    "Job Group" := Empl."Salary Scale";


                    EmpAccmap.RESET;
                    EmpAccmap.SETFILTER("Employee No.", "Employee No");
                    EmpAccmap.SETFILTER("Loan Type", 'IMPREST');
                    EmpAccmap.FINDSET;
                    "Customer A/C" := EmpAccmap."Customer A/c";
                    VALIDATE("Customer A/C");
                    "Request Date" := TODAY;
                    VALIDATE("Global Dimension 1 Code");
                    VALIDATE("Global Dimension 2 Code");
                    "Transaction Type" := 'IMPREST';

                    VALIDATE("Customer A/C");
                    "Request Date" := TODAY;
                    VALIDATE("Global Dimension 1 Code");
                    VALIDATE("Global Dimension 2 Code");
                END;*/
                /*
               IF Status<>Status::Open THEN
               ERROR('You cannot change this document at this stage');
               */

            end;
        }
        field(5; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Trip Start Date"; Date)
        {
        }
        field(7; "Trip Expected End Date"; Date)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Trip Start Date");
                IF "Trip Expected End Date" < "Trip Start Date" THEN BEGIN
                    ERROR('End Date cannot be earlier than Start date');
                END;
                "No. of Days" := ROUND("Trip Expected End Date" - "Trip Start Date", 1, '>');
                MODIFY;
                //SalesSetup.GET;
                // "Deadline for Return" :=CALCDATE(FORMAT(SalesSetup."No. of Days to Claim Imprest")+'D',"Trip Expected End Date");
                //Daterec.RESET;

                //Daterec.SETFILTER(daterec.

                //  IF "Deadline for Return"<>0D THEN
                //  BEGIN
                //  NextWorkingDate:="Deadline for Return";
                //  REPEAT
                //  IF NOT CalendarMgmt.CheckDateStatus(BaseCalendar.Code,NextWorkingDate,Description) THEN
                //  NoOfWorkingDays:=NoOfWorkingDays+1;
                //
                //  NextWorkingDate:=CALCDATE('1D',NextWorkingDate);
                //
                //  UNTIL NoOfWorkingDays=SalesSetup."No. of Days to Claim Imprest";
                //  END;
                //
                //  "Deadline for Return":=NextWorkingDate;
            end;
        }
        field(8; "No. of Days"; Decimal)
        {
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(10; "No. Series"; Code[20])
        {
        }
        field(11; "Deadline for Return"; Date)
        {
            Editable = true;
        }
        field(12; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected;

            trigger OnValidate()
            begin
                IF Status = Status::Released THEN BEGIN
                    Rec.CALCFIELDS("Total Amount Requested");
                    //Imprest and Imprest Surrender
                    //Commit Imprest Amount
                    IF Type = Type::Imprest THEN BEGIN
                        IF Committed = FALSE THEN BEGIN
                            PurchLine.RESET;
                            PurchLine.SETRANGE("Document No", "No.");
                            IF PurchLine.FIND('-') THEN BEGIN
                                REPEAT
                                    Factory.FnCommitAmount(PurchLine.Amount, PurchLine."Account No", PurchLine."Current Budget", PurchLine."Document No", CommitOpt::IMPREST, PurchLine."Global Dimension 1 Code", PurchLine."Global Dimension 2 Code", "Activity Date",
                                          CommitOpt1::Commitment, PurchLine."Global Dimension 3 Code");
                                UNTIL PurchLine.NEXT = 0;
                            END;
                        END;
                        Committed := TRUE;
                    END;
                    //Reverse Imprest commitment
                    /*
                    IF Type=Type::"Claim-Accounting" THEN BEGIN
                      IF "Commitment Reversed"=FALSE THEN BEGIN
                        PurchLine.RESET;
                        PurchLine.SETRANGE("Document No","Imprest/Advance No");
                        IF PurchLine.FIND('-') THEN BEGIN
                          REPEAT
                     Factory.FnCommitAmount(-PurchLine.Amount,PurchLine."Account No",PurchLine."Current Budget",PurchLine."Document No",CommitOpt::IMPREST,PurchLine."Global Dimension 1 Code",PurchLine."Global Dimension 2 Code","Activity Date",
                            CommitOpt1::Reversal,PurchLine."Global Dimension 3 Code");
                            UNTIL PurchLine.NEXT=0;
                          END;
                        END;
                        "Commitment Reversed":=FALSE;
                      END;
                      */
                    //Petty Cash And Petty Cash Surrender
                    //Commit Petty Cash Amount
                    IF Type = Type::PettyCash THEN BEGIN
                        IF Committed = FALSE THEN BEGIN
                            PurchLine.RESET;
                            PurchLine.SETRANGE("Document No", "No.");
                            IF PurchLine.FIND('-') THEN BEGIN
                                REPEAT
                                    Factory.FnCommitAmount(PurchLine.Amount, PurchLine."Account No", PurchLine."Current Budget", PurchLine."Document No", CommitOpt::PV, PurchLine."Global Dimension 1 Code", PurchLine."Global Dimension 2 Code", "Activity Date",
                                           CommitOpt1::Commitment, PurchLine."Global Dimension 3 Code");
                                UNTIL PurchLine.NEXT = 0;
                            END;
                        END;
                        Committed := TRUE;
                    END;
                    //Reverse Petty Cash commitment
                    IF Type = Type::"PettyCash Claim" THEN BEGIN
                        IF "Commitment Reversed" = FALSE THEN BEGIN
                            PurchLine.RESET;
                            PurchLine.SETRANGE("Document No", "Imprest/Advance No");
                            IF PurchLine.FIND('-') THEN BEGIN
                                REPEAT
                                    Factory.FnCommitAmount(-PurchLine.Amount, PurchLine."Account No", PurchLine."Current Budget", PurchLine."Document No", CommitOpt::PV, PurchLine."Global Dimension 1 Code", PurchLine."Global Dimension 2 Code", "Activity Date",
                                          CommitOpt1::Reversal, PurchLine."Global Dimension 3 Code");
                                UNTIL PurchLine.NEXT = 0;
                            END;
                        END;
                        "Commitment Reversed" := FALSE;
                    END;
                END;

            end;
        }
        field(13; Type; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Purchase Requisition,Store Requisition,Imprest,Claim-Accounting,Appointment,Payment Voucher,Leave Application,Training Request,Transport Request,Recruitment Request,Telephone Request,Appraisal,Communication Requests,Legal Request,Visits to Utilities,Refund,Journal,Normal,PettyCash,PettyCash Refund,PettyCash Claim,Claim/Refund,Memo,Car Loan';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Purchase Requisition","Store Requisition",Imprest,"Claim-Accounting",Appointment,"Payment Voucher","Leave Application","Training Request","Transport Request","Recruitment Request","Telephone Request",Appraisal,"Communication Requests","Legal Request","Visits to Utilities",Refund,Journal,Normal,PettyCash,"PettyCash Refund","PettyCash Claim","Claim/Refund",Memo,"Car Loan";
        }
        field(14; "User ID"; Code[50])
        {
        }
        field(15; "Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(16; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = FILTER(Standard));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");

                /*PurchaseReqDet.RESET;
                PurchaseReqDet.SETRANGE(PurchaseReqDet."Requistion No.","Requisition No.");
                
                IF PurchaseReqDet.FIND('-') THEN  BEGIN
                REPEAT
                PurchaseReqDet."Global Dimension 2 Code":="Global Dimension 2 Code";
                PurchaseReqDet.MODIFY;
                UNTIL PurchaseReqDet.NEXT=0;
                 END;
                 */

            end;
        }
        field(17; "Transaction Type"; Code[20])
        {
            NotBlank = true;
            //TableRelation = "Loan Product Type" WHERE(Internal = CONST(True));

            trigger OnValidate()
            begin
                IF Status <> Status::Open THEN
                    ERROR('You cannot change this document at this stage');

                /* IF EmpAccmap.GET("Employee No","Transaction Type") THEN
                  BEGIN
                  "Customer A/C":=EmpAccmap."Customer A/c";
                  END; */

                /*
                 IF Customer.GET("Customer A/C") THEN
                 BEGIN
                 IF Type=Type::Imprest THEN
                 BEGIN
                Customer.CALCFIELDS(Customer.Balance);IF Customer.Balance>0 THEN
                ERROR('You have a balance of KES %1 in your account and cannot proceed, account for the imprest first',Customer.Balance);
                 END;
                
                 END;
                */

                IF Type = Type::Imprest THEN BEGIN
                    /* EmpAccmap.RESET;
                    EmpAccmap.SETFILTER(EmpAccmap."Customer A/c", "Customer A/C");
                    EmpAccmap.FINDSET;

                    IF EmpAccmap."Customer A/c" = '' THEN
                        ERROR('Your Account has not been created and Mapped appropriately-Contact Finance Department for creation of the Account'); */
                END;

                IF Customer.GET("Customer A/C") THEN BEGIN
                    IF Type = Type::Imprest THEN BEGIN
                        Customer.CALCFIELDS(Customer.Balance);
                        IF Customer.Balance > 0 THEN
                            ERROR('You have a balance of KES %1 in your account and cannot proceed, account for the imprest first', Customer.Balance);
                    END;

                END;

            end;
        }
        field(18; "Customer A/C"; Code[20])
        {
            TableRelation = Customer."No.";

            trigger OnValidate()
            begin
                //Customer.No. WHERE (External Customer=FIELD(External))
            end;
        }
        field(19; "Imprest Amount"; Decimal)
        {
            CalcFormula = Sum("Request Lines".Amount WHERE("Document No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(20; Balance; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("Customer A/C")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(21; Country; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(22; City; Code[10])
        {
            TableRelation = "Post Code";

            trigger OnValidate()
            begin
                /*PostRec.RESET;
                PostRec.SETRANGE(Code,City);
                IF PostRec.FIND('-') THEN BEGIN
                "City Name":=PostRec.City;
                
                  IF Empl.GET("Employee No") THEN BEGIN
                  ImpRates.RESET;
                  ImpRates.SETRANGE("County Code",City);
                  ImpRates.SETRANGE("Job Grade",Empl."Salary Scale");
                  IF ImpRates.FIND('-') THEN BEGIN
                
                  CALCFIELDS("Imprest Amount");
                    IF "Imprest Amount" > ImpRates.Amount THEN
                    ERROR(Text002,"Imprest Amount",ImpRates.Amount,PostRec.City,PostRec.Code);
                    END;
                  END;
                END ELSE
                "City Name":='';
                */

            end;
        }
        field(23; "Job Group"; Code[10])
        {
            Editable = false;
            //TableRelation = "Salary Scales";
        }
        field(24; "Imprest/Advance No"; Code[20])
        {

            trigger OnValidate()
            begin
                IF RequestRec.GET("Imprest/Advance No") THEN BEGIN

                    RequestRec.CALCFIELDS("Accountable Expenses");
                    IF RequestRec."Accountable Expenses" = 0 THEN
                        ERROR(Text000);
                    "Trip No" := RequestRec."Trip No";
                    // Country := TripRec.Country;
                    // City := TripRec.City;
                    "Employee No" := RequestRec."Employee No";
                    "Employee Name" := RequestRec."Employee Name";
                    "Transaction Type" := RequestRec."Transaction Type";
                    "Global Dimension 1 Code" := RequestRec."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := RequestRec."Global Dimension 2 Code";
                    "Customer A/C" := RequestRec."Customer A/C";
                    "Imprest Type" := RequestRec."Imprest Type";
                    "Purpose of Imprest" := RequestRec."Purpose of Imprest";

                    RequestRec.CALCFIELDS(RequestRec."Imprest Amount");
                    "Total Amount Requested" := RequestRec."Imprest Amount";
                    RequestLineRec.RESET;
                    RequestLineRec.SETRANGE(RequestLineRec."Document No", "Imprest/Advance No");
                    IF RequestLineRec.FIND('-') THEN
                        REPEAT
                            RequestLineRecopy.TRANSFERFIELDS(RequestLineRec);
                            RequestLineRecopy.Surrender := TRUE;
                            IF RequestLineRecopy."Account No" = '' THEN BEGIN
                                RequestLineRecopy."Account No" := RequestLineRecopy.Activity;
                            END;
                            RequestLineRecopy."Requested Amount" := RequestLineRec.Amount;
                            RequestLineRecopy."Global Dimension 1 Code" := RequestLineRec."Global Dimension 1 Code";
                            RequestLineRecopy."Global Dimension 2 Code" := RequestLineRec."Global Dimension 2 Code";
                            RequestLineRecopy."Global Dimension 3 Code" := RequestLineRec."Global Dimension 3 Code";
                            RequestLineRecopy."Document No" := "No.";
                            IF NOT RequestLineRecopy.GET(RequestLineRecopy."Document No", RequestLineRecopy."Line No.") THEN
                                RequestLineRecopy.INSERT;

                        UNTIL RequestLineRec.NEXT = 0;


                    IF Payments.GET(RequestRec."Attached to PV No") THEN BEGIN
                        IF Payments.Posted = FALSE THEN
                            ERROR('Payment Voucher Number %1 has not been posted!', RequestRec."Attached to PV No");
                        "Applies-to Doc. No." := RequestRec."Attached to PV No";
                    END;
                    IF RequestRec.Type = RequestRec.Type::PettyCash THEN BEGIN

                        "Applies-to Doc. No." := RequestRec."No.";
                    END;
                    IF RequestRec.Training = TRUE THEN BEGIN
                        Training := RequestRec.Training;
                        "Local Travel" := RequestRec."Local Travel";
                        "International Travel" := RequestRec."International Travel";
                        "Destination City" := RequestRec."Destination City";
                        "Destination Country" := RequestRec."Destination Country";
                    END;

                END;
            end;
        }
        field(25; Posted; Boolean)
        {
            Editable = true;
        }
        field(26; "Applies-to Doc. No."; Code[20])
        {
        }
        field(27; "Total Amount Requested"; Decimal)
        {
            CalcFormula = Sum("Request Lines"."Requested Amount" WHERE("Document No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(28; "CBK Website Address"; Text[250])
        {
        }
        field(29; "No of Approvals"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(33; Surrendered; Boolean)
        {
        }
        field(38; "Remaining Amount"; Decimal)
        {
            CalcFormula = Sum("Request Lines"."Remaining Amount" WHERE("Document No" = FIELD("No."),
                                                                        Surrender = CONST(True)));
            FieldClass = FlowField;
        }
        field(39; "Receipt Created"; Boolean)
        {
        }
        field(44; "Cheque No"; Code[20])
        {
        }
        field(53; "Actual Amount"; Decimal)
        {
            CalcFormula = Sum("Request Lines"."Actual Spent" WHERE("Document No" = FIELD("No."),
                                                                    Surrender = CONST(True)));
            FieldClass = FlowField;
        }
        field(54; "Imprest Type"; Option)
        {
            OptionCaption = 'Individual,Group';
            OptionMembers = Individual,Group;
        }
        field(55; "Pay Mode"; Code[30])
        {
            NotBlank = true;
            TableRelation = "Pay Modes".Code;
        }
        field(56; "Accountable Expenses"; Integer)
        {
            CalcFormula = Count("Request Lines" WHERE("Document No" = FIELD("No."),
                                                       "Expense Type" = CONST("Accountable Expenses")));
            FieldClass = FlowField;
        }
        field(57; "Non Accountable Expenses"; Integer)
        {
            CalcFormula = Count("Request Lines" WHERE("Document No" = FIELD("No."),
                                                       "Expense Type" = CONST("Non-Accountable Expenses")));
            FieldClass = FlowField;
        }
        field(59; "Date Finance Received"; Date)
        {
        }
        field(60; "Activity Date"; Date)
        {
        }
        field(50019; "Language Code (Default)"; Code[10])
        {
        }
        field(50020; Attachement; Option)
        {
            OptionMembers = No,Yes;
        }
        field(50021; "External Application"; Option)
        {
            Description = 'Apply on behalf of external stakeholders';
            OptionMembers = No,Yes;
        }
        field(50022; "Employee/Commissioner"; Option)
        {
            OptionMembers = Commissioner,Employee;
        }
        field(50023; "Imprest Balance"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE("Customer No." = FIELD("Customer A/C"),
                                                                                 "Loan No" = FIELD("No.")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //Sum("Detailed Cust. Ledg. Entry"."Debit Amount" WHERE (Customer No.=FIELD(Customer A/C), Loan No=FIELD(No.)))
            end;
        }
        field(50024; "Claim accounting Balance"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("Customer A/C"),
                                                                         "Loan No" = FIELD("Imprest/Advance No")));
            FieldClass = FlowField;

            trigger OnValidate()
            begin
                //Sum("Detailed Cust. Ledg. Entry".Amount WHERE (Customer No.=FIELD(Customer A/C), Loan No=FIELD(Imprest/Advance No)))
            end;
        }
        field(50025; Archived; Boolean)
        {
        }
        field(50026; Select; Boolean)
        {
        }
        field(50027; "Recover from Payroll"; Boolean)
        {
        }
        field(50028; "Transferred to Payroll"; Boolean)
        {
        }
        field(50029; "Request Type"; Option)
        {
            OptionCaption = ' ,Training,Transport,Imprest,Meal,Taxi';
            OptionMembers = " ",Training,Transport,Imprest,Meal,Taxi;
        }
        field(50030; "Request No"; Code[20])
        {
            /*TableRelation = IF ("Request Type" = CONST(Training)) "Training Request"
            ELSE
            IF ("Request Type" = CONST(Transport)) "Transport Request"
            ELSE
            IF ("Request Type" = CONST(Imprest)) "Request Header";*/
        }
        field(50031; "Issued Amount"; Decimal)
        {
        }
        field(50032; "Remaining Imprest Amount"; Decimal)
        {
        }
        field(50033; Partial; Boolean)
        {
        }
        field(50034; "Partial Imprests"; Code[20])
        {
            TableRelation = "Partial Imprest Issue"."Imprest No" WHERE("Imprest No" = FIELD("Imprest/Advance No"),
                                                                        Posted = FILTER(true));

            trigger OnValidate()
            begin
                PartialRec.RESET;
                PartialRec.SETRANGE("Imprest No", "Partial Imprests");
                PartialRec.SETRANGE("Select to Surrender", TRUE);
                IF PartialRec.FIND('-') THEN BEGIN
                    RequestRec.RESET;
                    RequestRec.SETRANGE("No.", "Partial Imprests");
                    IF RequestRec.FIND('-') THEN BEGIN
                        RequestRec.CALCFIELDS("Accountable Expenses");
                        IF RequestRec."Accountable Expenses" = 0 THEN
                            ERROR(Text000);
                        "Trip No" := RequestRec."Trip No";
                        //Country := TripRec.Country;
                        //City := TripRec.City;
                        "Employee No" := RequestRec."Employee No";
                        "Employee Name" := RequestRec."Employee Name";
                        "Transaction Type" := RequestRec."Transaction Type";
                        "Global Dimension 1 Code" := RequestRec."Global Dimension 1 Code";
                        "Global Dimension 2 Code" := RequestRec."Global Dimension 2 Code";
                        "Customer A/C" := RequestRec."Customer A/C";
                        "Customer A/C Name" := RequestRec."Customer A/C Name";
                        "Imprest Type" := RequestRec."Imprest Type";

                        RequestRec.CALCFIELDS(RequestRec."Imprest Amount");

                        "Total Amount Requested" := RequestRec."Imprest Amount";
                        RequestLineRec.RESET;
                        RequestLineRec.SETRANGE(RequestLineRec."Document No", "Imprest/Advance No");
                        IF RequestLineRec.FIND('-') THEN
                            REPEAT
                                RequestLineRecopy.TRANSFERFIELDS(RequestLineRec);
                                RequestLineRecopy.Amount := PartialRec."Amount to Issue";
                                RequestLineRecopy."Document No" := "No.";
                                IF NOT RequestLineRecopy.GET(RequestLineRecopy."Document No", RequestLineRecopy."Line No.") THEN
                                    RequestLineRecopy.INSERT;

                            UNTIL RequestLineRec.NEXT = 0;

                    END;
                END;
            end;
        }
        field(50035; "PV Created"; Boolean)
        {
        }
        field(50036; Paid; Boolean)
        {
        }
        field(50037; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(50038; "Account No."; Code[20])
        {
        }
        field(50039; Amount; Decimal)
        {
        }
        field(50040; Description; Text[250])
        {
        }
        field(50041; "User Remarks"; Text[30])
        {
        }
        field(50042; "Cheque Date"; Date)
        {
        }
        field(50043; "Purpose of Imprest"; Text[150])
        {
        }
        field(50044; "Customer A/C Name"; Text[50])
        {
        }
        field(50045; "Posted Date"; Date)
        {

            trigger OnValidate()
            begin
                CASE Type OF
                    Type::PettyCash:
                        BEGIN
                            //Get the PettyCash Deadline Date
                            CashMgt.GET;
                            IF "Posted Date" <> 0D THEN
                                "Deadline for Return" := CALCDATE(CashMgt."Petty Cash Due Date", "Activity End Date");
                        END;
                    Type::Imprest:
                        BEGIN
                            //Get the Imprest Deadline Date
                            CashMgt.GET;
                            IF "Posted Date" <> 0D THEN
                                "Deadline for Return" := CALCDATE(CashMgt."Imprest Due Date", "Activity End Date");
                        END;

                END;
            end;
        }
        field(50046; "Posted Time"; Time)
        {
        }
        field(50047; "Posted By"; Code[30])
        {
        }
        field(50048; "PettyCash At Finance"; Boolean)
        {
        }
        field(50050; "Interaction Group Code"; Code[10])
        {
            Caption = 'Interaction Group Code';
            TableRelation = "Interaction Group";
        }
        field(50051; "Subject (Default)"; Text[50])
        {
            Caption = 'Subject (Default)';

            trigger OnValidate()
            var
                SegInteractLanguage: Record 5104;
                UpdateLines: Boolean;
            begin
            end;
        }
        field(50052; "Attachment No."; Integer)
        {
            Caption = 'Attachment No.';
            Editable = false;

            trigger OnValidate()
            var
                Attachment: Record 5062;
            begin
            end;
        }
        field(50053; "Interaction Template Code"; Code[50])
        {
            Caption = 'Interaction Template Code';
            TableRelation = "Interaction Template";

            trigger OnValidate()
            begin
                //UpdateSegLines(FIELDCAPTION("Interaction Template Code"),CurrFieldNo <> 0);
            end;
        }
        field(50054; "City Name"; Text[30])
        {
            Editable = false;
        }
        field(50055; "Imprest Purpose"; Option)
        {
            OptionCaption = 'DSA,OTHER';
            OptionMembers = DSA,OTHER;
        }
        field(50056; "Approval Date"; Date)
        {
        }
        field(50057; External; Boolean)
        {

            trigger OnValidate()
            begin
                IF External = TRUE THEN BEGIN
                    "Original Customer" := "Customer A/C";
                    "Customer A/C" := '';
                    MESSAGE('Please Select An External Customer');
                END;
                IF External = FALSE THEN BEGIN
                    "Customer A/C" := "Original Customer";
                END;
            end;
        }
        field(50058; "Original Customer"; Code[50])
        {
            TableRelation = Customer;
        }
        field(50059; "Attached to PV No"; Code[50])
        {
            FieldClass = Normal;
        }
        field(50060; "Approved Date"; Date)
        {
        }
        field(50061; "PV Posted"; Boolean)
        {
            CalcFormula = Lookup(Payments1.Posted WHERE(No = FIELD("Attached to PV No")));
            FieldClass = FlowField;
        }
        field(50062; "Petty Cash Serials"; Code[20])
        {
            Caption = 'Petty Cash No';
        }
        field(50063; "From Memo"; Boolean)
        {
        }
        field(50064; "Local Travel"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Local Travel" = TRUE THEN BEGIN
                    "International Travel" := FALSE;
                END;
                IF "Local Travel" = FALSE THEN BEGIN
                    "International Travel" := TRUE;
                END;
                //VALIDATE("International Travel");
            end;
        }
        field(50065; "International Travel"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "International Travel" = TRUE THEN BEGIN
                    "Local Travel" := FALSE;
                END;
                IF "International Travel" = FALSE THEN BEGIN
                    "Local Travel" := TRUE;
                END;
                //VALIDATE("Local Travel");
            end;
        }
        field(50066; "Destination City"; Code[100])
        {
            TableRelation = "SRC Cluster Places"."Cluster Place";
        }
        field(50067; "Destination Country"; Code[50])
        {
            TableRelation = "Country/Region";
        }
        field(50068; "Department Name"; Text[250])
        {
            Editable = false;
        }
        field(50069; "Training Code"; Code[20])
        {
            /*TableRelation = "Training Participants"."Training Request" WHERE("Employee No" = FIELD("Employee No"),
                                                                              Attendance = CONST("Not Attended"));*/

            trigger OnValidate()
            begin
                /* trainingrec.RESET;
                IF trainingrec.GET("Training Code") THEN BEGIN
                    IF trainingrec."Local Travel" = TRUE THEN BEGIN
                        "Local Travel" := TRUE;
                        "International Travel" := FALSE;
                        "Destination City" := trainingrec."Local Destination";
                        "Destination Country" := '';
                        "Trip Start Date" := trainingrec."Planned Start Date";
                        "Trip Expected End Date" := trainingrec."Planned End Date";
                        VALIDATE("Trip Expected End Date");

                        RequestLineRec.RESET;
                        RequestLineRec.SETFILTER("Document No", "No.");
                        IF RequestLineRec.FINDLAST THEN BEGIN
                            RequestLineRecopy.INIT;
                            RequestLineRecopy."Document No" := "No.";
                            RequestLineRecopy."Line No." := RequestLineRec."Line No." + 10;
                            RequestLineRecopy.Description := 'Perdim-Local Training: ' + trainingrec."Training Objective";
                            RequestLineRecopy.Type := 'DSA';
                            RequestLineRec."Unit of Measure" := 'DAYS';
                            RequestLineRecopy.Quantity := trainingrec."No. Of Days";
                            //RequestLineRec.Type:=RequestLineRec.Type:
                            RequestLineRecopy."Unit Price" := trainingrec."Per Diem";
                            RequestLineRecopy.VALIDATE("Unit Price");
                            RequestLineRecopy.Amount := trainingrec."Per Diem";
                            RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                            RequestLineRecopy.Activity := trainingrec."GL Account";
                            RequestLineRecopy.INSERT;

                        END;
                        RequestLineRec.RESET;
                        RequestLineRec.SETFILTER("Document No", "No.");
                        IF NOT RequestLineRec.FINDLAST THEN BEGIN
                            RequestLineRecopy.INIT;
                            RequestLineRecopy."Document No" := "No.";
                            RequestLineRecopy."Line No." := 10;
                            RequestLineRecopy.Description := 'Perdim-Local Training: ' + trainingrec."Training Objective";
                            RequestLineRecopy.Type := 'DSA';
                            RequestLineRecopy."Unit of Measure" := 'DAYS';
                            RequestLineRecopy.Quantity := trainingrec."No. Of Days";
                            RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                            RequestLineRecopy."Unit Price" := trainingrec."Perdiem Per Day";
                            RequestLineRecopy.VALIDATE("Unit Price");
                            RequestLineRecopy.Amount := (trainingrec."No. Of Days" * trainingrec."Perdiem Per Day");//trainingrec."Per Diem";

                            RequestLineRecopy.Activity := trainingrec."GL Account";
                            RequestLineRecopy.INSERT;
                        END;
                    END;
                    IF trainingrec."International Travel" = TRUE THEN BEGIN
                        "International Travel" := TRUE;
                        "Local Travel" := FALSE;
                        "Destination City" := '';
                        "Destination Country" := trainingrec."International Destination";
                        "Trip Start Date" := trainingrec."Planned Start Date";
                        "Trip Expected End Date" := trainingrec."Planned End Date";
                        VALIDATE("Trip Expected End Date");
                        RequestLineRec.RESET;
                        RequestLineRec.SETFILTER("Document No", "No.");
                        IF RequestLineRec.FINDLAST THEN BEGIN
                            RequestLineRecopy.INIT;
                            RequestLineRecopy."Document No" := "No.";
                            RequestLineRecopy."Line No." := RequestLineRec."Line No." + 10;
                            RequestLineRecopy.Description := 'Perdiem-Internationa Training:' + trainingrec."Training Objective";
                            RequestLineRecopy.Type := 'DSA';
                            RequestLineRec."Unit of Measure" := 'DAYS';
                            RequestLineRecopy.Quantity := trainingrec."No. Of Days";
                            //RequestLineRec.Type:=RequestLineRec.Type:
                            RequestLineRecopy."Unit Price" := trainingrec."Per Diem" / RequestLineRecopy.Quantity;
                            //RequestLineRecopy.VALIDATE("Unit Price");
                            RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                            RequestLineRecopy.Amount := 0;
                            RequestLineRecopy."USD Amount" := RequestLineRecopy.Quantity * RequestLineRecopy."Unit Price";
                            RequestLineRecopy.Activity := trainingrec."GL Account";
                            RequestLineRecopy.INSERT;

                        END;
                        RequestLineRec.RESET;
                        RequestLineRec.SETFILTER("Document No", "No.");
                        IF NOT RequestLineRec.FINDLAST THEN BEGIN
                            RequestLineRecopy.INIT;
                            RequestLineRecopy."Document No" := "No.";
                            RequestLineRecopy."Line No." := 10;
                            RequestLineRecopy.Description := 'Perdiem-Internationa Training:' + trainingrec."Training Objective";
                            RequestLineRecopy.Type := 'DSA';
                            RequestLineRecopy."Unit of Measure" := 'DAYS';
                            RequestLineRecopy.Quantity := trainingrec."No. Of Days";
                            RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                            RequestLineRecopy."Unit Price" := trainingrec."Per Diem" / RequestLineRecopy.Quantity;
                            RequestLineRecopy.Amount := 0;
                            RequestLineRecopy."USD Amount" := RequestLineRecopy.Quantity * RequestLineRecopy."Unit Price";
                            // RequestLineRecopy.VALIDATE("Unit Price");
                            RequestLineRecopy.Activity := trainingrec."GL Account";
                            RequestLineRecopy.INSERT;

                        END;
                    END;
                END; */
            end;
        }
        field(50070; Training; Boolean)
        {

            trigger OnValidate()
            begin
                "Local Travel2" := FALSE;
                "International Travel2" := FALSE;
            end;
        }
        field(50071; "Training Evaluation"; Code[20])
        {

            trigger OnValidate()
            begin
                //"Training Evaluation".No. WHERE (Employee No=FIELD(Employee No), Status=CONST(Released), Used=CONST(False))
            end;
        }
        field(50072; Memo; Boolean)
        {
        }
        field(50073; "Memo No"; Code[50])
        {

            trigger OnValidate()
            begin
                //"ERC Memo"."Memo No"
            end;
        }
        field(50074; "Local Travel2"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "Local Travel2" = TRUE THEN BEGIN
                    "International Travel2" := FALSE;
                    "International Travel" := FALSE;

                END;
                IF "Local Travel2" = FALSE THEN BEGIN
                    "International Travel2" := TRUE;
                    "International Travel" := TRUE;
                END;
                //VALIDATE("International Travel");
            end;
        }
        field(50075; "International Travel2"; Boolean)
        {

            trigger OnValidate()
            begin
                IF "International Travel2" = TRUE THEN BEGIN
                    "Local Travel2" := FALSE;
                    "Local Travel" := FALSE;
                    "International Travel" := TRUE;
                END;
                IF "International Travel2" = FALSE THEN BEGIN
                    "Local Travel2" := TRUE;
                    "Local Travel" := FALSE;
                    "International Travel" := FALSE;
                END;
                //VALIDATE("Local Travel");
            end;
        }
        field(50076; "Destination City2"; Code[100])
        {
            TableRelation = "SRC Cluster Places"."Cluster Place";

            trigger OnValidate()
            begin
                Empl.RESET;
                Empl.GET("Employee No");

                IF "Local Travel2" = TRUE THEN BEGIN
                    Clusterrec.SETFILTER("Cluster Place", "Destination City2");
                    IF Clusterrec.FINDSET THEN BEGIN
                        srcscaleslocal.RESET;
                        /*IF srcscaleslocal.GET(Empl."Salary Scale", Clusterrec."Cluster Code") THEN BEGIN
                            UnitPriceAmt := srcscaleslocal.Amount;
                        END;*/
                    END;
                END;
                IF "International Travel2" = TRUE THEN BEGIN
                    scrscalesinter.RESET;
                    /*IF scrscalesinter.GET(Empl."Salary Scale", "Destination Country2") THEN BEGIN
                        UnitPriceAmt := scrscalesinter.Amount;
                    END;*/
                END;

                /*dimensionvalue.RESET;
                dimensionvalue.GET('EMPLOYEES',"Employee No");
                IF dimensionvalue."Employee Region"="Destination City2" THEN BEGIN
                        UnitPriceAmt:=0;
                END;
                */
                IF UnitPriceAmt <> 0 THEN BEGIN
                    CreateLinesPerdiem(UnitPriceAmt);
                END;


            end;
        }
        field(50077; "Destination Country2"; Code[100])
        {
            TableRelation = "Country/Region".Code;

            trigger OnValidate()
            begin
                Empl.RESET;
                Empl.GET("Employee No");
                IF "Local Travel2" = TRUE THEN BEGIN
                    Clusterrec.SETFILTER("Cluster Place", "Destination City2");
                    IF Clusterrec.FINDSET THEN BEGIN
                        srcscaleslocal.RESET;
                        /*IF srcscaleslocal.GET(Empl."Salary Scale", Clusterrec."Cluster Code") THEN BEGIN
                            UnitPriceAmt := srcscaleslocal.Amount;
                        END;*/
                    END;
                END;
                IF "International Travel2" = TRUE THEN BEGIN
                    scrscalesinter.RESET;
                    /*IF scrscalesinter.GET(Empl."Salary Scale", "Destination Country2") THEN BEGIN
                        UnitPriceAmt := scrscalesinter.Amount;
                    END;*/
                END;

                IF UnitPriceAmt <> 0 THEN BEGIN
                    CreateLinesPerdiem(UnitPriceAmt);
                END;

            end;
        }
        field(50078; "Oustanding on Client"; Boolean)
        {
            CalcFormula = Lookup("Cust. Ledger Entry".Open WHERE("Document No." = FIELD("Attached to PV No"),
                                                                  "Customer No." = FIELD("Customer A/C")));
            FieldClass = FlowField;
        }
        field(50079; "Days Allowed"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50080; "Activity End Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //SalesSetup.GET;
                //"Deadline for Return":=CALCDATE(SalesSetup."Days Allowed","Activity End Date");
                CASE Type OF
                    Type::PettyCash:
                        BEGIN
                            //Get the PettyCash Deadline Date
                            CashMgt.GET;
                            IF "Activity End Date" <> 0D THEN
                                "Deadline for Return" := CALCDATE(CashMgt."Petty Cash Due Date", "Activity End Date");
                        END;
                    Type::Imprest:
                        BEGIN
                            //Get the Imprest Deadline Date
                            CashMgt.GET;
                            IF "Activity End Date" <> 0D THEN
                                "Deadline for Return" := CALCDATE(CashMgt."Imprest Due Date", "Activity End Date");

                        END;

                END;
            end;
        }
        field(50081; Committed; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50082; "Commitment Reversed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50083; Travel; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50084; Vote; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Employee No")
        {
        }
        key(Key3; "Employee Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Petty Cash Serials", "Employee No", "Employee Name")
        {
        }
    }

    trigger OnDelete()
    begin
        //ERROR('You are not allowed to delete a record');

        IF Status <> Status::Open THEN
            ERROR('You are not allowed to delete a record at this stage');
    end;

    trigger OnInsert()
    var
    //reheader: Record "Request Header";
    begin

        IF (Type = Type::Imprest) AND ("No." = '') THEN BEGIN
            SalesSetup.GET;
            SalesSetup.TESTFIELD(SalesSetup."Imprest Nos.");
            NoSeriesMgt.InitSeries(SalesSetup."Imprest Nos.", xRec."No.", 0D, "No.", "No. Series");
        END;
        IF UsersRec.GET(USERID) THEN BEGIN

            IF Empl.GET(UsersRec."Employee No.") THEN BEGIN
                "Employee No" := Empl."No.";
                "Employee Name" := Empl."First Name" + ' ' + Empl."Last Name";
                "Global Dimension 1 Code" := Empl."Global Dimension 1 Code";
                "Global Dimension 2 Code" := Empl."Global Dimension 2 Code";
                dimvalue.RESET;
                IF "Global Dimension 1 Code" <> '' THEN BEGIN
                    dimvalue.GET('DEPARTMENT', "Global Dimension 1 Code");
                    "Department Name" := dimvalue.Name;
                END;
                //"Job Group" := Empl."Salary Scale";
                // EmpAccmap.RESET;
                // EmpAccmap.SETFILTER("Employee No.", "Employee No");
                // EmpAccmap.SETFILTER("Loan Type", 'IMPREST');
                // EmpAccmap.FINDSET;
                //"Customer A/C" := EmpAccmap."Customer A/c";
                VALIDATE("Customer A/C");
                "Request Date" := TODAY;
                VALIDATE("Global Dimension 1 Code");
                VALIDATE("Global Dimension 2 Code");
                "Transaction Type" := 'IMPREST';
                //"Procurement Plan":=PurchSetup."Effective Procurement Plan";

                //===============================================================================
                IF Type = Type::"Claim/Refund" THEN BEGIN
                    reheader1.RESET;
                    reheader1.SETFILTER(reheader1."User ID", USERID);
                    reheader1.SETFILTER(reheader1.Status, '<>%1', reheader1.Status::Released);
                    reheader1.SETFILTER(reheader1.Type, '%1', reheader1.Type::"Claim/Refund");
                    IF reheader1.FINDSET THEN BEGIN
                        //  ERROR('You have Open Claim Entries. Please Re-use those open Entries First Before Creating a new one!!!');
                    END;
                    SalesSetup.GET; //error('3....99');
                    SalesSetup.TESTFIELD(SalesSetup."Claim Nos.");
                    NoSeriesMgt.InitSeries(SalesSetup."Claim Nos.", xRec."No.", 0D, "No.", "No. Series");
                    //NoSeriesMgt.InitSeries(SalesSetup."File Movement Numbers",xRec."File Movement Code",0D,"File Movement Code","No. Series");
                END;
                //===============================================================================
                IF Type = Type::Imprest THEN BEGIN
                    reheader1.RESET;
                    reheader1.SETFILTER(reheader1."User ID", USERID);
                    reheader1.SETFILTER(reheader1.Status, '<>%1', reheader1.Status::Released);
                    reheader1.SETFILTER(reheader1.Type, '%1', reheader1.Type::Imprest);
                    IF reheader1.FINDSET THEN BEGIN
                        //ERROR('You have Imprest Entries that have not been Approved!!!');
                    END;

                    "Transaction Type" := 'IMPREST';
                    //EmpAccmap.RESET;
                    //EmpAccmap.SETFILTER("Employee No.", "Employee No");
                    //EmpAccmap.SETFILTER("Loan Type", 'IMPREST');
                    //EmpAccmap.FINDSET;
                    //"Customer A/C" := EmpAccmap."Customer A/c";
                    custrec.RESET;
                    custrec.GET("Customer A/C");
                    custrec.CALCFIELDS(Balance);
                    IF custrec.Balance <> 0 THEN BEGIN
                        // ERROR('You have an outstanding Balance!!!');
                    END;
                    /*
                    SalesSetup.GET;
                    SalesSetup.TESTFIELD(SalesSetup."Imprest Nos.");
                    NoSeriesMgt.InitSeries(SalesSetup."Imprest Nos.",xRec."No.",0D,"No.","No. Series");
                    */
                    //NoSeriesMgt.InitSeries(SalesSetup."File Movement Numbers",xRec."File Movement Code",0D,"File Movement Code","No. Series");

                    /* Cust.RESET;
                     Cust.SETRANGE(Cust.ModeofInvestmentID,Empl."No.");
                     Cust.SETRANGE(RegistrationDate,Cust.RegistrationDate::"2");
                     IF Cust.FIND('-') THEN BEGIN
                     "Customer A/C":=Cust."No.";
                     "Customer A/C Name":=Cust.Name;*/
                END;
            END;

            IF Type = Type::"Leave Application" THEN BEGIN
                SalesSetup.GET;
                SalesSetup.TESTFIELD(SalesSetup."Imprest Accounting Nos.");
                NoSeriesMgt.InitSeries(SalesSetup."Imprest Accounting Nos.", xRec."No.", 0D, "No.", "No. Series");
                //NoSeriesMgt.InitSeries(SalesSetup."File Movement Numbers",xRec."File Movement Code",0D,"File Movement Code","No. Series");
            END;

            IF Type = Type::"Claim-Accounting" THEN BEGIN
                SalesSetup.GET;
                SalesSetup.TESTFIELD(SalesSetup."Claim Nos.");
                NoSeriesMgt.InitSeries(SalesSetup."Claim Nos.", xRec."No.", 0D, "No.", "No. Series");
                //NoSeriesMgt.InitSeries(SalesSetup."File Movement Numbers",xRec."File Movement Code",0D,"File Movement Code","No. Series");
                /*  Cust.RESET;
                  Cust.SETRANGE(Cust.ModeofInvestmentID,Empl."No.");
                  Cust.SETRANGE(RegistrationDate,Cust.RegistrationDate::"2");
                  IF Cust.FIND('-') THEN BEGIN
                  "Customer A/C":=Cust."No.";
                  "Customer A/C Name":=Cust.Name;
                  END;*/
            END;


            //CC
            IF Type = Type::PettyCash THEN BEGIN
                //ERROR('...');
                //  ERROR('...1   %1',"No.");
                GLSetup.GET; //error('3....99');
                GLSetup.TESTFIELD("Petty Cash No");
                "No." := NoSeriesMgt.GetNextNo(GLSetup."Petty Cash No", TODAY, TRUE);
                "Petty Cash Serials" := "No.";//NoSeriesMgt.GetNextNo(GLSetup."Petty Cash No",TODAY,TRUE);
                                              //st
                                              //NoSeriesMgt.InitSeries(SalesSetup."Imprest Nos.",xRec."No.",0D,"No.","No. Series");
                                              //Status:=Status::Released;
                "Imprest/Advance No" := "No.";


                //========================================================
                reheader1.RESET;
                reheader1.SETFILTER(reheader1."User ID", USERID);
                reheader1.SETFILTER(reheader1.Status, '%1', reheader1.Status::Open);
                reheader1.SETFILTER(reheader1.Type, '%1', reheader1.Type::PettyCash);
                IF reheader1.FINDSET THEN BEGIN
                    // ERROR('You have Open Petty Cash Entries. Please Re-use those open Entries First Before Creating a new one!!!');
                END;


                /* Cust.RESET;
                 Cust.SETRANGE(Cust.ModeofInvestmentID,Empl."No.");
                 Cust.SETRANGE(RegistrationDate,Cust.RegistrationDate::"3");
                 IF Cust.FIND('-') THEN BEGIN
                 "Customer A/C":=Cust."No.";
                 "Customer A/C Name":=Cust.Name;
                 END;*/
            END;

            IF Type = Type::"PettyCash Refund" THEN BEGIN
                SalesSetup.GET;
                // SalesSetup.TESTFIELD(SalesSetup."Petty Cash Claim Nos.");
                // NoSeriesMgt.InitSeries(SalesSetup."Petty Cash Claim Nos.", xRec."No.", 0D, "No.", "No. Series");
                //NoSeriesMgt.InitSeries(SalesSetup."File Movement Numbers",xRec."File Movement Code",0D,"File Movement Code","No. Series");
            END;

            IF Type = Type::"PettyCash Claim" THEN BEGIN
                SalesSetup.GET;
                //SalesSetup.TESTFIELD(SalesSetup."Petty Cash Accounting Nos.");
                //NoSeriesMgt.InitSeries(SalesSetup."Petty Cash Accounting Nos.", xRec."No.", 0D, "No.", "No. Series");
                //NoSeriesMgt.InitSeries(SalesSetup."File Movement Numbers",xRec."File Movement Code",0D,"File Movement Code","No. Series");

                //error('%1', "No.");
                /*  Cust.RESET;
                  Cust.SETRANGE(Cust.ModeofInvestmentID,Empl."No.");
                  Cust.SETRANGE(RegistrationDate,Cust.RegistrationDate::"3");
                  IF Cust.FIND('-') THEN BEGIN
                  "Customer A/C":=Cust."No.";
                  "Customer A/C Name":=Cust.Name;
                  END;*/

            END;
            "Request Date" := TODAY;
            "User ID" := USERID;

            //CASE Type OF
            CashMgt.GET();
            SalesSetup.GET;
            "Days Allowed" := CashMgt."Imprest Due Date";
            IF CashMgt."Imprest Accountant" <> USERID THEN BEGIN
                IF (Type = Type::PettyCash) OR (Type = Type::Imprest) THEN BEGIN


                    //Check Outstanding Imprest
                    //IF "Deadline for Return" < TODAY  THEN
                    //BEGIN
                    IF CashMgt."Check Petty Cash Debit Balance" = TRUE THEN BEGIN
                        NoofUnsurrenderedImp := 0;
                        RequestRec.RESET;
                        RequestRec.SETRANGE(Posted, TRUE);
                        RequestRec.SETRANGE(Status, RequestRec.Status::Released);
                        // RequestRec.SETFILTER(RequestRec.Type,'%1|%2',RequestRec.Type::PettyCash,RequestRec.Type::Imprest);
                        RequestRec.SETFILTER(RequestRec.Type, '%1', Type);

                        RequestRec.SETRANGE(Surrendered, FALSE);
                        RequestRec.SETRANGE("Customer A/C", "Customer A/C");
                        RequestRec.SETFILTER("Deadline for Return", '<%1', TODAY);
                        IF RequestRec.FIND('-') THEN BEGIN
                            REPEAT
                                NoofUnsurrenderedImp := NoofUnsurrenderedImp + 1;
                            UNTIL RequestRec.NEXT = 0;

                            IF Cust.GET("Customer A/C") THEN
                                //Cust.CALCFIELDS(Balance);

                                IF ((NoofUnsurrenderedImp > 0) AND (Cust.Balance > 0)) THEN
                                    ERROR(Text001, "Customer A/C", Cust.Balance, NoofUnsurrenderedImp);// repoen this
                        END;
                    END;

                END;
            END;


        END;
        //END;



        CompanyInfo.RESET;
        CompanyInfo.GET;
        //"CBK Website Address":=CompanyInfo."CBK Web Address";

    end;

    trigger OnModify()
    begin
        IF Posted THEN
            ERROR('You cannot change this document at this stage');

        IF Status <> Status::Open THEN
            // ERROR('You are not allowed to Edit a record at this stage');
            IF ((Status = Status::Released) AND (Committed = FALSE)) THEN
                VALIDATE(Status);
    end;

    trigger OnRename()
    begin
        IF Status <> Status::Released THEN
            ERROR('You cannot change this document at this stage');
    end;

    var
        Daterec: Record 2000000007;
        SalesSetup: Record 311;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Empl: Record Employee;
        UsersRec: Record "User Setup";
        //EmpAccmap: Record 51511204;
        NonWorking: Boolean;
        CalendarMgmt: Codeunit 7600;
        BaseCalendar: Record 7600;
        Description: Text[30];
        NextWorkingDate: Date;
        NoOfWorkingDays: Integer;
        CounterDays: DateFormula;
        //TripRec: Record 51511200;
        reheader1: Record 51511003;
        RequestRec: Record 51511003;
        RequestR1: Record 51511003;
        RequestLineRec: Record 51511004;
        RequestLineRecopy: Record 51511004;
        Customer: Record 18;
        JnlBatch: Record 232;
        CompanyInfo: Record 79;
        Text000: Label 'You cannot surrender an imprest that doesn''t have accountable expenses';
        PartialRec: Record 51511023;
        CashMgt: Record "Cash Management Setup";
        Cust: Record 18;
        NoofUnsurrenderedImp: Integer;
        Text001: Label 'Imprest Account %1 has an outstanding Balance  of %2 . Please Surrender the outstanding %3 imprests before you can make further requisitions';
        ImpRates: Record 51511021;
        PostRec: Record 225;
        Text002: Label 'Imprest Total Amount of %1 is Greater than %2 of your Allowable Allowance Amount for this City of %3 Postal Code %4';
        //workplanrec: Record 51511205;
        //adminrec: Record 51511390;
        // Procrec: Record 51511108;
        PurchLine: Record 51511004;
        custrec: Record 18;
        //empmap: Record "Employee Account Mapping";
        emprec: Record Employee;
        dimvalue: Record "Dimension Value";
        //travelrec: Record 51511203;
        //travelemprec: Record 51511202;
        Clusterrec: Record 51511026;
        srcscaleslocal: Record 51511024;
        scrscalesinter: Record 51511025;
        countryrec: Record 9;
        //trainingrec: Record 51511201;
        Clusterrec2: Record 51511026;
        srcscaleslocal2: Record 51511024;
        scrscalesinter2: Record 51511025;
        countryrec2: Record 9;
        GLSetup: Record "Cash Management Setup";
        dimensionvalue: Record "Dimension Value";
        vendorrec: Record 23;
        UnitPriceAmt: Decimal;
        Payments: Record 51511000;
        Totalamountbal: Decimal;
        Balancetopost: Decimal;
        "impresta/c": Code[20];
        Factory: Codeunit 51511015;
        CommitOpt: Option " ",LPO,LSO,IMPREST,INVOICE,PV;
        CommitOpt1: Option " ",Reservation,Commitment,Reversal;
        PVLines: Record 51511001;
        Receipt: Record 51511027;
        ReceiptLines: Record 51511028;
        Claim: Record 51511003;
        ClaimLines: Record 51511004;
        TransType: Record 51511015;

    procedure CreatePV(var RequestHeader: Record 51511003)
    var
        ReqLines: Record 51511004;
        PV: Record 51511000;
        PVlines: Record 51511001;
        GenJnline: Record 81;
        GLSetup: Record "Cash Management Setup";
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
        Text000: Label 'There is a remaining amount of %1 are you sure you want to create a receipt for this amount?';
        Text001: Label 'Post and Create &Receipt,&Post';
        LineNo: Integer;
        ReqHead: Record 51511003;
        RequestHeader1: Record 51511003;
        TotalSurrendered: Decimal;
        PartialImprest: Record 51511023;
        ImprestHeaderRec: Record 51511003;
        ImprestLinesRec: Record 51511004;
        //WorkPlanActivities: Record 51511205;
        CMSetup: Record "Cash Management Setup";
        commitmententry: Record "Commitment Entries";
        recline: Record "Cash Management Setup";
        commitmententry2: Record "Commitment Entries";
        glsetup87: Record "Cash Management Setup";
        commitmententry5: Record "Commitment Entries";
        custledgerentries: Record 21;
    begin

        IF RequestHeader.Posted = TRUE THEN
            ERROR('Sorry This Document No.  %1 Has Been Posted!', RequestHeader."No.");
        //IF CONFIRM('Are You SURE You Want To Post This Document...'+RequestHeader."No."+'..?',FALSE)=TRUE THEN
        //imprest

        IF Type = Type::Imprest THEN BEGIN
            RequestHeader.CALCFIELDS("Total Amount Requested", "Imprest Amount");
            GLSetup.GET();
            IF RequestHeader."Imprest Amount" <= GLSetup."Cash Limit" THEN BEGIN
                RequestHeader.CALCFIELDS("Total Amount Requested", "Imprest Amount");
                RequestHeader.TESTFIELD("Customer A/C");
                RequestHeader.TESTFIELD("Request Date");
                //Check if the imprest Lines have been populated
                ReqLines.RESET;
                ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
                //ReqLines.SETRANGE(Surrender,TRUE);
                IF NOT ReqLines.FINDLAST THEN
                    ERROR('The Imprest Claim Lines are empty');//
                ReqLines.RESET;
                ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
                ReqLines.SETRANGE(Surrender, TRUE);
                ReqLines.CALCSUMS("Actual Spent");

                GLSetup.GET;
                GLSetup.TESTFIELD("Petty Cash No");
                RequestR1.INIT;
                RequestR1."No." := NoSeriesMgt.GetNextNo(GLSetup."Petty Cash No", TODAY, TRUE);
                RequestR1."Petty Cash Serials" := RequestR1."No.";
                RequestR1."Imprest/Advance No" := RequestHeader."No.";
                RequestR1.Description := 'Petty Cash For Imprest No.' + RequestHeader."No.";
                RequestR1."Purpose of Imprest" := 'Paying Imprest No. ' + RequestHeader."No.";
                RequestR1."Request Date" := TODAY;
                RequestR1."Employee No" := RequestHeader."Employee No";
                RequestR1."Employee Name" := RequestHeader."Employee Name";
                RequestR1."Deadline for Return" := RequestHeader."Deadline for Return";
                RequestR1."User ID" := USERID;
                RequestR1.Type := RequestR1.Type::PettyCash;
                RequestR1."Customer A/C" := RequestHeader."Customer A/C";
                RequestR1."Global Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                RequestR1."Global Dimension 2 Code" := RequestHeader."Global Dimension 2 Code";
                RequestR1.Status := RequestR1.Status::Released;
                RequestR1.INSERT;


                RequestLineRec.INIT;
                RequestLineRec."Document No" := RequestR1."No.";
                RequestLineRec."Line No." := 1000;
                RequestLineRec.Description := 'Claim Refund for  ' + RequestHeader."Employee Name";
                RequestLineRec."Requested Amount" := RequestHeader."Imprest Amount";//RequestHeader."Total Amount Requested";
                RequestLineRec.Quantity := 1;
                RequestLineRec."Account Type" := RequestLineRec."Account Type"::Customer;
                RequestLineRec."Account No" := RequestR1."Customer A/C";
                RequestLineRec.Amount := RequestHeader."Total Amount Requested";
                RequestLineRec."Unit Price" := RequestHeader."Total Amount Requested";
                RequestLineRec."Global Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                RequestLineRec."Customer A/C" := RequestHeader."Customer A/C";
                RequestLineRec.INSERT;
                RequestHeader.Posted := TRUE;
                RequestHeader."Attached to PV No" := RequestR1."Petty Cash Serials";
                RequestHeader.MODIFY;
                MESSAGE('Converted to Petty Cash  No...%1', RequestR1."Petty Cash Serials");

            END ELSE BEGIN

            END;
        END;
        //==============================================end imprest
        //==========================================For Claims Refunds=============================
        IF Type = Type::"Claim/Refund" THEN BEGIN

            RequestHeader.CALCFIELDS("Total Amount Requested", "Imprest Amount");
            RequestHeader.TESTFIELD("Customer A/C");
            RequestHeader.TESTFIELD("Request Date");
            //Check if the imprest Lines have been populated

            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            //ReqLines.SETRANGE(Surrender,TRUE);
            IF NOT ReqLines.FINDLAST THEN
                ERROR('The Imprest Claim Lines are empty');//
                                                           /*
                                                           ReqLines.RESET;
                                                           ReqLines.SETRANGE(ReqLines."Document No",RequestHeader."No.");
                                                           ReqLines.SETRANGE(Surrender,TRUE);
                                                           ReqLines.CALCSUMS("Actual Spent");
                                                           IF ReqLines."Actual Spent"=0 THEN
                                                           // ERROR('Actual Spent Amount cannot be zero');
                                                           */
            IF RequestHeader.Posted THEN
                ERROR('Imprest surrender %1 is already posted', RequestHeader."No.");

            GLSetup.GET;

            //CMSetup.GET();
            // Delete Lines Present on the General Journal Line
            GenJnline.RESET;
            GenJnline.SETRANGE(GenJnline."Journal Template Name", 'GENERAL');
            GenJnline.SETRANGE(GenJnline."Journal Batch Name", RequestHeader."No.");
            GenJnline.DELETEALL;

            GenJnlBatch.INIT;
            //IF CMSetup.GET() THEN
            GenJnlBatch."Journal Template Name" := 'GENERAL';
            GenJnlBatch.Name := RequestHeader."No.";
            IF NOT GenJnlBatch.GET(GenJnlBatch."Journal Template Name", GenJnlBatch.Name) THEN
                GenJnlBatch.INSERT;


            //Staff entries
            LineNo := 10000;
            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            ReqLines.CALCSUMS("Actual Spent");
            GenJnline.INIT;
            GenJnline."Journal Template Name" := 'GENERAL';
            GenJnline."Journal Batch Name" := RequestHeader."No.";
            GenJnline."Line No." := LineNo;
            GenJnline."Account Type" := GenJnline."Account Type"::Customer;
            GenJnline."Account No." := RequestHeader."Customer A/C"; //error('%1',GenJnline."Account No.");//RequestHeader."Account No.";
            GenJnline."Posting Date" := RequestHeader."Request Date";
            GenJnline."Document No." := RequestHeader."No.";
            //GenJnLine."External Document No.":=RequestHeader."Cheque No";

            GenJnline.Description := RequestHeader."Purpose of Imprest";
            //GenJnline.Description:=ReqLines.Description;
            GenJnline.Amount := -RequestHeader."Imprest Amount";
            GenJnline.VALIDATE(Amount);
            GenJnline."Shortcut Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";

            //=====================================================================
            RequestHeader.CALCFIELDS("Applies-to Doc. No.");
            custledgerentries.RESET;
            custledgerentries.SETFILTER(custledgerentries."Customer No.", "Customer A/C");
            custledgerentries.SETFILTER(custledgerentries.Open, '%1', TRUE);
            custledgerentries.SETFILTER(custledgerentries."Document No.", '%1', "Applies-to Doc. No.");
            IF custledgerentries.FINDSET THEN BEGIN
                //GenJnline."Applies-to Doc. Type":=GenJnline."Applies-to Doc. Type"::Invoice;
            END;
            //=====================================================================
            GenJnline."Applies-to Doc. No." := RequestHeader."Applies-to Doc. No.";
            GenJnline.VALIDATE("Applies-to Doc. No.");
            MESSAGE(RequestHeader."Applies-to Doc. No.");

            IF GenJnline.Amount <> 0 THEN
                GenJnline.INSERT;


            //ERROR('N..99100');

            //Expenses
            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            //ReqLines.SETRANGE(Surrender,TRUE);
            IF ReqLines.FINDSET THEN BEGIN
                REPEAT

                    LineNo := LineNo + 10000;
                    GenJnline.INIT;
                    GenJnline."Journal Template Name" := 'GENERAL';
                    GenJnline."Journal Batch Name" := RequestHeader."No.";
                    GenJnline."Line No." := LineNo;
                    GenJnline."Account Type" := ReqLines."Account Type";
                    IF GenJnline."Account Type" = ReqLines."Account Type"::"Fixed Asset" THEN
                        GenJnline."FA Posting Type" := GenJnline."FA Posting Type"::"Acquisition Cost";

                    GenJnline."Account No." := ReqLines."Account No";
                    GenJnline.VALIDATE("Account No.");
                    GenJnline."Shortcut Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                    GenJnline."Posting Date" := RequestHeader."Request Date";
                    GenJnline."Document No." := RequestHeader."No.";
                    GenJnline.Description := ReqLines.Description;
                    GenJnline.Amount := ReqLines.Amount;
                    GenJnline.VALIDATE(Amount);
                    //Set these fields to blanks
                    GenJnline."Gen. Posting Type" := GenJnline."Gen. Posting Type"::" ";
                    GenJnline.VALIDATE("Gen. Posting Type");
                    GenJnline."Gen. Bus. Posting Group" := '';
                    GenJnline.VALIDATE("Gen. Bus. Posting Group");
                    GenJnline."Gen. Prod. Posting Group" := '';
                    GenJnline.VALIDATE("Gen. Prod. Posting Group");
                    GenJnline."VAT Bus. Posting Group" := '';
                    GenJnline.VALIDATE("VAT Bus. Posting Group");
                    GenJnline."VAT Prod. Posting Group" := '';
                    GenJnline.VALIDATE("VAT Prod. Posting Group");
                    //
                    /*
                    GenJnline."Shortcut Dimension 1 Code":=RequestHeader."Global Dimension 1 Code";
                    GenJnline.VALIDATE("Shortcut Dimension 1 Code");
                    GenJnline."Shortcut Dimension 2 Code":=RequestHeader."Global Dimension 2 Code";
                    GenJnline.VALIDATE("Shortcut Dimension 2 Code");
                    */
                    IF ReqLines."Activity Type" = ReqLines."Activity Type"::WorkPlan THEN BEGIN
                        // GenJnline."Work Plan Activity Code":=ReqLines.Activity;
                    END;
                    IF ReqLines."Activity Type" = ReqLines."Activity Type"::"Admin & PE" THEN BEGIN
                        // GenJnline."PE Activity Code":=ReqLines.Activity;;
                    END;
                    IF ReqLines."Activity Type" = ReqLines."Activity Type"::"Proc Plan" THEN BEGIN
                        // GenJnline."Procurement Plan Code":=ReqLines.Activity;
                    END;


                    IF GenJnline.Amount <> 0 THEN
                        GenJnline.INSERT;
                //MESSAGE('%1..%2',ReqLines."Actual Spent",LineNo);
                UNTIL ReqLines.NEXT = 0;
            END;

            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnline);
            RequestHeader.CALCFIELDS("Total Amount Requested", "Imprest Amount");
            // ERROR('the amount %1',RequestHeader."Total Amount Requested");
            GLSetup.GET();
            IF RequestHeader."Total Amount Requested" <= GLSetup."Cash Limit" THEN BEGIN
                GLSetup.GET();
                Balancetopost := 0;

                RequestR1.INIT;
                RequestR1.Type := RequestR1.Type::PettyCash;
                //RequestRec."Imprest/Advance No":=RequestHeader."No.";
                SalesSetup.GET;
                SalesSetup.TESTFIELD(SalesSetup."Imprest Nos.");
                RequestR1."No." := NoSeriesMgt.GetNextNo(SalesSetup."Imprest Nos.", TODAY, TRUE);
                GLSetup.GET; //error('3....99');
                GLSetup.TESTFIELD("Petty Cash No");
                //NoSeriesMgt.InitSeries(glsetup."Petty Cash No",RequestR1."No.",0D,RequestR1."Petty Cash Serials",RequestR1."No. Series");
                RequestR1."Petty Cash Serials" := NoSeriesMgt.GetNextNo(GLSetup."Petty Cash No", TODAY, TRUE);
                RequestR1."No." := RequestR1."Petty Cash Serials";
                RequestR1."Purpose of Imprest" := 'Paying For Claim No. ' + RequestHeader."No.";//ReceiptHeader."No.";
                                                                                                //RequestR1."Petty Cash Serials":='reree';
                RequestR1."Imprest/Advance No" := RequestHeader."No.";
                RequestR1."Request Date" := TODAY;
                RequestR1."Employee No" := RequestHeader."Employee No";
                RequestR1."Employee Name" := RequestHeader."Employee Name";
                RequestR1."Deadline for Return" := CALCDATE('7D', TODAY);
                RequestR1."User ID" := USERID;
                RequestR1."Customer A/C" := RequestHeader."Customer A/C";
                RequestR1."Global Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                RequestR1."Global Dimension 2 Code" := RequestHeader."Global Dimension 2 Code";
                RequestR1.Status := RequestR1.Status::Released;
                RequestR1.INSERT;
                //IF RequestR1.INSERT<>TRUE THEN
                //ERROR('Failed To Converted to Petty Cash No...%1',Totalamountbal-RequestLineRec."Requested Amount");

                //====================================================
                RequestLineRec.INIT;
                RequestLineRec."Document No" := RequestR1."No.";
                RequestLineRec."Line No." := 1000;
                RequestLineRec.Description := 'Claim Refund for  ' + RequestHeader."Employee Name";
                RequestLineRec."Requested Amount" := RequestHeader."Total Amount Requested";
                RequestLineRec.Quantity := 1;
                RequestLineRec."Account Type" := RequestLineRec."Account Type"::Customer;
                RequestLineRec."Account No" := RequestR1."Customer A/C";
                RequestLineRec.Amount := RequestHeader."Total Amount Requested";
                RequestLineRec."Unit Price" := RequestHeader."Total Amount Requested";
                RequestLineRec."Global Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                RequestLineRec."Customer A/C" := RequestHeader."Customer A/C";
                RequestLineRec.INSERT;
                MESSAGE('Converted to Petty Cash No...%1', RequestR1."Petty Cash Serials");
                //END;
                //END;
            END ELSE BEGIN
                GLSetup.GET();
                MESSAGE('The Claim Amount is %1 And the limit is %2 So It can Only be Paid through Payment Voucher', RequestHeader."Total Amount Requested", GLSetup."Cash Limit")
            END;
        END;
        //==========================================End Of Claims Refunds==========================

        //==========================================Claims Refunds==========================

        //==========================================End Claims Refunds==========================

        //===============================Claim-Accounting==========================================
        IF Type = Type::"Claim-Accounting" THEN BEGIN
            IF NOT GenJnlBatch.GET('GENERAL', RequestHeader."No.") THEN BEGIN
                GenJnlBatch.INIT;
                GenJnlBatch."Journal Template Name" := 'GENERAL';
                GenJnlBatch.Name := RequestHeader."No.";
                GenJnlBatch.INSERT;
            END;

            GenJnlineCopy.RESET;
            GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name", 'GENERAL');
            GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name", RequestHeader."No.");
            GenJnlineCopy.DELETEALL;
            GenJnlineCopy.RESET;
            GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name", 'GENERAL');
            GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name", RequestHeader."No.");
            IF GenJnlineCopy.FIND('+') THEN
                LastClaimNo := GenJnlineCopy."Line No.";
            Totalamountbal := 0;
            //Post Expenses
            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            IF ReqLines.FIND('-') THEN
                REPEAT
                    LastClaimNo := LastClaimNo + 10000;
                    GenJnline.INIT;
                    GenJnline."Journal Template Name" := 'GENERAL';
                    GenJnline."Journal Batch Name" := RequestHeader."No.";
                    GenJnline."Line No." := LastClaimNo;
                    GenJnline."Account Type" := GenJnline."Account Type"::"G/L Account";
                    GenJnline."Account No." := ReqLines."Account No";
                    GenJnline."Posting Date" := RequestHeader."Request Date";
                    GenJnline."Document No." := RequestHeader."No.";
                    GenJnline.Description := COPYSTR(ReqLines.Description + '-Imprest/Adv. accounting', 1, 50);
                    GenJnline.Amount := ReqLines."Actual Spent";
                    GenJnline."Asset No" := ReqLines."Asset No";
                    GenJnline."Shortcut Dimension 1 Code" := ReqLines."Global Dimension 1 Code";
                    GenJnline."Shortcut Dimension 2 Code" := ReqLines."Global Dimension 2 Code";
                    GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                    GenJnline.VALIDATE(GenJnline."Shortcut Dimension 2 Code");
                    IF GenJnline.Amount <> 0 THEN
                        GenJnline.INSERT;
                    Totalamountbal := Totalamountbal + ReqLines."Actual Spent";
                UNTIL ReqLines.NEXT = 0;
            //Post Customer entries
            LastClaimNo := LastClaimNo + 10000;
            GenJnline.INIT;
            GenJnline."Journal Template Name" := 'GENERAL';
            GenJnline."Journal Batch Name" := RequestHeader."No.";
            GenJnline."Line No." := LastClaimNo;
            GenJnline."Account Type" := GenJnline."Account Type"::Customer;
            GenJnline."Account No." := RequestHeader."Customer A/C";
            GenJnline."Posting Date" := RequestHeader."Request Date";
            GenJnline."Document No." := RequestHeader."No.";
            GenJnline.Description := STRSUBSTNO('Imprest/Advance accounting for %1', RequestHeader."Imprest/Advance No");
            GenJnline.Amount := -Totalamountbal;
            GenJnline."Loan No" := RequestHeader."Imprest/Advance No";
            GenJnline."External Document No." := RequestHeader."No.";
            GenJnline."Asset No" := ReqLines."Asset No";
            GenJnline."Shortcut Dimension 1 Code" := ReqLines."Global Dimension 1 Code";
            GenJnline."Shortcut Dimension 2 Code" := ReqLines."Global Dimension 2 Code";
            GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
            GenJnline.VALIDATE(GenJnline."Shortcut Dimension 2 Code");
            GenJnline."Applies-to Doc. No." := RequestHeader."Applies-to Doc. No.";
            IF GenJnline.Amount <> 0 THEN
                GenJnline.INSERT;
            //Post Journal
            GenJnline.RESET;
            GenJnline.SETRANGE(GenJnline."Journal Template Name", 'GENERAL');
            GenJnline.SETRANGE(GenJnline."Journal Batch Name", RequestHeader."No.");
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnline);

            GLSetup.GET();
            Balancetopost := 0;

            //Check for over/under expenditure
            RequestLineRec.RESET;
            RequestLineRec.SETRANGE("Document No", "Imprest/Advance No");
            IF RequestLineRec.FIND('-') THEN BEGIN
                RequestLineRec.CALCSUMS("Requested Amount", "Actual Spent");
                Balancetopost := (Totalamountbal - RequestLineRec."Requested Amount");
                IF Balancetopost <> 0 THEN BEGIN
                    //Create a payment voucher for over-expenditure
                    IF Totalamountbal > RequestLineRec."Requested Amount" THEN BEGIN
                        /*
                          Payments.INIT;
                          Payments.No:=NoSeriesMgt.GetNextNo(GLSetup."Payments No",TODAY,TRUE);
                          Payments.Date:=TODAY;
                          Payments.Cashier:=USERID;
                          Payments."Account Type":=Payments."Account Type"::"Bank Account";
                          Payments.Remarks:='Imprest '+"No."+' Refund Payments';
                          Payments."Global Dimension 1 Code":="Global Dimension 1 Code";
                          Payments.Payee:="Employee Name";
                          Payments."Payment Type":=Payments."Payment Type"::Normal;
                          Payments."Bank Type":=Payments."Bank Type"::Normal;
                          Payments."PV Type":=Payments."PV Type"::Normal;
                          Payments."Transaction Type":=Payments."Transaction Type"::Payments;
                          Payments."PV Date":=TODAY;
                            IF Payments.INSERT THEN BEGIN
                            PVlines.INIT;
                            PVlines."Line No":=10000;
                            PVlines."PV No":=Payments.No;
                            PVlines."Account Type":=PVlines."Account Type"::Customer;
                            PVlines."Account No":="Customer A/C";
                            PVlines.VALIDATE("Account No");
                            PVlines.Description:='Imprest '+"No."+' Refund Payments';
                            PVlines."VAT Code":='ZERO';
                            PVlines."W/Tax Code":='ZERO';
                            PVlines."W/VAT Code":='ZERO';
                            PVlines.Amount:=ABS(Balancetopost);
                            PVlines.VALIDATE(Amount);
                            PVlines.INSERT;
                            MESSAGE('Payment voucher '+Payments.No+' has been created');
                            END;
                            */
                        SalesSetup.GET;
                        Claim.INIT;
                        //Claim."No." := NoSeriesMgt.GetNextNo(SalesSetup."Claim/Refund Nos.", TODAY, TRUE);
                        Claim."Employee No" := RequestHeader."Employee No";
                        Claim.VALIDATE("Employee No");
                        Claim.Type := Claim.Type::"Claim/Refund";
                        Claim."Request Date" := TODAY;
                        Claim."User ID" := USERID;
                        Claim."Purpose of Imprest" := 'Claim Refund for Imprest ' + RequestHeader."No.";
                        Claim.INSERT;

                        ClaimLines.INIT;
                        ClaimLines."Document No" := Claim."No.";
                        ClaimLines."Line No." := 10000;
                        ClaimLines."Transaction Type" := RequestLineRec."Transaction Type";
                        ClaimLines.VALIDATE("Transaction Type");
                        ClaimLines."Global Dimension 1 Code" := RequestLineRec."Global Dimension 1 Code";
                        ClaimLines."Global Dimension 2 Code" := RequestLineRec."Global Dimension 2 Code";
                        ClaimLines."Global Dimension 3 Code" := RequestLineRec."Global Dimension 3 Code";
                        ClaimLines."Unit Price" := Totalamountbal - RequestLineRec."Requested Amount";
                        ClaimLines.Quantity := 1;
                        ClaimLines.Amount := ClaimLines."Unit Price";
                        ClaimLines.INSERT;
                        MESSAGE('Claim Refund ' + Claim."No." + ' has been generated');
                    END;
                    IF Totalamountbal < RequestLineRec."Requested Amount" THEN BEGIN
                        Receipt.INIT;
                        Receipt."No." := NoSeriesMgt.GetNextNo(GLSetup."Receipt No", TODAY, TRUE);
                        Receipt.Date := TODAY;
                        Receipt."Received From" := "Employee Name";
                        Receipt."Customer Category" := Receipt."Customer Category"::Staff;
                        Receipt."Received From No" := "Customer A/C";
                        Receipt.VALIDATE("Received From No");
                        IF Receipt.INSERT THEN BEGIN
                            ReceiptLines.INIT;
                            ReceiptLines."Line No" := 100000;
                            ReceiptLines."Receipt No." := Receipt."No.";
                            ReceiptLines."Account Type" := ReceiptLines."Account Type"::Customer;
                            ReceiptLines."Account No." := "Customer A/C";
                            ReceiptLines.VALIDATE("Account No.");
                            ReceiptLines.Description := 'Imprest ' + "No." + ' Refund';
                            ReceiptLines.Amount := ABS(Balancetopost);
                            ReceiptLines.VALIDATE(Amount);
                            ReceiptLines.INSERT;
                            MESSAGE('Receipt ' + Receipt."No." + ' has been created');
                        END;
                    END;
                END;
            END;
        END;

    end;

    procedure CreateAttachment()
    begin
        /*IF NOT SegInteractLanguage.GET("No.","Language Code (Default)") THEN BEGIN
          SegInteractLanguage.INIT;
          SegInteractLanguage."Segment No." := "No.";
          SegInteractLanguage."Segment Line No." := 0;
          SegInteractLanguage."Language Code" := "Language Code (Default)";
          SegInteractLanguage.Description := FORMAT("Interaction Template Code") + ' ' + FORMAT("Language Code (Default)");
          SegInteractLanguage.Subject := "Subject (Default)";
        END;
        SegInteractLanguage.CreateAttachment;
        */

    end;

    procedure OpenAttachment()
    begin
        /*IF SegInteractLanguage.GET("No.","Language Code (Default)") THEN
          IF SegInteractLanguage."Attachment No." <> 0 THEN
            SegInteractLanguage.OpenAttachment;
            */

    end;

    procedure ImportAttachment()
    begin
        /*IF NOT SegInteractLanguage.GET("No.","Language Code (Default)") THEN BEGIN
          SegInteractLanguage.INIT;
          SegInteractLanguage."Segment No." := "No.";
          SegInteractLanguage."Segment Line No." := 0;
          SegInteractLanguage."Language Code" := "Language Code (Default)";
          SegInteractLanguage.Description :=
            FORMAT("Interaction Template Code") + ' ' + FORMAT("Language Code (Default)");
          SegInteractLanguage.INSERT(TRUE);
        END;
        SegInteractLanguage.ImportAttachment;
        */

    end;

    procedure ExportAttachment()
    begin
        /*IF SegInteractLanguage.GET("No.","Language Code (Default)") THEN
          IF SegInteractLanguage."Attachment No." <> 0 THEN
            SegInteractLanguage.ExportAttachment;
        */

    end;

    procedure RemoveAttachment(Prompt: Boolean)
    begin
        /*IF SegInteractLanguage.GET("No.","Language Code (Default)") THEN
          IF SegInteractLanguage."Attachment No." <> 0 THEN
            SegInteractLanguage.RemoveAttachment(Prompt);
            */

    end;

    procedure ImprestLinesExist(): Boolean
    begin
        PurchLine.RESET;
        //PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Document No", "No.");
        EXIT(PurchLine.FINDFIRST);
    end;

    procedure PostImprestSurrender(var Imprestrec: Record 51511003)
    begin
    end;

    procedure PostPettyCash(var PettyCash: Record 51511003)
    var
        RequestHeader: Record 51511003;
        ReqLines: Record 51511004;
        GLSetup: Record "Cash Management Setup";
        GenJnline: Record 81;
        GenJnlBatch: Record 232;
        LineNo: Integer;
        custledgerentries: Record 21;
        GLEntry: Record 17;
    begin
        IF PettyCash.Posted = TRUE THEN
            ERROR('Sorry This Document No.  %1 Has Been Posted!', PettyCash."No.");
        IF CONFIRM('Are You SURE You Want To Post This Document...' + PettyCash."No." + '..?', FALSE) = TRUE THEN
            //ERROR('No go zone for this');
            PettyCash.TESTFIELD("Customer A/C");
        PettyCash.TESTFIELD("Request Date");
        //Check if the imprest Lines have been populated

        ReqLines.RESET;
        ReqLines.SETRANGE(ReqLines."Document No", PettyCash."No.");
        //ReqLines.SETRANGE(Surrender,TRUE);
        IF NOT ReqLines.FINDLAST THEN
            ERROR('The Petty Cash Lines are empty');

        ReqLines.RESET;
        ReqLines.SETRANGE(ReqLines."Document No", PettyCash."No.");
        // ReqLines.SETRANGE(Surrender,TRUE);
        ReqLines.CALCSUMS(Amount);
        IF ReqLines."Actual Spent" = 0 THEN
            // ERROR('Actual Spent Amount cannot be zero');

            IF PettyCash.Surrendered THEN
                // ERROR('Imprest %1 has been surrendered',PettyCash."No.");

                GLSetup.GET;

        //CMSetup.GET();
        // Delete Lines Present on the General Journal Line
        GenJnline.RESET;
        GenJnline.SETRANGE(GenJnline."Journal Template Name", 'GENERAL');
        GenJnline.SETRANGE(GenJnline."Journal Batch Name", PettyCash."No.");
        GenJnline.DELETEALL;

        GenJnlBatch.INIT;
        //IF CMSetup.GET() THEN
        GenJnlBatch."Journal Template Name" := 'GENERAL';
        GenJnlBatch.Name := PettyCash."No.";
        IF NOT GenJnlBatch.GET(GenJnlBatch."Journal Template Name", GenJnlBatch.Name) THEN
            GenJnlBatch.INSERT;


        //Staff entries
        LineNo := 10000;
        ReqLines.RESET;
        ReqLines.SETRANGE(ReqLines."Document No", PettyCash."No.");
        ReqLines.CALCSUMS("Actual Spent");
        GenJnline.INIT;
        GenJnline."Journal Template Name" := 'GENERAL';
        GenJnline."Journal Batch Name" := PettyCash."No.";
        GenJnline."Line No." := LineNo;
        GenJnline."Account Type" := GenJnline."Account Type"::Customer;
        GenJnline."Account No." := PettyCash."Customer A/C"; //error('%1',GenJnline."Account No.");//PettyCash."Account No.";
        GenJnline."Posting Date" := PettyCash."Request Date";
        GenJnline."Document No." := PettyCash."Petty Cash Serials";
        //GenJnLine."External Document No.":=PettyCash."Cheque No";
        GenJnline.Description := PettyCash."Purpose of Imprest";
        GenJnline.Amount := PettyCash."Imprest Amount";
        GenJnline.VALIDATE(Amount);
        /*
        //=====================================================================
        custledgerentries.RESET;
        custledgerentries.SETFILTER(custledgerentries."Customer No.","Customer A/C");
        custledgerentries.SETFILTER(custledgerentries.Open,'%1',TRUE);
        custledgerentries.SETFILTER(custledgerentries."Document No.",'%1',"Applies-to Doc. No.");
        IF custledgerentries.FINDSET THEN BEGIN
           GenJnline."Applies-to Doc. Type":=custledgerentries."Document Type";
        END;
        //=====================================================================

        GenJnline."Applies-to Doc. No.":=PettyCash."Applies-to Doc. No.";
       */
        GenJnline."Bal. Account Type" := GenJnline."Bal. Account Type"::"Bank Account";
        GLSetup.GET;
        GLSetup.TESTFIELD("Default Cash Account");
        GenJnline."Bal. Account No." := GLSetup."Default Cash Account";
        IF GenJnline.Amount <> 0 THEN
            GenJnline.INSERT;



        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnline);
        PettyCash.Posted := TRUE;
        GLEntry.RESET;
        GLEntry.SETRANGE(GLEntry."Document No.", PettyCash."No.");
        GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
        GLEntry.SETRANGE("Posting Date", PettyCash."Request Date");
        IF GLEntry.FIND('-') THEN BEGIN
            PettyCash.Posted := TRUE;
            PettyCash.Surrendered := FALSE;
            // PettyCash."Attached to PV No":='PV-07027';
            PettyCash."PV Posted" := TRUE;
            PettyCash.MODIFY;
        END;

    end;

    procedure DecommitSurrender(var ReqHdr: Record 51511003)
    var
        commitrec: Record 51511014;
        reqlines: Record 51511004;
        commitrec2: Record 51511014;
        glbudgets: Record 95;
        GLsetup: Record "Cash Management Setup";
    begin
        IF ReqHdr.Type = ReqHdr.Type::"Claim-Accounting" THEN BEGIN
            reqlines.RESET;
            reqlines.SETFILTER("Document No", ReqHdr."No.");
            reqlines.SETFILTER(Surrender, '%1', TRUE);
            IF reqlines.FINDSET THEN
                REPEAT
                    commitrec2.RESET;
                    commitrec2.SETFILTER("Entry No", '<>%1', 0);
                    IF commitrec2.FINDLAST THEN BEGIN
                        commitrec.INIT;
                        commitrec."Entry No" := commitrec2."Entry No" + 1;
                        commitrec."Document No." := ReqHdr."Imprest/Advance No";
                        commitrec."Commitment Date" := ReqHdr."Request Date";
                        commitrec.Amount := 0 - (reqlines."Actual Spent");
                        commitrec."Global Dimension 1 Code" := ReqHdr."Global Dimension 1 Code";
                        commitrec.GLAccount := reqlines.Activity;
                        glbudgets.RESET;
                        //glbudgets.SETFILTER("Start Date", '<=%1', ReqHdr."Request Date");
                        //glbudgets.SETFILTER("End Date", '>=%1', ReqHdr."Request Date");
                        IF glbudgets.FINDSET THEN BEGIN
                            commitrec."Budget Line" := glbudgets.Name;
                            commitrec."Budget Year" := glbudgets.Name;
                        END;
                        commitrec.Description := reqlines.Description;
                        commitrec."Global Dimension 1 Code" := reqlines."Global Dimension 1 Code";
                        IF commitrec."Budget Line" = '' THEN BEGIN
                            GLsetup.RESET;
                            GLsetup.GET;
                            GLsetup.TESTFIELD("Current Budget");
                            commitrec."Budget Line" := GLsetup."Current Budget";
                            commitrec."Budget Year" := GLsetup."Current Budget";
                        END;
                        commitrec.INSERT;

                    END;
                UNTIL reqlines.NEXT = 0;
        END;
    end;

    local procedure CreateLinesPerdiem(Amt: Decimal)
    begin
        GLSetup.GET;
        GLSetup.TESTFIELD("Per Diem Account");
        IF "Local Travel2" = TRUE THEN BEGIN
            RequestLineRec.RESET;
            RequestLineRec.SETFILTER("Document No", "No.");
            IF RequestLineRec.FINDLAST THEN BEGIN
                RequestLineRecopy.INIT;
                RequestLineRecopy."Document No" := "No.";
                RequestLineRecopy."Line No." := RequestLineRec."Line No." + 10;
                RequestLineRecopy."Account No" := GLSetup."Per Diem Account";
                //RequestLineRecopy.VALIDATE("Account No");
                RequestLineRecopy.Description := 'Perdim-Local : ';
                RequestLineRecopy.Type := '';
                RequestLineRec."Unit of Measure" := 'DAYS';
                RequestLineRecopy.Quantity := "No. of Days";
                IF "No. of Days" = 0 THEN BEGIN
                    RequestLineRecopy.Quantity := 1;
                END;
                RequestLineRecopy."Unit Price" := Amt;
                RequestLineRecopy."USD Amount" := Amt;
                //RequestLineRecopy.VALIDATE("Unit Price");
                RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                // RequestLineRecopy.Activity:=trainingrec."GL Account";
                RequestLineRecopy.INSERT;
            END;
            RequestLineRec.RESET;
            RequestLineRec.SETFILTER("Document No", "No.");
            IF NOT RequestLineRec.FINDLAST THEN BEGIN
                RequestLineRecopy.INIT;
                RequestLineRecopy."Document No" := "No.";
                RequestLineRecopy."Line No." := 10;
                RequestLineRecopy."Account No" := GLSetup."Per Diem Account";
                //RequestLineRecopy.VALIDATE("Account No");
                RequestLineRecopy.Description := 'Perdim-Local : ';
                RequestLineRecopy.Type := '';
                RequestLineRecopy."Unit of Measure" := 'DAYS';
                RequestLineRecopy.Quantity := "No. of Days";
                IF "No. of Days" = 0 THEN BEGIN
                    RequestLineRecopy.Quantity := 1;
                END;
                RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                RequestLineRecopy."Unit Price" := Amt;
                RequestLineRecopy."USD Amount" := Amt;
                //RequestLineRecopy.VALIDATE("Unit Price");
                // RequestLineRecopy.Amount:=trainingrec."Per Diem";
                // RequestLineRecopy.Activity:=trainingrec."GL Account";
                RequestLineRecopy.INSERT;
            END;
        END;
        IF "Local Travel2" = FALSE THEN BEGIN
            RequestLineRec.RESET;
            RequestLineRec.SETFILTER("Document No", "No.");
            IF RequestLineRec.FINDLAST THEN BEGIN
                RequestLineRecopy.INIT;
                RequestLineRecopy."Document No" := "No.";
                RequestLineRecopy."Line No." := RequestLineRec."Line No." + 10;
                RequestLineRecopy."Account No" := GLSetup."Per Diem Account";
                //RequestLineRecopy.VALIDATE("Account No");
                RequestLineRecopy.Description := 'Perdim-International : ';
                RequestLineRecopy.Type := '';
                RequestLineRec."Unit of Measure" := 'DAYS';
                RequestLineRecopy.Quantity := "No. of Days";
                IF "No. of Days" = 0 THEN BEGIN
                    RequestLineRecopy.Quantity := 1;
                END;
                RequestLineRecopy."Unit Price" := Amt;
                RequestLineRecopy."USD Amount" := Amt;
                //RequestLineRecopy.VALIDATE("Unit Price");
                RequestLineRecopy."USD Amount" := Amt * RequestLineRecopy.Quantity;
                RequestLineRecopy.Amount := Amt * RequestLineRecopy.Quantity;
                RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                // RequestLineRecopy.Activity:=trainingrec."GL Account";
                RequestLineRecopy.INSERT;
            END;
            RequestLineRec.RESET;
            RequestLineRec.SETFILTER("Document No", "No.");
            IF NOT RequestLineRec.FINDLAST THEN BEGIN
                RequestLineRecopy.INIT;
                RequestLineRecopy."Document No" := "No.";
                RequestLineRecopy."Line No." := 10;
                RequestLineRecopy."Account No" := GLSetup."Per Diem Account";
                //RequestLineRecopy.VALIDATE("Account No");
                RequestLineRecopy.Description := 'Perdim-International: ';
                RequestLineRecopy.Type := '';
                RequestLineRecopy."Unit of Measure" := 'DAYS';
                RequestLineRecopy.Quantity := "No. of Days";
                IF "No. of Days" = 0 THEN BEGIN
                    RequestLineRecopy.Quantity := 1;
                END;
                RequestLineRecopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                RequestLineRecopy."Unit Price" := Amt;
                // RequestLineRecopy.VALIDATE("Unit Price");
                RequestLineRecopy."USD Amount" := Amt * RequestLineRecopy.Quantity;
                RequestLineRecopy.Amount := Amt * RequestLineRecopy.Quantity;
                // RequestLineRecopy.Amount:=trainingrec."Per Diem";
                // RequestLineRecopy.Activity:=trainingrec."GL Account";
                RequestLineRecopy.INSERT;

            END;
        END;
    end;

    [Scope('Personalization')]
    procedure ReqLinesExist(): Boolean
    begin
        RequestLineRec.RESET;
        RequestLineRec.SETRANGE("Document No", "No.");
        EXIT(RequestLineRec.FINDFIRST);
    end;

    procedure CreatePV1(var RequestHeader: Record 51511003)
    var
        ReqLines: Record 51511004;
        PV: Record 51511000;
        PVlines: Record 51511001;
        GenJnline: Record 81;
        GLSetup: Record "Cash Management Setup";
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
        Text000: Label 'There is a remaining amount of %1 are you sure you want to create a receipt for this amount?';
        Text001: Label 'Post and Create &Receipt,&Post';
        LineNo: Integer;
        ReqHead: Record 51511003;
        RequestHeader1: Record 51511003;
        TotalSurrendered: Decimal;
        PartialImprest: Record 51511023;
        ImprestHeaderRec: Record 51511003;
        ImprestLinesRec: Record 51511004;
        CMSetup: Record "Cash Management Setup";
        commitmententry: Record 51511014;
        recline: Record 51511004;
        commitmententry2: Record 51511014;
        glsetup87: Record 98;
        commitmententry5: Record 51511014;
        custledgerentries: Record 21;
        PvPost: Codeunit 51511014;
    begin
        GLSetup.GET;
        RequestHeader.CALCFIELDS(RequestHeader."Imprest Amount");
        IF Type = Type::Imprest THEN BEGIN



            IF RequestHeader.Posted <> TRUE THEN BEGIN

                PV.INIT;
                PV.No := NoSeriesMgt.GetNextNo(GLSetup."Payments No", TODAY, TRUE);
                PV.Date := TODAY;
                PV.Payee := RequestHeader."Employee Name";

                IF RequestHeader.Type = RequestHeader.Type::Imprest THEN
                    PV.Remarks := 'Imprest';
                IF RequestHeader.Type = RequestHeader.Type::PettyCash THEN
                    PV.Remarks := 'Petty Cash';
                PV."PO/INV No" := RequestHeader."No.";
                PV."Paying Bank Account" := GLSetup."Imprest Payments Bank Account";//GLSetup."Default Bank Account";
                PV."Account Type" := PV."Account Type"::"Bank Account";
                PV."Account No." := GLSetup."Imprest Payments Bank Account";//RequestHeader."Bank Account";
                PV."Cheque No" := RequestHeader."Cheque No";
                PV."Cheque Date" := RequestHeader."Cheque Date";
                PV."Pay Mode" := RequestHeader."Pay Mode";
                PV.Status := PV.Status::Released;
                PV."Global Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                PV.VALIDATE("Global Dimension 1 Code");
                PV."Global Dimension 2 Code" := RequestHeader."Global Dimension 2 Code";
                PV.VALIDATE("Global Dimension 2 Code");
                PV.INSERT(TRUE);
                RequestHeader.CALCFIELDS(RequestHeader."Imprest Amount");

                PVlines.INIT;
                PVlines."PV No" := PV.No;
                PVlines."Line No" := PVlines."Line No" + 10000;
                PVlines."Account Type" := PVlines."Account Type"::Customer;
                PVlines."Account No" := RequestHeader."Customer A/C";

                Customer.RESET;
                IF Customer.GET(RequestHeader."Customer A/C") THEN
                    PVlines."Account Name" := Customer.Name;
                PVlines."Shortcut Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                PVlines.VALIDATE("Shortcut Dimension 1 Code");
                PVlines."Shortcut Dimension 2 Code" := RequestHeader."Global Dimension 2 Code";
                PVlines.VALIDATE("Shortcut Dimension 2 Code");
                //PVlines.Description:=RequestHeader."Employee Name"+'-Imprest';
                PVlines.Description := RequestHeader."Purpose of Imprest";

                PVlines."Loan No" := "No.";
                PVlines."VAT Code" := 'ZERO';
                PVlines."W/Tax Code" := 'ZERO';
                // SNN 03302021 PVlines."W/VAT Code" := 'ZERO';
                //PVlines.VALIDATE("W/VAT Code");
                PVlines.Amount := RequestHeader."Imprest Amount";
                PVlines.VALIDATE(Amount);
                PVlines.INSERT;
                RequestHeader.Posted := TRUE;
                RequestHeader."Attached to PV No" := PV.No;
                RequestHeader.MODIFY;

                MESSAGE('Payment Voucher %1 has been created for ' + FORMAT(RequestHeader.Type) + ' %2', PV.No, RequestHeader."No.");
                PvPost.PostPayment(PV);
            END ELSE
                ERROR('A Payment Voucher has already been created ' + FORMAT(RequestHeader.Type) + ' %1', RequestHeader."No.");

        END;




        IF Type = Type::"Claim-Accounting" THEN BEGIN
            //error('here...');
            RequestHeader.CALCFIELDS("Remaining Amount", "Actual Amount");
            RequestHeader.TESTFIELD("Customer A/C");
            RequestHeader.TESTFIELD("Request Date");
            //Check if the imprest Lines have been populated

            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            ReqLines.SETRANGE(Surrender, TRUE);
            IF NOT ReqLines.FINDLAST THEN
                ERROR('The Imprest Surrender Lines are empty');

            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            ReqLines.SETRANGE(Surrender, TRUE);
            ReqLines.CALCSUMS("Actual Spent");
            IF ReqLines."Actual Spent" = 0 THEN
                ERROR('Actual Spent Amount cannot be zero');

            IF RequestHeader.Surrendered THEN
                ERROR('Imprest %1 has been surrendered', RequestHeader."No.");

            GLSetup.GET;


            //error('BD..');
            //CMSetup.GET();
            // Delete Lines Present on the General Journal Line
            GenJnline.RESET;
            GenJnline.SETRANGE(GenJnline."Journal Template Name", 'GENERAL');
            GenJnline.SETRANGE(GenJnline."Journal Batch Name", RequestHeader."No.");
            GenJnline.DELETEALL;

            GenJnlBatch.INIT;
            //IF CMSetup.GET() THEN
            GenJnlBatch."Journal Template Name" := 'GENERAL';
            GenJnlBatch.Name := RequestHeader."No.";
            IF NOT GenJnlBatch.GET(GenJnlBatch."Journal Template Name", GenJnlBatch.Name) THEN
                GenJnlBatch.INSERT;


            //Staff entries
            LineNo := 10000;
            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            ReqLines.CALCSUMS("Actual Spent");
            GenJnline.INIT;
            GenJnline."Journal Template Name" := 'GENERAL';
            GenJnline."Journal Batch Name" := RequestHeader."No.";
            GenJnline."Line No." := LineNo;
            GenJnline."Account Type" := GenJnline."Account Type"::Customer;
            GenJnline."Account No." := RequestHeader."Customer A/C"; //error('%1',GenJnline."Account No.");//RequestHeader."Account No.";
            GenJnline."Posting Date" := RequestHeader."Request Date";
            GenJnline."Document No." := RequestHeader."No.";
            //GenJnLine."External Document No.":=RequestHeader."Cheque No";
            GenJnline.Description := RequestHeader."Purpose of Imprest";
            GenJnline.Amount := -RequestHeader."Actual Amount";
            GenJnline.VALIDATE(Amount);
            //=====================================================================
            custledgerentries.RESET;
            custledgerentries.SETFILTER(custledgerentries."Customer No.", "Customer A/C");
            custledgerentries.SETFILTER(custledgerentries.Open, '%1', TRUE);
            custledgerentries.SETFILTER(custledgerentries."Document No.", '%1', "Applies-to Doc. No.");
            IF custledgerentries.FINDSET THEN BEGIN
                // GenJnline."Applies-to Doc. Type":=custledgerentries."Document Type";  //error('%1..',GenJnline."Applies-to Doc. Type");
            END;
            //=====================================================================
            GenJnline."Applies-to Doc. No." := RequestHeader."Applies-to Doc. No.";
            GenJnline."Shortcut Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
            GenJnline.VALIDATE("Shortcut Dimension 1 Code");
            GenJnline."Shortcut Dimension 2 Code" := RequestHeader."Global Dimension 2 Code";
            GenJnline.VALIDATE("Shortcut Dimension 2 Code");


            //Map Acitivty Codes to table 81
            ReqLines.RESET;
            ReqLines.SETRANGE("Document No", RequestHeader."No.");
            IF ReqLines.FIND('-') THEN BEGIN
                CASE ReqLines."Activity Type" OF
                    ReqLines."Activity Type"::WorkPlan:
                        BEGIN
                            //GenJnline."Work Plan Activity Code" := ReqLines.Activity;
                        END;
                    ReqLines."Activity Type"::"Admin & PE":
                        BEGIN
                            //GenJnline."PE Activity Code" := ReqLines.Activity;
                        END;
                END;
            END;


            IF GenJnline.Amount <> 0 THEN
                GenJnline.INSERT;
            /*
              //Create Receipt IF Chosen
             IF Selection=1 THEN BEGIN
                 //Insert Header
                 RequestHeader.CALCFIELDS("Remaining Amount");
                 IF RequestHeader."Remaining Amount">0 THEN BEGIN
                 IF RequestHeader."Receipt Created"=FALSE THEN BEGIN

                 ReceiptHeader.INIT;
                 ReceiptHeader."No.":=NoSeriesMgt.GetNextNo(GLSetup."Receipt No",TODAY,TRUE);
                 ReceiptHeader.Date:=TODAY;//RequestHeader."Imprest Surrender Date";
                 ReceiptHeader."Received From":=PVPayee;
                // ReceiptHeader."On Behalf Of":=;
                 ReceiptHeader."Global Dimension 1 Code":=RequestHeader."Global Dimension 1 Code";
                 ReceiptHeader."Global Dimension 2 Code":=RequestHeader."Global Dimension 2 Code";
                 IF NOT ReceiptHeader.GET(ReceiptHeader."No.") THEN
                 ReceiptHeader.INSERT;

                 END;
                 END;
             END;
              */

            //ERROR('N..99100');

            //Expenses
            ReqLines.RESET;
            ReqLines.SETRANGE(ReqLines."Document No", RequestHeader."No.");
            ReqLines.SETRANGE(Surrender, TRUE);
            IF ReqLines.FINDSET THEN BEGIN
                REPEAT

                    LineNo := LineNo + 10000;

                    GenJnline.INIT;
                    GenJnline."Journal Template Name" := 'GENERAL';
                    GenJnline."Journal Batch Name" := RequestHeader."No.";
                    GenJnline."Line No." := LineNo;
                    GenJnline."Account Type" := ReqLines."Account Type";
                    IF GenJnline."Account Type" = ReqLines."Account Type"::"Fixed Asset" THEN
                        GenJnline."FA Posting Type" := GenJnline."FA Posting Type"::"Acquisition Cost";

                    GenJnline."Account No." := ReqLines."Account No";
                    GenJnline.VALIDATE("Account No.");
                    GenJnline."Posting Date" := RequestHeader."Request Date";
                    GenJnline."Document No." := RequestHeader."No.";
                    GenJnline.Description := ReqLines.Description;
                    GenJnline.Amount := ReqLines."Actual Spent";
                    GenJnline.VALIDATE(Amount);
                    //Set these fields to blanks
                    GenJnline."Gen. Posting Type" := GenJnline."Gen. Posting Type"::" ";
                    GenJnline.VALIDATE("Gen. Posting Type");
                    GenJnline."Gen. Bus. Posting Group" := '';
                    GenJnline.VALIDATE("Gen. Bus. Posting Group");
                    GenJnline."Gen. Prod. Posting Group" := '';
                    GenJnline.VALIDATE("Gen. Prod. Posting Group");
                    GenJnline."VAT Bus. Posting Group" := '';
                    GenJnline.VALIDATE("VAT Bus. Posting Group");
                    GenJnline."VAT Prod. Posting Group" := '';
                    GenJnline.VALIDATE("VAT Prod. Posting Group");
                    //
                    GenJnline."Shortcut Dimension 1 Code" := RequestHeader."Global Dimension 1 Code";
                    GenJnline.VALIDATE("Shortcut Dimension 1 Code");
                    GenJnline."Shortcut Dimension 2 Code" := RequestHeader."Global Dimension 2 Code";
                    GenJnline.VALIDATE("Shortcut Dimension 2 Code");
                    IF ReqLines."Activity Type" = ReqLines."Activity Type"::WorkPlan THEN BEGIN
                        //GenJnline."Work Plan Activity Code" := ReqLines.Activity;
                    END;
                    IF ReqLines."Activity Type" = ReqLines."Activity Type"::"Admin & PE" THEN BEGIN
                        //GenJnline."PE Activity Code" := ReqLines.Activity;
                        ;
                    END;
                    IF ReqLines."Activity Type" = ReqLines."Activity Type"::"Proc Plan" THEN BEGIN
                        //GenJnline."Procurement Plan Code" := ReqLines.Activity;
                    END;

                    IF GenJnline.Amount <> 0 THEN
                        GenJnline.INSERT;

                UNTIL ReqLines.NEXT = 0;
            END;


            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJnline);

            //BD Check if the imprest was commited. If not it creates it..
            glsetup87.RESET;
            glsetup87.GET;
            commitmententry.RESET;
            commitmententry.SETFILTER(commitmententry."Document No.", '%1', RequestHeader."Imprest/Advance No");
            IF NOT commitmententry.FINDSET THEN BEGIN
                commitmententry.RESET;
                IF commitmententry.FINDLAST THEN BEGIN
                    recline.RESET;
                    recline.SETFILTER(recline."Document No", RequestHeader."No.");
                    IF recline.FINDSET THEN
                        REPEAT
                            commitmententry2.INIT;
                            commitmententry5.RESET;
                            commitmententry5.FINDLAST;
                            commitmententry2."Entry No" := commitmententry5."Entry No" + 1;
                            commitmententry2."Commitment Date" := RequestHeader."Request Date";
                            commitmententry2."Document No." := RequestHeader."Imprest/Advance No";
                            RequestHeader.CALCFIELDS(RequestHeader."Actual Amount", RequestHeader.Balance);
                            commitmententry2.Amount := recline.Amount;//ABS(RequestHeader."Actual Amount");
                            commitmententry2."Budget Line" := recline."Current Budget";
                            //commitmententry2."Budget Year" := glsetup87."Current Budget";

                            commitmententry2."User ID" := RequestHeader."User ID";
                            commitmententry2.Description := recline.Description + ' Imprest No: ' + RequestHeader."No.";
                            commitmententry2.GLAccount := recline."Account No";
                            IF recline."Activity Type" = recline."Activity Type"::WorkPlan THEN BEGIN
                                commitmententry2.WorkPlan := recline.Activity;
                            END;
                            IF recline."Activity Type" = recline."Activity Type"::"Admin & PE" THEN BEGIN
                                commitmententry2."PE Admin Code" := recline.Activity;
                            END;
                            IF recline."Activity Type" = recline."Activity Type"::"Proc Plan" THEN BEGIN
                                commitmententry2."Procurement Plan" := recline.Activity;
                            END;
                            commitmententry2.INSERT;

                        //workplanrec.RESET;
                        //workplanrec.SETFILTER(workplanrec.Code, recline.Activity);
                        //.SETFILTER(workplanrec."Work Plan Code", '%1', recline."Current Budget");
                        /*IF workplanrec.FINDSET THEN
                            REPEAT
                                workplanrec.CALCFIELDS(workplanrec."Committed Amount", workplanrec."Actual Spent");
                                workplanrec.Balance := workplanrec.Amount - workplanrec."Committed Amount" - workplanrec."Actual Spent";
                                workplanrec.MODIFY;
                            UNTIL workplanrec.NEXT = 0;*/
                        /* adminrec.RESET;
                        adminrec.SETFILTER(adminrec."PE Activity Code", recline.Activity);
                        adminrec.SETFILTER(adminrec.Code, '%1', recline."Current Budget");
                        IF adminrec.FINDSET THEN
                            REPEAT
                                adminrec.CALCFIELDS(adminrec."Commitment Amount", adminrec."Actual Spent");
                                adminrec.Balance := adminrec.Amount - adminrec."Commitment Amount" - adminrec."Actual Spent";
                                adminrec.MODIFY;
                            UNTIL adminrec.NEXT = 0;
                        Procrec.RESET;

                        IF Procrec.FINDSET THEN
                            REPEAT

                            UNTIL adminrec.NEXT = 0; */

                        UNTIL recline.NEXT = 0;
                END;

            END;

            commitmententry.RESET;
            IF commitmententry.FINDLAST THEN BEGIN
                recline.RESET;
                recline.SETFILTER(recline."Document No", RequestHeader."No.");
                IF recline.FINDSET THEN
                    REPEAT
                        commitmententry2.INIT;
                        commitmententry5.RESET;
                        commitmententry5.FINDLAST;
                        commitmententry2."Entry No" := commitmententry5."Entry No" + 1;
                        commitmententry2."Commitment Date" := RequestHeader."Request Date";
                        commitmententry2."Document No." := RequestHeader."No.";
                        RequestHeader.CALCFIELDS(RequestHeader."Actual Amount");
                        commitmententry2.Amount := -recline.Amount;//ABS(RequestHeader."Actual Amount");
                        commitmententry2."Budget Line" := recline."Current Budget";
                        //commitmententry2."Budget Year" := glsetup87."Current Budget";
                        commitmententry2."User ID" := RequestHeader."User ID";
                        commitmententry2.Description := recline.Description + 'Imprest Surrender No: ' + RequestHeader."No.";
                        commitmententry2.GLAccount := recline."Account No";
                        IF recline."Activity Type" = recline."Activity Type"::WorkPlan THEN BEGIN
                            commitmententry2.WorkPlan := recline.Activity;
                        END;
                        IF recline."Activity Type" = recline."Activity Type"::"Admin & PE" THEN BEGIN
                            commitmententry2."PE Admin Code" := recline.Activity;
                        END;
                        IF recline."Activity Type" = recline."Activity Type"::"Proc Plan" THEN BEGIN
                            commitmententry2."Procurement Plan" := recline.Activity;
                        END;
                        commitmententry2.INSERT;
                    //--------Update workplan    & other budget codes
                    /* workplanrec.RESET;
                    workplanrec.SETFILTER(workplanrec.Code, recline.Activity);
                    workplanrec.SETFILTER(workplanrec."Work Plan Code", '%1', recline."Current Budget");
                    IF workplanrec.FINDSET THEN
                        REPEAT
                            workplanrec.CALCFIELDS(workplanrec."Committed Amount", workplanrec."Actual Spent");
                            workplanrec.Balance := workplanrec.Amount - workplanrec."Committed Amount" - workplanrec."Actual Spent";
                            workplanrec.MODIFY;
                        UNTIL workplanrec.NEXT = 0;
                    adminrec.RESET;
                    adminrec.SETFILTER(adminrec."PE Activity Code", recline.Activity);
                    adminrec.SETFILTER(adminrec.Code, '%1', recline."Current Budget");
                    IF adminrec.FINDSET THEN
                        REPEAT
                            adminrec.CALCFIELDS(adminrec."Commitment Amount", adminrec."Actual Spent");
                            adminrec.Balance := adminrec.Amount - adminrec."Commitment Amount" - adminrec."Actual Spent";
                            adminrec.MODIFY;
                        UNTIL adminrec.NEXT = 0;
                    Procrec.RESET;

                    IF Procrec.FINDSET THEN
                        REPEAT

                        UNTIL adminrec.NEXT = 0; */


                    UNTIL recline.NEXT = 0;
            END;

            GLEntry.RESET;
            GLEntry.SETRANGE(GLEntry."Document No.", RequestHeader."No.");
            GLEntry.SETRANGE(GLEntry.Reversed, FALSE);
            GLEntry.SETRANGE("Posting Date", RequestHeader."Request Date");
            IF GLEntry.FIND('-') THEN BEGIN
                //Uncommit Entries made to the various expenses accounts

                RequestHeader.Posted := TRUE;
                RequestHeader.Surrendered := TRUE;
                //Message(format(RequestHeader.Posted));

                // Mark Imprest as Surrendered
                ReqHead.RESET;
                ReqHead.SETRANGE("No.", "Imprest/Advance No");
                ReqHead.SETRANGE(Type, ReqHead.Type::Imprest);
                ReqHead.SETRANGE(Posted, TRUE);
                IF ReqHead.FIND('-') THEN BEGIN

                    IF NOT ReqHead.Partial THEN  //Mark Full Imprest Surrendered
                        ReqHead.Surrendered := TRUE

                    ELSE BEGIN
                        RequestHeader1.RESET;
                        RequestHeader1.SETRANGE("Imprest/Advance No", "Imprest/Advance No");
                        RequestHeader1.SETRANGE(Type, RequestHeader1.Type::"Claim-Accounting");
                        RequestHeader1.SETRANGE(Posted, TRUE);
                        IF RequestHeader1.FIND('-') THEN BEGIN
                            REPEAT
                                TotalSurrendered := TotalSurrendered + RequestHeader1."Actual Amount";
                            UNTIL RequestHeader1.NEXT = 0;
                        END;

                        IF PartialImprest.GET("Partial Imprests", PartialImprest."Line No") THEN BEGIN // Mark the Particular Partial Imprest Surrendered
                            PartialImprest.Surrendered := TRUE;
                            PartialImprest.MODIFY;
                        END;

                        IF ReqHead."Issued Amount" = TotalSurrendered THEN //Mark the Partial Imprest Surrendered(Header)
                            ReqHead.Surrendered := TRUE;
                    END;


                    ReqHead.MODIFY;

                END;

                IF Selection = 1 THEN
                    RequestHeader."Receipt Created" := TRUE;
                RequestHeader.MODIFY;

            END;
        END;
        //END; //Imprest

        IF Type = Type::"Leave Application" THEN BEGIN
            PV.INIT;
            PV.No := '';
            PV.Date := TODAY;
            PV.Payee := RequestHeader."Employee Name";
            PV.Remarks := 'Refund';
            PV."PO/INV No" := RequestHeader."No.";
            PV."Paying Bank Account" := GLSetup."Default Bank Account";
            //Map Acitivty Codes to PV Header
            ReqLines.RESET;
            ReqLines.SETRANGE("Document No", RequestHeader."No.");
            IF ReqLines.FIND('-') THEN BEGIN
                CASE ReqLines."Activity Type" OF
                /* // SNN 03302021  ReqLines."Activity Type"::WorkPlan:
                     BEGIN
                         PV."Activity Type" := PV."Activity Type"::WorkPlan;
                         PV.Activity := ReqLines.Activity;
                     END;
                 ReqLines."Activity Type"::"Admin & PE":
                     BEGIN
                         PV."Activity Type" := PV."Activity Type"::"P&E";
                         PV.Activity := ReqLines.Activity;
                     END;  // SNN 03302021 */
                END;
            END;

            PV.INSERT(TRUE);
            RequestHeader.CALCFIELDS(RequestHeader."Imprest Amount");

            PVlines.INIT;
            PVlines."PV No" := PV.No;
            PVlines."Line No" := PVlines."Line No" + 10000;
            PVlines."Account Type" := PVlines."Account Type"::Customer;
            PVlines."Account No" := RequestHeader."Customer A/C";
            PVlines.Description := RequestHeader."Employee Name" + '-Refund';
            PVlines.Amount := RequestHeader."Actual Amount" - RequestHeader."Imprest Amount";
            PVlines."Loan No" := "No.";
            //Map Acitivty Codes to PV Lines
            ReqLines.RESET;
            ReqLines.SETRANGE("Document No", RequestHeader."No.");
            IF ReqLines.FIND('-') THEN BEGIN
                CASE ReqLines."Activity Type" OF
                /* // SNN 03302021 ReqLines."Activity Type"::WorkPlan:
                    BEGIN
                         PVlines."Activity Type___" := PVlines."Activity Type___"::WorkPlan;
                        PVlines.Activity := ReqLines.Activity;
                    END;
                ReqLines."Activity Type"::"Admin & PE":
                    BEGIN
                        PVlines."Activity Type___" := PVlines."Activity Type___"::"P&E";
                        PVlines.Activity := ReqLines.Activity;
                    END;// SNN 03302021*/
                END;
            END;

            PVlines.INSERT;

            MESSAGE('Payment Voucher %1 has been created for the claim refund %2', PV.No, RequestHeader."No.");
        END;

    end;

    local procedure CreatePVRBA()
    begin
    end;
}

