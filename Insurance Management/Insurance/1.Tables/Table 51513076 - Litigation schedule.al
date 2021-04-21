table 51513076 "Litigation schedule"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Litigation schedule code"; Code[20])
        {
        }
        field(2; "Hearing Date"; Date)
        {
        }
        field(3; Time; Time)
        {
        }
        field(4; "Litigation Code"; Code[50])
        {
            TableRelation = Litigations;
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(6; Venue; Text[100])
        {
        }
        field(7; Details; Text[250])
        {
        }
        field(8; Status; Text[250])
        {
        }
        field(9; Witness; Text[250])
        {
        }
        field(10; Status1; BLOB)
        {
        }
        field(11; "Court Decision"; Code[10])
        {
            TableRelation = "Claim Decisions";
        }
        field(12; Stage; Option)
        {
            OptionCaption = '" ,Hearing Diary,Amicable Settlements,Judgements,Appeals/Reviews/Setting Aside"';
            OptionMembers = " ","Hearing Diary","Amicable Settlements",Judgements,"Appeals/Reviews/Setting Aside";
        }
        field(13; "Date Received"; Date)
        {
        }
        field(14; Remarks; Text[250])
        {
        }
        field(15; "Pre-Trial Date"; Date)
        {
        }
        field(16; "Bring up and Reminder Date"; Date)
        {
        }
        field(17; "TP Offer"; Decimal)
        {
        }
        field(18; "Our Offer"; Decimal)
        {
        }
        field(19; "Agreed Settlements"; Decimal)
        {
        }
        field(20; "Adjusted Reserves"; Decimal)
        {
        }
        field(21; "Claim No."; Code[30])
        {
            TableRelation = Claim;
        }
        field(22; "Claimant ID"; Integer)
        {
            TableRelation = "Claim Involved Parties";
        }
        field(23; "Date of Judgment"; Date)
        {
        }
        field(24; "Date of Notification"; Date)
        {
        }
        field(25; "Decretal Sum"; Decimal)
        {
        }
        field(26; "Taxed Cost"; Decimal)
        {
        }
        field(27; "Stay Period"; DateFormula)
        {
        }
        field(28; "Course of action required"; Text[250])
        {
        }
        field(29; "Negotiated settlement details"; Text[250])
        {
        }
        field(30; "Proposed settlement Parameters"; Text[30])
        {
        }
        field(31; "Recommending Officer"; Text[30])
        {
        }
        field(32; "Recomendation Date"; Date)
        {
        }
        field(33; "Orginal Decretal Sum"; Decimal)
        {
        }
        field(34; "Negotiated Award"; Decimal)
        {
        }
        field(35; "Payment Frequency"; DateFormula)
        {
        }
        field(36; "First Instalment Date"; Date)
        {
        }
        field(37; "Grounds of Appeals"; Text[250])
        {
        }
        field(38; "Nature of Loss"; Text[30])
        {
        }
        field(39; Quantum; Decimal)
        {
        }
        field(40; Liability; Decimal)
        {
        }
        field(41; "Advocate Code"; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law firms"));
        }
        field(42; "Advocate/Law Firm Name"; Text[30])
        {
        }
        field(43; "Agreed Total Fees"; Decimal)
        {
        }
        field(44; "Deposit Fees"; Decimal)
        {
        }
        field(45; "Invoice No"; Code[20])
        {
        }
        field(46; "Invoice Date"; Date)
        {
        }
        field(47; "Invoiced Amount"; Decimal)
        {
        }
        field(48; "Requisitioning Officer"; Code[80])
        {
        }
        field(49; "Requsitioning Date"; Date)
        {
        }
        field(50; Court; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = CONST("Law courts"));
        }
        field(51; Parties; Text[250])
        {
        }
        field(52; "Date of Order"; Date)
        {
        }
        field(53; "Terms of Order"; Text[250])
        {
        }
        field(54; "Compliance Period"; DateFormula)
        {
        }
        field(55; "Due Date"; Date)
        {
        }
        field(56; "Cheque No."; Code[20])
        {
        }
        field(57; "Payment Amount"; Decimal)
        {
        }
        field(58; "Final Award Date"; Date)
        {
        }
        field(59; "Grounds for Stay Code"; Code[10])
        {
        }
        field(60; "Grounds for Repudiation"; Code[10])
        {
        }
        field(61; "Claimant Name"; Text[80])
        {
        }
    }

    keys
    {
        key(Key1; "Litigation Code", "Litigation schedule code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Litigation schedule code" = '' THEN BEGIN

            LitigationSchedule.RESET;
            LitigationSchedule.SETRANGE(LitigationSchedule."Litigation Code", "Litigation Code");
            IF LitigationSchedule.FINDLAST THEN BEGIN
                "Litigation schedule code" := INCSTR(LitigationSchedule."Litigation schedule code");
                //MESSAGE('found last record Case no=%1',"Litigation schedule code")
            END
            ELSE BEGIN
                "Litigation schedule code" := '1';
                // MESSAGE('did not find Case no=%1',"Litigation schedule code");
            END;
        END;
    end;

    var
        LitigationSchedule: Record "Litigation schedule";
}

