table 51513071 "Certificate Printing"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement;
        }
        field(2; "Document No."; Code[30])
        {
        }
        field(3; "Risk ID"; Integer)
        {
        }
        field(4; "Family Name"; Text[30])
        {
        }
        field(5; "First Name(s)"; Text[15])
        {
        }
        field(6; Title; Option)
        {
            OptionMembers = Prof,Dr,Mr,Mrs,Ms;
        }
        field(7; Sex; Option)
        {
            OptionMembers = Male,Female;
        }
        field(8; "Height Unit"; Option)
        {
            OptionMembers = m,ft,inches,cm;
        }
        field(9; Height; Decimal)
        {
        }
        field(10; "Weight Unit"; Option)
        {
            OptionMembers = Kg,Lb;
        }
        field(11; Weight; Decimal)
        {
        }
        field(12; "Date of Birth"; Date)
        {
        }
        field(13; "Relationship to Applicant"; Option)
        {
            OptionMembers = " ",Employee,Spouse,Son,Daughter,Relative,Applicant;
        }
        field(14; Occupation; Text[30])
        {
        }
        field(15; Nationality; Code[20])
        {
            TableRelation = "Country/Region";
        }
        field(16; "Gross Premium"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(17; Age; Integer)
        {
        }
        field(18; BMI; Decimal)
        {
        }
        field(19; "Cover Type"; Option)
        {
            OptionMembers = Member,Dependant;
        }
        field(20; "Member Code"; Integer)
        {
        }
        field(21; "Area of Cover"; Code[20])
        {
        }
        field(22; "Policy Type"; Code[20])
        {
            TableRelation = "Policy Type";
        }
        field(23; "Insurance Type"; Code[20])
        {
        }
        field(24; "Premium Amount"; Decimal)
        {
        }
        field(25; "Height(m)"; Decimal)
        {
        }
        field(26; "Weight(Kg)"; Decimal)
        {
        }
        field(27; "Policy No"; Text[30])
        {
        }
        field(28; "Premium Payment"; Code[20])
        {
        }
        field(29; Optional; Boolean)
        {
        }
        field(30; "Check Mark"; Boolean)
        {
        }
        field(31; Class; Code[20])
        {
            TableRelation = "Insurance Class";
        }
        field(32; "Loading %"; Decimal)
        {
        }
        field(33; "Reduction %"; Decimal)
        {
        }
        field(34; "Loading amt"; Decimal)
        {
        }
        field(35; "reduction amt"; Decimal)
        {
        }
        field(36; Tax; Boolean)
        {
        }
        field(37; "Endorsement Date"; Date)
        {
        }
        field(38; "Moratorium Date"; Date)
        {
        }
        field(39; "Deletion Date"; Date)
        {
        }
        field(40; "Country of Residence"; Code[20])
        {
            TableRelation = "Country/Region";
        }
        field(41; "Sum Insured"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(42; "Rate %age"; Decimal)
        {
            DecimalPlaces = 0 : 8;
        }
        field(43; "Risk Covered"; Text[250])
        {
        }
        field(44; "Net Premium"; Decimal)
        {
        }
        field(45; "Adjustment %"; Decimal)
        {
        }
        field(46; "Mid-Term Adjustment Factor"; Decimal)
        {
        }
        field(47; "Copied from No."; Code[20])
        {
        }
        field(48; Status; Option)
        {
            OptionMembers = Active,Deleted;
        }
        field(49; "Cover Description"; Text[250])
        {
        }
        field(50; "Registration No."; Code[10])
        {
        }
        field(51; Make; Code[20])
        {
            TableRelation = "Car Makers";
        }
        field(52; "Year of Manufacture"; Integer)
        {
        }
        field(53; "Type of Body"; Code[20])
        {
            TableRelation = "Vehicle Body Type";
        }
        field(54; "Cubic Capacity (cc)"; Text[30])
        {
        }
        field(55; "Seating Capacity"; Integer)
        {
            TableRelation = "Vehicle Capacity";
        }
        field(56; "Carrying Capacity"; Integer)
        {
            TableRelation = "Vehicle Capacity";
        }
        field(57; "No. of Employees"; Integer)
        {
        }
        field(58; "Description Type"; Option)
        {
            OptionMembers = " ",Cover,Interest,Deductible,Clauses,Limits,Warranty,"Basis of Settlement",Excess,Geographic,"Schedule of Insured",Tax,Exclusions;
        }
        field(59; ft; Option)
        {
            OptionMembers = "0","1","2","Payment Terms",Currency,"5","6","7","8","9","10","11";
        }
        field(60; "Height (ft)"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(61; "Country of Residence Desc"; Text[30])
        {
        }
        field(62; "Nationality Description"; Text[30])
        {
        }
        field(63; "Mark for Deletion"; Boolean)
        {
        }
        field(64; "Purchase Date of Current Benef"; Date)
        {
        }
        field(65; "Start Date"; Date)
        {
        }
        field(66; "End Date"; Date)
        {
        }
        field(67; "Estimated Annual Earnings"; Decimal)
        {
        }
        field(68; "Serial No"; Text[30])
        {
        }
        field(69; "Limit of Liability"; Decimal)
        {
        }
        field(70; Position; Text[30])
        {
        }
        field(71; Category; Text[50])
        {
        }
        field(72; "Employee Name"; Text[30])
        {
        }
        field(73; Windscreen; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(74; "Radio Cassette"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(75; "Windscreen % Rate"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(76; "Radio Cassette % Rate"; Decimal)
        {
            DecimalPlaces = 0 : 4;
        }
        field(77; "Engine No."; Code[20])
        {
        }
        field(78; "Chassis No."; Code[20])
        {
        }
        field(79; Death; Decimal)
        {
        }
        field(80; "Permanent Disability"; Decimal)
        {
        }
        field(81; "Temporary Disability"; Decimal)
        {
        }
        field(82; "Medical expenses"; Decimal)
        {
        }
        field(83; "Death Rate"; Decimal)
        {
        }
        field(84; "P.D Rate"; Decimal)
        {
        }
        field(85; "T.D Rate"; Decimal)
        {
        }
        field(86; "M.E Rate"; Decimal)
        {
        }
        field(87; Section; Code[20])
        {
        }
        field(88; "Text Type"; Option)
        {
            OptionMembers = Normal,Bold,Underline;
        }
        field(89; "Line Type"; Option)
        {
            OptionMembers = interest,Heading,"Begin-Total","End-Total",Total;
        }
        field(90; Totaling; Integer)
        {
            TableRelation = "Sales Line"."Line No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(91; "Actual Value"; Text[70])
        {
        }
        field(92; Value; Decimal)
        {
        }
        field(93; "Commision %"; Decimal)
        {
        }
        field(94; Commission; Decimal)
        {
        }
        field(95; "First Loss Sum Insured"; Decimal)
        {
            DecimalPlaces = 0 : 0;
        }
        field(96; "Total Value at Risk"; Decimal)
        {
            DecimalPlaces = 0 : 0;

            trigger OnValidate();
            begin



                /*IF insurerPolicy.GET(InsHeader."Policy Type",InsHeader."Agent/Broker") THEN
                BEGIN
                "Rate %age":=insurerPolicy."Premium % age Rate";

                END;



               IF PolicyType.GET(InsHeader."Policy Type") THEN
               BEGIN
               "First Loss Sum Insured":=(PolicyType."First Loss %"/1000)*"Total Value at Risk";
               END;
               "Gross Premium":= (("TVA Rate"/1000)*"Total Value at Risk")+(("First Loss Rate"/1000)*"First Loss Sum Insured");
                VALIDATE("Gross Premium"); */

            end;
        }
        field(97; "First Loss Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                //Type:=Type::Vendor;
                "Gross Premium" := (("TVA Rate" / 1000) * "Total Value at Risk") + (("First Loss Rate" / 1000) * "First Loss Sum Insured");
            end;
        }
        field(98; "TVA Rate"; Decimal)
        {

            trigger OnValidate();
            begin
                "Gross Premium" := (("TVA Rate" / 1000) * "Total Value at Risk") + (("First Loss Rate" / 1000) * "First Loss Sum Insured");
                //Type:=Type::Vendor;
                VALIDATE("Gross Premium");
            end;
        }
        field(99; "Per Capita"; Decimal)
        {
        }
        field(100; "Rate Type"; Option)
        {
            OptionMembers = " ","Per Cent","Per Mille";
        }
        field(101; PLL; Decimal)
        {
        }
        field(102; "Valuation Currency"; Code[10])
        {
            TableRelation = Currency;
        }
        field(103; Model; Code[20])
        {
            TableRelation = "Car Models".Model WHERE("Car Maker" = FIELD(Make));
        }
        field(104; "Vehicle Usage"; Code[10])
        {
            TableRelation = "Vehicle Usage";
        }
        field(105; "Line No."; Integer)
        {
        }
        field(106; Amount; Decimal)
        {
        }
        field(107; "Extra Premium"; Decimal)
        {
            CalcFormula = Sum("Additional Benefits".Premium WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("Document No."),
                                                                   "Risk ID" = FIELD("Risk ID")));
            FieldClass = FlowField;
        }
        field(108; "Vehicle Tonnage"; Code[10])
        {
            TableRelation = Tonnage;
        }
        field(109; "Vehicle License Class"; Code[10])
        {
            TableRelation = "Motor Classification";
        }
        field(110; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(111; "Account No."; Code[20])
        {
            Caption = 'Account No.';
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                      Blocked = CONST(false))
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";
        }
        field(112; Name; Text[50])
        {
        }
        field(113; Description; Text[250])
        {
        }
        field(114; "TPO Premium"; Decimal)
        {
        }
        field(115; "SACCO ID"; Code[20])
        {
            TableRelation = Customer WHERE("Customer Type" = CONST(SACCO));
        }
        field(116; "Route ID"; Code[20])
        {
            TableRelation = "SACCO Routes";
        }
        field(117; "Dimension Set ID"; Integer)
        {
        }
        field(118; Quantity; Decimal)
        {
        }
        field(119; "Select Risk ID"; Integer)
        {
            TableRelation = "Insure Lines"."Line No." WHERE("Document Type" = CONST(Policy),
                                                             "Document No." = FIELD("Policy No"));
        }
        field(120; "Endorsement Type"; Code[20])
        {
            TableRelation = "Endorsement Types";

            trigger OnValidate();
            begin
                /*IF EndorsmentType.GET("Endorsement Type") THEN
                  "Action Type":=EndorsmentType."Action Type";*/

            end;
        }
        field(121; "Action Type"; Option)
        {
            OptionMembers = " ",Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition;
        }
        field(122; Selected; Boolean)
        {
        }
        field(123; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";
        }
        field(124; "Certificate Status"; Option)
        {
            OptionCaption = '" ,Active,Cancelled"';
            OptionMembers = " ",Active,Cancelled,Suspended,Lapsed;
        }
        field(125; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(126; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(127; "Insured No."; Code[20])
        {
        }
        field(128; "Certificate No."; Code[30])
        {
        }
        field(129; "Certificate Type"; Code[10])
        {
            TableRelation = Item;
        }
        field(130; "Date Printed"; Date)
        {
        }
        field(131; "Print Time"; Time)
        {
        }
        field(132; "Printed By"; Code[80])
        {
        }
        field(133; Printed; Boolean)
        {
        }
        field(134; "Item Entry No."; Integer)
        {
            TableRelation = "Item Ledger Entry"."Entry No." WHERE("Item No." = FIELD("Certificate Type"));

            trigger OnValidate();
            begin
                IF ItemEntryRelation.GET("Item Entry No.") THEN BEGIN
                    "Certificate No." := ItemEntryRelation."Serial No.";
                    MESSAGE('%1', ItemEntryRelation."Serial No.");
                END;
            end;
        }
        field(135; "date and time"; DateTime)
        {
        }
        field(136; "Insured Name"; Text[80])
        {
        }
        field(137; "cancellation Reason"; Code[20])
        {
            TableRelation = "Cancellation Reasons";

            trigger OnValidate();
            begin
                IF CancelReasonRec.GET("cancellation Reason") THEN
                    "cancellation Reason Desc" := CancelReasonRec.Description;
            end;
        }
        field(138; "cancellation Reason Desc"; Text[30])
        {
        }
        field(139; Medical; Decimal)
        {
        }
        field(140; "Cancellation Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        ERROR('Cannot Delete this record');
    end;

    trigger OnModify();
    begin
        //ERROR('Cannot modify this record');
    end;

    var
        ItemEntryRelation: Record "Item Entry Relation";
        CancelReasonRec: Record "Cancellation Reasons";
}

