tableextension 50104 VendorExt extends Vendor
{
    fields
    {

        field(50100; Type; Option)
        {
            OptionCaption = ',Reinsurer';
            OptionMembers = ,Reinsurer;
        }
        field(50101; "Vendor Type"; Option)
        {
            OptionCaption = '" ,Claimant,Law firms,Assessor,Garage,Law courts,Agent,Medical Practitioner,Investigator,Insurer,Re-Insurer"';
            OptionMembers = " ",Claimant,"Law firms",Assessor,Garage,"Law courts",Agent,"Medical Practitioner",Investigator,Insurer,"Re-Insurer";
        }
        field(50102; "Vendor Type1"; Option)
        {
            OptionCaption = '" ,Normal,Member,Pensioner,Medical,Law,Professional Bodies,Broker"';
            OptionMembers = " ",Normal,Member,Pensioner,Medical,Law,"Professional Bodies",Broker;
        }
        field(55008; "GL Code"; Code[10])
        {
        }
        field(55012; "Gross Premium"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                 "Posting Date" = field("Date Filter"),
                                                                                 "Insurance Trans Type" = CONST("Net Premium")));

        }
        field(55013; Receipts; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                 "Posting Date" = field("Date Filter")));

        }
        field(55014; Commission; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                 "Posting Date" = field("Date Filter"),
                                                                                 "Insurance Trans Type" = CONST(Commission)));

        }
        field(55015; Wht; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                 "Posting Date" = FIELD("Date Filter"),
                                                                                 "Insurance Trans Type" = CONST(Wht)));

        }
        field(55016; "Net Commission"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                                 "Posting Date" = field("Date Filter"),
                                                                                 "Insurance Trans Type" = FILTER(Commission | Wht)));

        }
        field(55017; "Certificate of Registration"; Code[20])
        {
        }
        field(55018; "Commission Paid"; Decimal)
        {
            CalcFormula = Sum("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("No."),
                                                                         "Posting Date" = FIELD("Date Filter"),
                                                                         "Insurance Trans Type" = CONST(Commission)));
            FieldClass = FlowField;
        }
        field(55100; Premium; Decimal)
        {
        }
        field(55101; "Statutory Share Percentage"; Decimal)
        {
        }
        field(55102; "Statutory Share Brokerage %"; Decimal)
        {
        }
        field(55103; "Commission %"; Decimal)
        {
        }
        field(55104; PIN; Code[20])
        {
        }
        field(68000; "Test Code"; Code[20])
        {
        }

    }
    trigger OnBeforeInsert()
    var
        myInt: Integer;
    begin
        if "No." = '' then begin
            case "Vendor Type" of
                "Vendor Type"::Agent:
                    begin
                        InsSetup.Get();
                        InsSetup.TestField("Agent Nos");
                        NoSeriesMgmt.InitSeries(InsSetup."Agent Nos", xRec."No. Series", 0D, "No.", "No. Series");
                    end;
                    "Vendor Type"::Insurer:
                    begin
                        InsSetup.Get();
                        InsSetup.TestField("Underwriters Nos");
                        NoSeriesMgmt.InitSeries(InsSetup."Underwriters Nos", xRec."No. Series", 0D, "No.", "No. Series");
                    end;

                    
            end;
        end;
    end;

    var
        NoSeriesMgmt: Codeunit NoSeriesManagement;
        InsSetup: Record "Insurance setup";
}
