tableextension 50110 "Bank Account Stmt LineExt" extends "Bank Account Statement Line"
{
    fields
    {
        field(50000; Reconciled; Boolean)
        {
        }
        field(50001; "Cheque Number"; Code[20])
        {
        }
    }
}
