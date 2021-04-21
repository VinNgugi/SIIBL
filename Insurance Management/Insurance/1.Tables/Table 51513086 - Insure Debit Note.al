table 51513086 "Insure Debit Note"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy;
        }
        field(2; "No."; Code[30])
        {
        }
        field(3; "Insured No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(4; "Family Name"; Text[20])
        {
        }
        field(5; "First Names(s)"; Text[20])
        {
        }
        field(6; Title; Option)
        {
            OptionMembers = Mr,Mrs,Ms,Dr,Prof;
        }
        field(7; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Divorced,"Widowed ";
        }
        field(8; Sex; Option)
        {
            OptionMembers = Male,Female;
        }
        field(9; "Date of Birth"; Date)
        {
        }
        field(10; "Height Unit"; Option)
        {
            OptionMembers = m,ft,inches,cm;
        }
        field(11; Height; Decimal)
        {
            DecimalPlaces = 1 : 2;
        }
        field(12; "Weight Unit"; Option)
        {
            OptionMembers = Kg,Lbs,Stone;
        }
        field(13; Weight; Decimal)
        {
        }
        field(14; Industry; Text[20])
        {
            TableRelation = "Industry Group";
        }
        field(15; Occupation; Text[130])
        {
        }
        field(16; Nationality; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(17; "Country of Residence"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(18; Mobile; Code[14])
        {
        }
        field(19; "Premium Payment Frequency"; Option)
        {
            OptionMembers = " ","Annual Payment","Bi-Annual Payment","Quarterly Payment","Monthy Payment";
        }
        field(20; Forms; Text[130])
        {
        }
        field(21; "Policy Type"; Code[20])
        {
            TableRelation = "Policy Type".Code;
        }
        field(22; "Agent/Broker"; Code[20])
        {
            TableRelation = Customer WHERE("Customer Type" = CONST("Agent/Broker"));
        }
        field(23; Underwriter; Code[20])
        {
            TableRelation = Vendor."No.";
        }
        field(24; "Exclude from Renewal"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(25; "Brokers Name"; Text[50])
        {
            Editable = false;
        }
        field(26; "Undewriter Name"; Text[60])
        {
            Editable = false;
        }
        field(27; "Discount %"; Decimal)
        {
            Editable = true;
        }
        field(28; "Insurance Type"; Code[20])
        {
        }
        field(29; "Premium Amount"; Decimal)
        {
        }
        field(30; "Effective Start date"; Date)
        {
        }
        field(31; "Group Name"; Text[30])
        {
        }
        field(32; "Excess Level"; Code[10])
        {
        }
        field(33; "Policy No"; Code[30])
        {
        }
        field(34; "Quote Type"; Option)
        {
            Editable = true;
            InitValue = New;
            OptionMembers = " ",New,Modification,Renewal;
        }
        field(35; "No. of Lives"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(36; "No. of Members"; Integer)
        {
            FieldClass = Normal;
        }
        field(37; "No. of Dependants"; Integer)
        {
            FieldClass = Normal;
        }
        field(38; "Broker #2"; Code[20])
        {
        }
        field(39; "Broker #3"; Code[20])
        {
        }
        field(40; "Broker #2 Name"; Text[20])
        {
            Editable = false;
        }
        field(41; "Broker #3 Name"; Text[20])
        {
            Editable = false;
        }
        field(42; "Commission Due"; Decimal)
        {
        }
        field(43; "Commission Payable 1"; Decimal)
        {
        }
        field(44; "Commission Payable 2"; Decimal)
        {
        }
        field(45; "Commission Payable 3"; Decimal)
        {
        }
        field(46; "Correspondence Country/State"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(47; "Phone No."; Text[20])
        {
        }
        field(48; "Fax No"; Text[20])
        {
        }
        field(49; "E-mail"; Text[30])
        {
        }
        field(50; "Payment Method"; Option)
        {
            OptionMembers = Annual,"Bi-Annual",Quarterly,Monthly;
        }
        field(51; "Cover Type"; Option)
        {
            OptionMembers = " ",Individual,Group;
        }
        field(52; "Total Premium Amount"; Decimal)
        {
            CalcFormula = Sum("Insure Debit Note Lines".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                                      "Document No." = FIELD("No."),
                                                                      "Description Type" = CONST("Schedule of Insured")));
            DecimalPlaces = 0 : 0;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Total  Discount Amount"; Decimal)
        {
            CalcFormula = Sum("Insure Debit Note Lines".Amount WHERE("Description Type" = CONST(Deductible)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Total Commission Due"; Decimal)
        {
            Editable = false;
        }
        field(55; "Total Commission Owed"; Decimal)
        {
            Editable = false;
        }
        field(56; "Total Training Levy"; Decimal)
        {
            Editable = false;
        }
        field(57; "Total Stamp Duty"; Decimal)
        {
            Editable = false;
        }
        field(58; "Total Tax"; Decimal)
        {
            CalcFormula = Sum("Insure Debit Note Lines".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                                      "Document No." = FIELD("No."),
                                                                      Tax = CONST(True)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(59; "From Date"; Date)
        {
        }
        field(60; "To Date"; Date)
        {
        }
        field(61; "From Time"; Text[4])
        {
        }
        field(62; "To Time"; Text[4])
        {
        }
        field(63; "Policy Status"; Option)
        {
            Editable = true;
            OptionMembers = " ",Live,Expired,Lapsed,Cancelled,Renewed;
        }
        field(64; "Expected Renewal Date"; Date)
        {
        }
        field(65; "Expected Renewal Time"; Time)
        {
        }
        field(66; "Modification Type"; Option)
        {
            OptionMembers = " ",Addition,Deletion;
        }
        field(67; "Policy Class"; Code[10])
        {
            TableRelation = "Insurance Class";
        }
        field(68; "Cover Period"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(69; "Mid Term Adjustment Factor"; Decimal)
        {
            Editable = false;
        }
        field(70; "Copied from No."; Code[20])
        {
        }
        field(71; "Payment Mode"; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(72; "Total Net Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Debit Note Lines".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "EHS Policy No"; Code[20])
        {
        }
        field(74; "Created By"; Code[80])
        {
            Editable = false;
            TableRelation = User;
        }
        field(75; "Follow Up Person"; Code[80])
        {
            TableRelation = User;
        }
        field(76; "Follow Up Date"; Date)
        {
        }
        field(77; "Renewal Date"; Date)
        {
        }
        field(78; "Vessel Name"; Text[30])
        {
        }
        field(79; "Mode of Conveyance"; Text[150])
        {
        }
        field(80; "Response Period"; DateTime)
        {
        }
        field(81; "Policy Description"; Text[50])
        {
            Editable = false;
        }
        field(82; "Cover Type Description"; Text[50])
        {
            Editable = false;
        }
        field(83; "Total Sum Insured"; Decimal)
        {
            CalcFormula = Sum("Insure Debit Note Lines"."Sum Insured" WHERE("Document Type" = FIELD("Document Type"),
                                                                             "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(84; "Order Hereon"; Decimal)
        {
        }
        field(85; "Insured Name"; Text[80])
        {
        }
        field(86; "ID/Passport No."; Code[20])
        {
        }
        field(87; "PIN No."; Code[20])
        {
        }
        field(88; "No. Series"; Code[10])
        {
        }
        field(89; "Posting Date"; Date)
        {
        }
        field(90; "Document Date"; Date)
        {
        }
        field(91; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(92; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(93; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(94; "Premium Financier"; Code[20])
        {
            TableRelation = Customer;
        }
        field(95; "Premium Financier Name"; Text[50])
        {
        }
        field(96; "Sales Rep. ID"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(97; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(98; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(99; "Dimension Set ID"; Integer)
        {
        }
        field(100; "Insured Address"; Text[80])
        {
        }
        field(101; "Insured Address 2"; Text[80])
        {
        }
        field(102; "Post Code"; Code[10])
        {
            TableRelation = "Post Code";
        }
        field(103; "Quotation No."; Code[30])
        {
        }
        field(104; "Cover Start Date"; Date)
        {
        }
        field(105; "Cover End Date"; Date)
        {
        }
        field(106; Posted; Boolean)
        {
        }
        field(107; "Posted By"; Code[80])
        {
        }
        field(108; "Posted DateTime"; DateTime)
        {
        }
        field(109; "Short Term Cover"; Code[20])
        {
            TableRelation = "Short Term Cover";
        }
        field(110; "No. Of Months"; Integer)
        {
        }
        field(111; "Short term Cover Percent"; Decimal)
        {
        }
        field(112; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(113; "Language Code"; Code[10])
        {
        }
        field(114; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(115; "Bill To Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(116; "No. Printed"; Integer)
        {
        }
        field(117; "Endorsement Type"; Code[20])
        {
            TableRelation = "Endorsement Types";

            trigger OnValidate();
            begin
                /*IF EndorsmentTypeRec.GET("Endorsement Type") THEN
                  "Action Type":=EndorsmentTypeRec."Action Type";*/

            end;
        }
        field(118; "Action Type"; Option)
        {
            OptionCaption = '" ,Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,Yellow Card,Additional Riders"';
            OptionMembers = " ",Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,"Yellow Card","Additional Riders";
        }
        field(119; "Instalment No."; Integer)
        {
            TableRelation = "Instalment Payment Plan"."Payment No" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("No."));
        }
        field(120; "Quote Expiry Date"; Date)
        {
        }
        field(121; "Premium Calculation Basis"; Option)
        {
            OptionMembers = " ","Pro-rata","Short term","Full Premium";
        }
        field(122; "Endorsement Policy No."; Code[30])
        {
        }
        field(123; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(3,"Shortcut Dimension 3 Code");
            end;
        }
        field(124; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(4,"Shortcut Dimension 4 Code");
            end;
        }
        field(125; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(126; "Insure Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            TableRelation = "Customer Template";

            trigger OnValidate();
            var
                SellToCustTemplate: Record "Customer Template";
            begin
            end;
        }
        field(127; "Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup();
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate();
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
            end;
        }
        field(128; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = IF ("Document Type" = FILTER(<> Quote)) Opportunity."No." WHERE("Contact No." = FIELD("Contact No."),
                                                                                      Closed = CONST(false))
            ELSE
            IF ("Document Type" = CONST(Quote)) Opportunity."No." WHERE("Contact No." = FIELD("Contact No."),
                                                                                                                                                  "Sales Document No." = FIELD("No."),
                                                                                                                                                  "Sales Document Type" = CONST(Quote));
        }
        field(129; "Contact Name"; Text[30])
        {
        }
        field(130; "No. Of Days"; Integer)
        {
        }
        field(131; "Original Cover Start Date"; Date)
        {
        }
        field(132; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(133; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup();
            begin
                /*TESTFIELD("Bal. Account No.",'');
                CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
                CustLedgEntry.SETRANGE("Customer No.","Bill-to Customer No.");
                CustLedgEntry.SETRANGE(Open,TRUE);
                IF "Applies-to Doc. No." <> '' THEN BEGIN
                  CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                  IF CustLedgEntry.FINDFIRST THEN;
                  CustLedgEntry.SETRANGE("Document Type");
                  CustLedgEntry.SETRANGE("Document No.");
                END ELSE
                  IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                    CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                    IF CustLedgEntry.FINDFIRST THEN;
                    CustLedgEntry.SETRANGE("Document Type");
                  END ELSE
                    IF Amount <> 0 THEN BEGIN
                      CustLedgEntry.SETRANGE(Positive,Amount < 0);
                      IF CustLedgEntry.FINDFIRST THEN;
                      CustLedgEntry.SETRANGE(Positive);
                    END;
                
                ApplyCustEntries.SetSales(Rec,CustLedgEntry,SalesHeader.FIELDNO("Applies-to Doc. No."));
                ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
                ApplyCustEntries.SETRECORD(CustLedgEntry);
                ApplyCustEntries.LOOKUPMODE(TRUE);
                IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  ApplyCustEntries.GetCustLedgEntry(CustLedgEntry);
                  GenJnlApply.CheckAgainstApplnCurrency(
                    "Currency Code",CustLedgEntry."Currency Code",GenJnILine."Account Type"::Customer,TRUE);
                  "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                  "Applies-to Doc. No." := CustLedgEntry."Document No.";
                END;
                CLEAR(ApplyCustEntries);
                */

            end;

            trigger OnValidate();
            begin
                /*IF "Applies-to Doc. No." <> '' THEN
                {  TESTFIELD("Bal. Account No.",'');}
                
                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                  SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.");
                  SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");
                END ELSE
                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                    SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.")
                  ELSE
                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                      SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");*/

            end;
        }
        field(134; "Source of Business"; Code[20])
        {
            TableRelation = "Source Of Business";
        }
        field(135; "Business Source Name"; Text[50])
        {
        }
        field(136; "Total Comprehensive Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Lines"."Gross Premium" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(137; "Total TPO Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Lines"."TPO Premium" WHERE("Document Type" = FIELD("Document Type"),
                                                                  "Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(138; "Total PLL Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".PLL WHERE("Document Type" = FIELD("Document Type"),
                                                        "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(139; "Total Extra Premium"; Decimal)
        {
            CalcFormula = Sum("Additional Benefits".Premium WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(140; "Applied Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Document No." = FIELD("Applies-to Doc. No."),
                                                                         "Insurance Trans Type" = CONST("Net Premium")));
            FieldClass = FlowField;
        }
        field(141; "No. Of Cover Periods"; Integer)
        {
        }
        field(142; "cancellation Reason"; Code[20])
        {
            TableRelation = "Cancellation Reasons";

            trigger OnValidate();
            begin
                IF CancelReasonRec.GET("cancellation Reason") THEN
                    "cancellation Reason Desc" := CancelReasonRec.Description;
            end;
        }
        field(143; "cancellation Reason Desc"; Text[30])
        {
        }
        field(144; "Premium Finance %"; Decimal)
        {
        }
        field(145; "Source of Business Type"; Option)
        {
            OptionCaption = '" ,Employee,Customer,Vendor,Contact,Campaign"';
            OptionMembers = " ",Employee,Customer,Vendor,Contact,Campaign;
        }
        field(146; "Source of Business No."; Code[20])
        {
            TableRelation = IF ("Source of Business Type" = CONST(Employee)) Employee
            ELSE
            IF ("Source of Business Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source of Business Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source of Business Type" = CONST(Contact)) Contact
            ELSE
            IF ("Source of Business Type" = CONST(Campaign)) Campaign;

            trigger OnValidate();
            begin
                /*IF "Source of Business Type"="Source of Business Type"::Employee THEN
                  BEGIN
                IF Employee.GET("Source of Business No.") THEN
                 "Business Source Name":=Employee."First Name"+ ' '+Employee."Last Name";
                 END;
                 IF "Source of Business Type"="Source of Business Type"::Customer THEN
                  BEGIN
                IF Cust.GET("Source of Business No.") THEN
                 "Business Source Name":=Cust.Name;
                 END;
                 IF "Source of Business Type"="Source of Business Type"::Vendor THEN
                  BEGIN
                IF Vend.GET("Source of Business No.") THEN
                 "Business Source Name":=Vend.Name;
                 END;
                
                IF "Source of Business Type"="Source of Business Type"::Campaign THEN
                  BEGIN
                IF Campaign.GET("Source of Business No.") THEN
                 "Business Source Name":=Campaign.Description;
                 END;*/

            end;
        }
        field(5049; UPR; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document No." = FIELD("No."),
                                                        "Insurance Trans Type" = CONST(UPR)));
            FieldClass = FlowField;
        }
        field(5050; "UPR Reinsurance"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document No." = FIELD("No."),
                                                        "Insurance Trans Type" = CONST("Re-UPR")));
            FieldClass = FlowField;
        }
        field(5051; DAC; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Document No." = FIELD("No."),
                                                        "Insurance Trans Type" = CONST(DAC)));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Cover Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        ERROR('Cannot Delete this record');
    end;

    trigger OnModify();
    begin
        ERROR('Cannot modify this record');
    end;

    var
        saleslinerec: Record "Insure Lines";
        InsSetup: Record "Insurance setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cust: Record Customer;
        PolicyRecs: Record "Policy Type";
        OptionsSelected: Record "Insure Header Loading_Discount";
        InsuranceType: Record "Loading and Discounts Setup";
        LastNo: Integer;
        InsurerPolicyDetails: Record "Insurer Policy Details";
        PolicyDetails: Record "Policy Details";
        DimMgt: Codeunit 408;
        vendor: Record Vendor;
        InsMngt: Codeunit "Insurance Management";
        shortCover: Record "Short Term Cover";
        InsureLines: Record "Insure Lines";
        commissionTab: Record PolicyProposalRisk;
        CancelReasonRec: Record "Cancellation Reasons";

    local procedure TestNoSeries(): Boolean;
    begin
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
    end;

    procedure InsureLinesExist(): Boolean;
    begin
    end;

    local procedure GetFilterCustNo(): Code[20];
    begin
    end;

    local procedure GetFilterContNo(): Code[20];
    begin
    end;

    procedure CreateTodo();
    var
        TempTodo: Record "To-do" temporary;
    begin
    end;

    procedure PrintRecords(ShowRequestForm: Boolean);
    begin
        SendRecords(ShowRequestForm, FALSE);
    end;

    procedure EmailRecords(ShowRequestForm: Boolean);
    begin
        SendRecords(ShowRequestForm, TRUE);
    end;

    local procedure SendRecords(ShowRequestForm: Boolean; SendAsEmail: Boolean);
    var
        ReportSelections: Record "Report Selections";
        SalesInvoiceHeader: Record "Insure Debit Note";
    begin
        WITH SalesInvoiceHeader DO BEGIN
            COPY(Rec);
            ReportSelections.SETRANGE(Usage, ReportSelections.Usage::"S.Invoice");
            ReportSelections.SETFILTER("Report ID", '<>0');
            ReportSelections.FIND('-');
            REPEAT
                IF NOT SendAsEmail THEN
                    REPORT.RUNMODAL(ReportSelections."Report ID", ShowRequestForm, FALSE, SalesInvoiceHeader)
                ELSE
                    SendReport(ReportSelections."Report ID", SalesInvoiceHeader)
            UNTIL ReportSelections.NEXT = 0;
        END;
    end;

    local procedure SendReport(ReportId: Integer; var SalesInvoiceHeader: Record "Insure Debit Note");
    var
        DocumentMailing: Codeunit "Document-Mailing";
        FileManagement: Codeunit "File Management";
        ServerAttachmentFilePath: Text[250];
    begin
        ServerAttachmentFilePath := COPYSTR(FileManagement.ServerTempFileName('pdf'), 1, 250);
        REPORT.SAVEASPDF(ReportId, ServerAttachmentFilePath, SalesInvoiceHeader);
        COMMIT;
        //DocumentMailing.EmailFileFromInsureDebitNote(SalesInvoiceHeader,ServerAttachmentFilePath,5);
    end;

    procedure Navigate();
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.RUN;
    end;
}

