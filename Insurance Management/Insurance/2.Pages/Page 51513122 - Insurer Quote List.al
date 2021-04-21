page 51513122 "Insurer Quote List"
{

    ApplicationArea = Basic, Suite, Service;
    Caption = 'Insurer Quote List';
    CardPageId = "Insurer Quote";
    PageType = List;
    SourceTable = "Insure Header";
    SourceTableView = sorting() where("Document Type" = const("Insurer Quotes"));
    UsageCategory = Lists;
    RefreshOnActivate=true;
    

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    //ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                   // ApplicationArea = All;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    //ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                   // ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    //ApplicationArea = All;
                }
                field("E-mail"; Rec."E-mail")
                {
                    //ApplicationArea = All;
                }
                
                field("Underwriter Code"; Rec.Underwriter)
                {
                    //ApplicationArea = All;
                }
                field("Underwriter Name"; Rec."Underwriter Name")
                {
                    //ApplicationArea = All;
                }
                
            }
        }

    }

}
