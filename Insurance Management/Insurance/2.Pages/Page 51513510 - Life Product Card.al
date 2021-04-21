page 51513510 "Life Product Card"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Policy Type";

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
                field(Class; Class)
                {
                }
                field("Insurance Type"; "Insurance Type")
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
                field("Premium Table"; "Premium Table")
                {
                    Caption = 'TPO Prem Table';
                }
                field("Premium Discount Applicable"; "Premium Discount Applicable")
                {
                }
                field("Earns Bonus"; "Earns Bonus")
                {
                }
                field("Cover Type Category"; "Cover Type Category")
                {
                }
                field("Allows Joint Cover"; "Allows Joint Cover")
                {
                }
                field("Age Computation Method"; "Age Computation Method")
                {
                }
                field("Min Entry Age"; "Min Entry Age")
                {
                }
                field("Max Entry Age"; "Max Entry Age")
                {
                }
                field("Min SA"; "Min SA")
                {
                }
                field("Max SA"; "Max SA")
                {
                }
                field("Free Cover Limit"; "Free Cover Limit")
                {
                }
                field("Sum Assured Calculation Method"; "Sum Assured Calculation Method")
                {
                }
                field("Premium Calculation Method"; "Premium Calculation Method")
                {
                }
                field("Term Guaranteed Period"; "Term Guaranteed Period")
                {
                }
                field("Account Type"; "Account Type")
                {
                }
                field("Allows Escalation"; "Allows Escalation")
                {
                }
                field("Allows Augmentation"; "Allows Augmentation")
                {
                }
                field("Annuity Uses"; "Annuity Uses")
                {
                }
                field("Premium Type"; "Premium Type")
                {
                }
                field("SA Assured Type"; "SA Assured Type")
                {
                }
                field("Surrender Period"; "Surrender Period")
                {
                }
                field("Account No"; "Account No")
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
                field("short code"; "short code")
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
            }
            part("Cover Details"; "Cover Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code),
                              "Description Type" = CONST(Cover);
            }
            part("Interest Details"; "Interest Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code),
                              "Description Type" = CONST(Interest);
            }
            part("Limits  Details"; "Limits  Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code);
            }
            part("Conditions and clauses Details"; "Conditions and clauses Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code);
            }
            part("Warranty  Details"; "Warranty  Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code);
            }
            part("excess/deductibles Details"; "excess/deductibles Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code);
            }
            part("basis of settlement Details"; "basis of settlement Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code);
            }
            part("Geographical Details"; "Geographical Details")
            {
                SubPageLink = "Policy Type" = FIELD(Code);
            }
            part(Exclusions; Exclusions)
            {
                SubPageLink = "Policy Type" = FIELD(Code);
            }
            part("Policy Instalments"; "Policy Instalments")
            {
            }
            part("Loss Type per Cover"; "Loss Type per Cover")
            {
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
                RunPageLink = "Policy Type" = FIELD(Code);
            }
            action("Page Policy Instalments")
            {
                Caption = 'Instalment Plans';
                RunObject = Page "Policy Instalments";
                RunPageLink = "Policy Type" = FIELD(Code);
            }
            action("Product Benefits")
            {
                RunObject = Page "Product Benefits Definition";
                RunPageLink = "Product Code" = FIELD(Code);
            }
            action("Product Term")
            {
                RunObject = Page "Product Terms";
                RunPageLink = "Product Code" = FIELD(Code);
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Insurance Type" := "Insurance Type"::Life;
    end;
}

