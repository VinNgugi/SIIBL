page 51513102 "Underwriter Policy Type Card"
{
    // version AES-INS 1.0



    PageType = Card;
    SourceTable = "Underwriter Policy Types";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Underwriter Code"; "Underwriter Code")
                {

                }

                field("Business Type"; "Insurance Type")
                {

                }
                field(Class; Class)
                {
                }
                field("Short Code"; "Short Code")
                {

                }
                field("Short Name"; "Short Name")
                {
                }
                field("Non Renewable"; "Non Renewable")
                {
                }
                field("Schedule Subform"; "Schedule Subform")
                {
                }
                field("Premium Calculation"; "Premium Calculation")
                {
                    Caption = 'Comp. Premium';
                }
                field("Default Term"; "Default Term")
                {

                }




                field("Premium Table"; "Premium Table")
                {
                    Caption = 'TPO Prem Table';
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Commission Income Account No"; "Account No")
                {
                }
                field("Commission Expense Account"; "Commission Expense Account")
                {

                }
                field("Commision % age"; "Commision % age(SIIBL)")
                {
                }
                field("Commission %age (Agent)"; "Commission %age (Agent)")
                {

                }
                field(Period; Period)
                {
                }
                field("Start Time"; "Start Time")
                {
                }
                field("End Time"; "End Time")
                {
                }
                field("First Loss %"; "First Loss %")
                {
                }
                field("Open Cover"; "Open Cover")
                {
                }
                field(Type; Type)
                {
                }
                field(Rating; Rating)
                {
                }
                field("Premium Rate"; "Premium Rate")
                {
                }
                field(Conveyance; Conveyance)
                {


                }
                field("Claims Validity Period"; "Claims Validity Period")
                {
                }
                field("Certificate Type"; "Certificate Type")
                {
                }
                field("Certificate Type Bus"; "Certificate Type Bus")
                {
                }
                field("Bus Seating Capacity Cut-off"; "Bus Seating Capacity Cut-off")
                {
                }
                field("PPL Cost Per PAX"; "PPL Cost Per PAX")
                {
                }
                field(Comprehensive; Comprehensive)
                {
                }
                field("Last Policy No."; "Last Policy No.")
                {
                }
                field("Last Endorsement No."; "Last Endorsement No.")
                {
                }
                field("Treaty Code"; "Treaty Code")
                {
                }
                field("Addendum No."; "Addendum No.")
                {

                }
                field("Premium Payment Options"; "Premium Payment Options")
                {

                }
                field("Commission calculation basis"; "Commission Calculation Basis")
                {

                }
                field("Partial maturity?"; "Partial maturity?")
                {
                      Caption='Partial Maturity?';
                }
            }
            part("Cover Details"; "Insurer Cover Details")
            {
                Caption = 'Cover Details';
                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Cover);
            }
            part("Interest Details"; "Insurer Cover Details")
            {
                Caption = 'Interest Details';

                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Interest);
            }
            part("Limits  Details"; "Insurer Cover Details")
            {
                Caption = 'Limit Details';

                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Limits);
            }

            part("Conditions and clauses Details"; "Insurer Cover Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Clauses);
                Caption = 'Conditions and Clauses';
            }
            part("Warranty  Details"; "Insurer Cover Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Warranty);
                Caption = 'Warranty Details';
            }
            part("excess/deductibles Details"; "Insurer Cover Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Excess);
                Caption = 'Excess/Deductible Details';
            }
            part("basis of settlement Details"; "Insurer Cover Details")
            {
                Caption = 'Basis of Settlement';
                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST("Basis of Settlement");
            }
            part("Geographical Details"; "Insurer Cover Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Geographic);
                Caption = 'Geographical Details';
            }
            part(Exclusions; "Insurer Cover Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code), Insurer = FIELD("Underwriter Code"), "Description Type" = CONST(Clauses);
                Caption = 'Exclusions';
            }


        }
    }

    actions
    {
        area(navigation)
        {

            action("Documents Required")
            {
                RunObject = Page "Documents Required";
                RunPageLink = "Policy Type" = FIELD(Code), "Insurer Code" = FIELD("Underwriter Code");
            }
            action("Import Products")
            {
                //begin
                // BrokerMgt.Update;
                // end;
                RunObject = xmlport 50101;
                //RunPageLink = "Policy Type" = FIELD(Code),"Insurer Code"=FIELD("Underwriter Code");
            }

            action("Instalment Plans")
            {
                Caption = 'Premium Instalment Plans';
                RunObject = Page "Policy Instalments";
                RunPageLink = "Policy Type" = FIELD(Code), "Underwriter Code" = FIELD("Underwriter Code");
            }
            action("Maturity Instalments")
            {
                Caption = 'Maturity Instalment Plans';
                RunObject = Page "Maturity Instalments";
                RunPageLink = "Policy Type" = FIELD(Code), "Underwriter Code" = FIELD("Underwriter Code");
            }
            action("Policy Type Template")
            {
                Caption = 'Policy Type Template';
                RunObject = Page "Policy Type Template";
                RunPageLink = Underwriter = FIELD("Underwriter code"), "Policy Type" = FIELD(Code);


            }
            action("Product Terms")
            {
                Caption = 'Product Terms(Period)';
                RunObject = Page "Product Terms";
                RunPageLink = "Underwriter code" = FIELD("Underwriter code"), "Product Code" = FIELD(Code);


            }
            action("Product Zones")
            {
                Caption = 'Product Zones';
                RunObject = Page "Product Zones";
                RunPageLink = "Underwriter code" = FIELD("Underwriter code"), "Policy Type" = FIELD(Code);


            }
            action("Product Benefits")
            {
                Caption = 'Product Benefits';
                RunObject = Page "Product Benefits Definition";
                RunPageLink = "Underwriter code" = FIELD("Underwriter code"), "Product Code" = FIELD(Code);


            }
            action("Product Endorsement Types")
            {
                Caption = 'Product Endorsement Types';
                RunObject = Page "Product Endorsements";
                RunPageLink = "Underwriter code" = FIELD("Underwriter code"), "Product Code" = FIELD(Code);


            }
            action("Product Loading and Discounts")
            {
                Caption = 'Product Loading and Discounts';
                RunObject = Page "Product Loading & discounts";
                RunPageLink = "Underwriter code" = FIELD("Underwriter code"), "Product Code" = FIELD(Code);


            }
            action("Product Age Eligibility")
            {
                Caption = 'Age Eligibility';
                RunObject = Page 51513216;
                RunPageLink = Underwriter = FIELD("Underwriter code"), "Prod_Code" = FIELD(Code);


            }
            action("Product Loss Type")
            {
                Caption = 'Loss Types';
                RunObject = Page "Product Loss Type";
                RunPageLink = "Underwriter Code" = FIELD("Underwriter code"), "Cover Type" = FIELD(Code);


            }
            action("Product Options")
            {
                Caption = 'Product Options';
                RunObject = Page "Product Options";
                RunPageLink = "Underwriter Code" = FIELD("Underwriter code"), "Product Code" = FIELD(Code);


            }
        }


    }
    var
        BrokerMgt: Codeunit "Broker Management";

}


