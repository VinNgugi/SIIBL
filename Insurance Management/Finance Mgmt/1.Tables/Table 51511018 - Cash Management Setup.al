table 51511018 "Cash Management Setup"
{
    // version FINANCE

    //LookupPageID = 50006;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Payment Voucher Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(3; "Imprest Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(4; "Imprest Surrender Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(5; "Petty Cash Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(6; "Receipt Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(7; "Post VAT"; Boolean)
        {
        }
        field(8; "Rounding Type"; Option)
        {
            OptionCaption = 'Up,Nearest,Down';
            OptionMembers = Up,Nearest,Down;
        }
        field(9; "Rounding Precision"; Decimal)
        {
        }
        field(10; "Imprest Limit"; Decimal)
        {
        }
        field(11; "Imprest Reconciliation Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Imprest Due Date"; DateFormula)
        {
        }
        field(13; "Petty Cash Limit"; Decimal)
        {
        }
        field(14; "PettyC Reconciliation Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(15; "Petty Cash Due Date"; DateFormula)
        {
        }
        field(16; "Post PAYEE"; Boolean)
        {
        }
        field(17; "Check Petty Cash Debit Balance"; Boolean)
        {
        }
        field(18; "Use Budget and Commit Setup"; Boolean)
        {
        }
        field(19; "Donor's Income Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(20; "Donor Accounting"; Boolean)
        {
        }
        field(21; "Finance Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = FILTER(Standard));

            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Global Dimension 1 Code");

                /*PurchaseReqDet.RESET;
                PurchaseReqDet.SETRANGE(PurchaseReqDet."Requistion No.","Requisition No.");
                
                IF PurchaseReqDet.FIND('-') THEN  BEGIN
                REPEAT
                PurchaseReqDet."Global Dimension 2 Code":="Global Dimension 2 Code";
                PurchaseReqDet.MODIFY;
                UNTIL PurchaseReqDet.NEXT=0;
                 END;
                 */

            end;
        }
        field(22; "Imprest Accountant"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(23; "Finance Email"; Text[50])
        {
        }
        field(24; "Petty Cash-Imprest Deduction"; Code[20])
        {
            //TableRelation = Deductions;
        }
        field(25; "Finance Admin"; Code[50])
        {
            TableRelation = "User Setup";
        }
        field(26; "Except from Activity"; Text[250])
        {
        }
        field(27; "Except Series From Activity"; Text[250])
        {
        }
        field(28; "Receipt No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(30; "Memo- Salary Advance Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50000; "Payments No"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50001; "Withholding Agent"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Cash Limit"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Default Bank Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(50004; "Default Cash Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(50005; "Attachments Path"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Current Budget"; Code[100])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Budget Name";
        }
        field(50007; "Commissioner Letters"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50008; "DMS Imprest Claim Link"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "DMS PV Link"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "DMS Imprest Link"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Remittance Sender Name"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Remittance Sender Address"; Text[80])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "HR DMS LINK"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Budget DMS Link"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Levy Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50017; "Current Budget Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50018; "Current Budget End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50019; "EFT File Path"; Code[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; "Journal Numbers"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50021; "Jnl Notification Time Period"; Duration)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Student Posting Group"; Code[20])
        {
            Caption = 'Student Posting Group';
            DataClassification = ToBeClassified;
            TableRelation = "Customer Posting Group";
        }
        field(50023; "Petty Cash No"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50024; "Allow Budget Overrun"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50025; "Cash Request  No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50026; "Surrender Template"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(50027; "Surrender batch"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Surrender Template"));
        }
        field(50028; "Board PV Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50029; "Exceed Budget"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Approve Journals"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Budget Approvals No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50032; "Budget Creation Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50033; "Budget Alert Threshold 1(%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Budget Alert Threshold 2(%)"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Budget Idle Period(Months)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "ERC Memo Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50037; "Warm Clothing Span (Years)"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Club Subscription AC"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50039; "Warm Clothing G/L Acc"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50041; "Basic Pay A/C"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50042; "Finance Department"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
        }
        field(50044; "Club Membership 1-3"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50045; "Club Membership 4-5"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50046; "NHIF Deadline Day"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50047; "NSSF Deadline Day"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50048; "PAYE Deadline Day"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50049; "Other Deductions Deadline"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50050; "Commisioner Payments Month Day"; Integer)
        {
            DataClassification = ToBeClassified;
            Description = '//Day of the Month When Commissioner Entries are created';
        }
        field(50051; "Commissioner Mandatory Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '//Global Payroll Figure For Commissioners';
        }
        field(50052; "Commissioner Jnl Template"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = '//Journal Template For Commissioners';
            TableRelation = "Gen. Journal Template";
        }
        field(50053; "Commissioner Jnl Batch"; Code[50])
        {
            DataClassification = ToBeClassified;
            Description = '//Journal Batch For Commissioners';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Commissioner Jnl Template"));
        }
        field(50054; "Seating Fee"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '//Amount Paid per Sitting By Commisioners';
        }
        field(50055; "Chair Honararia"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '//Amount Paid to Chair as Honararia';
        }
        field(50056; "Chair Airtime"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '//Amount Paid to Commissioner CjhairAirtime';
        }
        field(50057; "Commissioner Monthly Fee Acc"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50058; "Sitting Allowance Acc"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50059; "Chairman's Hononaria Acc"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50060; "PAYE%"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = '//Default 30% -';
        }
        field(50061; "Telephone Allowance Acc"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50062; "File Storage"; Text[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50063; "HR Department"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('DEPARTMENT'));
        }
        field(50064; "Trainings Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50065; "Comm No. Series"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50066; "Leave Allowance Payment Day"; Integer)
        {
            DataClassification = ToBeClassified;
            MaxValue = 31;
            MinValue = 1;
        }
        field(50067; "Receipts No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50068; "Normal Payments No"; Code[10])
        {
            Caption = 'Receipts No';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50069; "Cheque Reject Period"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50070; "Petty Cash Payments No"; Code[10])
        {
            Caption = 'Receipts No';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50071; "Line No."; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50072; ImprestProcess; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50073; ImprestSurrender; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series".Code;
        }
        field(50074; PCpayment; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50075; ImprestRequisition; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50076; "W/Hcertificate"; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50077; KCB1; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50078; NewCustomerNumber; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50079; Councils; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50080; "Venue Details"; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50081; "Training & Education"; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50082; KCB2; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50083; "Salary Advace"; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50085; "Investment DMS Link"; Text[1])
        {
            DataClassification = ToBeClassified;
        }
        field(50086; "Journal Template Name"; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Template";
        }
        field(50087; "Batch Name"; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(50088; "LPO Link"; Text[1])
        {
            DataClassification = ToBeClassified;
        }
        field(50089; "Requisition Link"; Text[1])
        {
            DataClassification = ToBeClassified;
        }
        field(50090; "Budget Transfer No."; Code[1])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50091; "Biometric Verification Link"; Text[1])
        {
            DataClassification = ToBeClassified;
        }
        field(50092; "Professional Membership Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50093; "DMS DB Link"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50094; "DBMS User ID"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50095; "DBMS Password"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50096; "Enforce Attachments"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50097; "Imprest DB Table"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50103; "Finance Budget Holder"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup";
        }
        field(50104; "InterBank Nos"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50105; "No of Days Allowed"; DateFormula)
        {
            DataClassification = ToBeClassified;
        }
        field(50106; "Imprest Payments Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account";
        }
        field(50107; "DMS Prequalification Link"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50108; "Per Diem Account"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(50109; "Budget Start Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50110; "Budget End Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50111; "EFT Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50112; "RTGS Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50113; "Posted Receipt Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50114; "Underwriter Receipt Nos."; Code[10])
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

