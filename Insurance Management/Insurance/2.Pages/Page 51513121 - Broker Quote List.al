page 51513121 "Broker Quote List"
{

    ApplicationArea = All;
    Caption = 'Broker Quote List';
    PageType = List;
    SourceTable = "Insure Header";
    SourceTableView = WHERE("Document Type" = CONST(Quote), "Quote Type" = CONST(New));
    UsageCategory = Lists;
    CardPageId = "Broker Quote";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field("Contact No."; Rec."Contact No.")
                {
                    ApplicationArea = All;
                }
                field("Contact Name"; Rec."Contact Name")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                }
                field("E-mail"; Rec."E-mail")
                {
                    ApplicationArea = All;
                }
                field("Policy Class"; Rec."Policy Class")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

}
