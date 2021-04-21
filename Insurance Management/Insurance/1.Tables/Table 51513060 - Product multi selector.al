table 51513060 "Product multi selector"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Policy';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Policy;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; UnderWriter; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                IF UnderWriterRec.GET(UnderWriter) THEN
                    "Underwriter Name" := UnderWriterRec.Name;
            end;
        }
        field(4; "Product Plan"; Code[20])
        {
            TableRelation = "Underwriter Policy Types".Code WHERE("UnderWriter code" = FIELD(UnderWriter));

            trigger OnValidate();
            begin
                IF ProductPlan.GET("Product Plan", UnderWriter) THEN
                    "Plan Name" := ProductPlan.Description;
                //"Cover Type" := FORMAT(ProductPlan."Type Of Cover");

                // "Module Type" := ProductPlan."Module Type"; */
            end;
        }
        field(5; "Underwriter Name"; Text[130])
        {
        }
        field(6; "Plan Name"; Text[130])
        {
        }
        field(7; "Select for Quote"; Boolean)
        {

            trigger OnValidate();
            begin
                /*ProductOptions.RESET;
                ProductOptions.SETRANGE(ProductOptions.Underwriter, UnderWriter);
                ProductOptions.SETRANGE(ProductOptions."Policy Type", "Product Plan");
                IF ProductOptions.FIND('-') THEN
                    REPEAT

                        OptionalItems.INIT;
                        OptionalItems."Document Type" := "Document Type";
                        OptionalItems."No." := "Document No.";
                        OptionalItems.Code := ProductOptions.Code;
                        OptionalItems.Description := ProductOptions.Description;
                        OptionalItems."Discount %" := ProductOptions."Discount %";
                        OptionalItems."Discount Amount" := ProductOptions."Discount Amount";
                        OptionalItems."Loading Amount" := ProductOptions."Loading Amount";
                        OptionalItems."Loading %" := ProductOptions."Loading %";
                        OptionalItems.Priority := ProductOptions.Priority;
                        OptionalItems."Product Plan" := "Product Plan";
                        OptionalItems.Underwriter := UnderWriter;
                        IF ProductOptions.Type = ProductOptions.Type::Mandatory THEN
                            OptionalItems.Selected := TRUE;

                        IF NOT OptionalItems.GET(OptionalItems."Document Type", OptionalItems."No.", OptionalItems.Code,
                        OptionalItems."Product Plan", OptionalItems.Underwriter) THEN
                            OptionalItems.INSERT;

                    UNTIL ProductOptions.NEXT = 0;*/
                VALIDATE("Product Plan");
            end;
        }
        field(8; "Area Of Cover"; Code[30])
        {
            TableRelation = "Area of Coverage"."Area Code" WHERE(UnderWriter = FIELD(UnderWriter));

            trigger OnValidate();
            begin
                IF CoverArea.GET("Area Of Cover", UnderWriter) THEN
                    Area := CoverArea.Description;
            end;
        }
        field(9; "Select Excess"; Code[20])
        {
            TableRelation = "Product Plan Excess".Excess WHERE(UnderWriter = FIELD(UnderWriter));

            trigger OnValidate();
            begin
                IF QuoteExcess.GET("Select Excess", '', '') THEN
                    Excess := QuoteExcess.Description;
            end;
        }
        field(10; "Premium Frequency"; Code[20])
        {
            TableRelation = "Payment Terms";
        }
        field(11; "Currency Desired"; Code[20])
        {
            TableRelation = Currency;
        }
        field(12; "Selected by Client"; Boolean)
        {
        }
        field(13; "Client Type"; Code[10])
        {
            //TableRelation = "Client Type";
        }
        field(14; "No Of Employees Range"; Code[20])
        {
            ///TableRelation = "Employee Range";
        }
        field(15; "Exchange Rate"; Decimal)
        {
        }
        field(16; "No. Of Months"; Code[10])
        {
            //TableRelation = Period;
        }
        field(17; "Module Type"; Option)
        {
            OptionMembers = Medical,"Medical Brokerage",Travel,"Life and Investment","Amini Data","Medical AWS","Medical AWSIHS",Funded;

            trigger OnValidate();
            begin
                MESSAGE('validated')
            end;
        }
        field(18; "Area"; Text[250])
        {
        }
        field(19; Excess; Text[30])
        {
        }
        field(20; "Cover Type"; Text[50])
        {
        }
        field(21; "Quote Created"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", UnderWriter, "Product Plan")
        {
        }

    }

    fieldgroups
    {
    }

    var
        UnderWriterRec: Record Vendor;
        ProductPlan: Record "Underwriter Policy Types";
        CoverArea: Record "Area of coverage";
        QuoteExcess: Record "Policy Excess";
}

