report 51513025 "Generate Adjustment Premium"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Generate Adjustment Premium.rdl';

    dataset
    {
        dataitem("XOL Layers"; "XOL Layers")
        {
            RequestFilterFields = "Treaty Code", "Addendum Code", Layer, "Period Filter";
            column(CedingCompany; CompanyRec.Name)
            {
            }
            column(TreatyBroker; Treaty."Broker Name")
            {
            }
            column(TreatyDescription; Treaty."Treaty description")
            {
            }
            column(MDP; "XOL Layers"."Minimum Deposit Premium")
            {
            }
            column(DepositPremiumPaid; "XOL Layers"."Deposit Premium Paid")
            {
            }
            column(PortionofPremiumPaid; PortionOfPremium)
            {
            }
            column(TotalGPI; "XOL Layers"."Total Gross Premium Income")
            {
            }
            column(CededPremium; "XOL Layers"."Ceded Premium")
            {
            }
            column(GNPI; "XOL Layers".GNPI)
            {
            }
            column(PremiumCalcMethod; "XOL Layers"."Premium Calculation Method")
            {
            }
            column(AdjustmentRate; "XOL Layers"."Applied Adjustment Rate")
            {
            }
            column(ActualPeriodPremium; ActualPeriodlPremium)
            {
            }
            column(AdjustmentPremium; AdjustmentPremium)
            {
            }
            column(StartDate; BeginDate)
            {
            }
            column(EndDate; Enddate)
            {
            }

            trigger OnAfterGetRecord();
            begin

                Treaty.GET("XOL Layers"."Treaty Code", "XOL Layers"."Addendum Code");

                "XOL Layers".SETRANGE("XOL Layers"."Date Filter", BeginDate, Enddate);
                "XOL Layers".CALCFIELDS("XOL Layers".GNPI, "XOL Layers"."Deposit Premium Paid", "XOL Layers"."Total Gross Premium Income", "XOL Layers"."Ceded Premium",
                "XOL Layers"."XL Paid Losses", "XOL Layers"."XL Outstanding Claims");

                IF "XOL Layers"."Applied Adjustment Method" = "XOL Layers"."Applied Adjustment Method"::"Burning Cost" THEN BEGIN

                    BurningCost := (("XOL Layers"."XL Paid Losses" + "XOL Layers"."XL Outstanding Claims") / "XOL Layers".GNPI) * (100 / 1);
                    PremiumRate := BurningCost * "XOL Layers"."Burning Cost Loading";

                    IF PremiumRate > "XOL Layers"."Max. Rate" THEN
                        PremiumRate := "XOL Layers"."Max. Rate";
                END;

                IF "XOL Layers"."Applied Adjustment Method" = "XOL Layers"."Applied Adjustment Method"::"Fixed Rate" THEN
                    PremiumRate := "XOL Layers"."Applied Adjustment Rate";

                PortionOfPremium := "XOL Layers"."Minimum Deposit Premium" / 12;
                ActualPeriodlPremium := (PremiumRate / 100) * "XOL Layers".GNPI;
                AdjustmentPremium := ActualPeriodlPremium - PortionOfPremium;
                PolicytypeRec.RESET;
                PolicytypeRec.SETRANGE(PolicytypeRec."Date Filter", BeginDate, Enddate);
                IF PolicytypeRec.FINDFIRST THEN BEGIN
                    REPEAT
                        PolicytypeRec.SETRANGE(PolicytypeRec."Date Filter", BeginDate, Enddate);
                        PolicytypeRec.CALCFIELDS(PolicytypeRec."Gross Premium");

                        TotalGrossPremium := TotalGrossPremium + PolicytypeRec."Gross Premium";

                    UNTIL PolicytypeRec.NEXT = 0;
                END;

                PolicytypeRec.RESET;
                PolicytypeRec.SETRANGE(PolicytypeRec."Date Filter", BeginDate, Enddate);
                IF PolicytypeRec.FINDFIRST THEN BEGIN
                    REPEAT
                        DimVal.RESET;
                        DimVal.SETRANGE(DimVal."Global Dimension No.", 1);
                        IF DimVal.FINDFIRST THEN
                            REPEAT
                                PolicytypeRec.SETRANGE(PolicytypeRec."Global Dimension 1 Filter", DimVal.Code);
                                PolicytypeRec.CALCFIELDS(PolicytypeRec."Gross Premium");

                                IF TotalGrossPremium <> 0 THEN
                                    PremiumPerProduct := (PolicytypeRec."Gross Premium" / TotalGrossPremium) * AdjustmentPremium;

                                //MESSAGE('Total Premium=%1 and Adjustment Premium=%2',TotalGrossPremium,AdjustmentPremium);

                                InSetup.GET;
                                GenJnline.INIT;
                                GenJnline."Journal Template Name" := InSetup."Insurance Template";
                                GenJnline."Journal Batch Name" := 'Prem-Adj';
                                GenJnline."Line No." := GenJnline."Line No." + 10000;
                                GenJnline."Document No." := 'PremAdj' + FORMAT(DATE2DMY(Enddate, 2)) + FORMAT(DATE2DMY(Enddate, 3));
                                GenJnline."Posting Date" := Enddate;
                                GenJnline."Account Type" := GenJnline."Account Type"::"G/L Account";
                                InsMapping.RESET;
                                InsMapping.SETRANGE(InsMapping."Class Code", PolicytypeRec.Code);
                                IF InsMapping.FINDFIRST THEN
                                    GenJnline."Account No." := InsMapping."XOL Premium Account";
                                GenJnline.VALIDATE(GenJnline."Account No.");
                                GenJnline.Description := STRSUBSTNO('Premium Adjustment as at %1', Enddate);
                                GenJnline.Amount := PremiumPerProduct;
                                GenJnline.VALIDATE(GenJnline.Amount);
                                GenJnline."Shortcut Dimension 1 Code" := DimVal.Code;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                                //GenJnLine."Shortcut Dimension 2 Code":=PV."Global Dimension 2 Code";
                                // GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                                GenJnline."Shortcut Dimension 3 Code" := PolicytypeRec.Class;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 3 Code");
                                //GenJnline."Shortcut Dimension 4 Code":=DimVal."Region Code";
                                // GenJnline.VALIDATE(GenJnline."Shortcut Dimension 4 Code");
                                GenJnline."Insurance Trans Type" := GenJnline."Insurance Trans Type"::"XOL Adjustment Premium";
                                IF GenJnline.Amount <> 0 THEN
                                    GenJnline.INSERT;

                                GenJnline.INIT;
                                GenJnline."Journal Template Name" := InSetup."Insurance Template";
                                GenJnline."Journal Batch Name" := 'Prem-Adj';
                                GenJnline."Line No." := GenJnline."Line No." + 10000;
                                GenJnline."Document No." := 'PremAdj' + FORMAT(DATE2DMY(Enddate, 2)) + FORMAT(DATE2DMY(Enddate, 3));
                                GenJnline."Posting Date" := Enddate;
                                GenJnline."Account Type" := GenJnline."Account Type"::Customer;
                                GenJnline."Account No." := Treaty.Broker;
                                GenJnline.VALIDATE(GenJnline."Account No.");
                                GenJnline.Description := STRSUBSTNO('Premium Adjustment as at %1', Enddate);
                                GenJnline.Amount := PremiumPerProduct;
                                GenJnline.VALIDATE(GenJnline.Amount);
                                GenJnline."Shortcut Dimension 1 Code" := DimVal.Code;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 1 Code");
                                //GenJnLine."Shortcut Dimension 2 Code":=PV."Global Dimension 2 Code";
                                // GenJnLine.VALIDATE(GenJnLine."Shortcut Dimension 2 Code");
                                GenJnline."Shortcut Dimension 3 Code" := PolicytypeRec.Class;
                                GenJnline.VALIDATE(GenJnline."Shortcut Dimension 3 Code");
                                //GenJnline."Shortcut Dimension 4 Code":=DimVal."Region Code";
                                // GenJnline.VALIDATE(GenJnline."Shortcut Dimension 4 Code");
                                GenJnline."Insurance Trans Type" := GenJnline."Insurance Trans Type"::"XOL Adjustment Premium";
                                IF GenJnline.Amount <> 0 THEN
                                    GenJnline.INSERT;


                            UNTIL DimVal.NEXT = 0;
                    UNTIL PolicytypeRec.NEXT = 0;
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
        BeginDate := "XOL Layers".GETRANGEMIN("XOL Layers"."Period Filter");
        Enddate := CALCDATE('1M', BeginDate) - 1;
    end;

    var
        Treaty: Record Treaty;
        CompanyRec: Record 79;
        PortionOfPremium: Decimal;
        ActualPeriodlPremium: Decimal;
        AdjustmentPremium: Decimal;
        Enddate: Date;
        BeginDate: Date;
        BurningCost: Decimal;
        PremiumRate: Decimal;
        PolicytypeRec: Record "Policy Type";
        TotalGrossPremium: Decimal;
        PremiumPerProduct: Decimal;
        DimVal: Record "Dimension Value";
        GenJnline: Record "Gen. Journal Line";
        InSetup: Record "Insurance setup";
        InsMapping: Record "Insurance Accounting Mappings";
}

