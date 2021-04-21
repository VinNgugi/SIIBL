table 51513098 "Claim Reservation Header"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Document Date"; Date)
        {
        }
        field(3; "Creation Date"; Date)
        {
        }
        field(4; "Creation Time"; Time)
        {
        }
        field(5; "Reserve Amount"; Decimal)
        {
            CalcFormula = Sum("Claim Reservation Line"."Reserved Amount" WHERE("Claim Reservation No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Claim No."; Code[30])
        {
            TableRelation = Claim;

            trigger OnValidate();
            begin
                IF Claim.GET("Claim No.") THEN BEGIN
                    "Insurance Class" := Claim.Class;
                    "Main Class Code" := Claim.MainClasscode;
                    IF PolicyType.GET(Claim.Class) THEN
                        "Shortcut Dimension 3 Code" := PolicyType.Class;
                    //VALIDATE("Shortcut Dimension 3 Code");
                END;
            end;
        }
        field(7; "Claimant ID"; Integer)
        {
            TableRelation = "Claim Involved Parties"."Claim Line No." WHERE("Claim No." = FIELD("Claim No."));

            trigger OnValidate();
            begin
                IF ClaimParties.GET("Claim No.", "Claimant ID") THEN
                    "Claimant Name" := ClaimParties.Surname;
            end;
        }
        field(8; Posted; Boolean)
        {
            Editable = false;
        }
        field(9; "Posted By"; Code[80])
        {
            Editable = false;
        }
        field(10; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(11; "Currency Factor"; Decimal)
        {
        }
        field(12; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(13; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(14; "Dimension Set ID"; Integer)
        {
        }
        field(15; "No. Series"; Code[10])
        {
        }
        field(16; "Insurance Class"; Code[20])
        {
            Editable = false;
            TableRelation = "Policy Type";
        }
        field(17; "Revised Reserve Link"; Code[20])
        {
            TableRelation = "Claim Reservation Header" WHERE(Posted = CONST(true),
                                                              "Claim No." = FIELD("Claim No."),
                                                              "Claimant ID" = FIELD("Claimant ID"));

            trigger OnValidate();
            begin
                IF ReserveHead.GET("Revised Reserve Link") THEN BEGIN
                    CALCFIELDS("Reserve Amount");
                    ReserveHead.CALCFIELDS(ReserveHead."Reserve Amount");
                    "Previous Reserve Amount" := ReserveHead."Reserve Amount";
                    Difference := "Reserve Amount" - ReserveHead."Reserve Amount";
                    MODIFY;
                END;
            end;
        }
        field(18; "Previous Reserve Amount"; Decimal)
        {
        }
        field(19; Difference; Decimal)
        {
        }
        field(20; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(21; "No. Of Approvers"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(22; "Main Class Code"; Code[20])
        {
        }
        field(23; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(24; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(25; "Service Provider Type"; Option)
        {
            OptionCaption = '" ,Claimant,Law firms,Assessor,Garage,Law courts,Agent,Medical Practitioner,Investigator"';
            OptionMembers = " ",Claimant,"Law firms",Assessor,Garage,"Law courts",Agent,"Medical Practitioner",Investigator;
        }
        field(26; "Service Provider Code"; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = FIELD("Service Provider Type"));

            trigger OnValidate();
            begin
                IF Vend.GET("Service Provider Code") THEN BEGIN

                    "Service Provider Name" := Vend.Name;

                END;
            end;
        }
        field(27; "Invoice No."; Code[20])
        {
        }
        field(28; "Service Provider Name"; Text[80])
        {
            Editable = false;
        }
        field(29; "Claimant Name"; Text[80])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            InsSetup.GET;
            InsSetup.TESTFIELD(InsSetup."Claim Reservation Nos");
            NoSeriesMgt.InitSeries(InsSetup."Claim Reservation Nos", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        "Document Date" := WORKDATE;
        "Creation Date" := WORKDATE;
        "Creation Time" := TIME;
        IF UserSetupDetails.GET(USERID) THEN BEGIN
            "Shortcut Dimension 1 Code" := UserSetupDetails."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := UserSetupDetails."Global Dimension 2 Code";

        END;
        IF GetFilterClaimNo <> '' THEN
            VALIDATE("Claim No.", GetFilterClaimNo);

        IF GetFilterClaimantID <> 0 THEN
            VALIDATE("Claimant ID", GetFilterClaimantID);
        //IF ClaimLine.GET(GetFilterClaimNo,GetFilterClaimantID) THEN


    end;

    var
        DimMgt: Codeunit 408;
        SalesLinesExist: Boolean;
        InsSetup: Record "Insurance setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Claim: Record Claim;
        ReserveHead: Record "Claim Reservation Header";
        Vend: Record Vendor;
        ClaimParties: Record "Claim Involved Parties";
        PolicyType: Record "Policy Type";
        UserSetupDetails: Record "User Setup Details";
        ClaimLine: Record "Claim Involved Parties";

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
        IF "No." <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF SalesLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
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

    local procedure GetFilterClaimNo(): Code[20];
    begin
        IF GETFILTER("Claim No.") <> '' THEN
            IF GETRANGEMIN("Claim No.") = GETRANGEMAX("Claim No.") THEN
                EXIT(GETRANGEMAX("Claim No."));
    end;

    local procedure GetFilterClaimantID(): Integer;
    begin
        IF GETFILTER("Claimant ID") <> '' THEN
            IF GETRANGEMIN("Claimant ID") = GETRANGEMAX("Claimant ID") THEN
                EXIT(GETRANGEMAX("Claimant ID"));
    end;
}

