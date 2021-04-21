page 51513106 "Insure Hist. Sell-to FactBox"
{
    // version AES-INS 1.0

    Caption = 'Sell-to Customer Sales History';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                Caption = 'Customer No.';

                trigger OnDrillDown();
                begin
                    ShowDetails;
                end;
            }
            field("No. Of Insure Quotes"; "No. Of Insure Quotes")
            {
                Caption = 'Quotes';
                DrillDownPageID = "Sales Quotes";
            }
            field("No. Of Vehicles"; "No. Of Vehicles")
            {
                Caption = 'No. Of vehicles';
                DrillDownPageID = "Blanket Sales Orders";
            }
            field("No. Of Active Policies"; "No. Of Active Policies")
            {
                Caption = 'Orders';
                DrillDownPageID = "Sales Order List";
            }
        }
    }

    actions
    {
    }

    local procedure ShowDetails();
    begin
        PAGE.RUN(PAGE::"Customer Card", Rec);
    end;
}

