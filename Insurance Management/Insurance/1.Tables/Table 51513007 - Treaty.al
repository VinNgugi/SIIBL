table 51513007 Treaty
{
    // version AES-INS 1.0

    DrillDownPageID = 51513055;
    LookupPageID = 51513055;

    fields
    {
        field(1; "Treaty Code"; Code[30])
        {
        }
        field(2; "Addendum Code"; Integer)
        {
        }
        field(3; "Treaty description"; Text[100])
        {
        }
        field(4; Broker; Code[30])
        {
            /*TableRelation = Customer WHERE("Customer Type" = CONST("Agent/Broker"));

            trigger OnValidate();
            begin
                IF BrokerRec.GET(Broker) THEN
                    "Broker Name" := BrokerRec.Name
                ELSE
                    "Broker Name" := '';
            end;*/
        }
        field(5; "Broker Name"; Text[100])
        {
        }
        field(6; "Broker Commision"; Decimal)
        {
            MaxValue = 100;
        }
        field(7; "Contract Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(8; "Cash call limit"; Decimal)
        {
        }
        field(9; "Quota Share"; Boolean)
        {
        }
        field(10; Surplus; Boolean)
        {
        }
        field(11; Facultative; Boolean)
        {
        }
        field(12; "Exess of loss"; Boolean)
        {
        }
        field(13; "Quota share Retention"; Decimal)
        {
        }
        field(14; "Surplus Retention"; Decimal)
        {
        }
        field(15; "Insurer quota percentage"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*QuotaTotalPercent:=0;
                
                //Quota Share.
                
                
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                QuotaTotalPercent:=QuotaTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF "Cedant quota percentage"+QuotaTotalPercent>100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                 */

            end;
        }
        field(16; "Premium income period"; DateFormula)
        {
        }
        field(17; "Premiun reserve period"; DateFormula)
        {
        }
        field(18; "Premiun reserve percentage"; Decimal)
        {
        }
        field(19; "Profit commission percentage"; Decimal)
        {
            MaxValue = 100;
        }
        field(20; "Commission period"; DateFormula)
        {
        }
        field(21; "Premium reserve cf period"; DateFormula)
        {
        }
        field(22; "Premium reserve cf percentage"; Decimal)
        {
        }
        field(23; "Claims period"; DateFormula)
        {
        }
        field(24; "Admin Expenses percentage"; Decimal)
        {
        }
        field(25; "Effective date"; Date)
        {
        }
        field(26; "Accounts preparation"; Option)
        {
            OptionCaption = '" ,Quartely,Semi-annualy,Annualy"';
            OptionMembers = " ",Quartely,"Semi-annualy",Annualy;
        }
        field(28; Blocked; Boolean)
        {
        }
        field(29; Warranty; Integer)
        {
        }
        field(30; "Minimum Premium Deposit(MDP)"; Decimal)
        {
        }
        field(31; "Automatic Cover Limit"; Decimal)
        {
        }
        field(32; "Premium Rate"; Decimal)
        {
        }
        field(33; "Limit Of Indemnity"; Decimal)
        {
        }
        field(34; "Treaty Type"; Option)
        {
            OptionCaption = 'Cession,Retrocession';
            OptionMembers = Cession,Retrocession;
        }
        field(35; "Apportionment Type"; Option)
        {
            OptionCaption = 'Proportional,Non-proportional';
            OptionMembers = Proportional,"Non-proportional";
        }
        field(36; "Language Code (Default)"; Code[10])
        {
        }
        field(37; Attachment; Boolean)
        {
        }
        field(39; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = true;
            TableRelation = "No. Series";
        }
        field(40; "Free Cover Limit"; Decimal)
        {
        }
        field(41; "Treaty Status"; Option)
        {
            OptionCaption = '" ,Accepted,Pending,Sent For approval"';
            OptionMembers = " ",Accepted,Pending,"Sent For approval";
        }
        field(42; "Territory Code"; Code[10])
        {
            Caption = 'Territory Code';
            TableRelation = Territory;
        }
        field(43; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(44; "Expiry Date"; Date)
        {
        }
        field(45; Type; Option)
        {
            OptionCaption = '" ,Group Life,Individual Life,Compulsory Cession,General Business"';
            OptionMembers = " ","Group Life","Individual Life","Compulsory Cession","General Business";
        }
        field(46; "Quota Share1"; Boolean)
        {
        }
        field(47; Surplus1; Boolean)
        {
        }
        field(48; Facultative1; Boolean)
        {
        }
        field(49; "Exess of loss1"; Boolean)
        {
        }
        field(50; "Quota share Retention1"; Decimal)
        {
        }
        field(51; "Surplus Retention1"; Decimal)
        {
        }
        field(52; "Cedant quota percentage"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*QuotaTotalPercent:=0;
                
                //Quota Share.
                
                
                ReassurerShare.RESET;
                ReassurerShare.SETRANGE(ReassurerShare."Treaty Code","Treaty Code");
                ReassurerShare.SETRANGE(ReassurerShare."Qouta Share",TRUE);
                ReassurerShare.SETRANGE(ReassurerShare."Addendum Code","Addendum Code");
                
                IF ReassurerShare.FIND('-') THEN BEGIN
                REPEAT
                QuotaTotalPercent:=QuotaTotalPercent+ReassurerShare."Percentage %";
                UNTIL ReassurerShare.NEXT=0;
                END;
                IF "Cedant quota percentage"+QuotaTotalPercent>100 THEN
                ERROR('You have exceeded 100 Percent%.Please Check!!!');
                //MESSAGE('%1',SurplusTotalPercent);
                */

            end;
        }
        field(57; "Renewal Broker Commision"; Decimal)
        {
        }
        field(58; Posted; Boolean)
        {
        }
        field(59; "Posted By"; Code[80])
        {
            TableRelation = User;
        }
        field(60; "Posting Date"; Date)
        {
        }
        field(61; "Posting Time"; Time)
        {
        }
        field(62; "Actual Premium"; Decimal)
        {
            FieldClass = FlowField;
            //CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD("Main Class Code"),
            //                                            "Insurance Trans Type"=CONST(Premium)));


            trigger OnValidate();
            begin
                IF "Actual Premium" < "Minimum Premium Deposit(MDP)" THEN
                    ERROR('Actual premium cannot be less than Minimum Premium Deposit(MDP).Please check!!');
            end;
        }
        field(63; "Created By"; Code[80])
        {
            TableRelation = User;
        }
        field(64; "Date Created"; Date)
        {
        }
        field(65; "Max Free Cover limit"; Decimal)
        {
        }
        field(66; "Max Age Limit"; Integer)
        {
        }
        field(67; "Claims Reserve"; DateTime)
        {
        }
        field(68; "Claims Payments period"; DateTime)
        {
        }
        field(69; "Quota Line"; Decimal)
        {
        }
        field(70; "Surplus Line"; Decimal)
        {
        }
        field(71; "Lead Reinsurer"; Code[20])
        {
            //TableRelation = Customer WHERE("Customer Type"=CONST("Re-Insurance Company"));
        }
        field(72; "Claim Notification Period"; DateFormula)
        {
        }
        field(73; "Settlement Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(74; "Renewal Commission"; Decimal)
        {
        }
        field(75; "Minimum Premium Deposit (MDP)"; Decimal)
        {
        }
        field(76; "Approved By"; Code[80])
        {
            TableRelation = User;
        }
        field(77; "Approval Date"; Date)
        {
        }
        field(78; "Creation Date"; Date)
        {
        }
        field(79; "Sent For Approval"; Boolean)
        {
        }
        field(80; "Date Sent For Approval"; Date)
        {
        }
        field(81; "Lead Reinsurer Name"; Text[30])
        {
        }
        field(82; "MDP No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(83; "Class of Insurance"; Code[20])
        {
            TableRelation = "Policy Type";

            trigger OnValidate();
            begin
                //IF PolicyTypereC.GET("Class of Insurance") THEN
                //    "Main Class Code" := PolicyTypereC.Class;
            end;
        }
        field(84; "Treaty Capacity"; Decimal)
        {
        }
        field(85; "Capacity Type"; Option)
        {
            OptionCaption = '" ,Per Risk,Per Policy,Per event"';
            OptionMembers = " ","Per Risk","Per Policy","Per event";
        }
        field(86; "Net Retained Line"; Decimal)
        {
        }
        field(87; "No. of Lines"; Decimal)
        {
        }
        field(88; "Premium Calculation Method"; Option)
        {
            OptionCaption = '" ,Fixed Amount,Fixed Premium Rate,variable Premium Rate"';
            OptionMembers = " ","Fixed Amount","Fixed Premium Rate","variable Premium Rate";
        }
        field(89; "Reinstatement Premium Method"; Option)
        {
            OptionCaption = '" ,Pro-rata temporis,Pro-rata capita"';
            OptionMembers = " ","Pro-rata temporis","Pro-rata capita";
        }
        field(90; "XOL Rate"; Decimal)
        {
        }
        field(91; "Main Class Code"; Code[20])
        {
        }
        field(92; "Total Resinsurance Share"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Treaty Reinsurance Share"."Percentage %" WHERE("Treaty Code" = FIELD("Treaty Code"),
                                                                               "Addendum Code" = FIELD("Addendum Code")));

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
        BrokerRec: Record Customer;
    //PolicyTypereC : Record "Policy Type";
}

