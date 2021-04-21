table 51513059 Benefits
{
    // version AES-INS 1.0


    fields
    {
        field(1; BenefitsID; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'Posting,Heading,Total,Begin-Total,End-Total';
            OptionMembers = Posting,Heading,Total,"Begin-Total","End-Total";

            trigger OnValidate();
            var
                GLEntry: Record "G/L Entry";
                GLBudgetEntry: Record "G/L Budget Entry";
            begin
                /*IF ("Account Type" <> "Account Type"::Posting) AND
                   (xRec."Account Type" = xRec."Account Type"::Posting)
                THEN BEGIN
                  GLEntry.SETCURRENTKEY("G/L Account No.");
                  GLEntry.SETRANGE("G/L Account No.","No.");
                  IF GLEntry.FIND('-') THEN
                    ERROR(
                      Text000,
                      FIELDCAPTION("Account Type"));
                  GLBudgetEntry.SETCURRENTKEY("Budget Name","G/L Account No.");
                  GLBudgetEntry.SETRANGE("G/L Account No.","No.");
                  IF GLBudgetEntry.FIND('-') THEN
                    ERROR(
                      Text001,
                      FIELDCAPTION("Account Type"));
                END;
                Totaling := '';
                IF "Account Type" = "Account Type"::Posting THEN BEGIN
                  IF "Account Type" <> xRec."Account Type" THEN
                    "Direct Posting" := TRUE;
                END ELSE
                  "Direct Posting" := FALSE; */

            end;
        }
        field(4; Indentation; Integer)
        {
            Caption = 'Indentation';
            MinValue = 0;
        }
        field(5; "Benefit Category"; Code[20])
        {
            TableRelation = "Claim Types";
        }
        field(22; "Benefit Type"; Option)
        {
            OptionMembers = " ","Overall Maximimum ","Full Refund","Full Refund+ # Sessions","Limited by Amount","Limited to Period","Full refund Upto Amt Per Day","Full refund upto # Days","Full refund upto # Days+waiting period","Limited by amount up to # Days","Limited by Amount and Membership Period","Limited by Amt and Waiting Period","Full Refund+Waiting Period","Full refund+Daily amount+Period Limit","Amt Limit+Amt Per day+Period","Limited by Amount+Lifetime benefit";
        }
        field(24; "Benefit Section"; Option)
        {
            OptionMembers = "0","1-Overall Maximum","2-Emergency Medical Transfer & Evacuation","3-Additional Transportation","4-Elective Medical transfer","5-In-Patient Treatment","6-Daycare Treatment","7-Out-Patient Treatment","8-Chronic Treatment","9-Kidney Dialysis","10-Infertility","11-Cancer Care","12-Organ Transplant","13-Lifetime","14-Cash","15-Pregnancy and Childbirth","16-Emergency Dental","17-Optical","18-Audiology","19-Wellness","20-Out of Area Cover","21-Optional Dental";
        }
    }

    keys
    {
        key(Key1; BenefitsID)
        {
        }
    }

    fieldgroups
    {
    }
}

