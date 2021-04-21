page 51404511 "Policies Issued"
{

    ApplicationArea = All;
    Caption = 'Policies Issued';
    PageType = List;
    SourceTable = "Policies Issued";
    CardPageId = "Policy Issued Card";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Policy No."; Rec."Policy No.")
                {
                    ApplicationArea = All;
                }
                field("Issued Date"; Rec."Issued Date")
                {
                    ApplicationArea = All;
                }
                field("Issued Time"; Rec."Issued Time")
                {
                    ApplicationArea = All;
                }
                field("Issued by"; Rec."Issued by")
                {
                    ApplicationArea = All;
                }
                field("Name of Person picking"; Rec."Name of Person picking")
                {
                    ApplicationArea = All;
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
