table 51513090 "Claim Service Appointments"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Appointment No."; Code[20])
        {
        }
        field(2; "Appointment Date"; Date)
        {
        }
        field(3; "Appointment Time"; Time)
        {
        }
        field(4; "Appointed By"; Code[80])
        {
        }
        field(5; "Appointment Instructions"; Text[250])
        {
        }
        field(6; "Claim No."; Code[20])
        {
            TableRelation = Claim;
        }
        field(7; "Service Provider Type"; Option)
        {
            OptionMembers = " ",Assessor,Lawyer,Garage;
        }
        field(8; "Sourcing type"; Option)
        {
            OptionMembers = " ",Internal,External;

            trigger OnValidate();
            begin
                IF InsuranceSetup.GET THEN
                    IF InsuranceSetup."Last Round" = 0 THEN
                        InsuranceSetup."Last Round" := 1;
                InsuranceSetup.MODIFY;
                IF "Sourcing type" = "Sourcing type"::External THEN BEGIN

                    ServiceProviderRec.RESET;
                    ServiceProviderRec.SETRANGE(ServiceProviderRec."Global Dimension 1 Code", "Shortcut Dimension 1 Code");
                    ServiceProviderRec.SETRANGE(ServiceProviderRec."Vendor Type", "Service Provider Type");
                    IF ServiceProviderRec.FINDFIRST THEN BEGIN


                        REPEAT



                            ServiceRoundRecord.RESET;
                            ServiceRoundRecord.SETRANGE(ServiceRoundRecord.Round, InsuranceSetup."Last Round");
                            ServiceRoundRecord.SETRANGE(ServiceRoundRecord."Service Provider", ServiceProviderRec."No.");
                            ServiceRoundRecord.SETRANGE(ServiceRoundRecord."Service Provider Type", "Service Provider Type");
                            IF NOT ServiceRoundRecord.FINDFIRST THEN BEGIN
                                ServiceRoundRec.INIT;
                                ServiceRoundRec.Round := InsuranceSetup."Last Round";
                                ServiceRoundRec."Service Provider" := ServiceProviderRec."No.";
                                ServiceRoundRec."Service Provider Type" := "Service Provider Type";
                                ServiceRoundRec.INSERT;
                                "No." := ServiceRoundRec."Service Provider";
                                VALIDATE("No.");
                                ServiceProviderSelected := TRUE;

                            END
                            ELSE BEGIN

                            END;

                        UNTIL (ServiceProviderRec.NEXT = 0) OR (ServiceProviderSelected = TRUE);
                    END;
                    IF ServiceProviderSelected = FALSE THEN BEGIN

                        InsuranceSetup.GET;
                        InsuranceSetup."Last Round" := InsuranceSetup."Last Round" + 1;
                        InsuranceSetup.MODIFY;


                        ServiceProviderRec.RESET;
                        ServiceProviderRec.SETRANGE(ServiceProviderRec."Global Dimension 1 Code", "Shortcut Dimension 1 Code");
                        ServiceProviderRec.SETRANGE(ServiceProviderRec."Vendor Type", "Service Provider Type");
                        IF ServiceProviderRec.FINDFIRST THEN BEGIN

                            REPEAT
                                ServiceRoundRecord.RESET;
                                ServiceRoundRecord.SETRANGE(ServiceRoundRecord.Round, InsuranceSetup."Last Round");
                                ServiceRoundRecord.SETRANGE(ServiceRoundRecord."Service Provider", ServiceProviderRec."No.");
                                ServiceRoundRecord.SETRANGE(ServiceRoundRecord."Service Provider Type", "Service Provider Type");
                                IF NOT ServiceRoundRecord.FINDFIRST THEN BEGIN
                                    ServiceRoundRec.INIT;
                                    ServiceRoundRec.Round := InsuranceSetup."Last Round";
                                    ServiceRoundRec."Service Provider" := ServiceProviderRec."No.";
                                    ServiceRoundRec."Service Provider Type" := "Service Provider Type";
                                    ServiceRoundRec.INSERT;
                                    "No." := ServiceRoundRec."Service Provider";
                                    VALIDATE("No.");
                                    ServiceProviderSelected := TRUE;

                                END
                                ELSE BEGIN

                                END;

                            UNTIL (ServiceProviderRec.NEXT = 0) OR (ServiceProviderSelected = TRUE);
                        END;
                    END





                END;
            end;
        }
        field(9; "No."; Code[20])
        {
            TableRelation = IF ("Service Provider Type" = CONST(Assessor), "Sourcing type" = CONST(Internal)) Employee
            ELSE
            IF ("Service Provider Type" = CONST(Assessor), "Sourcing type" = CONST(External)) Vendor WHERE("Vendor Type" = CONST(Assessor))
            ELSE
            IF ("Service Provider Type" = CONST(Lawyer)) Vendor WHERE("Vendor Type" = CONST("Law firms"), "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"))
            ELSE
            IF ("Service Provider Type" = CONST(Garage)) Vendor WHERE("Vendor Type" = CONST(Garage), "Global Dimension 1 Code" = FIELD("Shortcut Dimension 1 Code"));

            trigger OnValidate();
            begin
                IF "Service Provider Type" = "Service Provider Type"::Assessor THEN BEGIN
                    IF "Sourcing type" = "Sourcing type"::Internal THEN BEGIN
                        IF Employee.GET("No.") THEN
                            Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                        IF Employee.Status <> Employee.Status::Active THEN
                            ERROR('This assessor is status is not active and cannot be assigned');
                    END;
                    IF "Sourcing type" = "Sourcing type"::External THEN BEGIN
                        IF Vend.GET("No.") THEN
                            Name := Vend.Name;
                        IF Vend.Blocked <> Vend.Blocked::" " THEN
                            ERROR('Assessor No. %1 is Blocked and cannot be assigned', Vend.Name);
                    END;
                END;

                IF "Service Provider Type" = "Service Provider Type"::Lawyer THEN BEGIN
                    IF "Sourcing type" = "Sourcing type"::Internal THEN BEGIN
                        IF Employee.GET("No.") THEN
                            Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                        IF Employee.Status <> Employee.Status::Active THEN
                            ERROR('%1 not active and cannot be assigned', "Appointment Instructions");
                    END;
                    IF "Sourcing type" = "Sourcing type"::External THEN BEGIN
                        IF Vend.GET("No.") THEN
                            Name := Vend.Name;
                        IF Vend.Blocked <> Vend.Blocked::" " THEN
                            ERROR('Law firm No. %1 is Blocked and cannot be assigned', Vend.Name);
                    END;
                END;

                IF "Service Provider Type" = "Service Provider Type"::Garage THEN BEGIN
                    IF "Sourcing type" = "Sourcing type"::Internal THEN BEGIN
                        IF Employee.GET("No.") THEN
                            Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                    END;
                    IF "Sourcing type" = "Sourcing type"::External THEN BEGIN
                        IF Vend.GET("No.") THEN
                            Name := Vend.Name;
                        IF Vend.Blocked <> Vend.Blocked::" " THEN
                            ERROR('%1 is Blocked and cannot be assigned', Vend.Name);
                    END;
                END;
            end;
        }
        field(10; Name; Text[50])
        {
            Editable = false;
        }
        field(11; "Claimant ID"; Integer)
        {
            TableRelation = "Claim Involved Parties"."Claim Line No." WHERE("Claim No." = FIELD("Claim No."));
        }
        field(12; "Loss Type"; Code[10])
        {
            TableRelation = "Loss Type";
        }
        field(13; "Task Assigned"; Code[10])
        {
            TableRelation = "Loss Type stages"."Claim Stage" WHERE("Loss Type" = FIELD("Loss Type"));

            trigger OnValidate();
            begin
                IF LossTypeStages.GET("Loss Type", "Task Assigned") THEN
                    "Task Description" := LossTypeStages."Stage Description"
                ELSE
                    ERROR('not found');
            end;
        }
        field(14; "No. Series"; Code[10])
        {
        }
        field(15; "Task Description"; Text[30])
        {
            Editable = false;
        }
        field(16; "SLA End Date"; DateTime)
        {
        }
        field(17; Stage; Code[10])
        {
            TableRelation = "Loss Type stages"."Claim Stage" WHERE("Loss Type" = FIELD("Loss Type"));
        }
        field(18; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(19; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Appointment No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin

        InsSetup.GET;
        InsSetup.TESTFIELD(InsSetup."Service Provider Appointments");
        NoSeriesMgt.InitSeries(InsSetup."Service Provider Appointments", xRec."No. Series", 0D, "Appointment No.", "No. Series");

        "Appointment Date" := WORKDATE;
        "Appointment Time" := TIME;
        "Appointed By" := USERID;

        IF GetFilterClaimNo <> '' THEN
            VALIDATE("Claim No.", GetFilterClaimNo);

        IF GetFilterClaimantID <> 0 THEN
            VALIDATE("Claimant ID", GetFilterClaimantID);
        IF ClaimLine.GET(GetFilterClaimNo, GetFilterClaimantID) THEN
            "Loss Type" := ClaimLine."Loss Type";
        IF UserDetails.GET(USERID) THEN
            "Shortcut Dimension 2 Code" := UserDetails."Global Dimension 2 Code";
    end;

    var
        Employee: Record Employee;
        Vend: Record Vendor;
        InsSetup: Record "Insurance setup";

        ClaimLine: Record "Claim Involved Parties";
        ServiceRoundRecs: Record "Service Provider Round Robin";
        ServiceProviderRec: Record Vendor;
        RoundNo: Integer;
        ServiceProviderSelected: Boolean;
        ServiceRoundRecord: Record "Service Provider Round Robin";
        ServiceRoundRec: Record "Service Provider Round Robin";
        InsuranceSetup: Record "Insurance setup";
        UserDetails: Record "User Setup Details";
        LossTypeStages: Record "Loss Type stages";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure GetFilterClaimNo(): Code[20];
    begin
        IF GETFILTER("Claim No.") <> '' THEN
            IF GETRANGEMIN("Claim No.") = GETRANGEMAX("Claim No.") THEN
                EXIT(GETRANGEMAX("Claim No."));
    end;

    local procedure GetFilterClaimantID(): Integer;
    begin
        IF GETFILTER("Claimant ID") <> '' THEN
            IF GETRANGEMIN("Claimant ID") = GETRANGEMAX("Claimant ID") THEN
                EXIT(GETRANGEMAX("Claimant ID"));
    end;
}

