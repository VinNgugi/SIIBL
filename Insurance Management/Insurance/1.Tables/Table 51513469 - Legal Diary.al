table 51513469 "Legal Diary"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Case No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF Litigations.GET("Case No.") THEN
                    "Case Title" := Litigations.Description;
            end;
        }
        field(2; "Legal Stage Code"; Code[10])
        {
            TableRelation = "Claim Stage Setup" WHERE(Legal = CONST(true));

            trigger OnValidate();
            begin
                IF ClaimStage.GET("Legal Stage Code") THEN
                    "Stage Description" := ClaimStage.Description;
            end;
        }
        field(3; "Stage Description"; Text[30])
        {
        }
        field(4; Date; Date)
        {
        }
        field(5; "Start Time"; Time)
        {
        }
        field(6; "End time"; Time)
        {
        }
        field(7; "Amount awarded"; Decimal)
        {
        }
        field(8; "Date received"; Date)
        {
        }
        field(9; "Reminder date"; Date)
        {
        }
        field(10; "Judgement Decision"; Option)
        {
            OptionCaption = '" ,Liable,Dismissed"';
            OptionMembers = " ",Liable,Dismissed;
        }
        field(11; "Judgement Decision Response"; Option)
        {
            OptionCaption = '" ,Pay,Application for Stay,Appeal"';
            OptionMembers = " ",Pay,Appeal;
        }
        field(12; "Payment Period"; DateFormula)
        {

            trigger OnValidate();
            begin
                "Payment Expiry date" := CALCDATE("Payment Period", Date);
            end;
        }
        field(13; "Payment Expiry date"; Date)
        {
        }
        field(14; "Court No."; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law courts"));
        }
        field(15; "Event Status"; Option)
        {
            OptionCaption = '" ,Attended,Cancelled,No attendance,Postponed"';
            OptionMembers = " ",Attended,Cancelled,"No attendance",Postponed;
        }
        field(16; "Grounds for Repudiation"; Code[10])
        {
            TableRelation = "Denial Reasons";
        }
        field(17; "Grounds for Appeal/Review"; Code[10])
        {
            TableRelation = "Grounds for Appeal";
        }
        field(18; "Agreed Legal Fees"; Decimal)
        {
        }
        field(19; "Deposit Legal Fees"; Decimal)
        {
        }
        field(20; "Case Title"; Text[250])
        {
            Editable = false;
        }
        field(21; Warrant; Boolean)
        {
        }
        field(22; "Warrant type"; Code[10])
        {
            //TableRelation = Table51513467;
        }
        field(23; "Person Receiving"; Text[30])
        {
        }
        field(24; "Decretal Sum"; Decimal)
        {
        }
        field(25; "Taxed Cost"; Decimal)
        {
        }
        field(26; Interest; Decimal)
        {
        }
        field(27; "Court fees"; Decimal)
        {
        }
        field(28; "Court collection charges"; Decimal)
        {
        }
        field(29; Auctioneer; Code[20])
        {
            TableRelation = Vendor;
        }
        field(30; "Invoice No."; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Case No.", "Legal Stage Code", Date)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ClaimStage: Record "Claim Stage Setup";
        Litigations: Record Litigations;
}

