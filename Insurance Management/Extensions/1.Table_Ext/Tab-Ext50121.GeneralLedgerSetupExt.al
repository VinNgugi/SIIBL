tableextension 50121 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50000; "Payments No"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50001; "Withholding Agent"; Boolean)
        {
        }
        field(50002; "Cash Limit"; Decimal)
        {
        }
        field(50003; "Default Bank Account"; Code[10])
        {
            TableRelation = "Bank Account";
        }
        field(50004; "Default Cash Account"; Code[10])
        {
            TableRelation = "Bank Account";
        }
        field(50005; "Attachments Path"; Text[100])
        {
        }
        field(50006; "Current Budget"; Code[100])
        {
            TableRelation = "G/L Budget Name";
        }
        field(50007; "Commissioner Letters"; Text[150])
        {
        }
        field(50008; "DMS Imprest Claim Link"; Text[150])
        {
        }
        field(50009; "DMS PV Link"; Text[200])
        {
        }
        field(50010; "DMS Imprest Link"; Text[200])
        {
        }
        field(50011; "Remittance Sender Name"; Text[30])
        {
        }
        field(50012; "Remittance Sender Address"; Text[80])
        {
        }
        field(50013; "HR DMS LINK"; Text[200])
        {
        }
        field(50014; "Budget DMS Link"; Text[150])
        {
        }
        field(50015; "Levy Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50016; "Receipt No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50017; "Current Budget Start Date"; Date)
        {
        }
        field(50018; "Current Budget End Date"; Date)
        {
        }
        field(50019; "EFT File Path"; Code[30])
        {
        }
        field(50020; "Journal Numbers"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50021; "Jnl Notification Time Period"; Duration)
        {
        }
        field(50022; "Student Posting Group"; Code[20])
        {
            Caption = 'Student Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(50023; "Petty Cash No"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(50024; "Allow Budget Overrun"; Boolean)
        {
        }
        field(50025; "Cash Request  No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50026; "Surrender Template"; Code[20])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50027; "Surrender batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name"=FIELD("Surrender Template"));
        }
        field(50028;"Board PV Nos";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50029;"Exceed Budget";Boolean)
        {
        }
        field(50030;"Approve Journals";Boolean)
        {
        }
        field(50031;"Budget Approvals No.";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50032;"Budget Creation Nos";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50033;"Budget Alert Threshold 1(%)";Decimal)
        {
        }
        field(50034;"Budget Alert Threshold 2(%)";Decimal)
        {
        }
        field(50035;"Budget Idle Period(Months)";Integer)
        {
        }
        field(50036;"ERC Memo Nos";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50037;"Warm Clothing Span (Years)";DateFormula)
        {
        }
        field(50038;"Club Subscription AC";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50039;"Warm Clothing G/L Acc";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50040;"Memo- Salary Advance Nos";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50041;"Basic Pay A/C";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50042;"Finance Department";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('DEPARTMENT'));
        }
        field(50043;"Finance Email";Text[50])
        {
        }
        field(50044;"Club Membership 1-3";Decimal)
        {
        }
        field(50045;"Club Membership 4-5";Decimal)
        {
        }
        field(50046;"NHIF Deadline Day";Integer)
        {
        }
        field(50047;"NSSF Deadline Day";Integer)
        {
        }
        field(50048;"PAYE Deadline Day";Integer)
        {
        }
        field(50049;"Other Deductions Deadline";Integer)
        {
        }
        field(50050;"Commisioner Payments Month Day";Integer)
        {
            Description = '//Day of the Month When Commissioner Entries are created';
        }
        field(50051;"Commissioner Mandatory Fee";Decimal)
        {
            Description = '//Global Payroll Figure For Commissioners';
        }
        field(50052;"Commissioner Jnl Template";Code[50])
        {
            Description = '//Journal Template For Commissioners';
            TableRelation = "Gen. Journal Template";
        }
        field(50053;"Commissioner Jnl Batch";Code[50])
        {
            Description = '//Journal Batch For Commissioners';
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Commissioner Jnl Template"));
        }
        field(50054;"Seating Fee";Decimal)
        {
            Description = '//Amount Paid per Sitting By Commisioners';
        }
        field(50055;"Chair Honararia";Decimal)
        {
            Description = '//Amount Paid to Chair as Honararia';
        }
        field(50056;"Chair Airtime";Decimal)
        {
            Description = '//Amount Paid to Commissioner CjhairAirtime';
        }
        field(50057;"Commissioner Monthly Fee Acc";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50058;"Sitting Allowance Acc";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50059;"Chairman's Hononaria Acc";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50060;"PAYE%";Decimal)
        {
            Description = '//Default 30% -';
        }
        field(50061;"Telephone Allowance Acc";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50062;"File Storage";Text[100])
        {
        }
        field(50063;"HR Department";Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE ("Dimension Code"=CONST('DEPARTMENT'));
        }
        field(50064;"Trainings Account";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50065;"Comm No. Series";Code[20])
        {
            TableRelation = "No. Series".Code;
        }
        field(50066;"Leave Allowance Payment Day";Integer)
        {
            MaxValue = 31;
            MinValue = 1;
        }
        field(50067;"Receipts No";Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50068;"Normal Payments No";Code[10])
        {
            Caption = 'Receipts No';
            TableRelation = "No. Series";
        }
        field(50069;"Cheque Reject Period";DateFormula)
        {
        }
        field(50070;"Petty Cash Payments No";Code[20])
        {
            Caption = 'Receipts No';
            TableRelation = "No. Series";
        }
        field(50071;"Line No.";Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50072;ImprestProcess;Code[1])
        {
            TableRelation = "No. Series".Code;
        }
        field(50073;ImprestSurrender;Code[1])
        {
            TableRelation = "No. Series".Code;
        }
        field(50074;PCpayment;Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50075;ImprestRequisition;Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50076;"W/Hcertificate";Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50077;KCB1;Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50078;NewCustomerNumber;Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50079;Councils;Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50080;"Venue Details";Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50081;"Training & Education";Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50082;KCB2;Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50083;"Salary Advace";Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50085;"Investment DMS Link";Text[1])
        {
        }
        field(50086;"Journal Template Name";Code[1])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(50087;"Batch Name";Code[1])
        {
            TableRelation = "Gen. Journal Batch".Name;
        }
        field(50088;"LPO Link";Text[1])
        {
        }
        field(50089;"Requisition Link";Text[1])
        {
        }
        field(50090;"Budget Transfer No.";Code[1])
        {
            TableRelation = "No. Series";
        }
        field(50091;"Biometric Verification Link";Text[1])
        {
        }
        field(50092;"Professional Membership Code";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(50093;"DMS DB Link";Text[70])
        {
        }
        field(50094;"DBMS User ID";Text[70])
        {
        }
        field(50095;"DBMS Password";Text[50])
        {
        }
        field(50096;"Enforce Attachments";Boolean)
        {
        }
        field(50097;"Imprest DB Table";Text[40])
        {
        }
        field(50103;"Finance Budget Holder";Code[50])
        {
            TableRelation = "User Setup";
        }
        field(50104;"InterBank Transfer No.";Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(50105;"Withholding Tax %";Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }
}
