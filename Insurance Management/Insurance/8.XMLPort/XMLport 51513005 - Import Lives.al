xmlport 51513005 "Import Lives"
{
    // version AES-INS 1.0

    Format = VariableText;

    schema
    {
        textelement(Lives)
        {
            tableelement("Insure Lines"; "Insure Lines")
            {
                XmlName = 'Lives';
                fieldelement(Title; "Insure Lines".Title)
                {
                }
                fieldelement(Family_Name; "Insure Lines"."Family Name")
                {
                    FieldValidate = No;
                }
                fieldelement(First_Name; "Insure Lines"."First Name(s)")
                {
                }
                fieldelement(Gender; "Insure Lines".Sex)
                {
                    FieldValidate = No;
                }
                fieldelement(DOB; "Insure Lines"."Date of Birth")
                {
                }
                fieldelement(Relationship; "Insure Lines"."Relationship to Applicant")
                {
                    FieldValidate = No;
                }
                fieldelement(Occupation; "Insure Lines".Occupation)
                {
                    FieldValidate = No;
                }
                fieldelement(Nationality; "Insure Lines".Nationality)
                {
                }
                fieldelement(SumAssured; "Insure Lines"."Sum Insured")
                {
                }

                trigger OnAfterInsertRecord();
                begin

                    "Insure Lines".VALIDATE("Insure Lines"."Seating Capacity");
                end;

                trigger OnBeforeInsertRecord();
                begin
                    "Insure Lines"."Document Type" := InsureHeaderCopy."Document Type";
                    "Insure Lines"."Document No." := InsureHeaderCopy."No.";
                    "Insure Lines"."Description Type" := "Insure Lines"."Description Type"::"Schedule of Insured";
                    IF "Insure Lines"."Line No." = 0 THEN BEGIN
                        InsQuoteLines.RESET;
                        InsQuoteLines.SETRANGE(InsQuoteLines."Document Type", "Insure Lines"."Document Type");
                        InsQuoteLines.SETRANGE(InsQuoteLines."Document No.", "Insure Lines"."Document No.");
                        IF InsQuoteLines.FINDLAST THEN
                            "Insure Lines"."Line No." := InsQuoteLines."Line No." + 10000;

                    END;

                    IF InsHeader.GET("Insure Lines"."Document Type", "Insure Lines"."Document No.") THEN BEGIN

                        "Insure Lines"."Policy Type" := InsHeader."Policy Type";
                        IF InsHeader."No. Of Instalments" = 0 THEN
                            ERROR('Please key in No. of instalments before importing');
                        "Insure Lines"."No. Of Instalments" := InsHeader."No. Of Instalments";
                        "Insure Lines"."Policy No" := InsHeader."Policy No";
                        "Insure Lines"."Insured No." := InsHeader."Insured No.";

                        PremiumTab.RESET;
                        PremiumTab.SETRANGE(PremiumTab."Policy Type", "Insure Lines"."Policy Type");
                        IF PremiumTab.FINDFIRST THEN BEGIN
                            "Insure Lines"."Vehicle License Class" := PremiumTab."Vehicle Class";
                            "Insure Lines"."Vehicle Usage" := PremiumTab."Vehicle Usage";

                        END;
                    END;
                end;
            }
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

    trigger OnPostXmlPort();
    begin
        PolicyLines.RESET;
        PolicyLines.SETRANGE(PolicyLines."Document Type", InsureHeaderCopy."Document Type");
        PolicyLines.SETRANGE(PolicyLines."Document No.", InsureHeaderCopy."No.");
        PolicyLines.SETRANGE(PolicyLines."Description Type", PolicyLines."Description Type"::"Schedule of Insured");
        IF PolicyLines.FINDFIRST THEN
            REPEAT
                PolicyLines.VALIDATE(PolicyLines."Seating Capacity");
            //PolicyLines.MODIFY;
            UNTIL PolicyLines.NEXT = 0;
    end;

    var
        InsureHeaderCopy: Record "Insure Header";
        InsQuote: Record "Insure Header";
        InsQuoteLines: Record "Insure Lines";
        RiskData: Record "Risk Database";
        InsHeader: Record "Insure Header";
        PolicyType: Record "Policy Type";
        Insmanagement: Codeunit "Insurance management";
        PremiumTableLines: Record "Premium table Lines";
        PremiumTab: Record "Premium Table";
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
        EndorsmentType: Record "Endorsement Types";
        TaxesRec: Record "Loading and Discounts Setup";
        TPOLessTax: Decimal;
        TPOTaxPercentage: Decimal;
        TPOFlatAmtTax: Decimal;
        Policyline: Record "Insure Lines";
        PolicyLines: Record "Insure Lines";
        SalesHeader: Record "Insure Header";
        DimMgt: Codeunit 408;
        Insetup: Record "Insurance setup";
        Direction: Text;

    procedure GetRec(var InsureHeader: Record "Insure Header");
    begin
        InsureHeaderCopy.COPY(InsureHeader);
    end;
}

