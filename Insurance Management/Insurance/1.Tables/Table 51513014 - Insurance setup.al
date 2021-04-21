table 51513014 "Insurance setup"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "New Quotation Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(3; "Claim Incident Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4; "Claim Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(6; "Default Prod. Posting Group"; Code[10])
        {
            TableRelation = "Gen. Product Posting Group";
        }
        field(7; "Default VAT Bus. Posting Group"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(8; "Default VAT Pro. Posting Group"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";
        }
        field(9; "Default Area"; Code[10])
        {
            TableRelation = "Insurance Zone";
        }
        field(10; "Default Insurance Type"; Code[10])
        {
        }
        field(11; "Policy Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Underwriters Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(13; "Agent Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(14; "Renewal Quote Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(15; "Modification Quote Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(16; "Sell-to Customer Template Code"; Code[10])
        {
            TableRelation = "Customer Template";
        }
        field(17; "Renewal Reminder Period"; DateFormula)
        {
        }
        field(18; "Payment Reminder Period"; DateFormula)
        {
        }
        field(19; "Minimum Refund Period"; DateFormula)
        {
        }
        field(20; "No. of Days in a Year"; Decimal)
        {
        }
        field(21; "Commission Received"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(22; "Commission Payable"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(23; "Default Bus. Posting Group"; Code[20])
        {
            TableRelation = "Gen. Business Posting Group";
        }
        field(24; "Medical Practitioners No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(25; "Default Zone"; Code[20])
        {
            TableRelation = "Insurer Policy Details";
        }
        field(26; "Quotation Follow Up Period"; DateFormula)
        {
        }
        field(27; "Default Payment Terms"; Code[20])
        {
            TableRelation = "Payment Terms";
        }
        field(28; "Quotation Validity Period"; DateFormula)
        {
        }
        field(29; "Witholding Tax % age"; Decimal)
        {
        }
        field(30; "Withholding Tax Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(31; "Policy Holder Compensation %"; Decimal)
        {
        }
        field(32; "Training Levy %"; Decimal)
        {
        }
        field(33; "Yellow card %"; Decimal)
        {
        }
        field(34; "PCF G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(35; "Training Levy G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(36; "Yellow Card G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(37; "Gross Premium G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(38; "Claims Outsatnding A/c"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(39; "Post PCF"; Boolean)
        {
        }
        field(40; "Post Yellow Card"; Boolean)
        {
        }
        field(41; "Post Training Levy"; Boolean)
        {
        }
        field(42; "Insurance Template"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(43; "Debit Note"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(44; "Credit Note"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(45; "Last Policy No."; Code[10])
        {
        }
        field(46; "Business Type"; Enum "Business Type")
        {
            /*  OptionCaption = '" ,Brokerage,Insurer-General,Insurer-Life"';
             OptionMembers = " ",Brokerage,"Insurer-General","Insurer-Life"; */
        }
        field(47; "Default Insured PG"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(48; "Default Insurer PG"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(49; "Default Agent PG"; Code[10])
        {
            TableRelation = "Vendor Posting Group";
        }
        field(50; "Default Reinsurer PG"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(51; "Default SACCO PG"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(52; "Default Lawyer/Law firms PG"; Code[10])
        {
            TableRelation = "Vendor Posting Group";
        }
        field(53; "Default Premium Financier PG"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(54; "Credit Request Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(55; "Logo Position on Documents"; Option)
        {
            Caption = 'Logo Position on Documents';
            OptionCaption = 'No Logo,Left,Center,Right';
            OptionMembers = "No Logo",Left,Center,Right;
        }
        field(56; "Accepted Quote Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(57; "Insurance Batch"; Code[10])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Insurance Template"));
        }
        field(58; Name; Code[20])
        {
            NotBlank = false;
        }
        field(59; URL; Text[250])
        {
        }
        field(60; "Message Parameter"; Text[100])
        {
            NotBlank = true;
        }
        field(61; "Phone Parameter"; Text[100])
        {
            NotBlank = true;
        }
        field(62; Status; Option)
        {
            OptionMembers = " ",Active,Inactive;
        }
        field(63; "Phone Prefix"; Text[10])
        {
        }
        field(64; "Posted Debit Notes"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(65; "Posted Credit Notes"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(66; "Claim Report Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(67; "Claim Reservation Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(68; "Service Provider Appointments"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(69; "Claim Validity Period"; DateFormula)
        {
        }
        field(70; "Allow BackDating of Policy"; Boolean)
        {
        }
        field(71; "Use Caps for Names"; Boolean)
        {
        }
        field(72; "Rounding Type"; Option)
        {
            OptionCaption = 'Up,Nearest,Down';
            OptionMembers = Up,Nearest,Down;
        }
        field(73; "Rounding Precision"; Decimal)
        {
        }
        field(74; "Broker Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(75; "Insured Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(76; "SACCO Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(77; "Default Broker PG"; Code[10])
        {
            TableRelation = "Customer Posting Group";
        }
        field(78; "Default Broker WHT Group"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(79; "Default Agent WHT Group"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(80; "Default Re-insurer WHT Group"; Code[10])
        {
            TableRelation = "VAT Business Posting Group";
        }
        field(81; "Default WHT Code"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";
        }
        field(82; "Default Excise Duty Code"; Code[10])
        {
            TableRelation = "VAT Product Posting Group";
        }
        field(83; "Charge Full Tax on 1st Instal"; Boolean)
        {
        }
        field(84; "Bank Assurance Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(85; "Default PG Bank Assurance"; Code[20])
        {
            TableRelation = "Customer Posting Group";
        }
        field(86; "IPF Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(87; "Direct Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(88; "Company Credit Limit"; Decimal)
        {
        }
        field(89; "Total Branch Credit Allocation"; Decimal)
        {
            CalcFormula = Sum("Credit Limit Branch Setup".Amount);
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Last Round"; Integer)
        {
        }
        field(91; "Company Default Email"; Text[250])
        {
        }
        field(92; "Total Gross Premium"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST(Premium)));

        }
        field(93; "EFT Nos."; Code[10])
        {
        }
        field(94; "RTGS Nos."; Code[10])
        {
        }
        field(95; "Demand Letter Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(96; "Summon Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(97; "Insurer Quote Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

