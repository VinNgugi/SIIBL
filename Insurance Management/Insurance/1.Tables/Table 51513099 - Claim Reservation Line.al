table 51513099 "Claim Reservation Line"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Claim Reservation No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = false;
        }
        field(3; Description; Text[250])
        {
        }
        field(4; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(5; Quantity; Decimal)
        {

            trigger OnValidate();
            begin
                "Reserved Amount" := Quantity * "Unit Price";
            end;
        }
        field(6; "Unit Price"; Decimal)
        {

            trigger OnValidate();
            begin
                "Reserved Amount" := Quantity * "Unit Price";
            end;
        }
        field(7; "Reserved Amount"; Decimal)
        {
        }
        field(8; "Claim No."; Code[20])
        {
        }
        field(9; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                //ATOLink.UpdateAsmDimFromSalesLine(Rec);
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                //ATOLink.UpdateAsmDimFromSalesLine(Rec);
            end;
        }
        field(11; "Dimension Set ID"; Integer)
        {
        }
        field(12; "Claim Amount"; Decimal)
        {
        }
        field(13; "Agreed Amount"; Decimal)
        {
        }
        field(14; "Invoice No."; Code[20])
        {
        }
        field(15; "Service Provider No."; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                IF Vend.GET("Service Provider No.") THEN BEGIN
                    "Service Provider Name" := Vend.Name;
                END;
            end;
        }
        field(16; "Service Provider Name"; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Claim Reservation No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF ClaimReserveHeader.GET("Claim Reservation No.") THEN BEGIN
            "Invoice No." := ClaimReserveHeader."Invoice No.";
            "Service Provider No." := ClaimReserveHeader."Service Provider Code";
            "Service Provider Name" := ClaimReserveHeader."Service Provider Name";

        END;
    end;

    var
        ClaimReportLines: Record "Claim Report lines";
        DimMgt: Codeunit 408;
        Vend: Record Vendor;
        ClaimReserveHeader: Record "Claim Reservation Header";

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20]);
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        IF (OldDimSetID <> "Dimension Set ID") AND ClaimReserveLinesExist THEN BEGIN
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        /*IF "No." <> '' THEN
          MODIFY;
        
        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
          MODIFY;
          IF SalesLinesExist THEN
            UpdateAllLineDim("Dimension Set ID",OldDimSetID);
        END;*/

    end;

    procedure ClaimReserveLinesExist(): Boolean;
    begin
        /*SalesLine.RESET;
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        EXIT(SalesLine.FINDFIRST);*/

    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer);
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.
        /*
        IF NewParentDimSetID = OldParentDimSetID THEN
          EXIT;
        IF NOT HideValidationDialog AND GUIALLOWED THEN
          IF NOT CONFIRM(Text064) THEN
            EXIT;
        
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type","Document Type");
        SalesLine.SETRANGE("Document No.","No.");
        SalesLine.LOCKTABLE;
        IF SalesLine.FIND('-') THEN
          REPEAT
            NewDimSetID := DimMgt.GetDeltaDimSetID(SalesLine."Dimension Set ID",NewParentDimSetID,OldParentDimSetID);
            IF SalesLine."Dimension Set ID" <> NewDimSetID THEN BEGIN
              SalesLine."Dimension Set ID" := NewDimSetID;
              DimMgt.UpdateGlobalDimFromDimSetID(
                SalesLine."Dimension Set ID",SalesLine."Shortcut Dimension 1 Code",SalesLine."Shortcut Dimension 2 Code");
              SalesLine.MODIFY;
              ATOLink.UpdateAsmDimFromSalesLine(SalesLine);
            END;
          UNTIL SalesLine.NEXT = 0;*/

    end;
}

