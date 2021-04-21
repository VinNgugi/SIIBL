pageextension 50103 "Opportunity Card Ext" extends "Opportunity Card"
{
    layout
    {
        addlast(General)
        {
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {

            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {

            }
            field("Shortcut Dimension 3 Code"; "Shortcut Dimension 3 Code")
            {

            }
            field("Insurance Type"; "Insurance Type")
            {

            }
            field("Business Type"; "Business Type")
            {

            }
            field("Sum Insured"; "Sum Insured")
            {

            }
            field("Premium Amount"; "Premium Amount")
            {

            }
            field("Commission Amount"; "Commission Amount")
            {

            }

        }
    }
    actions
    {
        modify(CreateSalesQuote)
        {
            Promoted = false;
            Visible = false;
        }
        modify("Show Sales Quote")
        {
            Promoted = false;
            Visible = false;
        }

        addafter(CreateSalesQuote)
        {
            action("Create Insurance Quote")
            {
                Caption = 'Create Insurance Quote';
                trigger OnAction()
                var

                begin
                    //CUBrokerMgmt.FnCreateInsurerQuote();
                end;
            }
        }
    }
    var
        CUBrokerMgmt: Codeunit "Broker Management";
}
