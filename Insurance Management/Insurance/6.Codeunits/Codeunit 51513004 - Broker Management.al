/// <summary>
/// Codeunit Broker Management (ID 51513004).
/// </summary>
codeunit 51513004 "Broker Management"
{
    trigger OnRun()
    var
        myInt: Integer;
    begin

    end;

    


    /// <summary>
    /// FnCreateQuote.
    /// </summary>
    /// <param name="InsureHeader">VAR Record "Insure Header".</param>
    procedure FnCreateInsurerQuote(var InsureHeader: Record "Insure Header")
    var
        ProductSelection: Record "Product Multi selector";
        ObjInsureH: Record "Insure Header";
        ObjInsureLines: Record "Insure Lines";
        InsureLines: Record "Insure Lines";
        DocNo: Code[20];
        Insurer_Product: Record "Underwriter Policy Types";
    begin
        ProductSelection.Reset();
        ProductSelection.SetRange("Document Type", InsureHeader."Document Type");
        ProductSelection.SetRange("Document No.", InsureHeader."No.");
        ProductSelection.SetRange("Select for Quote", true);
        ProductSelection.SetRange("Quote Created", false);
        IF ProductSelection.FindSet() then  //prod selection
            repeat
                ObjInsureH.Reset();
                With ObjInsureH do begin
                    Init();
                    TransferFields(InsureHeader);
                    "Document Type" := "Document Type"::"Insurer Quotes";
                    Underwriter := ProductSelection.UnderWriter;
                    "Underwriter Name" := ProductSelection."Underwriter Name";
                    "Policy Type" := ProductSelection."Product Plan";
                    "Parent Quote No" := ProductSelection."Document No.";
                    IF Insurer_Product.GET(Underwriter, "Policy Type") THEN
                        "Commission Due" := Insurer_Product."Commision % age(SIIBL)";
                    "No." := '';
                    if Insert(true) then
                        DocNo := ObjInsureH."No.";
                end;
                InsureLines.Reset();
                InsureLines.SetRange("Document No.", InsureHeader."No.");
                InsureLines.SetRange("Document Type", InsureHeader."Document Type");
                if InsureLines.FindSet() then
                    repeat
                        with ObjInsureLines do begin
                            Init();
                            TransferFields(InsureLines);
                            "Document No." := DocNo;
                            "Document Type" := ObjInsureH."Document Type";
                            "Policy Type" := ProductSelection."Product Plan";

                            Insert();
                        end;
                    until InsureLines.Next() = 0;
                ProductSelection."Quote Created" := true;
                ProductSelection.Modify();
            until ProductSelection.Next() = 0;
        Message('Insurer Quotes created successfully.');
    end;

    procedure FnCreateQuote(RecRef: RecordRef)
    var
        DocNo: Code[20];
        ObjOpportunity: Record Opportunity;
        ObjInsureH: Record "Insure Header";
        ObjInsureLines: Record "Insure Lines";
        ProductSelection: Record "Product Multi selector";
        InsureLines: Record "Insure Lines";
        Insurer_Product: Record "Underwriter Policy Types";
        EnumManagement: Codeunit "Enum Assignment Mgmt";
    begin
        case RecRef.Number of
            Database::Opportunity:
                begin
                    RecRef.SetTable(ObjOpportunity);
                    ObjInsureH.Reset();
                    with ObjInsureH do begin
                        "Document Type" := "Document Type"::Quote;
                        Validate("Contact No.", ObjOpportunity."Contact No.");
                        "Shortcut Dimension 1 Code" := ObjOpportunity."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code" := ObjOpportunity."Global Dimension 2 Code";
                        "Shortcut Dimension 3 Code" := ObjOpportunity."Shortcut Dimension 3 Code";
                        "Business Type" := EnumManagement.FnGetBusinessType(ObjOpportunity."Business Type");
                        "Opportunity No." := ObjOpportunity."No.";
                        Validate("Opportunity No.");
                        if Insert(true) then
                            DocNo := ObjInsureH."No.";
                        ObjInsureLines.Reset();
                        with ObjInsureLines do begin
                            Init();
                            "Document No." := DocNo;
                            "Document Type" := ObjInsureLines."Document Type"::Quote;
                            Insert();
                        end;
                    end;

                end;
            Database::"Insure Header":
                begin
                    RecRef.SetTable(ObjInsureH);
                    ProductSelection.Reset();
                    ProductSelection.SetRange("Document Type", ObjInsureH."Document Type");
                    ProductSelection.SetRange("Document No.", ObjInsureH."No.");
                    ProductSelection.SetRange("Select for Quote", true);
                    ProductSelection.SetRange("Quote Created", false);
                    IF ProductSelection.FindSet() then  //prod selection
                        repeat
                            ObjInsureH.Reset();
                            With ObjInsureH do begin
                                Init();
                                TransferFields(ObjInsureH);
                                "Document Type" := "Document Type"::"Insurer Quotes";
                                Underwriter := ProductSelection.UnderWriter;
                                "Underwriter Name" := ProductSelection."Underwriter Name";
                                "Policy Type" := ProductSelection."Product Plan";
                                "Parent Quote No" := ProductSelection."Document No.";
                                IF Insurer_Product.GET(Underwriter, "Policy Type") THEN
                                    "Commission Due" := Insurer_Product."Commision % age(SIIBL)";
                                "No." := '';
                                if Insert(true) then
                                    DocNo := ObjInsureH."No.";
                            end;
                            InsureLines.Reset();
                            InsureLines.SetRange("Document No.", ObjInsureH."No.");
                            InsureLines.SetRange("Document Type", ObjInsureH."Document Type");
                            if InsureLines.FindSet() then
                                repeat
                                    with ObjInsureLines do begin
                                        Init();
                                        TransferFields(InsureLines);
                                        "Document No." := DocNo;
                                        "Document Type" := ObjInsureH."Document Type";
                                        "Policy Type" := ProductSelection."Product Plan";

                                        Insert();
                                    end;
                                until InsureLines.Next() = 0;
                            ProductSelection."Quote Created" := true;
                            ProductSelection.Modify();
                        until ProductSelection.Next() = 0;
                    Message('Insurer Quotes created successfully.');
                end;

        end
    end;
    procedure CalculateFV(Var P:Decimal;var N:Decimal;var R:Decimal) FV:Decimal
    

       begin
           //Combine:=1+R;
          Fv:=P*((POWER(1+R,N)-1)/R);
                    

        end;


procedure CalculatePP(Var Age:Integer;Var GuaranteeYrs:Integer;Var Gender:Enum Gender;Var GrossPay:Decimal;Var Frequency:Integer) PP:Decimal
var
AnnuityTable:Record "Annuity Rates";
rate: Decimal;
begin

annuityTable.RESET;
AnnuityTable.setrange(AnnuityTable."Guarantee Years",GuaranteeYrs);
AnnuityTable.setrange(AnnuityTable."Retire Age",Age);
If AnnuityTable.findlast then
begin
    if  Gender =Gender::male then
    rate:=AnnuityTable."Male Rate"/AnnuityTable.Denominator;
    if gender=gender::female then
    rate:=AnnuityTable."Female Rate"/AnnuityTable.Denominator;


end;


If Rate<>0 then
PP:=(Grosspay*Frequency)/Rate;
end;
procedure GetAnnuityRate(Var Age:Integer;Var GuaranteeYrs:Integer;Var Gender:Enum Gender) AnnuityRate:Decimal
var
AnnuityTable:Record "Annuity Rates";
//rate: Decimal;
begin

annuityTable.RESET;
AnnuityTable.setrange(AnnuityTable."Guarantee Years",GuaranteeYrs);
AnnuityTable.setrange(AnnuityTable."Retire Age",Age);
If AnnuityTable.findlast then
begin
    if  Gender =Gender::male then
    AnnuityRate:=AnnuityTable."Male Rate"/AnnuityTable.Denominator;
    if gender=gender::female then
    Annuityrate:=AnnuityTable."Female Rate"/AnnuityTable.Denominator;


end;



end;

procedure GetInterestRate(Var Age:Integer;Var GuaranteeYrs:Integer;Var Gender:Enum Gender;Var GrossPay:Decimal;Var Frequency:Integer) InterestRate:Decimal
var
AnnuityTable:Record "Annuity Rates";
//rate: Decimal;
begin

annuityTable.RESET;
AnnuityTable.setrange(AnnuityTable."Guarantee Years",GuaranteeYrs);
AnnuityTable.setrange(AnnuityTable."Retire Age",Age);
If AnnuityTable.findlast then
begin
    
InterestRate:=(AnnuityTable.Interest/100);
end;



end;
procedure CalcGrossPay(Var PP:Decimal;Var AnnuityRate:Decimal;Var Frequency:Integer) GrossPay:Decimal
begin
    IF Frequency<>0 then
    Grosspay:=(PP*AnnuityRate)/Frequency;
end;
procedure Update()
var 
PolicyTypes:record "Underwriter Policy Types";
begin
    PolicyTypes.Reset;
    If policyTypes. FindFirst() then
    repeat
    PolicyTypes."Commision % age(SIIBL)":=PolicyTypes."Commision % age(SIIBL)"*100;
    PolicyTypes.Modify();
    until policytypes.next=0;
end;

}