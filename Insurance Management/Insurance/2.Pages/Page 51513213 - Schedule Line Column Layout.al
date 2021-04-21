page 51513213 "Schedule Line Column Layout"
{
    // version AES-INS 1.0

    AutoSplitKey = true;
    Caption = 'Column Layout';
    DataCaptionFields = "Column Layout Name";
    PageType = Worksheet;
    SourceTable = "Column Layout";

    layout
    {
        area(content)
        {
            field(CurrentColumnName; CurrentColumnName)
            {
                AssistEdit = false;
                Caption = 'Name';
                Lookup = true;
                TableRelation = "Column Layout Name".Name;

                trigger OnLookup(Var Text: Text): Boolean;
                begin
                    EXIT(AccSchedManagement.LookupColumnName(CurrentColumnName, Text));
                end;

                trigger OnValidate();
                begin
                    AccSchedManagement.CheckColumnName(CurrentColumnName);
                    CurrentColumnNameOnAfterValida;
                end;
            }
            repeater(Lines)
            {
                field("Line No."; "Line No.")
                {
                    Visible = false;
                }
                field("Column No."; "Column No.")
                {
                }
                field("Column Header"; "Column Header")
                {
                }
                field("Column Type"; "Column Type")
                {
                }
                field("Ledger Entry Type"; "Ledger Entry Type")
                {
                }
                field("Amount Type"; "Amount Type")
                {
                }
                field(Formula; Formula)
                {
                }
                field("Show Opposite Sign"; "Show Opposite Sign")
                {
                }
                field("Comparison Date Formula"; "Comparison Date Formula")
                {
                }
                field("Comparison Period Formula"; "Comparison Period Formula")
                {
                    Visible = false;
                }
                field(Show; Show)
                {
                }
                field("Rounding Factor"; "Rounding Factor")
                {
                }
                field("Business Unit Totaling"; "Business Unit Totaling")
                {
                    Visible = false;
                }
                field("Dimension 1 Totaling"; "Dimension 1 Totaling")
                {
                    Visible = false;

                    trigger OnLookup(Var Text: Text): Boolean;
                    begin
                        EXIT(LookUpDimFilter(1, Text));
                    end;
                }
                field("Dimension 2 Totaling"; "Dimension 2 Totaling")
                {
                    Visible = false;

                    trigger OnLookup(Var Text: Text): Boolean;
                    begin
                        EXIT(LookUpDimFilter(2, Text));
                    end;
                }
                field("Dimension 3 Totaling"; "Dimension 3 Totaling")
                {
                    Visible = false;

                    trigger OnLookup(Var Text: Text): Boolean;
                    begin
                        EXIT(LookUpDimFilter(3, Text));
                    end;
                }
                field("Dimension 4 Totaling"; "Dimension 4 Totaling")
                {
                    Visible = false;

                    trigger OnLookup(Var Text: Text): Boolean;
                    begin
                        EXIT(LookUpDimFilter(4, Text));
                    end;
                }
                field("Cost Center Totaling"; "Cost Center Totaling")
                {
                    Visible = false;

                    trigger OnLookup(Var Text: Text): Boolean;
                    var
                        CostCenter: Record 1112;
                    begin
                        EXIT(CostCenter.LookupCostCenterFilter(Text));
                    end;
                }
                field("Cost Object Totaling"; "Cost Object Totaling")
                {
                    Visible = false;

                    trigger OnLookup(Var Text: Text): Boolean;
                    var
                        CostObject: Record 1113;
                    begin
                        EXIT(CostObject.LookupCostObjectFilter(Text));
                    end;
                }
            }
        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        IF NOT DimCaptionsInitialized THEN
            DimCaptionsInitialized := TRUE;
    end;

    trigger OnOpenPage();
    begin
        AccSchedManagement.OpenColumns(CurrentColumnName, Rec);
    end;

    var
        AccSchedManagement: Codeunit 8;
        CurrentColumnName: Code[10];
        DimCaptionsInitialized: Boolean;

    local procedure CurrentColumnNameOnAfterValida();
    begin
        CurrPage.SAVERECORD;
        AccSchedManagement.SetColumnName(CurrentColumnName, Rec);
        CurrPage.UPDATE(FALSE);
    end;

    procedure SetColumnLayoutName(NewColumnName: Code[10]);
    begin
        CurrentColumnName := NewColumnName;
    end;
}

