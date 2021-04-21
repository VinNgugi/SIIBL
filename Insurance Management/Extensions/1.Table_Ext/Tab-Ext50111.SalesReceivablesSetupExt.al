tableextension 50111 "Sales & Receivables SetupExt" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Imprest Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50001; "Claim Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50002; "Imprest Surrender Period"; Integer)
        {
        }
        field(50003; "User Support Inc Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50004; "Imprest Accounting Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50005; "Default Transaction Type"; Code[20])
        {
        }
        field(50006; "File Issue No"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50007; "Litigation source code"; Code[30])
        {
        }
        field(50008; "Requisition No"; Code[30])
        {
        }
        field(50009; "Trip Nos"; Code[20])
        {
        }
        field(50010; "Tyre Nos"; Code[20])
        {
        }
        field(50011; "Levy Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50012; "Batch Invoice Nos"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(50013; "AAR Email"; Text[100])
        {
        }
        field(50014; "LIFE Ind Product Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
    }
}
