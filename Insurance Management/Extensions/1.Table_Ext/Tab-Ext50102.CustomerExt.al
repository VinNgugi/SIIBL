tableextension 50102 CustomerExt extends Customer
{
    fields
    {
        field(50000; "Customer Type"; Option)
        {
            OptionCaption = '" ,Insured,Agent/Broker,Re-Insurance Company,Insurer,SACCO,Client,Employer,IPF"';
            OptionMembers = " ",Insured,"Agent/Broker","Re-Insurance Company",Insurer,SACCO,Client,Employer,IPF;
        }
        field(50001; "Insured Type"; Option)
        {
            OptionCaption = '" ,Individual,Group,Agent,Broker,BankAssurance,Direct"';
            OptionMembers = " ",Individual,Group,Agent,Broker,BankAssurance,Direct;
        }
        field(50002; "Family Name"; Text[30])
        {

            trigger OnValidate();
            begin
                //  "Family Name":=Insurancemangt.StandardizeNames("Family Name");
                //Name:=FORMAT(Title)+' '+"First name"+ ' ' +"Family Name";
                //Name:="First name"+ ' ' +"Family Name";
            end;
        }
        field(50003; "First name"; Text[30])
        {

            trigger OnValidate();
            begin
                //  "First name":=Insurancemangt.StandardizeNames("First name");
                //Name:=FORMAT(Title)+' '+"First name"+ ' ' +"Family Name";
            end;
        }
        field(50004; "Other Initials"; Text[30])
        {
        }
        field(50005; Sex; Option)
        {
            OptionMembers = Male,Female;
        }
        field(50006; Title; Option)
        {
            OptionMembers = Mr,Mrs,Ms,Dr,Prof;

            trigger OnValidate();
            begin
                //Name:=FORMAT(Title)+' '+"First name"+ ' ' +"Family Name";
            end;
        }
        field(50007; "Date of Birth"; Date)
        {
        }
        field(50008; Height; Decimal)
        {
        }
        field(50009; Weight; Decimal)
        {
        }
        field(50010; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Divorced,Widowed;
        }
        field(50011; Occupation; Text[30])
        {
        }
        field(50012; Nationality; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(50013; "Country of Residence"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(50014; Mobile; Text[30])
        {
        }
        field(50015; "Intermediary No."; Code[20])
        {
            TableRelation = Customer WHERE("Customer Type" = CONST("Agent/Broker"));

            trigger OnValidate();
            begin
                IF VendorRec.GET("Intermediary No.") THEN
                    "Intermediary Name" := VendorRec.Name;
                "Bill-to Customer No." := "Intermediary No.";
            end;
        }
        field(50016; "Intermediary Name"; Text[30])
        {
        }
        field(50017; PIN; Code[20])
        {
        }
        field(50018; "ID/Passport No."; Code[20])
        {

            trigger OnValidate();
            begin
                Cust.RESET;
                Cust.SETRANGE(Cust."ID/Passport No.", "ID/Passport No.");
                Cust.SETFILTER(Cust."No.", '<>%1', "No.");
                IF Cust.FINDLAST THEN BEGIN
                    "ID/Passport No." := '';
                    MODIFY;
                    ERROR('You cannot create this record because %1 is also assigned the same ID/Reg No', Cust."No.");
                END;
            end;
        }
        field(50019; "No. Of Vehicles"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Insure Lines" WHERE("Insured No." = FIELD("No.")));

        }
        field(50020; "Employer Code"; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                // IF Employer.GET("Employer Code") THEN
                //  "Employer Name":=Employer.Name;
            end;
        }
        field(50021; "Employer Name"; Text[50])
        {
        }
        field(50022; "Payroll No."; Code[20])
        {
        }
        field(50023; "Bank Code"; Code[10])
        {
            //TableRelation = "Bank Codes";
        }
        field(50024; "Bank Name"; Text[80])
        {
        }
        field(55000; Type; Option)
        {
            OptionCaption = ',Cedant,Broker,Benefit';
            OptionMembers = ,Cedant,Broker,Benefit;
        }
        field(55001; "Retro Nos."; Code[10])
        {
            Caption = 'Retro Nos.';
            TableRelation = "No. Series";
        }
        field(55002; "Claim Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(55003; "Group treaty Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(55004; "Individual treaty Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(55005; "XOL Treaty Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(55006; "Refund Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(55007; "Old Code"; Code[10])
        {
        }
        field(55008; "GL Code"; Code[10])
        {
        }
        field(55009; "No. Of Insure Quotes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Insure Header" WHERE("Insured No." = FIELD("No."),
                                                       "Document Type" = CONST(Quote)));

        }
        field(55010; "No. Of Active Policies"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Insure Header" WHERE("Insured No." = FIELD("No."),
                                                       "Document Type" = CONST(Policy),
                                                       "Policy Status" = CONST(Live)));

        }
        field(55011; "COP Certificate No."; Code[30])
        {
        }
        field(55012; "Gross Premium"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Insurance Trans Type" = CONST("Net Premium")));

        }
        field(55013; Receipts; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Posting Date" = field("Date Filter")));

        }
        field(55014; Commission; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Posting Date" = field("Date Filter"),
                                                                                 "Insurance Trans Type" = CONST(Commission)));

        }
        field(55015; Wht; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Insurance Trans Type" = CONST(Wht)));

        }
        field(55016; "Net Commission"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Customer No." = FIELD("No."),
                                                                                 "Posting Date" = field("Date Filter"),
                                                                                 "Insurance Trans Type" = FILTER(Commission | Wht)));

        }
        field(55017; "Certificate of Registration"; Code[20])
        {
        }
        field(55018; "Commission Paid"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("No."),
                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                         "Insurance Trans Type" = CONST(Commission)));
            FieldClass = FlowField;
        }
        field(55019; "Document Type"; Enum "Approval Document Type")
        {

        }
        field(55020; "Approval Status"; Option)
        {
            OptionMembers = Open,"Pending Approval",Approved,Rejected;
        }

    }

    trigger OnBeforeInsert()
    var
        myInt: Integer;
    begin
        //Error('Customer Type %1, Customer Posting Group %2', "Customer Type", "Customer Posting Group");

        IF "Customer Type" = "Customer Type"::Insured THEN BEGIN
            InsureSetup.GET;
            InsureSetup.TESTFIELD(InsureSetup."Insured Nos");
            NoSeriesMgmt.InitSeries(InsureSetup."Insured Nos", xRec."No. Series", 0D, "No.", "No. Series");
            "Document Type" := "Document Type"::"Insured Reg(Individual)";
        END;

        IF "Customer Type" = "Customer Type"::SACCO THEN BEGIN
            InsureSetup.GET;
            InsureSetup.TESTFIELD(InsureSetup."SACCO Nos");
            NoSeriesMgmt.InitSeries(InsureSetup."SACCO Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        IF "Customer Type" = "Customer Type"::IPF THEN BEGIN
            InsureSetup.GET;
            InsureSetup.TESTFIELD(InsureSetup."IPF Nos");
            NoSeriesMgmt.InitSeries(InsureSetup."IPF Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        IF "Customer Type" = "Customer Type"::Insurer THEN BEGIN
            InsureSetup.GET;
            InsureSetup.TESTFIELD(InsureSetup."Underwriters Nos");
            NoSeriesMgmt.InitSeries(InsureSetup."Underwriters Nos", xRec."No. Series", 0D, "No.", "No. Series");
            "Document Type" := "Document Type"::"Insurer Reg";

        END;
        IF "Customer Type" = "Customer Type"::"Re-Insurance Company" THEN BEGIN
            InsureSetup.GET;
            InsureSetup.TESTFIELD(InsureSetup."Broker Nos");
            NoSeriesMgmt.InitSeries(InsureSetup."Broker Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        IF "Customer Type" = "Customer Type"::"Agent/Broker" THEN BEGIN
            IF "Insured Type" = "Insured Type"::Agent THEN BEGIN
                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Agent Nos");
                NoSeriesMgmt.InitSeries(InsureSetup."Agent Nos", xRec."No. Series", 0D, "No.", "No. Series");
            END;
            IF "Insured Type" = "Insured Type"::Broker THEN BEGIN
                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Broker Nos");
                NoSeriesMgmt.InitSeries(InsureSetup."Broker Nos", xRec."No. Series", 0D, "No.", "No. Series");
                //MESSAGE('Executing ..it');
            END;
            IF "Insured Type" = "Insured Type"::BankAssurance THEN BEGIN
                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Bank Assurance Nos");
                NoSeriesMgmt.InitSeries(InsureSetup."Bank Assurance Nos", xRec."No. Series", 0D, "No.", "No. Series");
                //MESSAGE('Executing ..it');
            END;
            IF "Insured Type" = "Insured Type"::Direct THEN BEGIN
                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Direct Nos");
                NoSeriesMgmt.InitSeries(InsureSetup."Direct Nos", xRec."No. Series", 0D, "No.", "No. Series");
                //MESSAGE('Executing ..it');
            END;
        END;

    end;

    var
        VendorRec: Record Vendor;
        Cust: Record Customer;
        SalesSetup: Record "Sales & Receivables Setup";
        InsureSetup: Record "Insurance setup";
        NoSeriesMgmt: Codeunit NoSeriesManagement;
}
