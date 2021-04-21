pageextension 50100 "Accountant Role Center Ext" extends "Accountant Role Center"
{
    layout
    {

    }
    actions
    {
        addafter(SetupAndExtensions)
        {

            group("Insurance Mgmt")
            {
                // Visible = false;
                Caption = 'Insurance Management';
                group(Registration)
                {
                    action("Insured List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Insured List';
                        RunObject = Page "Insured List";
                        ToolTip = 'Open the Insured List.';
                    }
                    action("Insured List Corporate")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Insured List Corporate';
                        RunObject = Page "Insured List Corporate";
                        ToolTip = 'Open the Insured List Corporate.';
                    }
                    action("SACCO List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'SACCO List';
                        RunObject = Page "SACCO List";
                        ToolTip = 'Open the SACCO List.';
                    }
                    action("Insurer List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Insurer List';
                        RunObject = Page "Insurer List";
                        ToolTip = 'Open the Insurer List.';
                    }
                    action("Re_Insurer List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Re_Insurer List';
                        RunObject = Page "Re_Insurer List";
                        ToolTip = 'Open the Re_Insurer List.';
                    }
                    action("Agent List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Agent List';
                        RunObject = Page "Agent List";
                        ToolTip = 'Open the Agent List.';
                    }
                    action("Broker List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Broker List';
                        RunObject = Page "Broker List";
                        ToolTip = 'Open the Broker List.';
                    }
                    action("Direct Intermediary List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Direct Intermediary List';
                        RunObject = Page "Direct Intermediary List";
                        ToolTip = 'Open the Direct Intermediary List.';
                    }
                    action("Bank Assurance List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Assurance List';
                        RunObject = Page "Bank Assurance List";
                        ToolTip = 'Open the Bank Assurance List.';
                    }
                    action("Risk database")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Risk database ';
                        RunObject = Page "Vehicle Database";
                        ToolTip = 'Open the Risk database .';
                    }
                    action("IPF Provider List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'IPF Provider List';
                        RunObject = Page "IPF Provider List";
                        ToolTip = 'Open the IPF Provider List.';
                    }
                }
                group(Quotations)
                {
                    action("New Quotes")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New';
                        RunObject = Page "Quote List-New";
                        ToolTip = 'Open the new Quote List.';
                    }
                    action("Renewal")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Renewal';
                        RunObject = Page "Quote List-Renewal";
                        ToolTip = 'Open the Quote List-Renewal.';
                    }
                    action("Accepted Quote List ")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Accepted Quotes';
                        RunObject = Page "Accepted Quote List";
                        ToolTip = 'Open the Quote List-Renewal.';
                    }

                }
                group(Policies)
                {
                    action("Accepted Quote List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'New Policies';
                        RunObject = Page "Accepted Quote List";
                        ToolTip = 'Open the Accepted Quote List.';
                    }
                    action("Discount List ")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Underwriting Discounts List';
                        RunObject = Page "Discount List";
                        ToolTip = 'Open the Discount List';
                    }
                    action("Policy List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Policy List';
                        RunObject = Page "Policy List";
                        ToolTip = 'Open the Accepted Policy List.';
                    }
                    action("Quote List-Endorsements")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Endorsements';
                        RunObject = Page "Quote List-Endorsements";
                        ToolTip = 'Open the Quote List-Endorsements.';
                    }
                    action("Vehicles Listing")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Policy List Per Risk';
                        RunObject = Page "Vehicles Listing";
                        ToolTip = 'Open the Vehicles Listing.';
                    }
                    action("Policies Issued")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Policy Issued';
                        RunObject = Page "Policies Issued";
                        ToolTip = 'Open the Policies Issued.';
                    }
                }
                group("Agent/Brokers")
                {
                    /* action("Broker List")
                     {
                         ApplicationArea= Basic,Suite;
                         Caption ="Agent_Broker List";
                         RunObject=Page "Broker List ";
                         ToolTip='Open the Broker List';
                     }*/

                }
                group(Claims)
                {
                    group(Claims1)
                    {
                        action("Claim Vehicles Listing")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Claim Vehicle Listing';
                            RunObject = Page "Claim Vehicles Listing";
                            ToolTip = 'Open the Claim Vehicles Listing.';
                        }
                        action("Claim Register List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Claim Register List';
                            RunObject = Page "Claim Register List";
                            ToolTip = 'Open the Claim Register List';
                        }
                        action("Claim Report List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Claim Report List';
                            RunObject = Page "Claim Report List";
                            ToolTip = 'Open the Claim Report List';

                        }
                        action("Claim Reservation List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Claim Reservation List';
                            RunObject = Page "Claim Reservation List";
                            ToolTip = 'Open the Claim Register List';
                        }
                        action("Service Provider Appointments")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Service Provider Appointments';
                            RunObject = Page "Service Provider Appointments";
                            ToolTip = 'Open the Service Provider Appointments';
                        }
                        action("Purchase Invoices1")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Purchase Invoices';
                            RunObject = Page "Purchase Invoices";
                            ToolTip = 'Open the Purchase Invoices';

                        }
                        action("Vendor List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Service Provider List';
                            RunObject = Page "Vendor List";
                            ToolTip = 'Open the Servicce Provider List';
                        }
                        action("Payment Listing")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Payment Requsition';
                            RunObject = Page "Payment Listing";
                            ToolTip = 'Open the Payment Requsition';

                        }


                    }
                    group(Legal)
                    {
                        action("Demand letter List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Demand Letter List';
                            RunObject = Page "Demand letter List";
                            ToolTip = 'Open the Demand Letter List';
                        }
                        action("Demand letter List-Responded")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Demand Letter-List Responded';
                            RunObject = Page "Demand letter List-Responded";
                            ToolTip = 'Demand letter List-Responded';

                        }
                        action("Demand letter List-Ignored")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Demand Letter List-Ignored';
                            RunObject = Page "Demand letter List-Ignored";
                            ToolTip = 'Open the Demand letter  List-Ignored.';
                        }
                        action("Summon letter List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Summon letter List';
                            RunObject = Page "Summon letter List";
                            ToolTip = 'Open the Summon letter List';


                        }
                        action("Litigation listx")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Litigation list';
                            RunObject = Page "Litigation listx";
                            ToolTip = 'Open the Litigation list';
                        }
                        action("Law Firms")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Law Firms';
                            RunObject = Page "Law Firms";
                            ToolTip = 'Open the Law Firms';
                        }
                        action("legal diary updates")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'legal diary updates';
                            RunObject = Page "legal diary updates";
                            ToolTip = 'Open the legal diary updates';

                        }
                        action("legal cases Liable")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'legal cases Liable';
                            RunObject = Page "legal cases Liable";
                            ToolTip = 'Open the legal cases Liable';
                        }
                        action("legal cases Repudiated")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'legal cases Repudiated';
                            RunObject = Page "legal cases Repudiated";
                            ToolTip = 'Open the legal cases Repudiated';
                        }
                        action("Appealed cases")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Appealed cases';
                            RunObject = Page "Appealed cases";
                            ToolTip = 'Open the Appealed cases';
                        }
                    }
                    group("Service providers1")
                    {
                        action("Service providers")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Service Providers';
                            RunObject = Page "Service providers";
                            ToolTip = 'Open the Service providers';
                        }

                    }
                }
                group("Insurance Setups")
                {
                    action("Insurance Setup")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Insurance Setup';
                        RunObject = Page "Insurance Setup";
                        ToolTip = 'Open the insurance general setup';
                    }
                }

            }
            group(Finance)
            {
                // Visible = false;
                Caption = 'Finance Management';
                group("Cash_Management")
                {
                    group("Payment Vouchers")
                    {
                        action("Payment Listing1")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Open Payment Vouchers';
                            RunObject = Page "Payment Listing";
                            ToolTip = 'Open the Payment Listing';
                        }
                        action("Pending Payment Vouchers")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Payment Vouchers Pending Approval';
                            RunObject = Page "Pending Payment Vouchers";
                            ToolTip = 'Open the Pending Payment Vouchers';
                        }
                        action("Released PVs")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Approved Payment Vouchers';
                            RunObject = Page "Released PVs";
                            ToolTip = 'Open the Released PVs';
                        }
                        action("Posted PVs")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Payment Vouchers';
                            RunObject = Page "Posted PVs";
                            ToolTip = 'Open the Posted PVs';
                        }
                    }
                    group(Receipts)
                    {
                        action("Receipt List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Receipt List';
                            RunObject = Page 51511292;
                            ToolTip = 'Open the Receipt List';
                        }
                        action("Posted Receipt List")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Posted Receipt List';
                            RunObject = Page 51511294;
                            ToolTip = 'Open the Posted Receipt List';

                        }
                        action("Direct-Premium Receipts")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Direct-Underwriter Receipts';
                            RunObject = Page "Underwriter receipts list";
                            ToolTip = 'Open the Underwriter Receipt List';
                        }
                    }
                }
                group("Imprest Management")
                {
                    action("Open Imprests")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Open Imprest Warranty';
                        RunObject = Page "Open Imprests";
                        ToolTip = 'Open the Open Imprests';
                    }
                    action("Released Imprests")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approved Imperest Warranty';
                        RunObject = Page "Released Imprests";
                        ToolTip = 'Open the Released Imprest';
                    }
                    action("Claims Listing")
                    {
                        ApplicationArea = Basic, SUite;
                        Caption = 'Open Surrender';
                        RunObject = Page "Claims Listing";
                        ToolTip = 'Open the Claims Listing';
                    }
                    action("Released Imprest Surrenders ")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approved Imprest Surrenders';
                        RunObject = Page "Released Imprest Surrenders";
                        ToolTip = 'Open the Released Imprest Surrenders';
                    }
                    action("Posted Imprests")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Imprest Warranty';
                        RunObject = Page "Posted Imprests";
                        ToolTip = 'Open the Posted Imprests';
                    }
                    action("Posted Imprests-Outstanding")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Imprest Warranty-Outstanding On Client';
                        RunObject = Page "Posted Imprests-Outstanding";
                        ToolTip = 'Open the Posted Imprests-Outstanding';
                    }
                    action("Posted Imprest Surrenders")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Imprest Surrenders';
                        RunObject = Page "Posted Imprest Surrenders";
                        ToolTip = 'Open the Posted Imprest Surrenders';
                    }
                }
                group("Claim Management")
                {
                    action("Cash Request List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Open Claims';
                        RunObject = Page "Cash Request List";
                        ToolTip = 'Open the Cash Request List';
                    }
                    action("Released Claims")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Released Claims';
                        RunObject = Page "Released Claims";
                        ToolTip = 'Released Claims';
                    }
                    action("Claims_Refunds Listing")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Claims/Refund';
                        RunObject = Page "Claims_Refunds Listing";
                        ToolTip = 'Open the Claims_Refunds Listing';
                    }
                }
                group("Petty Cash Management")
                {
                    action("Petty Cash List - Finance")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Petty Cash List- Finance';
                        RunObject = Page "Petty Cash List - Finance";
                        ToolTip = 'Open the Petty Cash List - Finance';
                    }
                    action("Posted Petty Cash List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Petty Cash List';
                        RunObject = Page "Posted Petty Cash List";
                        ToolTip = 'Open the Posted Petty Cash List';
                    }
                    action("Petty Cash Replenishment List")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Petty Cash Replenishment List';
                        RunObject = Page "Petty Cash Replenishment List";
                        ToolTip = 'Open the Petty Cash Replenishment List';
                    }

                }
                group("Finance Setups")
                {
                    Caption = 'Finance SetUps';
                    action("Cash Management Setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Cash Management Setup', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Cash Management Setup";
                    }
                }
            }
            group("Insurance Brokerage")
            {
                group(Setups)
                {
                    action("Underwriter Policy Type")
                    {
                        ApplicationArea = All;
                        Caption = 'Underwriter Policy Types', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Underwriter Policy Type List";
                    }
                    action("Insurance Cover Type")
                    {
                        ApplicationArea = All;
                        Caption = 'Insurance Cover Types';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        Runobject = page "Insurance Cover types";
                    }
                    action("Term List")
                    {
                        ApplicationArea = All;
                        Caption = 'Term List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Term List";
                    }
                    action("Optional Benefits")
                    {
                        ApplicationArea = All;
                        Caption = 'Optional Benefits', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Optional Benefits";
                    }
                    action("Instalments")
                    {
                        ApplicationArea = All;
                        Caption = 'Instalments', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page Instalments;
                    }
                    action("Discounts and Loading setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Discounts and Loadings setup', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Discounts and Loading setup";
                    }
                    action("Short term cover")
                    {
                        ApplicationArea = All;
                        Caption = 'Short term cover', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Short term cover";
                    }
                    action("Endorsement types")
                    {
                        ApplicationArea = All;
                        Caption = 'Endorsement types', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Endorsement types";
                    }
                    action("Document setup")
                    {
                        ApplicationArea = All;
                        Caption = 'Document setup', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Document setup";
                    }
                    action("Source Of Business")
                    {
                        ApplicationArea = All;
                        Caption = 'Source Of Business', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Source Of Business";
                    }
                    action("Cancellation Reasons")
                    {
                        ApplicationArea = All;
                        Caption = 'Cancellation Reasons', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Cancellation Reasons";
                    }
                    action("Countries/Regions")
                    {
                        ApplicationArea = All;
                        Caption = 'Countries/Regions', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Countries/Regions";
                    }

                    action("Death Causes")
                    {
                        ApplicationArea = All;
                        Caption = 'Death Causes', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "LIFE Death Causes";

                    }
                    action("Underwriting Medical tests")
                    {
                        ApplicationArea = All;
                        Caption = 'Underwriting Medical tests', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Underwriting Medical tests";

                    }
                    action("Occupation Lists")
                    {
                        ApplicationArea = All;
                        Caption = 'Occupation List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Occupation List";
                    }
                    action("Means of Identification")
                    {
                        ApplicationArea = All;
                        Caption = 'Means of Identification', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Means Of Identification";
                    }
                    action("Cover Benefits")
                    {
                        ApplicationArea = All;
                        Caption = 'Cover Benefits', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Cover Benefits";
                    }
                    action("Tables Setup List")
                    {
                        ApplicationArea = All;
                        Caption = 'Tables Setup List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Tables Setup List";
                    }
                    action("Commission Types")
                    {
                        ApplicationArea = All;
                        Caption = 'Commission Types', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Commission Types List";
                    }
                    action("Loss Type")
                    {
                        ApplicationArea=All;
                        Caption = 'Loss Type Setup', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject=Page 51513193;
                    }
                    action(Relationship)
                    {
                        ApplicationArea=All;
                        Caption = 'Relationship List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject=Page Relationship;
                    }
                    action("Client Type")
                    {
                        ApplicationArea=All;
                        Caption = 'Client Type List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject=Page "Client Type";
                    }
                    action("Notification Setup")
                    {
                        ApplicationArea=All;
                        Caption = 'Notification Setup', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject=Page "Notification setup";
                    }
                   




                }
                group(Onboarding)
                {
                    action("Insured List1")
                    {
                        ApplicationArea = All;
                        Caption = 'Insured List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Insured List";
                    }
                    action("Insured List Corporate1")
                    {
                        ApplicationArea = All;
                        Caption = 'Insured List Corporate', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Insured List Corporate";
                    }
                    action("Sales Agents")
                    {
                        ApplicationArea = All;
                        Caption = 'Sales Agent List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Sales Agent List";
                    }
                    action("Insurer List1")
                    {
                        ApplicationArea = All;
                        Caption = 'Insurer List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Insurer List";
                    }
                    action("Re-Insurer List")
                    {
                        ApplicationArea = All;
                        Caption = 'Re-Insurer List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Re_Insurer List";

                    }
                    
                    
                    
                    action("Bank Assurance List1")
                    {
                        ApplicationArea = All;
                        Caption = 'Bank Assurance List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Bank Assurance List";
                    }
                    action("Risk Database1")
                    {
                        ApplicationArea = All;
                        Caption = 'Risk Database', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Risk Database";
                    }
                    action("IPF Provider List1")
                    {
                        ApplicationArea = All;
                        Caption = 'IPF Provider List', comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "IPF Provider List";
                    }
                    action("Underwriter")
                    {
                        ApplicationArea = All;
                        Caption = 'Underwriter', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = "";
                        RunObject = Page "Underwriter List";
                    }

                }
                Group(Insurance_Reports)
                {
                    group("Underwriting Reports")
                    {
                        action("Production Report")
                        {
                            ApplicationArea = All;
                            Caption = 'Production Report', comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Production Reportx";

                        }

                        action("Customer Statement")
                        {
                            ApplicationArea = All;
                            Caption = 'Insured Statement', comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Customer Statement MIC";

                        }
                        action("Expire Policies")
                        {
                            ApplicationArea = All;
                            Caption = 'Expired Policies', comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Expired Policies";
                        }
                        action("Renewal Policy")
                        {
                            ApplicationArea = All;
                            Caption = 'Renewal Policy', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Renewal Policy";

                        }
                        action("Renewal Notice Listing")
                        {
                            ApplicationArea = All;
                            Caption = 'Renewal Notice Listing', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Renewal Notice Listing";
                        }
                        action("Renewal Listing Per Intermediary")
                        {
                            ApplicationArea = All;
                            Caption = 'Renewal Listing Per Intermediary', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Renewal Listing Per Intermed";

                        }
                        action("Premium Production Report")
                        {
                            ApplicationArea = All;
                            Caption = 'Premium Production Report', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Premium Production Report";
                        }
                        action("Schedule TPO")
                        {
                            ApplicationArea = All;
                            Caption = 'Schedule TPO', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Schedule TPO";

                        }
                        action("Direct Business")
                        {
                            ApplicationArea = All;
                            Caption = 'Direct Business', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Direct Business";
                        }
                        action("Premium Production")
                        {
                            ApplicationArea = All;
                            Caption = 'Premium Production', Comment = 'NLB="YourLanguageCaption';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Premium Production";
                        }
                        action("Suspension Report")
                        {
                            ApplicationArea = All;
                            Caption = 'Suspension Report', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Suspension Report";

                        }
                        action("Substitution Report")
                        {
                            ApplicationArea = All;
                            Caption = 'Substitution Report', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Substitution Report";

                        }
                        action("Premium Summary Per Class")
                        {
                            ApplicationArea = All;
                            Caption = 'Premium Summary Per Class', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Cumulative Premium Summary";
                        }
                        action("Cancelled Policies")
                        {
                            ApplicationArea = All;
                            Caption = 'Cancelled Policies', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            //RunObject=Report "Cancelled Policies";
                        }
                        action("IPF Report")
                        {
                            ApplicationArea = All;
                            Caption = 'IPF Report', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            // RunObject=Report "IPR Report";
                        }
                        action("Reinstatement Report")
                        {
                            ApplicationArea = All;
                            Caption = 'Reinstatement Report', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            // RunObject=Report "Reinstatement Report";
                        }
                        action("Premium Production Summary")
                        {
                            ApplicationArea = All;
                            Caption = 'Premium Production Summary', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Premium Production Summary";

                        }
                        action("New Business Report")
                        {
                            ApplicationArea = All;
                            Caption = 'New Business Report', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "New Business  Report";
                        }
                        action("Endorsement Report")
                        {
                            ApplicationArea = All;
                            Caption = 'Endorsement Report', Comment = 'NLB="YourLanguageCaption"';
                            Promoted = true;
                            PromotedCategory = Process;
                            PromotedIsBig = true;
                            Image = Setup;
                            RunObject = Report "Extension Report";
                        }
                    }

                }
                group("Brokerage Processes")
                {
                    action("Broker Quote List")
                    {
                        ApplicationArea = All;

                        Caption = 'Broker Quote List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Broker Quote List";
                    }
                    action("Insurer Quote List")
                    {
                        ApplicationArea = All;

                        Caption = 'Insurer Quote List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Insurer Quote List";
                    }

                    action("Policy Listing")
                    {
                        ApplicationArea = All;

                        Caption = 'Policy List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Policy List";
                    }

                    action("Debit Note List")
                    {
                        ApplicationArea = All;

                        Caption = 'Debit Note List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Debit Note List (Posted)";
                    }

                    action("Credit Note List")
                    {
                        ApplicationArea = All;

                        Caption = 'Credit Note List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Credit Note List (Posted)";
                    }
                    group("Claims Management")
                    {

                       action("Claim Register") 
                       {
                        ApplicationArea = All;

                        Caption = 'Claim Register List', Comment = 'NLB="YourLanguageCaption"';
                        Promoted = true;
                        PromotedCategory = Process;
                        PromotedIsBig = true;
                        Image = Setup;
                        RunObject = Page "Claim Register List";

                       }
                    }









                }
            }
        }
    }

}
