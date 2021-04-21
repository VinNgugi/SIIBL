pageextension 50104 "Contact Card Ext" extends "Contact Card"
{
    actions
    {
        modify(NewSalesQuote)
        {
            Promoted = false;
            Visible = false;
        }
        modify(SalesQuotes)
        {
            Promoted = false;
            Visible = false;
        }
    }
}
