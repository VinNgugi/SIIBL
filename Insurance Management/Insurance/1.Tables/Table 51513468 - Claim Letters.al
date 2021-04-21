table 51513468 "Claim Letters"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Claim No."; Code[20])
        {
            TableRelation = Claim;
        }
        field(2; "Claimant ID"; Integer)
        {
            TableRelation = "Claim Involved Parties"."Claim Line No." WHERE("Claim No." = FIELD("Claim No."));

            trigger OnValidate();
            begin
                IF Claimants.GET("Claim No.", "Claimant ID") THEN
                    "Claimant Name" := Claimants.Surname;
            end;
        }
        field(3; "Letter Type"; Option)
        {
            OptionCaption = '" ,Demand Letter,Summons"';
            OptionMembers = " ","Demand Letter",Summons;
        }
        field(4; "Received by"; Code[80])
        {
            Editable = false;
        }
        field(5; "Received Date"; Date)
        {
            Editable = false;
        }
        field(6; "Received Time"; Time)
        {
            Editable = false;
        }
        field(7; "Demand Amount"; Decimal)
        {
        }
        field(8; "TP Offer"; Decimal)
        {
        }
        field(9; "Our Offer"; Decimal)
        {
        }
        field(10; "Agreed Settlement Amount"; Decimal)
        {
        }
        field(11; "Reserve Link"; Code[20])
        {
            TableRelation = "Claim Reservation Header" WHERE("Claim No." = FIELD("Claim No."),
                                                              "Claimant ID" = FIELD("Claimant ID"));
        }
        field(12; "Demand Letter Action"; Option)
        {
            OptionCaption = '" ,Respond,Ignore"';
            OptionMembers = " ",Respond,Ignore;
        }
        field(13; "Case No."; Code[30])
        {
        }
        field(14; "Court No."; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law courts"));

            trigger OnValidate();
            begin
                IF VendorRec.GET("Court No.") THEN BEGIN
                    "Court Name" := VendorRec.Name;
                END;
            end;
        }
        field(15; "Law Firm"; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));
        }
        field(16; "No."; Code[20])
        {
        }
        field(17; "External Reference No."; Code[30])
        {
        }
        field(18; "Claimant Name"; Text[50])
        {
            Editable = false;
        }
        field(19; "No. Series"; Code[10])
        {
        }
        field(20; "Demand Letter No."; Code[20])
        {
            TableRelation = "Claim Letters"."No." WHERE("Letter Type" = CONST("Demand Letter"));

            trigger OnValidate();
            begin
                IF DemandLetter.GET("Demand Letter No.") THEN BEGIN
                    "Claim No." := DemandLetter."Claim No.";
                    "Claimant ID" := DemandLetter."Claimant ID";
                    VALIDATE("Claimant ID");
                END;
            end;
        }
        field(21; "Negotiated Agreement Date"; Date)
        {
        }
        field(22; "No. of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments"."No. Of Instalments";
        }
        field(23; "Case Title"; Text[250])
        {
        }
        field(24; "Court Name"; Text[30])
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
        IF "Letter Type" = "Letter Type"::"Demand Letter" THEN BEGIN
            IF "No." = '' THEN BEGIN
                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Demand Letter Nos.");
                NoSeriesMgt.InitSeries(InsureSetup."Demand Letter Nos.", xRec."No. Series", 0D, "No.", "No. Series");
            END;
        END;
        IF "Letter Type" = "Letter Type"::Summons THEN BEGIN
            IF "No." = '' THEN BEGIN
                InsureSetup.GET;
                InsureSetup.TESTFIELD(InsureSetup."Summon Nos");
                NoSeriesMgt.InitSeries(InsureSetup."Summon Nos", xRec."No. Series", 0D, "No.", "No. Series");
            END;
        END;
        "Received Date" := WORKDATE;
        "Received Time" := TIME;
        "Received by" := USERID;
    end;

    var
        Claimants: Record "Claim Involved Parties";
        InsureSetup: Record "Insurance setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DemandLetter: Record "Claim Letters";
        VendorRec: Record Vendor;
}

