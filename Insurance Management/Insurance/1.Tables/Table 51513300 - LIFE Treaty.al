table 51513300 "LIFE Treaty"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Treaty Code"; Code[30])
        {
            NotBlank = false;
        }
        field(2; "Treaty Description"; Text[100])
        {
        }
        field(3; "Ceding office"; Code[30])
        {
            TableRelation = Customer WHERE(Type = CONST(Cedant));

            trigger OnValidate();
            begin
                IF Cedant.GET("Ceding office") THEN BEGIN
                    "Ceding office Name" := Cedant.Name;

                    //"Treaty Code":=format(date2dmy(3,today))+Cedant."Treaty Number"+
                END ELSE BEGIN
                    "Ceding office Name" := '';
                END;
            end;
        }
        field(4; "Ceding office Name"; Text[100])
        {
        }
        field(5; "Cedant Commission"; Decimal)
        {
            MaxValue = 100;
        }
        field(6; Broker; Code[30])
        {
            TableRelation = Customer WHERE(Type = CONST(Broker));

            trigger OnValidate();
            begin
                IF Cedant.GET(Broker) THEN
                    "Broker Name" := Cedant.Name
                ELSE
                    "Broker Name" := '';
            end;
        }
        field(7; "Broker Name"; Text[100])
        {
        }
        field(8; "Broker Commision"; Decimal)
        {
            MaxValue = 100;
        }
        field(9; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(10; "Cash call limit"; Decimal)
        {
        }
        field(11; "Quota Share"; Boolean)
        {
        }
        field(12; Surplus; Boolean)
        {
        }
        field(13; Facultative; Boolean)
        {
        }
        field(14; "Exess of loss"; Boolean)
        {
        }
        field(15; "Quota share Retention"; Decimal)
        {
        }
        field(16; "Surplus Retention"; Decimal)
        {
        }
        field(17; "Cedant quota percentage"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                QuotaTotalPercent := 0;

                //Quota Share.


                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code", "Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share", TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code", "Addendum Code");

                IF ReassurerShare.FIND('-') THEN BEGIN
                    REPEAT
                        QuotaTotalPercent := QuotaTotalPercent + ReassurerShare."Percentage %";
                    UNTIL ReassurerShare.NEXT = 0;
                END;
                IF "Cedant quota percentage" + QuotaTotalPercent > 100 THEN
                    ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
            end;
        }
        field(18; "Premium income period"; DateFormula)
        {
        }
        field(19; "Premiun reserve period"; DateFormula)
        {
        }
        field(20; "Premiun reserve percentage"; Decimal)
        {
        }
        field(21; "Profit commission percentage"; Decimal)
        {
            MaxValue = 100;
        }
        field(22; "Commission period"; DateFormula)
        {
        }
        field(23; "Premium reserve cf period"; DateFormula)
        {
        }
        field(24; "Premium reserve cf percentage"; Decimal)
        {
        }
        field(25; "Claims period"; DateFormula)
        {
        }
        field(26; "Admin Expenses percentage"; Decimal)
        {
        }
        field(27; "Effective date"; Date)
        {
        }
        field(28; "Accounts preparation"; Option)
        {
            OptionCaption = '" ,Quartely,Semi-annualy,Annualy"';
            OptionMembers = " ",Quartely,"Semi-annualy",Annualy;
        }
        field(29; "Addendum Code"; Integer)
        {
        }
        field(30; Blocked; Boolean)
        {
        }
        field(31; Warranty; Integer)
        {
        }
        field(32; "Minimum Premium Deposit MDP"; Decimal)
        {
        }
        field(33; "Automatic Cover Limit"; Decimal)
        {
        }
        field(34; "Premium Rate"; Decimal)
        {
        }
        field(35; "Limit Of Indemnity"; Decimal)
        {
        }
        field(36; "Treaty Type"; Option)
        {
            OptionCaption = 'Cession,Retrocession';
            OptionMembers = Cession,Retrocession;
        }
        field(37; "Apportionment Type"; Option)
        {
            OptionCaption = 'Proportional,Non-proportional';
            OptionMembers = Proportional,"Non-proportional";
        }
        field(38; "Language Code Default"; Code[10])
        {
        }
        field(39; Attachement; Option)
        {
            OptionMembers = No,Yes;
        }
        field(40; "Code"; Code[10])
        {
            Numeric = true;
        }
        field(41; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = true;
            TableRelation = "No. Series";
        }
        field(42; "Free Cover Limit"; Decimal)
        {
        }
        field(43; "Treaty Status"; Option)
        {
            OptionCaption = '" ,Accepted,Pending,Sent For approval"';
            OptionMembers = " ",Accepted,Pending,"Sent For approval";
        }
        field(44; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(45; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(46; "Expiry Date"; Date)
        {
        }
        field(47; Type; Option)
        {
            OptionCaption = '" ,Group Life,Individual Life,Compulsory Cession"';
            OptionMembers = " ","Group Life","Individual Life","Compulsory Cession";
        }
        field(48; "Quota Share1"; Boolean)
        {
        }
        field(49; Surplus1; Boolean)
        {
        }
        field(50; Facultative1; Boolean)
        {
        }
        field(51; "Exess of loss1"; Boolean)
        {
        }
        field(52; "Quota share Retention1"; Decimal)
        {
        }
        field(53; "Surplus Retention1"; Decimal)
        {
        }
        field(54; "Cedant quota percentage1"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                QuotaTotalPercent := 0;

                //Quota Share.


                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code", "Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share", TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code", "Addendum Code");

                IF ReassurerShare.FIND('-') THEN BEGIN
                    REPEAT
                        QuotaTotalPercent := QuotaTotalPercent + ReassurerShare."Percentage %";
                    UNTIL ReassurerShare.NEXT = 0;
                END;
                IF "Cedant quota percentage" + QuotaTotalPercent > 100 THEN
                    ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
            end;
        }
        field(55; "Rider Commission"; Decimal)
        {
            MaxValue = 100;
        }
        field(56; "Renewal Cedant Commision"; Decimal)
        {
        }
        field(57; "Renewal Rider Commision"; Decimal)
        {
        }
        field(58; "Mandatory Cession Percentage"; Decimal)
        {
        }
        field(59; "Renewal Broker Commision"; Decimal)
        {
        }
        field(60; Posted; Boolean)
        {
        }
        field(61; "Posted By"; Code[10])
        {
            TableRelation = User;
        }
        field(62; "Posting Date"; Date)
        {
        }
        field(63; "Posting Time"; Time)
        {
        }
        field(64; "Actual Premium"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Actual Premium" < "Minimum Premium Deposit MDP" THEN
                    ERROR('Actual premium cannot be less than Minimum Premium Deposit(MDP).Please check!!');
            end;
        }
        field(65; "Created By"; Code[10])
        {
            TableRelation = User;
        }
        field(66; "Date Created"; Date)
        {
        }
        field(67; "Max Free Cover limit"; Decimal)
        {
        }
        field(68; "Max Age Limit"; Integer)
        {
        }
        field(69; "Claims Reserve"; DateTime)
        {
        }
        field(70; "Claims Payments period"; DateTime)
        {
        }
        field(71; "Approved By"; Code[10])
        {
            TableRelation = User;
        }
        field(72; "Approval Date"; Date)
        {
        }
        field(74; "Creation Date"; Date)
        {
        }
        field(75; "Sent For Approval"; Boolean)
        {
        }
        field(76; "Date Sent For Approval"; Date)
        {
        }
        field(77; "Renewal Cedant Commision1"; Decimal)
        {
        }
        field(78; "New Cedant Commision1"; Decimal)
        {
        }
        field(79; "Overrider Retro Commission"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Treaty Code", "Addendum Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cedant: Record Customer;
        TreatyProducts: Record "Treaty  Products";
        ReassuranceShare: Record "Reassurance Share";
        QuotaTotalPercent: Decimal;
        ReassurerShare: Record "Reassurance Share";
        LifeReSetup: Record "Reinsurance Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

