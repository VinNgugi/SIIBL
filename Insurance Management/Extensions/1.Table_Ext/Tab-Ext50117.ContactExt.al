tableextension 50117 "Contact Ext" extends Contact
{
    fields
    {
        field(50000; "Customer Type"; Option)
        {
            OptionCaption = '" ,Insured,Agent/Broker,Re-Insurance Company,Insurer,SACCO,Client,Employer"';
            OptionMembers = " ",Insured,"Agent/Broker","Re-Insurance Company",Insurer,SACCO,Client,Employer;
        }
        field(50001; "Insured Type"; Option)
        {
            OptionMembers = " ",Individual,Group;
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
        /*field(50003; "First name"; Text[30])
        {

            trigger OnValidate();
            begin
                //  "First name":=Insurancemangt.StandardizeNames("First name");
                //Name:=FORMAT(Title)+' '+"First name"+ ' ' +"Family Name";
            end;
        }*/
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
        field(50015; "Broker No."; Code[20])
        {
            TableRelation = Customer WHERE(Type = CONST(Broker));

            trigger OnValidate();
            begin
                //IF vendorRec.GET("Broker No.") THEN
                //"Broker Name":=vendorRec.Name;
            end;
        }
        field(50016; "Broker Name"; Text[30])
        {
        }
        field(50017; PIN; Code[20])
        {
        }
        field(50018; "ID/Passport No."; Code[20])
        {
        }
        field(50019; "No. Of Vehicles"; Integer)
        {
            FieldClass = FlowField;
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
        field(55000; InsureType; Option)
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
            CalcFormula = Count("Insure Header" WHERE("Insured No." = FIELD("No."),
                                                       "Document Type" = CONST(Policy),
                                                       "Policy Status" = CONST(Live)));
            FieldClass = FlowField;
        }
    }
    //**********************************************Custom Precedures****************************************************//
    procedure CreateInsured(CustomerTemplate: Code[10])
    var
        Cust: Record Customer;
        ContComp: Record Contact;
        CustTemplate: Record "Customer Template";
        DefaultDim: Record "Default Dimension";
        DefaultDim2: Record "Default Dimension";
    begin
        //TESTFIELD("Company No.");
        RMSetup.GET;
        RMSetup.TESTFIELD("Bus. Rel. Code for Customers");

        ContBusRel.RESET;
        ContBusRel.SETRANGE("Contact No.", "No.");
        ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
        IF ContBusRel.FINDFIRST THEN
            ERROR(Text019,
              TABLECAPTION, "No.", ContBusRel.TABLECAPTION, ContBusRel."Link to Table", ContBusRel."No.");

        IF CustomerTemplate <> '' THEN
            CustTemplate.GET(CustomerTemplate);

        CLEAR(Cust);
        Cust.SetInsertFromContact(TRUE);
        Cust."Customer Type" := Cust."Customer Type"::Insured;
        If Type = Type::Company Then
            Cust."Insured Type" := Cust."Insured Type"::Group;

        If Type = Type::Person Then
            Cust."Insured Type" := Cust."Insured Type"::Individual;


        Cust.INSERT(TRUE);
        Cust.SetInsertFromContact(FALSE);

        IF Type = Type::Company THEN
            ContComp := Rec
        ELSE
            ContComp := Rec;
        //Original ContComp.GET("Company No.");

        ContBusRel."Contact No." := ContComp."No.";
        ContBusRel."Business Relation Code" := RMSetup."Bus. Rel. Code for Customers";
        ContBusRel."Link to Table" := ContBusRel."Link to Table"::Customer;
        ContBusRel."No." := Cust."No.";
        ContBusRel.INSERT(TRUE);

        UpdateCustVendBank.UpdateCustomer(ContComp, ContBusRel);

        Cust.GET(ContBusRel."No.");
        Cust.VALIDATE(Name, "Company Name");
        IF Cust.Name = '' THEN
            Cust.Name := Rec.Name;
        Cust."Customer Type" := Cust."Customer Type"::Insured;
        If Type = Type::Company Then
            Cust."Insured Type" := Cust."Insured Type"::Group;

        If Type = Type::Person Then
            Cust."Insured Type" := Cust."Insured Type"::Individual;
        Cust.MODIFY;

        IF CustTemplate.Code <> '' THEN BEGIN
            Cust."Territory Code" := "Territory Code";
            Cust."Currency Code" := ContComp."Currency Code";
            Cust."Country/Region Code" := "Country/Region Code";
            Cust."Customer Posting Group" := CustTemplate."Customer Posting Group";
            Cust."Customer Price Group" := CustTemplate."Customer Price Group";
            Cust."Invoice Disc. Code" := CustTemplate."Invoice Disc. Code";
            Cust."Customer Disc. Group" := CustTemplate."Customer Disc. Group";
            Cust."Allow Line Disc." := CustTemplate."Allow Line Disc.";
            Cust."Gen. Bus. Posting Group" := CustTemplate."Gen. Bus. Posting Group";
            Cust."VAT Bus. Posting Group" := CustTemplate."VAT Bus. Posting Group";
            Cust."Payment Terms Code" := CustTemplate."Payment Terms Code";
            Cust."Payment Method Code" := CustTemplate."Payment Method Code";
            Cust."Shipment Method Code" := CustTemplate."Shipment Method Code";
            Cust."Customer Type" := Cust."Customer Type"::Insured;
            If Type = Type::Company Then
                Cust."Insured Type" := Cust."Insured Type"::Group;

            If Type = Type::Person Then
                Cust."Insured Type" := Cust."Insured Type"::Individual;
            Cust.MODIFY;

            DefaultDim.SETRANGE("Table ID", DATABASE::"Customer Template");
            DefaultDim.SETRANGE("No.", CustTemplate.Code);
            IF DefaultDim.FIND('-') THEN
                REPEAT
                    CLEAR(DefaultDim2);
                    DefaultDim2.INIT;
                    DefaultDim2.VALIDATE("Table ID", DATABASE::Customer);
                    DefaultDim2."No." := Cust."No.";
                    DefaultDim2.VALIDATE("Dimension Code", DefaultDim."Dimension Code");
                    DefaultDim2.VALIDATE("Dimension Value Code", DefaultDim."Dimension Value Code");
                    DefaultDim2."Value Posting" := DefaultDim."Value Posting";
                    DefaultDim2.INSERT(TRUE);
                UNTIL DefaultDim.NEXT = 0;
        END;

        UpdateInsureQuotes(Cust);
        CampaignMgt.ConverttoCustomer(Rec, Cust);
        MESSAGE(Text009, Cust.TABLECAPTION, Cust."No.");
    end;

    procedure UpdateInsureQuotes(Customer: Record Customer)
    var
        SalesHeader: Record "Insure Header";
        Cont: Record Contact;
        SalesLine: Record "Insure Lines";
    begin
        Cont.SETCURRENTKEY("Company No.");
        Cont.SETRANGE("Company No.", "Company No.");

        IF Cont.FIND('-') THEN
            REPEAT
                SalesHeader.RESET;
                SalesHeader.SETCURRENTKEY("Document Type", "Contact No.");
                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Debit Note");
                SalesHeader.SETRANGE("Contact No.", Cont."No.");
                IF SalesHeader.FIND('-') THEN
                    REPEAT

                        // MESSAGE('Customer No=%1',Customer."No.");

                        SalesHeader."Insured No." := Customer."No.";
                        SalesHeader."Insure Template Code" := '';
                        SalesHeader.MODIFY;
                        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                        IF SalesLine.FINDFIRST THEN
                            ;
                    //SalesLine.MODIFYALL(SalesLine."Insured No.", SalesHeader."Insured No.");
                    UNTIL SalesHeader.NEXT = 0;

                SalesHeader.RESET;
                SalesHeader.SETCURRENTKEY("Contact No.");
                SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::"Debit Note");
                SalesHeader.SETRANGE("Contact No.", Cont."No.");
                IF SalesHeader.FIND('-') THEN
                    REPEAT
                        SalesHeader."Insured No." := Customer."No.";
                        SalesHeader.VALIDATE(SalesHeader."Insured No.");
                        SalesHeader."Insure Template Code" := '';
                        SalesHeader."Salesperson Code" := Customer."Salesperson Code";
                        SalesHeader.MODIFY;
                        SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                        SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                        IF SalesLine.FINDFIRST THEN
                            ;
                    //  SalesLine.MODIFYALL("Insured No.", SalesHeader."Insured No.");
                    UNTIL SalesHeader.NEXT = 0;
            UNTIL Cont.NEXT = 0;
    end;
    //**********************************************Custom Precedures****************************************************//

    var
        RMSetup: Record "Marketing Setup";
        Cont: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        PostCode: Record "Post Code";
        DuplMgt: Codeunit DuplicateManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UpdateCustVendBank: Codeunit "CustVendBank-Update";
        CampaignMgt: Codeunit "Campaign Target Group Mgt";
        ContChanged: Boolean;
        SkipDefaults: Boolean;
        HideValidationDialog: Boolean;

        Text009: TextConst ENU = 'The %2 record of the %1 has been created.';
        Text019: TextConst ENU = 'The %2 record of the %1 already has the %3 with %4 %5.';
}
