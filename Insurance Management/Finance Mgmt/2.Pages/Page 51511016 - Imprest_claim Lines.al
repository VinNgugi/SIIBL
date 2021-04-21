page 51511016 "Imprest_claim Lines"
{
    // version FINANCE

    AutoSplitKey = true;
    PageType = ListPart;
    SourceTable = "Request Lines";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Transaction Type"; "Transaction Type")
                {
                }
                field(Type; Type)
                {
                    Visible = false;
                }
                field("Account No"; "Account No")
                {
                    Caption = 'Account No.';
                    Editable = false;
                }
                field("Travel Type"; "Travel Type")
                {
                }
                field(Destination; Destination)
                {
                }
                field("Destination Name"; "Destination Name")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Account Type"; "Account Type")
                {
                    Visible = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Global Dimension 3 Code"; "Global Dimension 3 Code")
                {
                    Visible = false;
                }
                field(Description; Description)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                    Editable = false;
                }
                field("USD Amount"; "USD Amount")
                {
                    Editable = false;
                }
                field("Unit Price"; "Unit Price")
                {
                }
                field(Quantity; Quantity)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Budgetted Amount"; "Budgetted Amount")
                {
                }
                field("Available Amount"; "Available Amount")
                {
                    Editable = false;
                }
                field("Current Budget"; "Current Budget")
                {
                    Visible = false;
                }
                field(Committment; Committment)
                {
                }
                field("Actual Spent"; "Actual Spent")
                {
                    Visible = true;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        /*IF (("P&E Admin" = '') AND ("Work Plan"='')) THEN BEGIN
        WorkEditable:=TRUE;
        PEEditable:=TRUE;
        END; */

    end;

    trigger OnAfterGetRecord()
    begin
        GLSetup.GET;
        "Current Budget" := GLSetup."Current Budget";

        IF "Imprest Purpose" = "Imprest Purpose"::DSA THEN
            CountyEditable := TRUE
        ELSE
            CountyEditable := FALSE;

        IF RequestHeader.GET("Document No") THEN BEGIN
            IF RequestHeader."Transaction Type" = 'ADVANCE' THEN BEGIN
                SeeAdvanceColumns := TRUE;
                SeeNoAdvanceColumns := FALSE;
            END;
            IF RequestHeader."Transaction Type" <> 'ADVANCE' THEN BEGIN
                SeeAdvanceColumns := FALSE;
                SeeNoAdvanceColumns := TRUE;
            END;
        END;
        //MESSAGE('%1',SeeNoAdvanceColumns);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        /*
        RequestHeader.SETRANGE(RequestHeader."No.","Document No");
         IF RequestHeader.Status<>RequestHeader.Status::Open THEN
         ERROR('You cannot modify this document at this stage');
        */

    end;

    trigger OnModifyRecord(): Boolean
    begin

        RequestHeader.SETRANGE(RequestHeader."No.", "Document No");
        IF RequestHeader.Status <> RequestHeader.Status::Open THEN
            ERROR('You cannot modify this document at this stage');


        IF "Imprest Purpose" = "Imprest Purpose"::DSA THEN
            CountyEditable := TRUE
        ELSE
            CountyEditable := FALSE;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        //WorkEditable:=TRUE;
        //PEEditable:=TRUE;
        IF "Imprest Purpose" = "Imprest Purpose"::DSA THEN
            CountyEditable := TRUE
        ELSE
            CountyEditable := FALSE;
    end;

    trigger OnOpenPage()
    begin
        IF "Imprest Purpose" = "Imprest Purpose"::DSA THEN
            CountyEditable := TRUE
        ELSE
            CountyEditable := FALSE;
    end;

    var
        RequestHeader: Record "Request Header";
        ReceiptHeader: Record 51511027;
        PEEditable: Boolean;
        WorkEditable: Boolean;
        GLSetup: Record "Cash Management Setup";
        CountyEditable: Boolean;
        SeeAdvanceColumns: Boolean;
        SeeNoAdvanceColumns: Boolean;
}

