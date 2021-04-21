table 51513000 "Policy Type"
{
    // version AES-INS 1.0


    fields
    {
        field(1; Code; Code[10])
        {
            NotBlank = true;
        }
        field(2; Description; Text[120])
        {
        }
        field(4; "Quote Report ID"; Integer)
        {
            //TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(5; "Policy Report ID"; Integer)
        {
            //TableRelation = Object.ID WHERE(Type = CONST(Report));
        }
        field(6; Class; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(7; "Default Insurance Type"; Code[10])
        {
        }
        field(8; "Default Area Code"; Code[10])
        {
        }
        field(9; "Default Premium Payment"; Code[10])
        {
            TableRelation = "Payment Terms".Code;
        }
        field(10; "Default Excess"; Code[10])
        {
            //TableRelation = Table53004;
        }
        field(11; "Country Determines Area"; Boolean)
        {
        }
        field(12; "Quote Form ID-Individual"; Integer)
        {
            //TableRelation = Object.ID WHERE(Type = CONST(Page));
        }
        field(13; "Quote Form ID-Company"; Integer)
        {
            //TableRelation = Object.ID WHERE(Type = CONST(Page));
        }
        field(14; "Firm Order Form ID-Individual"; Integer)
        {
        }
        field(15; "Firm Order Form ID-Company"; Integer)
        {
        }
        field(16; "Policy Form ID-Individual"; Integer)
        {
        }
        field(17; "Policy Form ID-Company"; Integer)
        {
        }
        field(18; "No. of Quotes"; Integer)
        {
        }
        field(19; "No. of Firm Orders"; Integer)
        {
        }
        field(20; "No. of Policies"; Integer)
        {
        }
        field(21; "No. of Claims Paid"; Integer)
        {
        }
        field(22; "No. of Claims Rejected"; Integer)
        {
        }
        field(23; "Premium Calculation"; Enum PremiumCalculation)
        {
            //OptionMembers = " ",Percent," Per Mile";
        }
        field(24; "Schedule Subform"; Enum ScheduleSubform)
        {
            // OptionCaption = '" ,Vehicle,Medical,Fidelity,Employers Liability,Money,Group Personal,Workmen,Other,Personal Accident,Burglary,Bond,Life"';
            // OptionMembers = " ",Vehicle,Medical,Fidelity,"Employers Liability",Money,"Group Personal",Workmen,Other,"Personal Accident",Burglary,Bond,Life;
        }
        field(25; "Account Type"; Enum "Gen. Journal Account Type")
        {
            //OptionMembers = " ","G/L Account",Vendor;
        }
        field(26; "Account No"; Code[10])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" where(Blocked = const(false), "Direct Posting" = const(true))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor where(Blocked = const(" "));
            ValidateTableRelation = false;
        }
        field(27; "Commision % age(SIIBL)"; Decimal)
        {
        }
        field(28; "Commission Amount"; Decimal)
        {
        }
        field(29; "Non Renewable"; Boolean)
        {
        }
        field(30; Period; DateFormula)
        {
        }
        field(31; "Start Time"; Text[30])
        {
        }
        field(32; "End Time"; Text[30])
        {
        }
        field(33; "First Loss %"; Decimal)
        {
        }
        field(34; "Open Cover"; Boolean)
        {
        }
        field(35; "Short Name"; Text[5])
        {
        }
        field(36; Type; Option)
        {
            OptionMembers = " ",Asset,Liability;
        }
        // Check Enum PremiumCalculation
        field(37; Rating; Option)
        {
            OptionCaption = '" ,Per Cent,Per Mille"';
            OptionMembers = " ","Per Cent","Per Mille";
        }
        field(38; Conveyance; Text[250])
        {
        }
        field(39; "short code"; Code[10])
        {
        }
        field(40; "Premium Table"; Code[20])
        {
            TableRelation = "Premium Table";
        }
        field(41; "Policy Numbering"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(42; "Create Policy Numbers"; Boolean)
        {
        }
        field(43; "Claims Validity Period"; DateFormula)
        {
        }
        field(44; "Claims Paid"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Type" = FIELD(Code),
                                                        "Insurance Trans Type" = CONST("Claim Payment"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter")));

        }
        field(45; "Outstanding Claims"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Type" = FIELD(Code),
                                                        "Insurance Trans Type" = FILTER("Claim Payment" | "Claim Reserve"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(46; "Claims Incurred"; Decimal)
        {
        }
        field(47; "Gross Premium"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Type" = FIELD(Code),
                                                        "Insurance Trans Type" = CONST(Premium),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter")));
            FieldClass = FlowField;
        }
        field(48; "Certificate Type"; Code[20])
        {
            TableRelation = Item."No.";
        }
        field(49; "Retention Outstanding"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Type" = FIELD(Code),
                                                        "Insurance Trans Type" = FILTER("Claim Payment" | "Claim Reserve" | "Claim Recovery"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter")));

        }
        field(50; "Quota share"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Recovery"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Apportionment Type" = CONST("Quota Share")));

        }
        field(51; "Surplus Share"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Recovery"),
                                                       "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Apportionment Type" = CONST(Surplus)));

        }
        field(52; "Facultative Share"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Recovery"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Apportionment Type" = CONST(Fucultative)));

        }
        field(53; "X Loss 1"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Recovery"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Apportionment Type" = CONST("Excess Of Loss"),
                                                        "Lot No" = filter('X01')));
            FieldClass = FlowField;
        }
        field(54; "X Loss 2"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Recovery"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Apportionment Type" = CONST("Excess Of Loss"),
                                                        "Lot No" = filter('X02')));
            FieldClass = FlowField;
        }
        field(55; "X Loss 3"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = FILTER("Claim Recovery"),
                                                        "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Apportionment Type" = CONST("Excess Of Loss"),
                                                        "Lot No" = filter('X03')));
            FieldClass = FlowField;
        }
        field(56; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(57; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(58; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(59; "PPL Cost Per PAX"; Decimal)
        {
        }
        field(60; Comprehensive; Boolean)
        {
        }
        field(61; "Last Policy No."; Code[20])
        {
        }
        field(62; "Last Endorsement No."; Code[20])
        {
        }
        field(63; "Certificate Type Bus"; Code[20])
        {
            TableRelation = Item;
        }
        field(64; "Bus Seating Capacity Cut-off"; Integer)
        {
        }
        field(65; "Premium Rate"; Decimal)
        {
        }
        field(66; IBNR; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Policy Type" = FIELD(Code),
                                                        "Posting Date" = FIELD("Date Filter"),
                                                        "Insurance Trans Type" = CONST(IBNR)));

        }
        field(67; "Reinsurance Notified Claims"; Decimal)
        {
        }
        field(68; "Reinsurance IBNR"; Decimal)
        {
        }
        field(69; "Treaty Code"; Code[30])
        {
            TableRelation = Treaty;
        }
        field(70; "Addendum No."; Integer)
        {
            TableRelation = Treaty."Addendum Code" WHERE("Treaty Code" = FIELD("Treaty Code"));
        }
        field(71; "Insurance Type"; Enum InsuranceType)
        {
            //OptionCaption = '" ,General,Life"';
            //OptionMembers = " ",General,Life;
        }
        field(72; "Premium Discount Applicable"; Boolean)
        {
        }
        field(73; "Earns Bonus"; Boolean)
        {
        }
        field(74; "Cover Type Category"; Code[20])
        {
            TableRelation = "Cover Type";
        }
        field(75; "Allows Joint Cover"; Boolean)
        {
        }
        field(76; "Age Computation Method"; Enum AgeComputationMethod)
        {
            //OptionCaption = '" ,Age Next Birthday,Age Last Birthday"';
            //OptionMembers = " ","Age Next Birthday","Age Last Birthday";
        }
        field(77; "Min Entry Age"; Integer)
        {
        }
        field(78; "Max Entry Age"; Integer)
        {
        }
        field(79; "Min SA"; Decimal)
        {
        }
        field(80; "Max SA"; Decimal)
        {
        }
        field(81; "Min. Premium"; Decimal)
        {
        }
        field(82; "Max. Premium"; Decimal)
        {
        }
        field(83; "Sum Assured Calculation Method"; Enum SumAssuredCalcMethod)
        {
            // OptionCaption = '" ,Factor of salary,Unit Rate,Age based Rates,Fixed SA,Age based and SA Range"';
            // OptionMembers = " ","Factor of salary","Unit Rate","Age based Rates","Fixed SA","Age based and SA Range";
        }
        field(84; "Premium Calculation Method"; Enum PremiumCalcMethod)
        {
            //OptionCaption = '" ,Age and Term based Rate tables,Unit Rate,Defined SA,Unit Rate & Age limit"';
            //OptionMembers = " ","Age and Term based Rate tables","Unit Rate","Defined SA","Unit Rate & Age limit";
        }
        field(85; "Term Guaranteed Period"; Boolean)
        {
        }
        field(86; "Allows Escalation"; Boolean)
        {
        }
        field(87; "Allows Augmentation"; Boolean)
        {
        }
        field(88; "Annuity Uses"; Enum AnnuityUses)
        {
            //OptionMembers = " ","Age Based rates","Interest rates";
        }
        field(89; "Premium Type"; Enum InsurancePremiumType)
        {
            //OptionCaption = '" ,Level Term Premium,Single Premium,Reducing Balance Premium"';
            //OptionMembers = " ","Level Term Premium","Single Premium","Reducing Balance Premium";
        }
        field(90; "SA Assured Type"; Enum SAAssuredType)
        {
            //OptionCaption = '" ,Constant,Decreasing"';
            //OptionMembers = " ",Constant,Decreasing;
        }
        field(91; "Surrender Period"; DateFormula)
        {
        }
        field(92; "Free Cover Limit"; Decimal)
        {
        }
        field(93; "Commission %age (Agent)"; Decimal)
        {

        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

