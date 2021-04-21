table 51513461 "Schedule Line Columns"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Column Layout Name"; Code[10])
        {
            Caption = 'Column Layout Name';
            TableRelation = "Column Layout Name";
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Column No."; Code[10])
        {
            Caption = 'Column No.';
        }
        field(4; "Column Header"; Text[30])
        {
            Caption = 'Column Header';
        }
        field(5; "Column Type"; Option)
        {
            Caption = 'Column Type';
            InitValue = "Net Change";
            OptionCaption = 'Formula,Net Change,Balance at Date,Beginning Balance,Year to Date,Rest of Fiscal Year,Entire Fiscal Year';
            OptionMembers = Formula,"Net Change","Balance at Date","Beginning Balance","Year to Date","Rest of Fiscal Year","Entire Fiscal Year";
        }
        field(6; "Ledger Entry Type"; Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = 'Entries,Budget Entries';
            OptionMembers = Entries,"Budget Entries";
        }
        field(7; "Amount Type"; Option)
        {
            Caption = 'Amount Type';
            OptionCaption = 'Net Amount,Debit Amount,Credit Amount';
            OptionMembers = "Net Amount","Debit Amount","Credit Amount";
        }
        field(8; Formula; Code[80])
        {
            Caption = 'Formula';

            trigger OnValidate();
            begin
                AccSchedLine.CheckFormula(Formula);
            end;
        }
        field(9; "Comparison Date Formula"; DateFormula)
        {
            Caption = 'Comparison Date Formula';

            trigger OnValidate();
            begin
                IF FORMAT("Comparison Date Formula") <> '' THEN
                    VALIDATE("Comparison Period Formula", '');
            end;
        }
        field(10; "Show Opposite Sign"; Boolean)
        {
            Caption = 'Show Opposite Sign';
        }
        field(11; Show; Option)
        {
            Caption = 'Show';
            InitValue = Always;
            NotBlank = true;
            OptionCaption = 'Always,Never,When Positive,When Negative';
            OptionMembers = Always,Never,"When Positive","When Negative";
        }
        field(12; "Rounding Factor"; Option)
        {
            Caption = 'Rounding Factor';
            OptionCaption = 'None,1,1000,1000000';
            OptionMembers = "None","1","1000","1000000";
        }
        field(14; "Comparison Period Formula"; Code[20])
        {
            Caption = 'Comparison Period Formula';

            trigger OnValidate();
            var
                Steps: Integer;
                RangeFromInt: Integer;
                RangeToInt: Integer;
                Type: Option " ",Period,"Fiscal year","Fiscal Halfyear","Fiscal Quarter";
                RangeFromType: Option Int,CP,LP;
                RangeToType: Option Int,CP,LP;
            begin
                ParsePeriodFormula(
                  "Comparison Period Formula",
                  Steps, Type, RangeFromType, RangeToType, RangeFromInt, RangeToInt);
                IF "Comparison Period Formula" <> '' THEN
                    CLEAR("Comparison Date Formula");
            end;
        }
        field(15; "Business Unit Totaling"; Text[80])
        {
            Caption = 'Business Unit Totaling';
            TableRelation = "Business Unit";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(16; "Dimension 1 Totaling"; Text[80])
        {
            AccessByPermission = TableData 348 = R;
            CaptionClass = GetCaptionClass(5);
            Caption = 'Dimension 1 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;
        }
        field(17; "Dimension 2 Totaling"; Text[80])
        {
            AccessByPermission = TableData 348 = R;
            CaptionClass = GetCaptionClass(6);
            Caption = 'Dimension 2 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;
        }
        field(18; "Dimension 3 Totaling"; Text[80])
        {
            AccessByPermission = TableData 350 = R;
            CaptionClass = GetCaptionClass(7);
            Caption = 'Dimension 3 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            // ValidateTableRelation = false;
        }
        field(19; "Dimension 4 Totaling"; Text[80])
        {
            AccessByPermission = TableData 350 = R;
            CaptionClass = GetCaptionClass(8);
            Caption = 'Dimension 4 Totaling';
            //This property is currently not supported
            //TestTableRelation = false;
            //ValidateTableRelation = false;
        }
        field(20; "Cost Center Totaling"; Text[80])
        {
            Caption = 'Cost Center Totaling';
        }
        field(21; "Cost Object Totaling"; Text[80])
        {
            Caption = 'Cost Object Totaling';
        }
        field(22; "Schedule Name"; Code[10])
        {
            TableRelation = "Acc. Schedule Name";
        }
        field(23; "Schedule Line No."; Integer)
        {
            TableRelation = "Acc. Schedule Line"."Line No.";
        }
    }

    keys
    {
        key(Key1; "Schedule Name", "Schedule Line No.", "Column Layout Name", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ColumnLayoutName: Record "Column Layout Name";
        AnalysisView: Record "Analysis View";
        GLSetup: Record "General Ledger Setup";
        HasGLSetup: Boolean;
        AccSchedLine: Record "Acc. Schedule Line";
        Text001: Label '%1 is not a valid Period Formula';
        Text002: Label 'P';
        Text003: Label 'FY';
        Text004: Label 'CP';
        Text005: Label 'LP';
        Text006: Label '1,6,,Dimension 1 Filter';
        Text007: Label '1,6,,Dimension 2 Filter';
        Text008: Label '1,6,,Dimension 3 Filter';
        Text009: Label '1,6,,Dimension 4 Filter';
        Text010: Label ',, Totaling';
        Text011: Label '1,5,,Dimension 1 Totaling';
        Text012: Label '1,5,,Dimension 2 Totaling';
        Text013: Label '1,5,,Dimension 3 Totaling';
        Text014: Label '1,5,,Dimension 4 Totaling';
        Text015: Label 'The %1 refers to %2 %3, which does not exist. The field %4 on table %5 has now been deleted.';

    procedure ParsePeriodFormula(Formula: Code[20]; var Steps: Integer; var Type: Option " ",Period,"Fiscal Year"; var RangeFromType: Option Int,CP,LP; var RangeToType: Option Int,CP,LP; var RangeFromInt: Integer; var RangeToInt: Integer);
    var
        OriginalFormula: Code[20];
    begin
        // <PeriodFormula> ::= <signed integer> <formula> | blank
        // <signed integer> ::= <sign> <positive integer> | blank
        // <sign> ::= + | - | blank
        // <positive integer> ::= <digit 1-9> <digits>
        // <digit 1-9> ::= 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
        // <digits> ::= 0 <digits> | <digit 1-9> <digits> | blank
        // <formula> ::= P | FY <range> | FH <range> | FQ <range>
        // <range> ::= blank | [<range2>]
        // <range2> ::= <index> .. <index> | <index>
        // <index> ::= <positive integer> | CP | LP

        OriginalFormula := Formula;
        Formula := DELCHR(Formula);

        IF NOT ParseFormula(Formula, Steps, Type) THEN
            ERROR(Text001, OriginalFormula);

        IF Type = Type::"Fiscal Year" THEN
            IF NOT ParseRange(Formula, RangeFromType, RangeFromInt, RangeToType, RangeToInt) THEN
                ERROR(Text001, OriginalFormula);

        IF Formula <> '' THEN
            ERROR(Text001, OriginalFormula);
    end;

    local procedure ParseFormula(var Formula: Code[20]; var Steps: Integer; var Type: Option " ",Period,"Fiscal year","Fiscal Halfyear","Fiscal Quarter"): Boolean;
    begin
        Steps := 0;
        Type := Type::" ";

        IF Formula = '' THEN
            EXIT(TRUE);

        IF NOT ParseSignedInteger(Formula, Steps) THEN
            EXIT(FALSE);

        IF Formula = '' THEN
            EXIT(FALSE);

        IF NOT ParseType(Formula, Type) THEN
            EXIT(FALSE);

        EXIT(TRUE);
    end;

    local procedure ParseSignedInteger(var Formula: Code[20]; var Int: Integer): Boolean;
    begin
        Int := 0;

        CASE COPYSTR(Formula, 1, 1) OF
            '-':
                BEGIN
                    Formula := COPYSTR(Formula, 2);
                    IF NOT ParseInt(Formula, Int, FALSE) THEN
                        EXIT(FALSE);
                    Int := -Int;
                END;
            '+':
                BEGIN
                    Formula := COPYSTR(Formula, 2);
                    IF NOT ParseInt(Formula, Int, FALSE) THEN
                        EXIT(FALSE);
                END;
            ELSE BEGIN
                    IF NOT ParseInt(Formula, Int, TRUE) THEN
                        EXIT(FALSE);
                END;
        END;
        EXIT(TRUE);
    end;

    local procedure ParseInt(var Formula: Code[20]; var Int: Integer; AllowNotInt: Boolean): Boolean;
    var
        IntegerStr: Code[20];
    begin
        IF COPYSTR(Formula, 1, 1) IN ['1' .. '9'] THEN
            REPEAT
                IntegerStr := IntegerStr + COPYSTR(Formula, 1, 1);
                Formula := COPYSTR(Formula, 2);
                IF Formula = '' THEN
                    EXIT(FALSE);
            UNTIL NOT (COPYSTR(Formula, 1, 1) IN ['0' .. '9'])
        ELSE
            EXIT(AllowNotInt);
        EVALUATE(Int, IntegerStr);
        EXIT(TRUE);
    end;

    local procedure ParseType(var Formula: Code[20]; var Type: Option " ",Period,"Fiscal Year"): Boolean;
    begin
        CASE ReadToken(Formula) OF
            Text002:
                Type := Type::Period;
            Text003:
                Type := Type::"Fiscal Year";
            ELSE
                EXIT(FALSE);
        END;
        EXIT(TRUE);
    end;

    local procedure ParseRange(var Formula: Code[20]; var FromType: Option Int,CP,LP; var FromInt: Integer; var ToType: Option Int,CP,LP; var ToInt: Integer): Boolean;
    begin
        FromType := FromType::CP;
        ToType := ToType::CP;

        IF Formula = '' THEN
            EXIT(TRUE);

        IF NOT ParseToken(Formula, '[') THEN
            EXIT(FALSE);

        IF NOT ParseIndex(Formula, FromType, FromInt) THEN
            EXIT(FALSE);
        IF Formula = '' THEN
            EXIT(FALSE);

        IF COPYSTR(Formula, 1, 1) = '.' THEN BEGIN
            IF NOT ParseToken(Formula, '..') THEN
                EXIT(FALSE);
            IF NOT ParseIndex(Formula, ToType, ToInt) THEN
                EXIT(FALSE);
        END ELSE BEGIN
            ToType := FromType;
            ToInt := FromInt;
        END;

        IF NOT ParseToken(Formula, ']') THEN
            EXIT(FALSE);

        EXIT(TRUE);
    end;

    local procedure ParseIndex(var Formula: Code[20]; var IndexType: Option Int,CP,LP; var Index: Integer): Boolean;
    begin
        IF Formula = '' THEN
            EXIT(FALSE);

        IF ParseInt(Formula, Index, FALSE) THEN
            IndexType := IndexType::Int
        ELSE
            CASE ReadToken(Formula) OF
                Text004:
                    IndexType := IndexType::CP;
                Text005:
                    IndexType := IndexType::LP;
                ELSE
                    EXIT(FALSE);
            END;

        EXIT(TRUE);
    end;

    local procedure ParseToken(var Formula: Code[20]; Token: Code[20]): Boolean;
    begin
        IF COPYSTR(Formula, 1, STRLEN(Token)) <> Token THEN
            EXIT(FALSE);
        Formula := COPYSTR(Formula, STRLEN(Token) + 1);
        EXIT(TRUE)
    end;

    local procedure ReadToken(var Formula: Code[20]): Code[20];
    var
        Token: Code[20];
        p: Integer;
    begin
        FOR p := 1 TO STRLEN(Formula) DO BEGIN
            IF COPYSTR(Formula, p, 1) IN ['[', ']', '.'] THEN BEGIN
                Formula := COPYSTR(Formula, STRLEN(Token) + 1);
                EXIT(Token);
            END;
            Token := Token + COPYSTR(Formula, p, 1);
        END;

        Formula := '';
        EXIT(Token);
    end;

    procedure LookUpDimFilter(DimNo: Integer; var Text: Text[250]): Boolean;
    var
        DimVal: Record "Dimension Value";
        CostAccSetup: Record "Cost Accounting Setup";
        DimValList: Page "Dimension Value List";
    begin
        GetColLayoutSetup;
        IF CostAccSetup.GET THEN;
        CASE DimNo OF
            1:
                DimVal.SETRANGE("Dimension Code", AnalysisView."Dimension 1 Code");
            2:
                DimVal.SETRANGE("Dimension Code", AnalysisView."Dimension 2 Code");
            3:
                DimVal.SETRANGE("Dimension Code", AnalysisView."Dimension 3 Code");
            4:
                DimVal.SETRANGE("Dimension Code", AnalysisView."Dimension 4 Code");
            5:
                DimVal.SETRANGE("Dimension Code", CostAccSetup."Cost Center Dimension");
            6:
                DimVal.SETRANGE("Dimension Code", CostAccSetup."Cost Object Dimension");
        END;
        DimValList.LOOKUPMODE(TRUE);
        DimValList.SETTABLEVIEW(DimVal);
        IF DimValList.RUNMODAL = ACTION::LookupOK THEN BEGIN
            DimValList.GETRECORD(DimVal);
            Text := DimValList.GetSelectionFilter;
            EXIT(TRUE);
        END;
        EXIT(FALSE)
    end;

    local procedure GetCaptionClass(AnalysisViewDimType: Integer): Text[250];
    begin
        GetColLayoutSetup;
        CASE AnalysisViewDimType OF
            1:
                BEGIN
                    IF AnalysisView."Dimension 1 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 1 Code");

                    EXIT(Text006);
                END;
            2:
                BEGIN
                    IF AnalysisView."Dimension 2 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 2 Code");

                    EXIT(Text007);
                END;
            3:
                BEGIN
                    IF AnalysisView."Dimension 3 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 3 Code");

                    EXIT(Text008);
                END;
            4:
                BEGIN
                    IF AnalysisView."Dimension 4 Code" <> '' THEN
                        EXIT('1,6,' + AnalysisView."Dimension 4 Code");

                    EXIT(Text009);
                END;
            5:
                BEGIN
                    IF AnalysisView."Dimension 1 Code" <> '' THEN
                        EXIT('1,5,' + AnalysisView."Dimension 1 Code" + Text010);

                    EXIT(Text011);
                END;
            6:
                BEGIN
                    IF AnalysisView."Dimension 2 Code" <> '' THEN
                        EXIT('1,5,' + AnalysisView."Dimension 2 Code" + Text010);

                    EXIT(Text012);
                END;
            7:
                BEGIN
                    IF AnalysisView."Dimension 3 Code" <> '' THEN
                        EXIT('1,5,' + AnalysisView."Dimension 3 Code" + Text010);

                    EXIT(Text013);
                END;
            8:
                BEGIN
                    IF AnalysisView."Dimension 4 Code" <> '' THEN
                        EXIT('1,5,' + AnalysisView."Dimension 4 Code" + Text010);

                    EXIT(Text014);
                END;
        END;
    end;

    local procedure GetColLayoutSetup();
    begin
        IF "Column Layout Name" <> ColumnLayoutName.Name THEN
            ColumnLayoutName.GET("Column Layout Name");
        IF ColumnLayoutName."Analysis View Name" <> '' THEN
            IF ColumnLayoutName."Analysis View Name" <> AnalysisView.Code THEN
                IF NOT AnalysisView.GET(ColumnLayoutName."Analysis View Name") THEN BEGIN
                    MESSAGE(
                      Text015,
                      ColumnLayoutName.TABLECAPTION, AnalysisView.TABLECAPTION, ColumnLayoutName."Analysis View Name",
                      ColumnLayoutName.FIELDCAPTION("Analysis View Name"), ColumnLayoutName.TABLECAPTION);
                    ColumnLayoutName."Analysis View Name" := '';
                    ColumnLayoutName.MODIFY;
                END;

        IF ColumnLayoutName."Analysis View Name" = '' THEN BEGIN
            IF NOT HasGLSetup THEN BEGIN
                GLSetup.GET;
                HasGLSetup := TRUE;
            END;
            CLEAR(AnalysisView);
            AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
            AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
        END;
    end;

    procedure GetPeriodName(): Code[10];
    begin
        EXIT(Text002);
    end;
}

