report 51513008 UPR
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/UPR.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Insurance Trans Type", "Posting Date")
                                WHERE("Insurance Trans Type" = FILTER(Premium | "Reinsurance Premium" | Commission));
            RequestFilterFields = "Posting Date";
            column(DocNo; "G/L Entry"."Document No.")
            {
            }
            column(Date; "G/L Entry"."Posting Date")
            {
            }
            column(PolicyNo; "G/L Entry"."Policy Number")
            {
            }
            column(Desc; "G/L Entry".Description)
            {
            }
            column(UPR; UPRGrossPremium)
            {
            }
            column(UPRRatio; UnearnedPortion)
            {
            }
            column(Premium; "G/L Entry".Amount)
            {
            }
            column(Min_Date; MinDate)
            {
            }
            column(Max_Date; MaxDate)
            {
            }

            trigger OnAfterGetRecord();
            begin
                LineNo := LineNo + 10000;
                UnearnedPortion := 0;

                IF DrNote.GET("G/L Entry"."Document No.") THEN BEGIN

                    CoverStartDate := DrNote."Cover Start Date";
                    CoverEndDate := DrNote."Cover End Date";
                    DrNote.CALCFIELDS(DrNote.UPR, DrNote."UPR Reinsurance", DrNote.DAC);
                    PreviousUPR := DrNote.UPR;
                    PreviousUPRRe := DrNote."UPR Reinsurance";
                    PreviousDAC := DrNote.DAC;
                    GLMappings.RESET;
                    GLMappings.SETRANGE(GLMappings."Class Code", DrNote."Policy Type");
                    IF GLMappings.FINDFIRST THEN
                        ;
                END;
                IF CrNote.GET("G/L Entry"."Document No.") THEN BEGIN

                    CrNote.CALCFIELDS(CrNote.UPR, CrNote."UPR Reinsurance", CrNote.DAC);
                    PreviousUPR := CrNote.UPR;
                    PreviousUPRRe := CrNote."UPR Reinsurance";
                    PreviousDAC := CrNote.DAC;
                    GLMappings.RESET;
                    GLMappings.SETRANGE(GLMappings."Class Code", CrNote."Policy Type");

                    IF GLMappings.FINDFIRST THEN
                        ;
                    CoverStartDate := CrNote."Cover Start Date";
                    CoverEndDate := CrNote."Cover End Date";

                END;

                NofODays := (CoverEndDate - CoverStartDate) + 1;
                IF NofODays <> 0 THEN
                    UnearnedPortion := ((CoverEndDate - MaxDate) + 1) / NofODays;
                //IF CoverEndDate<>0D THEN
                //UnearnedPortion:=InsMgt.CalculateMidTermFactorMIC(CoverEndDate,MaxDate);
                IF "G/L Entry"."Insurance Trans Type" = "G/L Entry"."Insurance Trans Type"::Premium THEN
                    UPRGrossPremium := ROUND(UnearnedPortion * "G/L Entry".Amount) - PreviousUPR;

                IF "G/L Entry"."Insurance Trans Type" = "G/L Entry"."Insurance Trans Type"::"Reinsurance Premium" THEN
                    UPRReinsurancePremium := ROUND(UnearnedPortion * "G/L Entry".Amount) - PreviousUPRRe;

                IF "G/L Entry"."Insurance Trans Type" = "G/L Entry"."Insurance Trans Type"::Commission THEN BEGIN
                    IF "G/L Entry"."Bal. Account Type" <> "G/L Entry"."Bal. Account Type"::Customer THEN
                        CurrReport.SKIP;
                    DefferedAcqusitionCost := ROUND(UnearnedPortion * "G/L Entry".Amount) - PreviousDAC;
                END;


                IF UPRGrossPremium <> 0 THEN BEGIN
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := ISetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := 'UPR';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := MaxDate;
                    GenJnlLine."Document No." := "G/L Entry"."Document No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := GLMappings."Un-earned Premium";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 UPR POLICY No. %2', DrNote."Insured Name", DrNote."Policy No"), 1, 50);
                    GenJnlLine.Amount := -UPRGrossPremium;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Shortcut Dimension 1 Code" := "G/L Entry"."Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := "G/L Entry"."Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    GenJnlLine."Effective Start Date" := CoverStartDate;
                    GenJnlLine."Effective End Date" := CoverEndDate;

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::UPR;
                    GenJnlLine."Policy No" := DrNote."Policy No";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    //Tax
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;
                    LineNo := LineNo + 10000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := ISetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := 'UPR';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := MaxDate;
                    GenJnlLine."Document No." := "G/L Entry"."Document No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := GLMappings."Un-earned Premium Reserve";
                    GenJnlLine.VALIDATE(GenJnlLine."Account No.");
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 UPR POLICY No. %2', DrNote."Insured Name", DrNote."Policy No"), 1, 50);
                    GenJnlLine.Amount := UPRGrossPremium;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Shortcut Dimension 1 Code" := "G/L Entry"."Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := "G/L Entry"."Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    GenJnlLine."Effective Start Date" := CoverStartDate;
                    GenJnlLine."Effective End Date" := CoverEndDate;

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::UPR;
                    GenJnlLine."Policy No" := DrNote."Policy No";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    //Tax
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";

                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;



                END;

                IF UPRReinsurancePremium <> 0 THEN BEGIN
                    LineNo := LineNo + 10000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := ISetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := 'UPR';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := MaxDate;
                    GenJnlLine."Document No." := "G/L Entry"."Document No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := GLMappings."Reinsurer Share of Reserves-A";
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 UPR-RE POLICY No. %2', DrNote."Insured Name", DrNote."Policy No"), 1, 50);
                    GenJnlLine.Amount := -UPRReinsurancePremium;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Shortcut Dimension 1 Code" := "G/L Entry"."Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := "G/L Entry"."Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    GenJnlLine."Effective Start Date" := CoverStartDate;
                    GenJnlLine."Effective End Date" := CoverEndDate;

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Re-UPR";
                    GenJnlLine."Policy No" := DrNote."Policy No";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    //Tax
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;
                    LineNo := LineNo + 10000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := ISetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := 'UPR';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := MaxDate;
                    GenJnlLine."Document No." := "G/L Entry"."Document No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := GLMappings."Reinsurer Share of Reserves-L";
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 UPR RE-POLICY No. %2', DrNote."Insured Name", DrNote."Policy No"), 1, 50);
                    GenJnlLine.Amount := UPRReinsurancePremium;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Shortcut Dimension 1 Code" := "G/L Entry"."Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := "G/L Entry"."Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    GenJnlLine."Effective Start Date" := CoverStartDate;
                    GenJnlLine."Effective End Date" := CoverEndDate;

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::"Re-UPR";
                    GenJnlLine."Policy No" := DrNote."Policy No";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    //Tax
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;



                END;

                IF DefferedAcqusitionCost <> 0 THEN BEGIN
                    LineNo := LineNo + 10000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := ISetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := 'UPR';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := MaxDate;
                    GenJnlLine."Document No." := "G/L Entry"."Document No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := GLMappings."Un-earned Commission Allowable";
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 DAC POLICY No. %2', DrNote."Insured Name", DrNote."Policy No"), 1, 50);
                    GenJnlLine.Amount := -DefferedAcqusitionCost;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Shortcut Dimension 1 Code" := "G/L Entry"."Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := "G/L Entry"."Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    GenJnlLine."Effective Start Date" := CoverStartDate;
                    GenJnlLine."Effective End Date" := CoverEndDate;

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::DAC;
                    GenJnlLine."Policy No" := DrNote."Policy No";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    //Tax
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;
                    LineNo := LineNo + 10000;
                    GenJnlLine.INIT;
                    GenJnlLine."Journal Template Name" := ISetup."Insurance Template";
                    GenJnlLine."Journal Batch Name" := 'UPR';
                    GenJnlLine."Line No." := LineNo;
                    GenJnlLine."Posting Date" := MaxDate;
                    GenJnlLine."Document No." := "G/L Entry"."Document No.";
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Account No." := GLMappings."Un-earned Commission Allow. BS";
                    //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                    GenJnlLine.Description := COPYSTR(STRSUBSTNO('%1 DAC-POLICY No. %2', DrNote."Insured Name", DrNote."Policy No"), 1, 50);
                    GenJnlLine.Amount := DefferedAcqusitionCost;
                    GenJnlLine.VALIDATE(GenJnlLine.Amount);
                    GenJnlLine."Shortcut Dimension 1 Code" := "G/L Entry"."Global Dimension 1 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                    GenJnlLine."Shortcut Dimension 2 Code" := "G/L Entry"."Global Dimension 2 Code";
                    GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                    GenJnlLine."Effective Start Date" := CoverStartDate;
                    GenJnlLine."Effective End Date" := CoverEndDate;

                    GenJnlLine."Insurance Trans Type" := GenJnlLine."Insurance Trans Type"::DAC;
                    GenJnlLine."Policy No" := DrNote."Policy No";
                    IF GenJnlLine.Amount <> 0 THEN
                        GenJnlLine.INSERT;
                    //Tax
                    DimensionSetEntryRec.RESET;
                    DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID", "G/L Entry"."Dimension Set ID");
                    IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                            DimensionSetEntryRecCopy.INIT;
                            DimensionSetEntryRecCopy."Dimension Set ID" := GenJnlLine."Dimension Set ID";
                            DimensionSetEntryRecCopy."Dimension Code" := DimensionSetEntryRec."Dimension Code";
                            DimensionSetEntryRecCopy."Dimension Value Code" := DimensionSetEntryRec."Dimension Value Code";
                            DimensionSetEntryRecCopy."Dimension Name" := DimensionSetEntryRec."Dimension Name";
                            DimensionSetEntryRecCopy."Dimension Value ID" := DimensionSetEntryRec."Dimension Value ID";
                            DimensionSetEntryRecCopy."Dimension Value Name" := DimensionSetEntryRec."Dimension Value Name";
                            IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID", DimensionSetEntryRecCopy."Dimension Code") THEN
                                DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin

        MinDate := "G/L Entry".GETRANGEMIN("G/L Entry"."Posting Date");
        MaxDate := "G/L Entry".GETRANGEMAX("G/L Entry"."Posting Date");
        ISetup.GET;
    end;

    var
        MinDate: Date;
        MaxDate: Date;
        CoverStartDate: Date;
        CoverEndDate: Date;
        InsMgt: Codeunit "Insurance management";
        DrNote: Record "Insure Debit Note";
        CrNote: Record "Insure Credit Note";
        UnearnedPortion: Decimal;
        UPRGrossPremium: Decimal;
        UPRReinsurancePremium: Decimal;
        GLMappings: Record "Insurance Accounting Mappings";
        GenJnlLine: Record "Gen. Journal Line";
        ISetup: Record "Insurance setup";
        DimensionSetEntryRec: Record "Dimension Set Entry";
        DimensionSetEntryRecCopy: Record "Dimension Set Entry";
        LineNo: Integer;
        NofODays: Integer;
        DefferedAcqusitionCost: Decimal;
        PreviousUPR: Decimal;
        PreviousUPRRe: Decimal;
        PreviousDAC: Decimal;
}

