table 51513013 Claim
{
    // version AES-INS 1.0

    //DrillDownPageID = 51513020;
    //LookupPageID = 51513020;

    fields
    {
        field(1; "Claim No"; Code[20])
        {

            trigger OnValidate();
            begin
                IF "Claim No" <> xRec."Claim No" THEN BEGIN
                    InsureSetup.GET;
                    NoSeriesMgt.TestManual(InsureSetup."Claim Nos");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "Policy No"; Code[30])
        {
            TableRelation = "Insure Header"."No." WHERE("Document Type" = CONST(Policy));

            trigger OnValidate();
            begin
                IF PolicyHeader.GET(PolicyHeader."Document Type"::Policy, "Policy No") THEN BEGIN
                    //IF PolicyHeader."Cover Type"=PolicyHeader."Cover Type"::Group THEN
                    "Name of Insured" := PolicyHeader."Insured Name";
                    "Insurer Policy No" := PolicyHeader."Policy No";
                    "Renewal Date" := PolicyHeader."Expected Renewal Date";
                    "Agent/Broker" := PolicyHeader."Sales Agent";
                    VALIDATE("Agent/Broker");
                    "Customer No." := PolicyHeader."Insured No.";
                    "Policy Type" := PolicyHeader."Policy Type";
                    Class := PolicyHeader."Policy Type";
                    "Class Description" := PolicyHeader."Policy Description";
                    MainClasscode := PolicyHeader."Shortcut Dimension 3 Code";
                    Insured := PolicyHeader."Insured No.";

                    IF cust.GET(Insured) THEN BEGIN
                        "Insured Address" := cust.Address;
                        "ID Number" := cust."ID/Passport No.";
                        "Insured Telephone No." := cust."Phone No.";
                        "Date of Birth" := cust."Date of Birth";
                        Occupation := cust.Occupation;

                    END;

                    IF PolicyTypeRec.GET(PolicyHeader."Policy Type",PolicyHeader.Underwriter) THEN BEGIN
                        IF PolicyTypeRec."Schedule Subform" = PolicyTypeRec."Schedule Subform"::Vehicle THEN
                            IF "Claim Type" <> "Claim Type"::Motor THEN
                                ERROR('This is a motor policy register it under motor claim section');
                        IF PolicyTypeRec."Schedule Subform" <> PolicyTypeRec."Schedule Subform"::Vehicle THEN
                            IF "Claim Type" = "Claim Type"::Motor THEN
                                ERROR('This is a non motor policy please register it under miscleneous');
                        TreatyRec.RESET;
                        TreatyRec.SETRANGE(TreatyRec.Blocked, FALSE);
                        TreatyRec.SETRANGE(TreatyRec."Class of Insurance", "Policy Type");
                        IF TreatyRec.FINDLAST THEN BEGIN
                            TreatyNumber := TreatyRec."Treaty Code";
                            "Addendum Code" := TreatyRec."Addendum Code";


                        END;
                    END;

                    /*IF PolicyHeader."Cover Type"=PolicyHeader."Cover Type"::Individual THEN
                    "Name of Insured":=PolicyHeader."Family Name"+ ' '+PolicyHeader."First Names(s)";*/

                    DocumentsRequired.RESET;
                    //SNN
                    //DocumentsRequired.SETRANGE(DocumentsRequired."Transaction Type", DocumentsRequired."Transaction Type"::"3");
                    DocumentsRequired.SETRANGE(DocumentsRequired."Policy Type", PolicyHeader."Policy Type");
                    IF DocumentsRequired.FIND('-') THEN BEGIN
                        REPEAT
                            InsuranceDocs.INIT;
                            InsuranceDocs."Document Type" := InsuranceDocs."Document Type"::claim;
                            InsuranceDocs."Document No" := "Claim No";
                            InsuranceDocs."Entry No." := InsuranceDocs."Entry No." + 10000;
                            InsuranceDocs."Document Name" := DocumentsRequired.Description;
                            IF NOT InsuranceDocs.GET(InsuranceDocs."Document Type", InsuranceDocs."Document No", InsuranceDocs."Entry No.") THEN
                                InsuranceDocs.INSERT;
                        UNTIL DocumentsRequired.NEXT = 0;
                    END;

                END;

            end;
        }
        field(3; "Name of Insured"; Text[130])
        {
        }
        field(4; "Renewal Date"; Date)
        {
            Editable = false;
        }
        field(5; "Agent/Broker"; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin

                IF InsurerRec.GET("Agent/Broker") THEN
                    "Agent/Broker Name" := InsurerRec.Name;
            end;
        }
        field(6; "Insured Address"; Text[30])
        {
        }
        field(7; "Insured Telephone No."; Text[30])
        {
        }
        field(8; District; Text[30])
        {
        }
        field(9; Occupation; Text[30])
        {
        }
        field(10; Make; Text[30])
        {
            Editable = false;
        }
        field(11; "Registration No."; Text[30])
        {
            Editable = false;
        }
        field(12; "Year of Manufacture"; Integer)
        {
            Editable = false;
        }
        field(13; "Cubic Capacity c.c"; Text[30])
        {
            Editable = false;
        }
        field(14; "Purpose at time of Accident"; Text[100])
        {
        }
        field(15; "Driver's Name"; Text[30])
        {
        }
        field(16; "Driver's Age"; Integer)
        {
        }
        field(17; "Drivers Address"; Text[30])
        {
        }
        field(18; "Driver's Occupation"; Text[30])
        {
        }
        field(19; "Other Details"; Text[100])
        {
        }
        field(20; "Date of Occurence"; Date)
        {

            trigger OnValidate();
            begin
                IF InsureSetup.GET THEN
                    "Claim Closure Date" := CALCDATE(InsureSetup."Claim Validity Period", "Date of Occurence");
                IF "Date of Occurence" > TODAY THEN
                    ERROR('Date of occurence cannot be greater than todays Date');

                IF "Date of Occurence" > "Renewal Date" THEN
                    ERROR('Check if the the client has a valid policy');
            end;
        }
        field(21; "When Reported"; Date)
        {
        }
        field(22; Time; Time)
        {
        }
        field(23; Place; Text[200])
        {
        }
        field(24; "Est. Cost of Repairs"; Decimal)
        {
        }
        field(25; "Amount Settled"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                        "Insurance Trans Type" = CONST("Claim Payment")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Nature and Cause of Accident"; BLOB)
        {
        }
        field(27; "Reported to Police"; Boolean)
        {
        }
        field(28; "Date Reported"; Date)
        {
        }
        field(29; "Report Reference No"; Text[30])
        {
        }
        field(30; "Action Taken by Police"; Text[30])
        {
        }
        field(31; "Location of Inspection"; Text[30])
        {
        }
        field(32; "Name of Police Station"; Text[30])
        {
        }
        field(33; "Details of damage"; BLOB)
        {
        }
        field(34; "Appointed Assessor"; Code[10])
        {
        }
        field(35; "Any Third Party Claims"; Boolean)
        {
        }
        field(36; "Details of Third Party Claims"; Text[30])
        {
        }
        field(37; "Name of third party"; Text[30])
        {
        }
        field(38; "Address of 3rd Party"; Text[30])
        {
        }
        field(39; "Certificate No."; Code[20])
        {
            Editable = false;
        }
        field(40; "3rd Party Policy No."; Code[30])
        {
        }
        field(41; "Driver Name"; Text[30])
        {
        }
        field(42; "Insurance Company"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(43; "Vehicle Registration No."; Code[10])
        {
        }
        field(44; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(45; "Insurer Policy No"; Code[30])
        {
            Editable = false;
        }
        field(46; "Agent/Broker Name"; Text[100])
        {
            Editable = false;
        }
        field(47; RiskID; Integer)
        {
            TableRelation = "Insure Lines"."Line No." WHERE("Document Type" = CONST(Policy),
                                                             "Document No." = FIELD("Policy No"),
                                                             "Description Type" = CONST("Schedule of Insured"));

            trigger OnValidate();
            begin
                /* IF SalesLineRec.GET(SalesLineRec."Document Type"::Policy,"Policy No","Line No.") THEN
                 BEGIN
                 "Registration No.":=SalesLineRec."Registration No.";
                 "Year of Manufacture":=SalesLineRec."Year of Manufacture";
                  Make:=SalesLineRec.Make;
                 // "Cubic Capacity c.c":=SalesLineRec."Cubic Capacity (cc)";

                 END;*/

                IF RiskLines.GET(RiskLines."Document Type"::Policy, "Policy No", RiskID) THEN BEGIN

                    "Year of Manufacture" := RiskLines."Year of Manufacture";
                    Make := RiskLines.Make;
                    "Registration No." := RiskLines."Registration No.";
                    "Cubic Capacity c.c" := RiskLines."Cubic Capacity (cc)";
                    "Certificate No." := RiskLines."Certificate No.";
                    "Policy No" := RiskLines."Policy No";
                    VALIDATE("Policy No");
                    // "Customer No.":=RiskLines."Insured No.";
                    //Insured:=RiskLines."Insured Name";
                END;

            end;
        }
        field(48; Class; Code[10])
        {
            Editable = true;
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                /*IF PolicyTypeRec.GET(Class) THEN
                BEGIN
                
                Classcode:=PolicyTypeRec."short code";
                //"Class Description":=PolicyTypeRec.Description;
                
                END; */

            end;
        }
        field(49; "Plot No."; Text[30])
        {
        }
        field(50; Street; Text[30])
        {
        }
        field(51; "Method of Entry to Premises"; Text[30])
        {
        }
        field(52; "Was Alarm Fitted Working"; Boolean)
        {
        }
        field(53; "If Not Reasons"; Text[30])
        {
        }
        field(54; "Are Guards Employed"; Boolean)
        {
        }
        field(55; "Name of Guard Firm"; Text[30])
        {
        }
        field(56; "Claim Type"; Option)
        {
            OptionMembers = " ",Motor,Miscellaneous,Medical;
        }
        field(57; "Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(58; Garage; Code[20])
        {
        }
        field(59; "Name of Garage"; Text[50])
        {
        }
        field(60; "Date taken to Garage"; Date)
        {
        }
        field(61; "Assessors Notification Date"; Date)
        {
        }
        field(62; "Third party type"; Option)
        {
            OptionMembers = "Personal Injury",Property;
        }
        field(63; "Date of Notification"; Date)
        {
        }
        field(64; "Medical Expenses"; Decimal)
        {
        }
        field(65; TDD; Decimal)
        {
        }
        field(66; PTD; Decimal)
        {
        }
        field(67; Particulars; Text[250])
        {
        }
        field(68; "Insurer's Claim No."; Code[30])
        {
        }
        field(69; "Current Status"; Text[250])
        {
        }
        field(70; "Claim Amount"; Decimal)
        {
            FieldClass = Normal;
        }
        field(71; "Policy Type"; Text[120])
        {
            Editable = false;
        }
        field(72; "Police Comments"; Text[250])
        {
        }
        field(73; Country; Code[10])
        {
        }
        field(74; Death; Decimal)
        {
        }
        field(75; "Reserve Amount"; Decimal)
        {
            //"CalcFormula" = Sum("G/L Entry".Amount WHERE("Insurance Trans Type"=FILTER("Claim Reserve"),
            // "Claim No."=FIELD("Claim No")));
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Reserve"),
             "Claim No." = FIELD("Claim No")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(76; Excess; Decimal)
        {
        }
        field(77; "Class Description"; Text[80])
        {
            Editable = false;
        }
        field(78; "Outstanding Claim Amount"; Decimal)
        {
        }
        field(79; Insured; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                IF cust.GET(Insured) THEN BEGIN
                    "Name of Insured" := cust.Name;
                    "Insured Address" := cust.Address;
                    "Insured Telephone No." := "Insured Telephone No.";
                    VALIDATE("Agent/Broker");
                END;
            end;
        }
        field(80; "Claim Status"; Option)
        {
            OptionMembers = Open,Closed;

            trigger OnValidate();
            begin
                IF xRec."Claim Status" <> "Claim Status" THEN BEGIN
                    IF "Claim Status" = "Claim Status"::Closed THEN
                        CALCFIELDS("Reserve Amount");
                    IF "Reserve Amount" > 0 THEN
                        ERROR('Please bring the reserve to Zero before closing the claim %1', "Claim No");
                END;
            end;
        }
        field(81; "Payment Status"; Option)
        {
            OptionMembers = " ",Paid,Unpaid,Rejected;
        }
        field(82; "Copy To 1"; Code[10])
        {
            TableRelation = Vendor;
        }
        field(83; "Copy To 2"; Code[10])
        {
            TableRelation = Vendor;
        }
        field(84; "Copy To 3"; Code[10])
        {
            TableRelation = Vendor;
        }
        field(85; "Memorandum Address"; Code[10])
        {
            TableRelation = Vendor;
        }
        field(86; Name; Text[30])
        {
        }
        field(87; "ID Number"; Text[30])
        {
        }
        field(88; "Employment No"; Text[30])
        {
        }
        field(89; "Patient Name"; Text[30])
        {
        }
        field(90; "Membership No"; Text[30])
        {
        }
        field(91; "Date of Birth"; Date)
        {
        }
        field(92; Sex; Option)
        {
            OptionMembers = Male,Female;
        }
        field(93; Relationship; Option)
        {
            OptionMembers = Employee," Spouse",Child;
            TableRelation = "Policy Type"."short code";
        }
        field(95; Deductible; Decimal)
        {
        }
        field(96; "Co-Insurers"; Code[10])
        {

            trigger OnValidate();
            begin
                IF InsurerRec.GET("Co-Insurers") THEN
                    "Co- Insurer Name" := InsurerRec.Name;
            end;
        }
        field(97; MainClasscode; Code[20])
        {
        }
        field(98; "Co- Insurer Name"; Text[50])
        {
        }
        field(99; "Closure Reason"; Code[20])
        {
            TableRelation = "Claim Closure Reasons";

            trigger OnValidate();
            begin
                VALIDATE("Claim Status");
            end;
        }
        field(100; "Premium Balance"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Policy Number" = FIELD("Policy No"),
                                                                         "Insurance Trans Type" = CONST("Net Premium")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(101; "Excess Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                        "Insurance Trans Type" = CONST(Excess)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(102; TreatyNumber; Code[30])
        {
        }
        field(103; "Addendum Code"; Integer)
        {
        }
        field(104; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Incident';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Incident;
        }
        field(105; "Cause ID"; Code[10])
        {
            TableRelation = "Claim causes";

            trigger OnValidate();
            begin
                IF AccidentCause.GET("Cause ID") THEN BEGIN
                    "Cause Description" := AccidentCause.Description;
                END;
            end;
        }
        field(106; "Cause Description"; Text[30])
        {
        }
        field(107; "Loss Type"; Code[10])
        {
            TableRelation = "Loss Type";

            trigger OnValidate();
            begin

                IF losstyperec.GET("Loss Type") THEN
                    "Loss Type Description" := losstyperec.Description;
            end;
        }
        field(108; "Loss Type Description"; Text[30])
        {
        }
        field(109; "Assigned User"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(110; "Claim Closure Date"; Date)
        {
        }
        field(111; "Treaty Claim Recoveries"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
             "Insurance Trans Type" = CONST("Claim Recovery")));

            Editable = false;
            FieldClass = FlowField;
        }
        field(112; "Facultative Claim Recovries"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                     "Insurance Trans Type" = CONST("Claim Recovery"),
                                                        "Apportionment Type" = CONST(Fucultative)));
            FieldClass = FlowField;
        }
        field(113; "XOL Claim Recoveries"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                        "Insurance Trans Type" = CONST("Claim Recovery")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(114; "Quota Share"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                        "Insurance Trans Type" = CONST("Claim Recovery"),
                                                     "Apportionment Type" = CONST("Quota Share")));
            FieldClass = FlowField;
        }
        field(115; "PSTM Claims"; Decimal)
        {
        }
        field(116; Submitted; Boolean)
        {
        }
        field(117; "Creation DateTime"; DateTime)
        {
        }
        field(118; "Created By"; Code[80])
        {
        }
        field(119; "Ultimate Net Loss"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                        "Insurance Trans Type" = FILTER("Claim Recovery" | Salvage | Excess)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Salvage Recovery"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                        "Insurance Trans Type" = FILTER(Salvage)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(121; "Recovery Paid to Date"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Claim No." = FIELD("Claim No"),
                                                                         "Insurance Trans Type" = CONST("Claim Reserve")));
            FieldClass = FlowField;
        }
        field(122; "ClaimReserve Amt"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Reserve"),
                                                        "Claim No." = FIELD("Claim No"),
                                                        "Document No." = FILTER('<>PV*')));
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Claim No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF Status <> Status::Incident THEN BEGIN
            IF "Claim No" = '' THEN BEGIN
                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Claim Nos");
                NoSeriesMgt.InitSeries(InsureSetup."Claim Nos", xRec."No. Series", 0D, "Claim No", "No. Series");



            END;
        END
        ELSE BEGIN
            IF "Claim No" = '' THEN BEGIN
                //TestNoSeries;

                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Claim Incident Nos");
                NoSeriesMgt.InitSeries(InsureSetup."Claim Incident Nos", xRec."No. Series", 0D, "Claim No", "No. Series");

            END;
        END;
        "Creation DateTime" := CURRENTDATETIME;
        "Created By" := USERID;
        /*IF RiskLinesRec."Line No."<>0 THEN
          BEGIN
           "Policy No":=RiskLinesRec."Policy No";
            VALIDATE("Policy No");
            RiskID:=RiskLinesRec."Line No.";
            VALIDATE(RiskID);
          END;*/
        IF GetFilterPolicyNo <> '' THEN
            VALIDATE("Policy No", GetFilterPolicyNo);

        IF GetFilterRiskID <> 0 THEN
            VALIDATE(RiskID, GetFilterRiskID);
        //MESSAGE('%1',GetFilterContNo);

    end;

    var
        InsureSetup: Record "Insurance setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        cust: Record Customer;
        InsurerRec: Record Customer;
        PolicyHeader: Record "Insure Header";
        PolicyTypeRec: Record "Underwriter Policy Types";
        DocumentsRequired: Record "Documents Required";
        InsuranceDocs: Record "Insurance Documents";
        RiskDatabase: Record "Risk Database";
        AccidentCause: Record "Claim causes";
        losstyperec: Record "Loss Type";
        Text014: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        RiskLines: Record "Insure Lines";
        TreatyRec: Record Treaty;
        RiskLinesRec: Record "Insure Lines";

    procedure DisplayMap();
    var
        MapPoint: Record "Online Map Setup";
    //MapMgt: Codeunit "Online Map Management";
    begin
        //IF MapPoint.FINDFIRST THEN
        //    MapMgt.MakeSelection(DATABASE::Customer, GETPOSITION)
        //ELSE
        //    MESSAGE(Text014);
    end;

    local procedure GetFilterRegNo(): Code[20];
    begin
        IF GETFILTER("Registration No.") <> '' THEN
            IF GETRANGEMIN("Registration No.") = GETRANGEMAX("Registration No.") THEN
                EXIT(GETRANGEMAX("Registration No."));
    end;

    procedure GetInsureLines(var PolicyLine: Record "Insure Lines");
    begin
        RiskLinesRec.COPY(PolicyLine);
    end;

    procedure GetFilterRiskID(): Integer;
    begin
        IF GETFILTER(RiskID) <> '' THEN
            IF GETRANGEMIN(RiskID) = GETRANGEMAX(RiskID) THEN
                EXIT(GETRANGEMAX(RiskID));
    end;

    procedure GetFilterPolicyNo(): Code[30];
    begin
        IF GETFILTER("Policy No") <> '' THEN
            IF GETRANGEMIN("Policy No") = GETRANGEMAX("Policy No") THEN
                EXIT(GETRANGEMAX("Policy No"));
    end;
}

