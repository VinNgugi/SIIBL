table 51513091 "Claim Report Header"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Claim No."; Code[20])
        {
            TableRelation = Claim;

            trigger OnValidate();
            begin
                IF ClaimRec.GET("Claim No.") THEN
                    Class := ClaimRec."Policy Type";
            end;
        }
        field(3; Date; Date)
        {
        }
        field(4; Time; Time)
        {
        }
        field(5; "Reported By"; Code[80])
        {
        }
        field(6; "Total Estimated Value"; Decimal)
        {
            CalcFormula = Sum("Claim Report lines"."Estimated Value" WHERE("Claim Report No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(7; Decision; Code[10])
        {
            TableRelation = "Claim Decisions";
        }
        field(8; "Service Provider No."; Code[20])
        {
            Editable = false;
        }
        field(9; Name; Text[50])
        {
            Editable = false;
        }
        field(10; "Decision Code"; Code[20])
        {
            TableRelation = "Claim Decisions";
        }
        field(11; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(12; "No. Series"; Code[10])
        {
        }
        field(13; "Cause of Accident"; Code[10])
        {
            TableRelation = "Claim causes";
        }
        field(14; "Appointment No."; Code[20])
        {
            TableRelation = "Claim Service Appointments";

            trigger OnValidate();
            begin
                IF ClaimServeApp.GET("Appointment No.") THEN BEGIN
                    MESSAGE('service p =%1', ClaimServeApp.Name);
                    "Service Provider No." := ClaimServeApp."No.";
                    Name := ClaimServeApp.Name;
                    "Claim No." := ClaimServeApp."Claim No.";
                    "Claimant ID" := ClaimServeApp."Claimant ID";
                END;
            end;
        }
        field(15; Class; Code[20])
        {
        }
        field(16; "Claimant ID"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        "Reported By" := USERID;
        Date := WORKDATE;
        Time := Time;
        IF "No." = '' THEN BEGIN
            InsSetup.GET;
            InsSetup.TESTFIELD(InsSetup."Claim Report Nos");
            NoSeriesMgt.InitSeries(InsSetup."Claim Report Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        IF GetFilterAppointmentNo <> '' THEN BEGIN
            VALIDATE("Appointment No.", GetFilterAppointmentNo);
        END;
    end;

    var
        InsSetup: Record "Insurance setup";
        ClaimRec: Record Claim;
        ClaimServeApp: Record "Claim Service Appointments";
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

    local procedure GetFilterAppointmentNo(): Code[20];
    begin
        IF GETFILTER("Appointment No.") <> '' THEN
            IF GETRANGEMIN("Appointment No.") = GETRANGEMAX("Appointment No.") THEN
                EXIT(GETRANGEMAX("Appointment No."));
    end;
}

