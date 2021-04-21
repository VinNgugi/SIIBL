page 51513144 "Copy Insurance Product"
{
    Caption = 'Copy Product';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Copy Insurance Product Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(SourceItemNo; "Source Insurer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Source Insurer No.';
                    Editable = false;
                    Lookup = true;
                    TableRelation = "Underwriter Policy Types"."Underwriter Code";
                    ToolTip = 'Specifies the number of the Insurer that you want to copy the data from.';
                }
                field(TargetInsurerNo; "Target Insurer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Target Insurer No.';
                    ToolTip = 'Specifies the number of the new Insurer that you want to copy the data to. \\To generate the new item number from a number series, fill in the Target No. Series field instead.';
                    TableRelation=Vendor where("Vendor Type"=CONST(Insurer));
                }
                    
                    
                    field(SourceProdCode; "Source Product Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Source Product Code';
                    Editable = false;
                    Lookup = true;
                    TableRelation = "Underwriter Policy Types"."Code";
                    ToolTip = 'Specifies the number of the Product that you want to copy the data from.';
                }
                field(TargetProdCode; "Target Product Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Target Insurer No.';
                    ToolTip = 'Specifies the number of the new Product Code that you want to copy the data to. \\To generate the new item number from a number series, fill in the Target No. Series field instead.';
                    //TableRelation=Vendor where("Vendor Type"=CONST(Insurer));
                    
                    
                    
                }
                   
                
                
                
                
            }
        }
    
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
       // InitCopyInsureProdBuffer();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then
            ValidateUserInput;
    end;

    var
        SourceInsureProd: Record "Underwriter Policy Types";
        TempInsureProd: Record "Underwriter Policy Types" temporary;
        //InventorySetup: Record "Inventory Setup";
        CopyInsProdParameters: Record "Copy Insure Product Parameter";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        SpecifyTargetItemNoErr: Label 'You must specify the target Insurer number.';
        TargetItemDoesNotExistErr: Label 'Target Insurer number %1 already exists.', Comment = '%1 - item number.';
        TargetItemNoTxt: Label 'Target Insurer No.';
        UnincrementableStringErr: Label 'The value in the %1 field must have a number so that we can assign the next number in the series.', Comment = '%1 = New Field Name';

    procedure GetParameters(var CopyInsProdBuffer: Record "Copy Insurance Product Buffer")
    begin
        CopyInsProdBuffer := Rec;
    end;

    local procedure InitCopyInsProdBuffer()
    begin
        Init();
        if CopyInsProdParameters.Get(UserId()) then
            TransferFields(CopyInsProdParameters)
        else begin
            //"Number of Copies" := 1;
            //InventorySetup.Get();
            //"Target No. Series" := InventorySetup."Item Nos.";
        end;
        "Source Insurer No." := TempInsureProd."Underwriter Code";
        Insert();

        OnAfterInitCopyInsureProdBuffer(Rec);
    end;

    local procedure ValidateUserInput()
    var
        Item: Record "Underwriter Policy Types";
        CurrUserId: Code[80];
    begin
        CheckTargetInsureNo;

        if ("Target Insurer No." = '') then
            Error(SpecifyTargetItemNoErr);

        CurrUserId := CopyStr(UserId(), 1, MaxStrLen(CopyInsProdParameters."User ID"));
        if CopyInsProdParameters.Get(CurrUserId) then begin
            CopyInsProdParameters.TransferFields(Rec);
            CopyInsProdParameters.Modify();
        end else begin
            CopyInsProdParameters.Init();
            CopyInsProdParameters.TransferFields(Rec);
            CopyInsProdParameters."User ID" := CurrUserId;
            CopyInsProdParameters.Insert();
        end;

        OnAfterValidateUserInput(Rec);
    end;

    procedure SetInsureProd(var InsureProd2: Record "Underwriter Policy Types")
    begin
        TempInsureProd := InsureProd2;
    end;

    local procedure CheckTargetInsureNo()
    begin
       
    end;

    local procedure CheckExistingInsureProd(Var InsurerNo: Code[20];var ProdCode:Code[20] )
    var
        InsureProd: Record "Underwriter Policy Types";
    begin
        if InsureProd.Get(ProdCode,InsurerNo) then
            Error(TargetItemDoesNotExistErr, Prodcode);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCopyInsureProdBuffer(var CopyInsureProdBuffer: Record "Copy Insurance Product Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateUserInput(var CopyInsureProdBuffer: Record "Copy Insurance Product Buffer")
    begin
    end;
}