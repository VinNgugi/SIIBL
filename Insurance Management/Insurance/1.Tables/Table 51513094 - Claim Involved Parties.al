table 51513094 "Claim Involved Parties"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Claim No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF ClaimRec.GET("Claim No.") THEN
                    "Policy Type" := ClaimRec."Policy Type";
            end;
        }
        field(2; "Claim Line No."; Integer)
        {
        }
        field(3; Title; Code[10])
        {
            TableRelation = Salutation;
        }
        field(4; Surname; Text[30])
        {
        }
        field(5; "Other Name(s)"; Text[30])
        {
        }
        field(6; "Phone No."; Code[20])
        {
        }
        field(7; Address; Text[250])
        {
        }
        field(8; "Post Code"; Code[10])
        {
            TableRelation = "Post Code";

            trigger OnValidate();
            begin
                PostCode.RESET;
                PostCode.SETRANGE(PostCode.Code, "Post Code");
                IF PostCode.FINDFIRST THEN
                    "Town/City" := PostCode.City;
            end;
        }
        field(9; "Town/City"; Code[30])
        {
        }
        field(10; "Third Party Vehicle Reg. No."; Code[20])
        {
        }
        field(11; "Third Party Insurance Company"; Text[30])
        {
        }
        field(12; "Third Party Policy No."; Code[20])
        {
        }
        field(13; "Details of damage"; Text[250])
        {
        }
        field(14; Passenger; Boolean)
        {
        }
        field(15; "Location during incident"; Text[30])
        {
        }
        field(16; "Involvement type"; Option)
        {
            OptionMembers = " ",Claimant,Witness,"Adverse Party",Lawyer,"third party lawyer",Garage,Insured;

            trigger OnValidate();
            begin
                IF "Involvement type" = "Involvement type"::Insured THEN BEGIN
                    IF ClaimRec.GET("Claim No.") THEN
                        IF PolicyRec.GET(PolicyRec."Document Type"::Policy, ClaimRec."Policy No") THEN BEGIN
                            Surname := PolicyRec."Insured Name";
                            Address := PolicyRec."Insured Address";

                        END;

                END;
            end;
        }
        field(17; "Third Party Insurance Co."; Code[20])
        {
            TableRelation = Customer WHERE("Customer Type" = CONST(Insurer));
        }
        field(18; "Date Created"; Date)
        {
        }
        field(19; "Time Created"; Time)
        {
        }
        field(20; "Assigned By"; Code[80])
        {
        }
        field(21; "Loss Type"; Code[10])
        {
            TableRelation = "Loss Type";

            trigger OnValidate();
            begin
                IF LosstypeRec.GET("Loss Type") THEN BEGIN
                    //MESSAGE('gets it');
                    IF LosstypeRec."Reserve calculation type" = LosstypeRec."Reserve calculation type"::"Flat Amount" THEN
                        "Minimum Reserve Amount" := LosstypeRec."Minimum Reserve";
                    //MESSAGE('%1',"Minimum Reserve Amount");
                    IF LosstypeRec."Reserve calculation type" = LosstypeRec."Reserve calculation type"::"Full Value" THEN BEGIN
                        IF ClaimRec.GET("Claim No.") THEN
                            IF PolicyLine.GET(PolicyLine."Document Type"::Policy, ClaimRec."Policy No", ClaimRec.RiskID) THEN
                                "Minimum Reserve Amount" := PolicyLine."Sum Insured";
                    END;

                    IF LosstypeRec."Reserve calculation type" = LosstypeRec."Reserve calculation type"::"% of Full Value" THEN BEGIN
                        IF ClaimRec.GET("Claim No.") THEN
                            IF PolicyLine.GET(PolicyLine."Document Type"::Policy, ClaimRec."Policy No", ClaimRec.RiskID) THEN
                                "Minimum Reserve Amount" := PolicyLine."Sum Insured" * (LosstypeRec.Percentage / 100);
                    END;
                    //"Excess Amount Required":=LosstypeRec."Excess Required";

                END;
            end;
        }
        field(22; "Minimum Reserve Amount"; Decimal)
        {
        }
        field(23; "Case No."; Code[30])
        {
            TableRelation = Litigations;

            trigger OnValidate();
            begin
                IF Litigation.GET("Case No.") THEN BEGIN
                    "Law Court No." := Litigation."Law Court";
                    VALIDATE("Law Court No.");
                    "Claimant Attorney" := Litigation."Third Party Lawyer";

                END;
            end;
        }
        field(24; "Excess Amount Required"; Decimal)
        {
        }
        field(25; "ID/Passport No."; Code[20])
        {

            trigger OnValidate();
            begin
                Claimants3rdParty.RESET;
                Claimants3rdParty.SETRANGE(Claimants3rdParty."Claim No.", "Claim No.");
                Claimants3rdParty.SETRANGE(Claimants3rdParty."ID/Passport No.", "ID/Passport No.");
                IF Claimants3rdParty.FINDLAST THEN
                    ERROR('The Claimant with ID/Passport No %1 already exists', "ID/Passport No.");
            end;
        }
        field(26; "Legal Rep/Law Firm"; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));
        }
        field(27; "Law firm Name"; Text[30])
        {
        }
        field(28; "Claim Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(29; "Claim Amount"; Decimal)
        {
        }
        field(30; "Claim Amount LCY"; Decimal)
        {
        }
        field(31; "Law Court No."; Text[30])
        {
        }
        field(32; "Claimant Attorney"; Text[50])
        {
        }
        field(33; "Settlement Amount"; Decimal)
        {
        }
        field(34; "Posted Reserve Amount"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No."),
                                                        "Insurance Trans Type" = FILTER("Claim Reserve" | "Claim Payment"),
                                                        "Claimant ID" = FIELD("Claim Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(35; "Amount Paid"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No."),
                                                        "Insurance Trans Type" = CONST("Claim Payment"),
                                                        "Claimant ID" = FIELD("Claim Line No.")));
            FieldClass = FlowField;
        }
        field(36; "Exess Paid"; Decimal)
        {
            CalcFormula = - Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No."),
                                                         "Insurance Trans Type" = CONST(Excess),
                                                         "Claimant ID" = FIELD("Claim Line No.")));
            FieldClass = FlowField;
        }
        field(37; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(38; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(39; "Treaty Recoverable"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Claim No." = FIELD("Claim No."),
                                                        "Insurance Trans Type" = CONST("Claim Recovery"),
                                                        "Claimant ID" = FIELD("Claim Line No.")));
            FieldClass = FlowField;
        }
        field(40; "XOLTreaty Recoverable"; Decimal)
        {
            CalcFormula = Sum("Coinsurance Reinsurance Lines"."Claims Payment Amount" WHERE("Claim No." = FIELD("Claim No."),
                                                                                             "Claimant ID" = FIELD("Claim Line No."),
                                                                                             TreatyLineID = FIELD("XOL Layer Filter"),
                                                                                             "Partner No." = FIELD("Partner Filter")));
            FieldClass = FlowField;
        }
        field(41; "Partner Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            TableRelation = Customer;
        }
        field(42; "XOL Layer Filter"; Code[20])
        {
            FieldClass = FlowFilter;
            //TableRelation = "XOL Layers";
        }
        field(43; "Minimum Reserve Posted"; Boolean)
        {
        }
        field(44; "Policy Type"; Code[20])
        {
        }
        field(45; "Loss Type selection"; Integer)
        {
            TableRelation = "Policy Details"."Line No" WHERE("Policy Type" = FIELD("Policy Type"),
                                                              "Description Type" = CONST(Excess));

            trigger OnValidate();
            begin
                PolicyDetails.RESET;
                PolicyDetails.SETRANGE(PolicyDetails."Policy Type", "Policy Type");
                PolicyDetails.SETRANGE(PolicyDetails."Line No", "Loss Type selection");
                PolicyDetails.SETRANGE(PolicyDetails."Description Type", PolicyDetails."Description Type"::Excess);
                IF PolicyDetails.FINDFIRST THEN BEGIN
                    Description := PolicyDetails.Description;
                    "Excess Amount Required" := PolicyDetails.Value;
                END;
            end;
        }
        field(46; Description; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Claim No.", "Claim Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        Claimants3rdParty.RESET;
        Claimants3rdParty.SETRANGE(Claimants3rdParty."Claim No.", "Claim No.");
        IF Claimants3rdParty.FINDLAST THEN
            "Claim Line No." := Claimants3rdParty."Claim Line No." + 1
        ELSE
            "Claim Line No." := 1;

        "Date Created" := WORKDATE;
        "Time Created" := TIME;
        "Assigned By" := USERID;
    end;

    var
        Claimants3rdParty: Record "Claim Involved Parties";
        LosstypeRec: Record "Loss Type";
        PolicyLine: Record "Insure Lines";
        ClaimRec: Record Claim;
        Litigation: Record Litigations;
        PolicyRec: Record "Insure Header";
        PostCode: Record "Post Code";
        PolicyDetails: Record "Policy Details";
}

