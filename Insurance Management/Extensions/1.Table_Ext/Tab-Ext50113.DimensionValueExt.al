tableextension 50113 "Dimension ValueExt" extends "Dimension Value"
{
    fields
    {
        field(50000; "Last Policy No."; Code[20])
        {
        }
        field(50001; "Last Endorsement No."; Code[20])
        {
        }
        field(50002; "No. of Debit Notes"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = Count("Insure Debit Note" WHERE("Document Date" = FIELD("Date Filter"),
                                                           "Shortcut Dimension 3 Code" = FIELD(Code)));

        }
        field(50003; "No. of Credit Notes"; Integer)
        {
            CalcFormula = Count("Insure Credit Note" WHERE("Document Date" = FIELD("Date Filter"),
                                                            "Shortcut Dimension 3 Code" = FIELD(Code)));
            FieldClass = FlowField;
        }
        field(50004; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(50005; "Gross Premium"; Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Insurance Trans Type"=CONST(Premium)));
            FieldClass = FlowField; */
        }
        field(50006; "Stamp Duty"; Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Insurance Trans Type"=CONST(Tax)));
            FieldClass = FlowField; */
        }
        field(50007; "Commission Amount"; Decimal)
        {
            /*  CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                         "Posting Date"=FIELD("Date Filter"),
                                                         "Insurance Trans Type"=CONST(Commission)));
             FieldClass = FlowField; */
        }
        field(50008; "Withholding Tax"; Decimal)
        {
            /*  CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                         "Posting Date"=FIELD("Date Filter"),
                                                         "Insurance Trans Type"=CONST(Wht)));
             FieldClass = FlowField; */
        }
        field(50009; "Training Levy"; Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Insurance Trans Type"=CONST(Tax)));
            FieldClass = FlowField; */
        }
        field(50010; PCHF; Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Insurance Trans Type"=CONST(Tax)));
            FieldClass = FlowField; */
        }
        field(50011; "Net Premium"; Decimal)
        {
            /*  CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                         "Posting Date"=FIELD("Date Filter"),
                                                         "Insurance Trans Type"=CONST("Net Premium")));
             FieldClass = FlowField; */
        }
        field(50012; "New Business"; Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Insurance Trans Type"=CONST(Premium)));
            FieldClass = FlowField; */
        }
        field(50013; "Renewal Business"; Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Insurance Trans Type"=CONST(Premium)));
            FieldClass = FlowField; */
        }
        field(50014; "Refund Premium"; Decimal)
        {
            /*  CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                         "Posting Date"=FIELD("Date Filter"),
                                                         "Insurance Trans Type"=CONST(Premium)));
             FieldClass = FlowField; */
        }
        field(50015; "Extra Premium"; Decimal)
        {
        }
        field(50016; "Misc. Debits/Credits"; Decimal)
        {
        }
        field(50017; "Additional Certificates/Yellow"; Decimal)
        {
        }
        field(50018; "Total Premium"; Decimal)
        {
            /* CalcFormula = Sum("G/L Entry".Amount WHERE ("Global Dimension 3 Code"=FIELD(Code),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Insurance Trans Type"=CONST(Premium)));
            FieldClass = FlowField; */
        }
        field(50019; "Posted Receipt Nos"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(50020; "Region Code"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
    }
}
