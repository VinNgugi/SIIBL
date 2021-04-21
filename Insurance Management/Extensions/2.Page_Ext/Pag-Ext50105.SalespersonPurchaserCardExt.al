pageextension 50105 "Salesperson/Purchaser Card Ext" extends "Salesperson/Purchaser Card"
{
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
    begin
        if not "Vendor Acc Created" then begin
            FnCreateVendorAccount();
        end;
    end;
}
