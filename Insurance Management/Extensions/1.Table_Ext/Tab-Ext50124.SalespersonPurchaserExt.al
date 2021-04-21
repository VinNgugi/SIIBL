tableextension 50124 "Salesperson/Purchaser Ext" extends "Salesperson/Purchaser"
{
    fields
    {
        field(50100; "Vendor Acc Created"; Boolean)
        {
            Caption = 'Vendor Acc Created';
            DataClassification = ToBeClassified;
        }
    }
    procedure FnCreateVendorAccount()
    var
        ObjVend: Record Vendor;
        InsSetup: Record "Insurance setup";

    begin
        if "Vendor Acc Created" = false then begin
            if not ObjVend.Get(Code) then begin
                with ObjVend do begin
                    InsSetup.Get();
                    Init();
                    "No." := Code;
                    Name := Rec.Name;
                    "Name 2" := Rec.Name;
                    "Phone No." := Rec."Phone No.";
                    "E-Mail" := Rec."E-Mail";
                    "E-Mail 2" := Rec."E-Mail 2";
                    "Global Dimension 1 Code" := Rec."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Rec."Global Dimension 2 Code";
                    "Vendor Posting Group" := InsSetup."Default Agent PG";
                    "Vendor Type" := "Vendor Type"::Agent;
                    if Insert() then
                        "Vendor Acc Created" := true;
                end;
            end;
        end;

    end;
}
