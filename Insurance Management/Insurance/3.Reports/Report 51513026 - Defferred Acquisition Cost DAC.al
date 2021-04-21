report 51513026 "Defferred Acquisition Cost DAC"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Defferred Acquisition Cost DAC.rdl';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            DataItemTableView = SORTING("Insurance Trans Type", "Posting Date")
                                WHERE("Insurance Trans Type" = FILTER(Commission),
                                      "Bal. Account Type" = CONST(Customer));
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
            column(Dac_amt; DACAmt)
            {
            }
            column(UPRRatio; UnearnedPortion)
            {
            }
            column(Commission; "G/L Entry".Amount)
            {
            }
            column(Min_Date; MinDate)
            {
            }
            column(Max_Date; MaxDate)
            {
            }
            column(Class; ClassName)
            {
            }
            column(Effective_Date; CoverStartDate)
            {
            }
            column(Expiry_Date; CoverEndDate)
            {
            }
            column(Reins_premium; ReinsurancePremium)
            {
            }
            column(Insured; NameofInsured)
            {
            }
            column(Branch; Branch)
            {
            }
            column(Business_Type; DrNote."Action Type")
            {
            }
            column(Noofdays; NofODays)
            {
            }
            column(Total_DAC; TotalDac)
            {
            }
            column(Total_Comm; TotalCommission)
            {
            }
            column(Premium; PremiumAmt)
            {
            }

            trigger OnAfterGetRecord();
            begin
                LineNo := LineNo + 10000;
                UnearnedPortion := 0;
                DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.", 1);
                DimVal.SETRANGE(DimVal.Code, "G/L Entry"."Global Dimension 1 Code");
                IF DimVal.FINDFIRST THEN
                    Branch := DimVal.Name;

                IF DrNote.GET("G/L Entry"."Document No.") THEN BEGIN
                    DrNote.CALCFIELDS(DrNote."Total Premium Amount");
                    PremiumAmt := DrNote."Total Premium Amount";

                    IF PolicyType.GET(DrNote."Policy Type") THEN BEGIN
                        DimVal.RESET;
                        DimVal.SETRANGE(DimVal."Global Dimension No.", 3);
                        DimVal.SETRANGE(DimVal.Code, PolicyType.Class);
                        IF DimVal.FINDFIRST THEN
                            ClassName := DimVal.Name;

                    END;
                    NameofInsured := DrNote."Insured Name";
                    CoverStartDate := DrNote."Cover Start Date";
                    CoverEndDate := DrNote."Cover End Date";
                    GLMappings.RESET;
                    GLMappings.SETRANGE(GLMappings."Class Code", DrNote."Policy Type");
                    IF GLMappings.FINDFIRST THEN
                        ;
                END;
                IF CrNote.GET("G/L Entry"."Document No.") THEN BEGIN
                    CrNote.CALCFIELDS(CrNote."Total Premium Amount");
                    PremiumAmt := CrNote."Total Premium Amount";
                    GLMappings.RESET;
                    GLMappings.SETRANGE(GLMappings."Class Code", CrNote."Policy Type");
                    IF GLMappings.FINDFIRST THEN
                        ;
                    CoverStartDate := CrNote."Cover Start Date";
                    CoverEndDate := CrNote."Cover End Date";
                    NameofInsured := CrNote."Insured Name";
                END;

                NofODays := (CoverEndDate - CoverStartDate) + 1;
                IF NofODays <> 0 THEN
                    UnearnedPortion := ((CoverEndDate - MaxDate) + 1) / NofODays;
                //IF CoverEndDate<>0D THEN
                // UnearnedPortion:=InsMgt.CalculateMidTermFactorMIC(CoverEndDate,MaxDate);
                IF "G/L Entry"."Insurance Trans Type" = "G/L Entry"."Insurance Trans Type"::Premium THEN
                    UPRGrossPremium := ROUND(UnearnedPortion * "G/L Entry".Amount);

                IF "G/L Entry"."Insurance Trans Type" = "G/L Entry"."Insurance Trans Type"::"Reinsurance Premium" THEN
                    UPRReinsurancePremium := ROUND(UnearnedPortion * "G/L Entry".Amount);

                IF "G/L Entry"."Insurance Trans Type" = "G/L Entry"."Insurance Trans Type"::Commission THEN BEGIN
                    IF "G/L Entry"."Bal. Account Type" <> "G/L Entry"."Bal. Account Type"::Customer THEN
                        CurrReport.SKIP;
                    DACAmt := ROUND(UnearnedPortion * "G/L Entry".Amount);
                END;

                TotalCommission := TotalCommission + DACAmt;
                TotalDac := TotalDac + DACAmt;

                /*IF UPRGrossPremium<>0 THEN
                  BEGIN
                      GenJnlLine.INIT;
                      GenJnlLine."Journal Template Name":=ISetup."Insurance Template";
                      GenJnlLine."Journal Batch Name":='UPR';
                      GenJnlLine."Line No.":=LineNo;
                      GenJnlLine."Posting Date":="G/L Entry"."Posting Date";
                      GenJnlLine."Document No.":="G/L Entry"."Document No.";
                      GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                      GenJnlLine."Account No.":=GLMappings."Un-earned Premium";
                      //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                      GenJnlLine.Description:=COPYSTR(STRSUBSTNO('%1 UPR POLICY No. %2',DrNote."Insured Name",DrNote."Policy No"),1,50);
                      GenJnlLine.Amount:=-UPRGrossPremium;
                      GenJnlLine.VALIDATE(GenJnlLine.Amount);
                      GenJnlLine."Shortcut Dimension 1 Code":="G/L Entry"."Global Dimension 1 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                      GenJnlLine."Shortcut Dimension 2 Code":="G/L Entry"."Global Dimension 2 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                      GenJnlLine."Effective Start Date":=CoverStartDate;
                      GenJnlLine."Effective End Date":=CoverEndDate;

                      GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                      GenJnlLine."Policy No":=DrNote."Policy No";
                      IF GenJnlLine.Amount<>0 THEN
                      GenJnlLine.INSERT;
                      //Tax
                      DimensionSetEntryRec.RESET;
                      DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID","G/L Entry"."Dimension Set ID");
                      IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                          DimensionSetEntryRecCopy.INIT;
                          DimensionSetEntryRecCopy."Dimension Set ID":=GenJnlLine."Dimension Set ID";
                          DimensionSetEntryRecCopy."Dimension Code":=DimensionSetEntryRec."Dimension Code";
                          DimensionSetEntryRecCopy."Dimension Value Code":=DimensionSetEntryRec."Dimension Value Code";
                          DimensionSetEntryRecCopy."Dimension Name":=DimensionSetEntryRec."Dimension Name";
                          DimensionSetEntryRecCopy."Dimension Value ID":=DimensionSetEntryRec."Dimension Value ID";
                          DimensionSetEntryRecCopy."Dimension Value Name":=DimensionSetEntryRec."Dimension Value Name";
                          IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID",DimensionSetEntryRecCopy."Dimension Code") THEN
                          DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT=0;
                      LineNo:=LineNo+10000;
                      GenJnlLine.INIT;
                      GenJnlLine."Journal Template Name":=ISetup."Insurance Template";
                      GenJnlLine."Journal Batch Name":='UPR';
                      GenJnlLine."Line No.":=LineNo;
                      GenJnlLine."Posting Date":="G/L Entry"."Posting Date";
                      GenJnlLine."Document No.":="G/L Entry"."Document No.";
                      GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                      GenJnlLine."Account No.":=GLMappings."Un-earned Premium Reserve";
                      //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                      GenJnlLine.Description:=COPYSTR(STRSUBSTNO('%1 UPR POLICY No. %2',DrNote."Insured Name",DrNote."Policy No"),1,50);
                      GenJnlLine.Amount:=UPRGrossPremium;
                      GenJnlLine.VALIDATE(GenJnlLine.Amount);
                       GenJnlLine."Shortcut Dimension 1 Code":="G/L Entry"."Global Dimension 1 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                      GenJnlLine."Shortcut Dimension 2 Code":="G/L Entry"."Global Dimension 2 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                      GenJnlLine."Effective Start Date":=CoverStartDate;
                      GenJnlLine."Effective End Date":=CoverEndDate;

                      GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                      GenJnlLine."Policy No":=DrNote."Policy No";
                      IF GenJnlLine.Amount<>0 THEN
                      GenJnlLine.INSERT;
                      //Tax
                      DimensionSetEntryRec.RESET;
                      DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID","G/L Entry"."Dimension Set ID");
                      IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                          DimensionSetEntryRecCopy.INIT;
                          DimensionSetEntryRecCopy."Dimension Set ID":=GenJnlLine."Dimension Set ID";
                          DimensionSetEntryRecCopy."Dimension Code":=DimensionSetEntryRec."Dimension Code";
                          DimensionSetEntryRecCopy."Dimension Value Code":=DimensionSetEntryRec."Dimension Value Code";
                          DimensionSetEntryRecCopy."Dimension Name":=DimensionSetEntryRec."Dimension Name";
                          DimensionSetEntryRecCopy."Dimension Value ID":=DimensionSetEntryRec."Dimension Value ID";
                          DimensionSetEntryRecCopy."Dimension Value Name":=DimensionSetEntryRec."Dimension Value Name";
                          IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID",DimensionSetEntryRecCopy."Dimension Code") THEN
                          DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT=0;



                 END;

                IF UPRReinsurancePremium<>0 THEN
                  BEGIN
                    LineNo:=LineNo+10000;
                      GenJnlLine.INIT;
                      GenJnlLine."Journal Template Name":=ISetup."Insurance Template";
                      GenJnlLine."Journal Batch Name":='UPR';
                      GenJnlLine."Line No.":=LineNo;
                      GenJnlLine."Posting Date":="G/L Entry"."Posting Date";
                      GenJnlLine."Document No.":="G/L Entry"."Document No.";
                      GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                      GenJnlLine."Account No.":=GLMappings."Reinsurer Share of Reserves-A";
                      //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                      GenJnlLine.Description:=COPYSTR(STRSUBSTNO('%1 UPR-RE POLICY No. %2',DrNote."Insured Name",DrNote."Policy No"),1,50);
                      GenJnlLine.Amount:=-UPRReinsurancePremium;
                      GenJnlLine.VALIDATE(GenJnlLine.Amount);
                      GenJnlLine."Shortcut Dimension 1 Code":="G/L Entry"."Global Dimension 1 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                      GenJnlLine."Shortcut Dimension 2 Code":="G/L Entry"."Global Dimension 2 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                      GenJnlLine."Effective Start Date":=CoverStartDate;
                      GenJnlLine."Effective End Date":=CoverEndDate;

                      GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                      GenJnlLine."Policy No":=DrNote."Policy No";
                      IF GenJnlLine.Amount<>0 THEN
                      GenJnlLine.INSERT;
                      //Tax
                      DimensionSetEntryRec.RESET;
                      DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID","G/L Entry"."Dimension Set ID");
                      IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                          DimensionSetEntryRecCopy.INIT;
                          DimensionSetEntryRecCopy."Dimension Set ID":=GenJnlLine."Dimension Set ID";
                          DimensionSetEntryRecCopy."Dimension Code":=DimensionSetEntryRec."Dimension Code";
                          DimensionSetEntryRecCopy."Dimension Value Code":=DimensionSetEntryRec."Dimension Value Code";
                          DimensionSetEntryRecCopy."Dimension Name":=DimensionSetEntryRec."Dimension Name";
                          DimensionSetEntryRecCopy."Dimension Value ID":=DimensionSetEntryRec."Dimension Value ID";
                          DimensionSetEntryRecCopy."Dimension Value Name":=DimensionSetEntryRec."Dimension Value Name";
                          IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID",DimensionSetEntryRecCopy."Dimension Code") THEN
                          DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT=0;
                     LineNo:=LineNo+10000;
                      GenJnlLine.INIT;
                      GenJnlLine."Journal Template Name":=ISetup."Insurance Template";
                      GenJnlLine."Journal Batch Name":='UPR';
                      GenJnlLine."Line No.":=LineNo;
                      GenJnlLine."Posting Date":="G/L Entry"."Posting Date";
                      GenJnlLine."Document No.":="G/L Entry"."Document No.";
                      GenJnlLine."Account Type":=GenJnlLine."Account Type"::"G/L Account";
                      GenJnlLine."Account No.":=GLMappings."Reinsurer Share of Reserves-L";
                      //GenJnlLine."Document Type":=GenJnlLine."Document Type"::Invoice;
                      GenJnlLine.Description:=COPYSTR(STRSUBSTNO('%1 UPR RE-POLICY No. %2',DrNote."Insured Name",DrNote."Policy No"),1,50);
                      GenJnlLine.Amount:=UPRReinsurancePremium;
                      GenJnlLine.VALIDATE(GenJnlLine.Amount);
                      GenJnlLine."Shortcut Dimension 1 Code":="G/L Entry"."Global Dimension 1 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 1 Code");
                      GenJnlLine."Shortcut Dimension 2 Code":="G/L Entry"."Global Dimension 2 Code";
                      GenJnlLine.VALIDATE(GenJnlLine."Shortcut Dimension 2 Code");

                      GenJnlLine."Effective Start Date":=CoverStartDate;
                      GenJnlLine."Effective End Date":=CoverEndDate;

                      GenJnlLine."Insurance Trans Type":=GenJnlLine."Insurance Trans Type"::Premium;
                      GenJnlLine."Policy No":=DrNote."Policy No";
                      IF GenJnlLine.Amount<>0 THEN
                      GenJnlLine.INSERT;
                      //Tax
                      DimensionSetEntryRec.RESET;
                      DimensionSetEntryRec.SETRANGE(DimensionSetEntryRec."Dimension Set ID","G/L Entry"."Dimension Set ID");
                      IF DimensionSetEntryRec.FINDFIRST THEN
                        REPEAT

                          DimensionSetEntryRecCopy.INIT;
                          DimensionSetEntryRecCopy."Dimension Set ID":=GenJnlLine."Dimension Set ID";
                          DimensionSetEntryRecCopy."Dimension Code":=DimensionSetEntryRec."Dimension Code";
                          DimensionSetEntryRecCopy."Dimension Value Code":=DimensionSetEntryRec."Dimension Value Code";
                          DimensionSetEntryRecCopy."Dimension Name":=DimensionSetEntryRec."Dimension Name";
                          DimensionSetEntryRecCopy."Dimension Value ID":=DimensionSetEntryRec."Dimension Value ID";
                          DimensionSetEntryRecCopy."Dimension Value Name":=DimensionSetEntryRec."Dimension Value Name";
                          IF NOT DimensionSetEntryRecCopy.GET(DimensionSetEntryRecCopy."Dimension Set ID",DimensionSetEntryRecCopy."Dimension Code") THEN
                          DimensionSetEntryRecCopy.INSERT;
                        UNTIL DimensionSetEntryRec.NEXT=0;



                 END;*/

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
        ClassName: Text;
        EffectiveDate: Date;
        ExpiryDate: Date;
        ReinsurancePremium: Decimal;
        BusinessType: Text;
        NameofInsured: Text;
        Branch: Text;
        DimVal: Record "Dimension Value";
        PolicyType: Record "Policy Type";
        NofODays: Integer;
        TotalUPR: Decimal;
        TotalPremium: Decimal;
        DACAmt: Decimal;
        TotalCommission: Decimal;
        TotalDac: Decimal;
        PremiumAmt: Decimal;
}

