page 51513127 "Agent Commissions"
{

    ApplicationArea = All;
    Caption = 'Agent Commissions';
    PageType = List;
    SourceTable = "Commissions Setup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Agent Code"; "Agent Code")
                {
                    ApplicationArea = All;
                }
                field("Commission Type"; "Commission Type")
                {
                    ApplicationArea = All;
                }
                field("Commission Calculation Type"; "Commission Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("% age"; "% age")
                {
                    ApplicationArea = All;
                }
                field("Fixed Amount"; "Fixed Amount")
                {
                    ApplicationArea = All;
                }
                field(Underwriter; Underwriter)
                {
                    ApplicationArea = All;
                }
                field("Policy Type"; "Policy Type")
                {
                    ApplicationArea = All;
                }
                field("Target Premium"; "Target Premium")
                {
                    ApplicationArea = All;
                }
                
                field("Endorsement Types"; "Endorsement Types")
                {
                    ApplicationArea = All;
                }
                field("Target Period"; "Target Period")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
