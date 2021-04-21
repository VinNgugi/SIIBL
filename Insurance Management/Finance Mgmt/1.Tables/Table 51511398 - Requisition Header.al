table 51511398 "Requisition Header"
{
    // version PROC

    DataCaptionFields = "No.", Reason;
    //DrillDownPageID = 51511888;
    //LookupPageID = 51511888;

    fields
    {
        field(1; "No."; Code[22])
        {
        }
        field(2; "Employee Code"; Code[20])
        {
            Editable = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                /*IF Empl.GET("Employee Code") THEN
                "Employee Name":=Empl."First Name"+' '+Empl."Last Name"
                ELSE
                "Employee Name":='';
                MODIFY;

               IF Empl.GET("Employee Code") THEN
               BEGIN
                "Global Dimension 1 Code":=Empl."Global Dimension 1 Code";
                "Global Dimension 2 Code":=Empl."Global Dimension 2 Code";
               END;
               */


                /*  IF Empl.GET("Employee Code") THEN BEGIN
                     "Employee Name" := Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name";
                     "Global Dimension 1 Code" := Empl."Global Dimension 1 Code";
                     "Global Dimension 2 Code" := Empl."Global Dimension 2 Code";

                 END ELSE BEGIN
                     "Employee Name" := '';
                     MODIFY;
                 END; */

            end;
        }
        field(3; "Employee Name"; Text[50])
        {
        }
        field(5; Reason; Text[100])
        {
        }
        field(6; "Requisition Date"; Date)
        {
        }
        field(7; Status; Option)
        {
            Caption = 'Status';
            Editable = true;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected,Archived;

            trigger OnValidate()
            begin
                IF Status = Status::Released THEN BEGIN
                    /* IF "Requisition Type" = "Requisition Type"::"Store Requisition" THEN BEGIN
                        Subject := 'Store Requisition Approval';
                        usersetup.RESET;
                        usersetup.SETRANGE("User ID", USERID);
                        IF usersetup.FINDFIRST THEN BEGIN
                            Sender := usersetup."E-Mail";
                            IF Emp.GET(usersetup."Employee No.") THEN
                                SenderName := Emp."First Name" + ' ' + Emp."Last Name";
                        END;
                        PurchSetup.GET;
                        SmtpSet.GET;
                        Sender := SmtpSet."User ID";
                        usersetup.RESET;
                        usersetup.SETRANGE("User ID", PurchSetup."STORE Account User");
                        IF usersetup.FINDFIRST THEN BEGIN
                            Reciept := usersetup."E-Mail";
                            IF Emp.GET(usersetup."Employee No.") THEN
                                Body := 'Dear ' + Emp."First Name" + ' ' + Emp."Last Name" + '<p>';
                        END;

                        Body := Body + 'Kindly note that store requisition-' + "No." + ' has been approved and awaiting your action';
                        Body := '<p> Kind Regards,<br>';
                        smtpcu.CreateMessage(SenderName, Sender, Reciept, Subject, Body, TRUE);

                        smtpcu.Send;


                    END;
                    IF "Requisition Type" = "Requisition Type"::"Purchase Requisition" THEN BEGIN
                        Subject := 'Purchase Requisition Approval';
                        usersetup.RESET;
                        usersetup.SETRANGE("User ID", USERID);
                        IF usersetup.FINDFIRST THEN BEGIN
                            Sender := usersetup."E-Mail";
                            IF Emp.GET(usersetup."Employee No.") THEN
                                SenderName := Emp."First Name" + ' ' + Emp."Last Name";
                        END;
                        PurchSetup.GET;
                        SmtpSet.GET;
                        Sender := SmtpSet."User ID";
                        usersetup.RESET;
                        usersetup.SETRANGE("User ID", PurchSetup."PROC MANAGER USER ID");
                        IF usersetup.FINDFIRST THEN BEGIN
                            Reciept := PurchSetup."Procurement Email";
                            IF Emp.GET(usersetup."Employee No.") THEN
                                Body := 'Dear ' + Emp."First Name" + ' ' + Emp."Last Name" + '<p>';
                        END;

                        Body := Body + 'Kindly note that purchase requisition-' + "No." + ' has been approved and awaiting your action';
                        Body := '<p> Kind Regards,<br>';
                        smtpcu.CreateMessage(SenderName, Sender, Reciept, Subject, Body, TRUE);
                        smtpcu.Send;


                    END; */
                END;
            end;
        }
        field(10; "Raised by"; Code[30])
        {
        }
        field(14; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18; "Purchase?"; Boolean)
        {
        }
        field(20; "MA Approval"; Boolean)
        {
        }
        field(21; Rejected; Boolean)
        {
        }
        field(22; "Process Type"; Option)
        {
            OptionMembers = " ",Direct,RFQ,RFP,Tender,"Low Value";

            trigger OnValidate()
            begin

                /* PurchSetup.GET; //"Max Low Value Proc Amount"

                IF "Process Type" <> "Process Type"::" " THEN
                    IF CONFIRM(Text004, TRUE, "Process Type") THEN BEGIN

                        CASE "Process Type" OF
                            "Process Type"::"Low Value":
                                BEGIN
                                    //PurchSetup.TESTFIELD("Max Low Value Proc Amount");
                                    CALCFIELDS(Amount);
                                    // IF Amount > PurchSetup."Max Low Value Proc Amount" THEN
                                    // ERROR(Text002, "Process Type",PurchSetup."Max Low Value Proc Amount");
                                END;
                            "Process Type"::RFQ:
                                BEGIN
                                    // PurchSetup.TESTFIELD("Max Quote Value Proc Amount");
                                    CALCFIELDS(Amount);
                                    //   IF Amount > PurchSetup."Max Quote Value Proc Amount" THEN
                                    //    ERROR(Text002, "Process Type",PurchSetup."Max Quote Value Proc Amount");
                                END;
                            "Process Type"::Tender:
                                BEGIN
                                    //     PurchSetup.TESTFIELD("Above Tender Value Proc Amount");
                                    CALCFIELDS(Amount);
                                    //     IF Amount < PurchSetup."Above Tender Value Proc Amount" THEN
                                    //     ERROR(Text003, "Process Type",PurchSetup."Above Tender Value Proc Amount");
                                END;


                        END;

                    END ELSE
                        "Process Type" := "Process Type"::" "; */
            end;
        }
        field(23; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");

                /*PurchaseReqDet.RESET;
                PurchaseReqDet.SETRANGE(PurchaseReqDet."Requistion No.","Requisition No.");
                
                f IF PurchaseReqDet.FIND('-') THEN BEGIN
                REPEAT
                PurchaseReqDet."Global Dimension 1 Code":="Global Dimension 1 Code";
                PurchaseReqDet.MODIFY;
                UNTIL PurchaseReqDet.NEXT=0;
                END;
                
                PurchaseReqDet.VALIDATE(PurchaseReqDet."No."); */

            end;
        }
        field(37; Ordered; Boolean)
        {
            Editable = false;
        }
        field(38; User; Code[30])
        {
            TableRelation = User;
        }
        field(39; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

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
                 END;*/

            end;
        }
        field(40; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                /*PurchaseReqDet.RESET;
                PurchaseReqDet.SETRANGE(PurchaseReqDet."Requistion No.","Requisition No.");
                
                IF PurchaseReqDet.FIND('-') THEN BEGIN
                REPEAT
                PurchaseReqDet."Global Dimension 3 Code":="Global Dimension 3 Code";
                PurchaseReqDet.MODIFY;
                UNTIL PurchaseReqDet.NEXT=0;
                
                 END;
                
                {IF "Global Dimension 2 Code" = '' THEN
                  EXIT;
                GetGLSetup;
                ValidateDimValue(GLSetup."Global Dimension 2 Code","Global Dimension 2 Code");
                
                }  */

            end;
        }
        field(41; "Procurement Plan"; Code[10])
        {
            TableRelation = "G/L Budget Name".Name;
        }
        field(42; "Purchaser Code"; Code[10])
        {
        }
        field(43; "Document Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Purchase Requisition,Store Requisition,Imprest,Claim-Accounting,Appointment,Payment Voucher';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Purchase Requisition","Store Requisition",Imprest,"Claim-Accounting",Appointment,"Payment Voucher";
        }
        field(44; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(45; "Date of Use"; Date)
        {
        }
        field(46; "Requisition Type"; Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Purchase Requisition,Store Requisition,Imprest,Claim-Accounting,Appointment,Payment Voucher,Claim,Category,Asset Disposal';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Purchase Requisition","Store Requisition",Imprest,"Claim-Accounting",Appointment,"Payment Voucher",Claim,Category,"Asset Disposal";
        }
        field(47; Posted; Boolean)
        {
        }
        field(48; "No of Approvals"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(51511398),
                                                        "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(49; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(50; "Purchase Type"; Code[30])
        {
            //TableRelation = "Purchases Types";
        }
        field(51; "Language Code (Default)"; Code[10])
        {
        }
        field(52; Attachment; Option)
        {
            OptionMembers = No,Yes;
        }
        field(53; "Posted By"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(54; "Date Posted"; Date)
        {
        }
        field(55; Issued; Boolean)
        {
            Editable = false;
        }
        field(56; "Issued By"; Code[30])
        {
        }
        field(57; Received; Boolean)
        {
        }
        field(58; "Received By"; Code[30])
        {
        }
        field(59; "Date Issued"; DateTime)
        {
        }
        field(60; "Date Received"; DateTime)
        {
        }
        field(61; Supplier; Text[100])
        {
        }
        field(62; "Supplier Code"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                /* IF Vend.GET ("Supplier Code") THEN
                Supplier:=Vend.Name; */
            end;
        }
        field(63; "LPO Generated"; Boolean)
        {
        }
        field(64; "Assigned User ID"; Code[70])
        {
            TableRelation = "User Setup";
        }
        field(65; Select; Boolean)
        {
        }
        field(66; "Date of Assignment"; Date)
        {
        }
        field(67; Amount; Decimal)
        {
            CalcFormula = Sum("Requisition Lines".Amount WHERE("Requisition No" = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(68; "Procurement Type"; Option)
        {
            OptionCaption = 'Goods&Services,Works';
            OptionMembers = "Goods&Services",Works;

            trigger OnValidate()
            begin
                /* PurchSetup.GET; //"Max Low Value Proc Amount"

                IF CONFIRM(Text004,TRUE,"Procurement Type") THEN BEGIN

                  CASE "Procurement Type" OF
                   "Procurement Type"::Works:
                     BEGIN
                       IF "Process Type" = "Process Type"::RFQ THEN BEGIN
                    //   PurchSetup.TESTFIELD("Max Quote Value Proc Amount");
                   //    PurchSetup.TESTFIELD("Quote Value Proc Amount-Works");
                       CALCFIELDS(Amount);
                    //   IF Amount < PurchSetup."Max Quote Value Proc Amount" THEN
                    //   ERROR(Text003, "Process Type",PurchSetup."Max Quote Value Proc Amount");
                    //   IF Amount > PurchSetup."Quote Value Proc Amount-Works" THEN
                    //   ERROR(Text002, "Process Type",PurchSetup."Quote Value Proc Amount-Works");

                       END;
                     IF "Process Type" = "Process Type"::Tender THEN BEGIN
                    //   PurchSetup.TESTFIELD("Tender Value Proc Amount-Works");
                   //    CALCFIELDS(Amount);
                   //    IF Amount < PurchSetup."Quote Value Proc Amount-Works" THEN
                   //    ERROR(Text003, "Process Type",PurchSetup."Above Tender Value Proc Amount");
                     END;
                     END;

                  END;

                END; */
            end;
        }
        field(69; "Contract No."; Code[10])
        {
        }
        field(50000; "Amount within Limit"; Boolean)
        {
        }
        field(50001; "Procurement No"; Code[20])
        {
            //TableRelation = "Procurement Request";
        }
        field(50002; "LPO Generated No"; Code[30])
        {
            //TableRelation = "Purchase Header".No.;
        }
        field(50003; "LPO Generated Date"; Date)
        {
        }
        field(50004; "Date Required"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Prequalification Committee"; Code[30])
        {
            DataClassification = ToBeClassified;
            /*  TableRelation = "Tender Commitee Appointment" WHERE ("Evaluation Type"=FILTER("Prequalification Evaluation"|"Supplier Registration"),
                                                                  "Tender/Quotation No"=FIELD("No."),
                                                                  Status=FILTER(Open)); */
        }
        field(50006; Opened; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Evaluation Lines Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "Prequalification Passmark"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "TOR Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "TOR File Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Pre Registration Attached"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Pre Registration File Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Asset Disposal"; Boolean)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                PurchLine.RESET;
                PurchLine.SETRANGE(PurchLine."Requisition No", "No.");
                IF PurchLine.FINDSET THEN BEGIN
                    REPEAT
                        PurchLine."Asset Disposal" := TRUE;
                    //PurchLine.MODIFY;
                    UNTIL PurchLine.NEXT = 0;
                END;
            end;
        }
        field(50014; "Batch No"; Code[30])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Disposal Batch"."Batch No";

            trigger OnValidate()
            begin
                PurchLine.RESET;
                PurchLine.SETRANGE(PurchLine."Requisition No", "No.");
                IF PurchLine.FINDSET THEN
                    PurchLine.DELETEALL();



                /* MaintenanceLines.RESET;
                MaintenanceLines.SETRANGE(MaintenanceLines."Batch No", "Batch No");
                // MaintenanceLines.SETRANGE(MaintenanceLines."Disposal method","Asset Disposal Method");
                MaintenanceLines.SETRANGE(MaintenanceLines.Descision, MaintenanceLines.Descision::Dispose);
                IF MaintenanceLines.FINDSET THEN
                    REPEAT
                        Asst.RESET;
                        Asst.SETRANGE("No.", MaintenanceLines."Asset No");
                        IF Asst.FINDFIRST THEN
                            //IF Asst.Disposed=FALSE THEN BEGIN
                            PurchLine.INIT;
                        PurchLine."Requisition No" := "No.";
                        PurchLine."Serial No." := Asst."Serial No.";
                        PurchLine."Line No" := PurchLine.COUNT + 100;
                        PurchLine.No := MaintenanceLines."Asset No";
                        PurchLine.Description := MaintenanceLines."Asset Description";
                        PurchLine.Type := PurchLine.Type::"Fixed Asset";
                        PurchLine."Acquisition Cost" := MaintenanceLines."Acquisition Cost";
                        PurchLine.Category := '';
                        PurchLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        PurchLine."Global Dimension 2 Code" := "Global Dimension 2 Code";
                        PurchLine."ShortCut Dimension 3 Code" := "Global Dimension 3 Code";
                        PurchLine."Book Value" := MaintenanceLines."Current Book Value";
                        PurchLine."Reserved Price" := MaintenanceLines."Reserved Price";
                        PurchLine."Acquisition Date" := MaintenanceLines."Acquisition Date";
                        PurchLine."Batch No" := MaintenanceLines."Batch No";
                        IF PurchLine.No <> '' THEN
                            PurchLine.INSERT(TRUE);
                    //END;
                    UNTIL MaintenanceLines.NEXT = 0; */
            end;
        }
        field(50015; "Asset Disposal Method"; Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Disposal Methods";
        }
        field(50016; "Process Sequence"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; EOI; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Assigned By"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "Memo File Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Employee Code")
        {
        }
        key(Key3; "Employee Name")
        {
        }
        key(Key4; Reason)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Reason)
        {
        }
    }

    trigger OnDelete()
    begin
        IF Status <> Status::Open THEN
            ERROR('You cannot delete a document that is already approved or pending approval');
    end;

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
            IF "Requisition Type" = "Requisition Type"::"Purchase Requisition" THEN BEGIN
                PurchSetup.GET;
                /*  PurchSetup.TESTFIELD("Purchase Req No");
                 NoSeriesMgt.InitSeries(PurchSetup."Purchase Req No",xRec."No.",0D,"No.","No. Series"); */
            END;

            IF "Requisition Type" = "Requisition Type"::"Store Requisition" THEN BEGIN
                PurchSetup.GET;
                /* PurchSetup.TESTFIELD(PurchSetup."Store Requisition Nos.");
                NoSeriesMgt.InitSeries(PurchSetup."Store Requisition Nos.",xRec."No.",0D,"No.","No. Series");
               END; */

                //Prequalification Request
                IF "Requisition Type" = "Requisition Type"::Category THEN BEGIN
                    PurchSetup.GET;
                    /* PurchSetup.TESTFIELD(PurchSetup."Preq Nos");
                    NoSeriesMgt.InitSeries(PurchSetup."Preq Nos",xRec."No.",0D,"No.","No. Series"); */
                    //NoSeriesMgt.InitSeries(SalesSetup."File Movement Numbers",xRec."File Movement Code",0D,"File Movement Code","No. Series");
                END;

                //Asset Disposal
                IF "Requisition Type" = "Requisition Type"::"Asset Disposal" THEN BEGIN
                    PurchSetup.GET;
                    /* PurchSetup.TESTFIELD(PurchSetup."Asset Disposal Nos");
                    NoSeriesMgt.InitSeries(PurchSetup."Asset Disposal Nos",xRec."No.",0D,"No.","No. Series"); */
                END;
            END;

            "Raised by" := USERID;
            "Date of Use" := TODAY;
            IF UsersRec.GET(USERID) THEN BEGIN
                IF UsersRec."Employee No." = '' THEN
                    ERROR(Txt0005);

                IF Empl.GET(UsersRec."Employee No.") THEN BEGIN
                    "Employee Code" := Empl."No.";
                    "Employee Name" := Empl."First Name" + ' ' + Empl."Last Name";
                    "Global Dimension 1 Code" := Empl."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Empl."Global Dimension 2 Code";

                    //"Procurement Plan":=PurchSetup."Effective Procurement Plan";
                END;
            END;

            "Requisition Date" := TODAY;
            GLSetup.RESET;
            GLSetup.GET;
            GLSetup.TESTFIELD("Current Budget");
            "Procurement Plan" := GLSetup."Current Budget";

            "Process Sequence" := 1;
        end;
    end;

    trigger OnModify()
    begin
        //IF Status<>Status::Open THEN
        //ERROR('You cannot modify a document that is already approved or pending approval');
    end;

    var
        Empl: Record 5200;
        PurchSetup: Record 312;
        NoSeriesMgt: Codeunit 396;
        UsersRec: Record 91;
        PurchLine: Record 51511399;
        Vend: Record 23;
        PurchaseHeader: Record 38;
        PurchaseLine: Record 39;
        PurchaseRecLine: Record 51511399;
        Text000: Label 'Please Select the Supplier';
        Text001: Label 'Purchase Order No %1 has been created';
        Text002: Label 'Process Type %1,  cannot be used when the Amount is above the set limit of %2';
        Text003: Label 'Process Type %1,  cannot be used when the Amount is less than the minimum the set limit of %2';
        Text004: Label 'Are you sure you want to select Process Type as %1 ?';
        /* ProcReq: Record 51511393;
        ProcReq1: Record 51511393;
        ProcReqLines: Record 51511400;
        ProcReqLines1: Record 51511400;
        ProcReqLines2: Record 51511400; */
        Recordsupdated: Integer;
        GLSetup: Record 51511018;
        lineno: Integer;
        locationrec: Record 14;
        Txt0005: Label 'You should be mapped to an employee. Please contact your system administrator.';
        /* DisposalBatch: Record 51511856;
        MaintenanceLines: Record 51511718; */
        Asst: Record 5600;
        smtpcu: Codeunit 400;
        Sender: Text;
        Reciept: Text;
        Subject: Text;
        Body: Text;
        FileName: Text;
        SenderName: Text;
        Emp: Record 5200;
        usersetup: Record 91;
        SmtpSet: Record 409;

    procedure PurchLinesExist(): Boolean
    begin
        PurchLine.RESET;
        //PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SETRANGE("Requisition No", "No.");
        EXIT(PurchLine.FINDFIRST);
    end;

    procedure QuantityExist(): Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Requisition No", "No.");
        IF PurchLine.FIND('-') THEN
            REPEAT
                IF PurchLine.Quantity <= 0 THEN
                    EXIT(FALSE)
                ELSE
                    EXIT(TRUE);
            UNTIL
            PurchLine.NEXT = 0;
    end;

    procedure LocationCodeExist() LocationExist: Boolean
    begin
        PurchLine.RESET;
        PurchLine.SETRANGE("Requisition No", "No.");
        IF PurchLine.FIND('-') THEN
            REPEAT
                IF PurchLine."Location Code" = '' THEN
                    LocationExist := FALSE
                ELSE
                    LocationExist := TRUE;
            UNTIL
            PurchLine.NEXT = 0;
        EXIT(LocationExist);
    end;

    /* procedure CreatePurchaseOrder(var PurchaseRec: Record "51511398")
    begin

        WITH PurchaseRec DO BEGIN

            /*IF Ordered THEN
            ERROR('An LPO has already been generated for requisition No %1',PurchaseRec."No.");

            IF PurchaseRec."Supplier Code" = '' THEN
                ERROR(Text000);


            //Purchase Header
            PurchaseHeader.INIT;
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
            PurchaseHeader."No." := '';
            PurchaseHeader."Buy-from Vendor No." := PurchaseRec."Supplier Code";
            PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
            IF Vend.GET(PurchaseRec."Supplier Code") THEN
                //PurchaseHeader."Supplier Type":=Vend."Sup Type";
                //PurchaseHeader."Requisition No":=PurchaseRec."No.";
                //PurchaseHeader.VALIDATE(PurchaseHeader."Requisition No");
                //PurchaseHeader."Contract No":=PurchaseRec."Contract No.";
                //IF NOT PurchaseHeader.GET(PurchaseHeader."No.") THEN
                PurchaseHeader.INSERT(TRUE);


            PurchaseRecLine.RESET;
            PurchaseRecLine.SETRANGE("Requisition No", PurchaseRec."No.");
            IF PurchaseRecLine.FIND('-') THEN BEGIN
                REPEAT
                    //Purchase Lines
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE(PurchaseLine."Line No.", PurchaseRecLine."Line No");
                    PurchaseLine.SETRANGE(PurchaseLine."Buy-from Vendor No.", PurchaseRec."Supplier Code");
                    IF NOT PurchaseLine.FINDFIRST THEN BEGIN
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseRecLine."Line No";//PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine."Buy-from Vendor No." := PurchaseRec."Supplier Code";

                        IF PurchaseRecLine.Type = PurchaseRecLine.Type::"3" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        IF PurchaseRecLine.Type = PurchaseRecLine.Type::"G/L Account" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        IF PurchaseRecLine.Type = PurchaseRecLine.Type::Item THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item;


                        PurchaseLine."No." := PurchaseRecLine.No;
                        PurchaseLine.Description := PurchaseRecLine.Description;
                        PurchaseLine."Unit of Measure" := PurchaseRecLine."Unit of Measure";
                        PurchaseLine.Quantity := PurchaseRecLine.Quantity;
                        PurchaseLine."Direct Unit Cost" := PurchaseRecLine."Unit Price";
                        PurchaseLine.VALIDATE(PurchaseLine."Direct Unit Cost");
                        PurchaseLine."Location Code" := PurchaseRecLine."Location Code";
                        PurchaseLine."Contract No" := PurchaseRec."Contract No.";
                        IF NOT PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchaseHeader."No.", PurchaseRecLine."Line No") THEN
                            PurchaseLine.INSERT(TRUE);
                    END;
                UNTIL PurchaseRecLine.NEXT = 0;
                //CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order",PurchaseHeader);
            END;

            MESSAGE(Text001, PurchaseHeader."No.");


            PurchaseRec.Ordered := TRUE;
            PurchaseRec.MODIFY;

            //Update the Proc Request
            ProcReq.RESET;
            ProcReq.SETRANGE("Requisition No", PurchaseRec."No.");
            ProcReq.SETRANGE(Closed, FALSE);
            IF ProcReq.FIND('-') THEN BEGIN
                ProcReq.Closed := TRUE;
                ProcReq.Status := ProcReq.Status::"Pending Approval";
                ProcReq.MODIFY;
            END;




        END;

    end; */

    procedure CreatePurchaseOrderCont(var PurchaseRec: Record 51511398; var Amnt: Decimal)
    begin

        WITH PurchaseRec DO BEGIN

            /*IF Ordered THEN
            ERROR('An LPO has already been generated for requisition No %1',PurchaseRec."No.");*/

            IF PurchaseRec."Supplier Code" = '' THEN
                ERROR(Text000);


            //Purchase Header
            PurchaseHeader.INIT;
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
            PurchaseHeader."No." := '';
            PurchaseHeader."Buy-from Vendor No." := PurchaseRec."Supplier Code";
            PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
            IF Vend.GET(PurchaseRec."Supplier Code") THEN
                //PurchaseHeader."Supplier Type":=Vend."Sup Type";
                //PurchaseHeader."Requisition No":=PurchaseRec."No.";
                //PurchaseHeader."Contract No":=PurchaseRec."Contract No.";
                //IF NOT PurchaseHeader.GET(PurchaseHeader."No.") THEN
                PurchaseHeader.INSERT(TRUE);


            PurchaseRecLine.RESET;
            PurchaseRecLine.SETRANGE("Requisition No", PurchaseRec."No.");
            IF PurchaseRecLine.FIND('-') THEN BEGIN
                REPEAT
                    //Purchase Lines
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE(PurchaseLine."Line No.", PurchaseRecLine."Line No");
                    PurchaseLine.SETRANGE(PurchaseLine."Buy-from Vendor No.", PurchaseRec."Supplier Code");
                    IF NOT PurchaseLine.FINDFIRST THEN BEGIN
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseRecLine."Line No";//PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine."Buy-from Vendor No." := PurchaseRec."Supplier Code";

                        //IF PurchaseRecLine.Type = PurchaseRecLine.Type::"3" THEN
                        // PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        IF PurchaseRecLine.Type = PurchaseRecLine.Type::"G/L Account" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        IF PurchaseRecLine.Type = PurchaseRecLine.Type::Item THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item;


                        PurchaseLine."No." := PurchaseRecLine.No;
                        PurchaseLine.Description := PurchaseRecLine.Description;
                        PurchaseLine."Unit of Measure" := PurchaseRecLine."Unit of Measure";
                        PurchaseLine.Quantity := PurchaseRecLine.Quantity;
                        PurchaseLine."Direct Unit Cost" := Amnt;//PurchaseRecLine."Unit Price";
                        PurchaseLine.VALIDATE(PurchaseLine."Direct Unit Cost");
                        PurchaseLine."Location Code" := PurchaseRecLine."Location Code";
                        //PurchaseLine."Contract No" := PurchaseRec."Contract No.";
                        IF NOT PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchaseHeader."No.", PurchaseRecLine."Line No") THEN
                            PurchaseLine.INSERT(TRUE);
                    END;
                UNTIL PurchaseRecLine.NEXT = 0;
                //CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order",PurchaseHeader);
            END;

            MESSAGE(Text001, PurchaseHeader."No.");


            PurchaseRec.Ordered := TRUE;
            PurchaseRec.MODIFY;

            //Update the Proc Request
            /* ProcReq.RESET;
            ProcReq.SETRANGE("Requisition No", PurchaseRec."No.");
            ProcReq.SETRANGE(Closed, FALSE);
            IF ProcReq.FIND('-') THEN BEGIN
                ProcReq.Closed := TRUE;
                ProcReq.Status := ProcReq.Status::"Pending Approval";
                ProcReq.MODIFY;
            END; */




        END;

    end;

    /* procedure CreatePurchaseOrderProcMethod(var ProcReq: Record 51511393)
    var
        PurchaseRec: Record "51511398";
    begin

        WITH ProcReq DO BEGIN

            //Purchase Header
            PurchaseHeader.INIT;
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
            PurchaseHeader."No." := '';
            PurchaseHeader."Buy-from Vendor No." := ProcReq."Vendor No";
            PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
            IF Vend.GET(ProcReq."Vendor No") THEN
                //PurchaseHeader."Supplier Type":=Vend."Sup Type";
                //PurchaseHeader."Requisition No":=ProcReq."Requisition No";
                PurchaseHeader."Posting Date" := TODAY;
            PurchaseHeader."Due Date" := TODAY;
            PurchaseHeader.VALIDATE(PurchaseHeader."Posting Date");
            PurchaseHeader."Document Date" := TODAY;
            PurchaseHeader.VALIDATE(PurchaseHeader."Document Date");
            PurchaseHeader."Source Document" := No;
            PurchaseHeader."Requisition No" := "Requisition No";
            //IF NOT PurchaseHeader.GET(PurchaseHeader."No.") THEN
            PurchaseHeader.INSERT(TRUE);


            ProcReqLines.RESET;
            ProcReqLines.SETRANGE("Requisition No", ProcReq.No);
            IF ProcReqLines.FIND('-') THEN BEGIN
                REPEAT
                    //Purchase Lines
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE(PurchaseLine."Line No.", ProcReqLines."Line No");
                    PurchaseLine.SETRANGE(PurchaseLine."Buy-from Vendor No.", ProcReq."Vendor No");
                    IF NOT PurchaseLine.FINDFIRST THEN BEGIN
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := ProcReqLines."Line No";//PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine."Buy-from Vendor No." := ProcReq."Vendor No";
                        //PurchaseLine.Type:=ProcReqLines.Type;

                        IF ProcReqLines.Type = ProcReqLines.Type::"3" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        IF ProcReqLines.Type = ProcReqLines.Type::"Fixed Asset" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        IF ProcReqLines.Type = ProcReqLines.Type::Item THEN BEGIN
                            PurchaseLine.Type := PurchaseLine.Type::Item;
                        END;
                        PurchaseLine."No." := ProcReqLines.No;
                        PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine."Activity Type" := ProcReqLines."Activity Type";
                        PurchaseLine.Activity := ProcReqLines.Activity;
                        PurchaseLine."Current Budget" := ProcReqLines."Current Budget";
                        PurchaseLine."Procurement Plan" := ProcReqLines."Procurement Plan";
                        PurchaseLine."Procurement Plan Item" := ProcReqLines."Procurement Plan Item";
                        PurchaseLine."Shortcut Dimension 1 Code" := ProcReqLines."Global Dimension 1 Code";//Department
                        PurchaseLine.Description := ProcReqLines.Description;
                        PurchaseLine."Unit of Measure" := PurchaseRecLine."Unit of Measure";
                        PurchaseLine.Quantity := ProcReqLines.Quantity;
                        PurchaseLine."Direct Unit Cost" := ProcReqLines."Unit Price";
                        PurchaseLine.VALIDATE(PurchaseLine."Direct Unit Cost");
                        //PurchaseLine."Location Code":=PurchaseRecLine."Location Code";
                        PurchLine.Amount := PurchaseLine.Quantity * PurchaseLine."Direct Unit Cost";
                        PurchaseLine.VALIDATE(Quantity);
                        PurchaseLine."Direct Unit Cost" := ProcReqLines."Unit Price";
                        IF NOT PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchaseHeader."No.", ProcReqLines."Line No") THEN
                            PurchaseLine.INSERT(TRUE);
                    END;
                UNTIL ProcReqLines.NEXT = 0;
                //CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order",PurchaseHeader);
            END;

            MESSAGE(Text001, PurchaseHeader."No.");

            IF PurchaseRec.GET(ProcReq."Requisition No") THEN BEGIN
                PurchaseRec.Ordered := TRUE;
                PurchaseRec."LPO Generated" := TRUE;
                PurchaseRec.MODIFY;
            END;

            //Update the Proc Request
            ProcReq.Closed := TRUE;
            //ProcReq.Status:=ProcReq.Status::"Pending Approval";
            ProcReq."LPO Generated" := TRUE;
            ProcReq.MODIFY;


        END;
    end; */

    /* procedure CreatePurchaseOrderProcMethodLines(var ProcReqLines: Record 51511400)
    var
        PurchaseRec: Record "51511398";
    begin

        WITH ProcReqLines DO BEGIN

            ProcReqLines2.RESET;
            ProcReqLines2.SETRANGE("Requisition No", ProcReqLines."Requisition No");
            ProcReqLines2.SETRANGE(Select, TRUE);
            ProcReqLines2.SETRANGE(Ordered, FALSE);
            ProcReqLines2.SETRANGE("Vendor No", ProcReqLines."Vendor No");
            IF ProcReqLines2.FIND('-') THEN BEGIN

                //Purchase Header
                PurchaseHeader.INIT;
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                PurchaseHeader."No." := '';
                PurchaseHeader."Buy-from Vendor No." := ProcReqLines2."Vendor No";
                PurchaseHeader.VALIDATE(PurchaseHeader."Buy-from Vendor No.");
                IF Vend.GET(ProcReqLines2."Vendor No") THEN
                    //PurchaseHeader."Supplier Type":=Vend."Sup Type";

                    ProcReq.RESET;
                ProcReq.SETRANGE(ProcReq.No, ProcReqLines2."Requisition No");
                IF ProcReq.FIND('-') THEN
                    //PurchaseHeader."Requisition No":=ProcReq."Requisition No";
                    //IF NOT PurchaseHeader.GET(PurchaseHeader."No.") THEN
                    PurchaseHeader.INSERT(TRUE);


                REPEAT
                    //Purchase Lines
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE(PurchaseLine."Line No.", ProcReqLines2."Line No");
                    PurchaseLine.SETRANGE(PurchaseLine."Buy-from Vendor No.", ProcReqLines2."Vendor No");
                    IF NOT PurchaseLine.FINDFIRST THEN BEGIN
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := ProcReqLines2."Line No";//PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine."Buy-from Vendor No." := ProcReqLines2."Vendor No";

                        IF ProcReqLines.Type = ProcReqLines2.Type::"3" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        IF ProcReqLines.Type = ProcReqLines2.Type::"Fixed Asset" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        IF ProcReqLines.Type = ProcReqLines2.Type::Item THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item;

                        PurchaseLine."No." := ProcReqLines2.No;
                        PurchaseLine.Description := ProcReqLines2.Description;
                        PurchaseLine."Unit of Measure" := ProcReqLines2."Unit of Measure";
                        PurchaseLine.Quantity := ProcReqLines2.Quantity;
                        PurchaseLine."Direct Unit Cost" := ProcReqLines2."Unit Price";
                        PurchaseLine.VALIDATE(PurchaseLine."Direct Unit Cost");
                        //PurchaseLine."Location Code":=PurchaseRecLine."Location Code";
                        IF NOT PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchaseHeader."No.", ProcReqLines2."Line No") THEN
                            PurchaseLine.INSERT(TRUE);
                    END;
                    //UNTIL ProcReqLines.NEXT = 0;
                    //CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order",PurchaseHeader);


                    //Update the Proc Request
                    /*ProcReqLines.RESET;
                    ProcReqLines.SETRANGE("Requisition No",ProcReqLines."Requisition No");
                    ProcReqLines.SETRANGE(Ordered,FALSE);
                    ProcReqLines.SETRANGE(Select,TRUE);
                    IF ProcReqLines.FIND('-') THEN BEGIN
                    REPEAT
                    ProcReqLines2.Ordered := TRUE;
                    ProcReqLines2."Order Date" := TODAY;
                    ProcReqLines2.MODIFY;
                /*UNTIL ProcReqLines.NEXT =0;
                END;

                //END;
                UNTIL ProcReqLines2.NEXT = 0;

                MESSAGE(Text001, PurchaseHeader."No.");
            END;//****ProcReqLines2

            //Update Header Fully ordered*****
            Recordsupdated := 0;
            //Update Header Fully ordered
            ProcReqLines1.RESET;
            ProcReqLines1.SETRANGE("Requisition No", ProcReqLines."Requisition No");
            ProcReqLines1.SETRANGE(Ordered, FALSE);
            ProcReqLines1.SETRANGE(Select, TRUE);
            IF ProcReqLines1.FIND('-') THEN BEGIN
                REPEAT
                    Recordsupdated := Recordsupdated + 1;
                UNTIL ProcReqLines1.NEXT = 0;
            END;


            IF Recordsupdated = 0 THEN BEGIN
                ProcReq.Closed := TRUE;
                ProcReq.Status := ProcReq.Status::"Pending Approval";
                ProcReq.MODIFY;

                //Update Purch Req
                ProcReq.RESET;
                ProcReq.SETRANGE(ProcReq.No, ProcReqLines."Requisition No");
                IF ProcReq.FIND('-') THEN
                    IF PurchaseRec.GET(ProcReq."Requisition No") THEN BEGIN
                        PurchaseRec.Ordered := TRUE;
                        PurchaseRec.MODIFY;
                    END;


            END;
            //Update Header Fully ordered*****


        END;

    end; */

    /* procedure CreatePurchaseOrderMilestone(var PurchaseRec: Record 51511398; vendorno: Code[20]; docdate: Date; MilestoneAmount: Decimal; RFQNo: Code[20]; OverheadCostsDec: Decimal)
    var
        //rfqrec: Record 51511393;
        //rfqline: Record 51511400;
        //PurchaseOrderP: Page 50;
    begin
        WITH PurchaseRec DO BEGIN

            //Purchase Header
            PurchaseHeader.INIT;
            PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
            PurchaseHeader."No." := '';

            PurchaseHeader."Buy-from Vendor No." := vendorno;
            PurchaseHeader.VALIDATE("Buy-from Vendor No.");
            PurchaseHeader."Pay-to Vendor No." := vendorno;
            PurchaseHeader.VALIDATE("Pay-to Vendor No.");
            PurchaseHeader."Document Date" := docdate;
            PurchaseHeader.VALIDATE("Document Date");
            rfqrec.RESET;
            rfqrec.GET(RFQNo);
            PurchaseHeader."Requisition No" := rfqrec."Requisition No";
            PurchaseHeader."Source Document" := RFQNo;
            PurchaseHeader."Evaluation Report" := rfqrec."Evaluation Report";

            PurchaseHeader.INSERT(TRUE);

            rfqrec.RESET;
            rfqrec.GET(RFQNo);
            rfqline.SETFILTER("Requisition No", rfqrec.No);
            IF rfqline.FINDSET THEN BEGIN
                REPEAT

                    //ERROR('Existing...');
                    //Purchase Lines
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE(PurchaseLine."Line No.", PurchaseRecLine."Line No");
                    PurchaseLine.SETRANGE(PurchaseLine."Buy-from Vendor No.", vendorno);
                    IF NOT PurchaseLine.FINDFIRST THEN BEGIN
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        PurchaseLine."Line No." := PurchaseRecLine."Line No";//PurchaseLine.VALIDATE(PurchaseLine."No.");
                        lineno += PurchaseLine."Line No.";
                        PurchaseLine."Buy-from Vendor No." := vendorno;

                        IF rfqline.Type = rfqline.Type::"3" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        IF rfqline.Type = rfqline.Type::"G/L Account" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        IF rfqline.Type = rfqline.Type::Item THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item;


                        PurchaseLine."No." := rfqline.No;
                        PurchaseLine.Description := rfqrec.Title + ' ' + rfqline.Description;
                        PurchaseLine."Unit of Measure" := rfqline."Unit of Measure";
                        PurchaseLine.VALIDATE("No.");

                        locationrec.RESET;
                        locationrec.SETFILTER(Code, '<>%1', '');
                        locationrec.FINDSET;
                        IF PurchaseLine.Type = PurchaseLine.Type::Item THEN BEGIN
                            PurchaseLine."Location Code" := locationrec.Code;
                            PurchaseLine.VALIDATE("Location Code");
                        END;


                        PurchaseLine.Quantity := 1;
                        PurchaseLine.VALIDATE(Quantity);

                        PurchaseLine."Direct Unit Cost" := MilestoneAmount;
                        PurchaseLine.VALIDATE(PurchaseLine."Direct Unit Cost");

                        //PurchaseLine."Location Code":=PurchaseRecLine."Location Code";
                        PurchaseLine."Contract No" := PurchaseRec."Contract No.";
                        PurchaseLine."Procurement Plan" := rfqline."Procurement Plan";
                        PurchaseLine."Procurement Plan Item" := rfqline."Procurement Plan Item";
                        IF NOT PurchaseLine.GET(PurchaseLine."Document Type"::Order, PurchaseHeader."No.", PurchaseRecLine."Line No") THEN
                            PurchaseLine.INSERT(TRUE);
                    END;
                UNTIL rfqline.NEXT = 0;
                //ERROR('yu...11');
                //Overhead Costs=====================================================================================
                //Purchase Lines
                IF OverheadCostsDec <> 0 THEN BEGIN
                    //ERROR('...');
                    PurchaseLine.RESET;
                    PurchaseLine.SETRANGE(PurchaseLine."Document Type", PurchaseLine."Document Type"::Order);
                    PurchaseLine.SETRANGE(PurchaseLine."Document No.", PurchaseHeader."No.");
                    PurchaseLine.SETRANGE(PurchaseLine."Line No.", PurchaseRecLine."Line No");
                    PurchaseLine.SETRANGE(PurchaseLine."Buy-from Vendor No.", vendorno);
                    IF PurchaseLine.FINDFIRST THEN BEGIN
                        PurchaseLine.INIT;
                        PurchaseLine."Document Type" := PurchaseLine."Document Type"::Order;
                        PurchaseLine."Document No." := PurchaseHeader."No.";
                        lineno += PurchaseLine."Line No.";
                        //ERROR('%1',lineno);
                        PurchaseLine."Line No." := 10000;//PurchaseLine.VALIDATE(PurchaseLine."No.");
                        PurchaseLine."Buy-from Vendor No." := vendorno;
                        //ERROR('...');
                        IF rfqline.Type = rfqline.Type::"3" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                        IF rfqline.Type = rfqline.Type::"G/L Account" THEN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        IF rfqline.Type = rfqline.Type::Item THEN
                            PurchaseLine.Type := PurchaseLine.Type::Item;




                        PurchaseLine."No." := rfqline.No;
                        PurchaseLine.Description := rfqrec.Title + ' ' + rfqline.Description + '-Overhead Costs';
                        PurchaseLine."Unit of Measure" := rfqline."Unit of Measure";

                        PurchaseLine.VALIDATE("No.");
                        locationrec.RESET;
                        locationrec.SETFILTER(Code, '<>%1', '');
                        locationrec.FINDSET;
                        IF PurchaseLine.Type = PurchaseLine.Type::Item THEN BEGIN
                            PurchaseLine."Location Code" := locationrec.Code;
                            PurchaseLine.VALIDATE("Location Code");
                        END;

                        PurchaseLine.Quantity := 1;
                        PurchaseLine.VALIDATE(Quantity);
                        PurchaseLine."Direct Unit Cost" := OverheadCostsDec;
                        PurchaseLine.VALIDATE(PurchaseLine."Direct Unit Cost");
                        //PurchaseLine."Location Code":=PurchaseRecLine."Location Code";
                        PurchaseLine."Contract No" := PurchaseRec."Contract No.";
                        PurchaseLine."Procurement Plan" := rfqline."Procurement Plan";
                        PurchaseLine."Procurement Plan Item" := rfqline."Procurement Plan Item";
                        // IF NOT PurchaseLine.GET(PurchaseLine."Document Type"::Order,PurchaseHeader."No.",PurchaseRecLine."Line No") THEN
                        PurchaseLine.INSERT(TRUE);
                    END;
                END;
                //===================================================================================================
                //CODEUNIT.RUN(CODEUNIT::"Purch.-Quote to Order",PurchaseHeader);
            END;

            MESSAGE(Text001, PurchaseHeader."No.");


            PurchaseRec.Ordered := TRUE;
            PurchaseRec.MODIFY;

            //Update the Proc Request
            ProcReq.RESET;
            ProcReq.SETRANGE("Requisition No", PurchaseRec."No.");
            ProcReq.SETRANGE(Closed, FALSE);
            IF ProcReq.FIND('-') THEN BEGIN
                ProcReq.Closed := TRUE;
                //ProcReq.Status:=ProcReq.Status::"Pending Approval";
                ProcReq.MODIFY;
            END;



            //PAGE.RUNMODAL(PurchaseOrderP,PurchaseHeader);
            PAGE.RUN(50, PurchaseHeader);
        END;
    end; */

    [Scope('Personalization')]
    procedure ReqLinesExist(): Boolean
    begin
        PurchaseRecLine.RESET;
        PurchaseRecLine.SETRANGE("Requisition No", "No.");
        EXIT(PurchaseRecLine.FINDFIRST);
    end;
}

