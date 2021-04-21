page 51513104 "Product Selection"
{

    ApplicationArea = All;
    Caption = 'Product Selection';
    PageType = List;
    SourceTable = "Product multi selector";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(UnderWriter; Rec.UnderWriter)
                {
                    ApplicationArea = All;
                }
                field("Product Plan"; Rec."Product Plan")
                {
                    ApplicationArea = All;
                }
                field("Underwriter Name"; Rec."Underwriter Name")
                {
                    ApplicationArea = All;
                }
                field("Plan Name"; Rec."Plan Name")
                {
                    ApplicationArea = All;
                }
                field("Select for Quote"; Rec."Select for Quote")
                {
                    ApplicationArea = All;
                }
                field("Selected by Client"; Rec."Selected by Client")
                {
                    ApplicationArea = All;
                }
                field("Area Of Cover"; Rec."Area Of Cover")
                {
                    ApplicationArea = All;
                }
                field("Select Excess"; Rec."Select Excess")
                {
                    ApplicationArea = All;
                }
                field("Client Type"; Rec."Client Type")
                {
                    ApplicationArea = All;
                }
                field("Premium Frequency"; Rec."Premium Frequency")
                {
                    ApplicationArea = All;
                }
                field("Currency Desired"; Rec."Currency Desired")
                {
                    ApplicationArea = All;
                }
                field("Exchange Rate"; Rec."Exchange Rate")
                {
                    ApplicationArea = All;
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = All;
                }

                field("Cover Type"; Rec."Cover Type")
                {
                    ApplicationArea = All;
                }

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }

                field("Module Type"; Rec."Module Type")
                {
                    ApplicationArea = All;
                }
                field("No Of Employees Range"; Rec."No Of Employees Range")
                {
                    ApplicationArea = All;
                }
                field("No. Of Months"; Rec."No. Of Months")
                {
                    ApplicationArea = All;
                }

                field(Excess; Rec.Excess)
                {
                    ApplicationArea = All;
                }
                /*field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                }*/






            }


        }


    }
    actions
    {
        area(Navigation)
        {
            action("Select All")
            {
                Caption = 'Select All';
                Image = Email;

                trigger OnAction();
                begin
                    //DocPrint.EmailInsureHeader(Rec);
                    Prodselect.RESET;
                    Prodselect.CopyFilters(Rec);
                    IF Prodselect.FindFirst THEN
                        repeat
                            Prodselect."Select for Quote" := TRUE;
                            Prodselect.MODIFY;
                            MESSAGE('%1', Prodselect."Product Plan");
                        until Prodselect.Next() = 0;

                end;
            }
            action("Unselect All")
            {
                Caption = 'Unselect All';
                Image = Email;

                trigger OnAction();
                begin
                    //DocPrint.EmailInsureHeader(Rec);
                    Prodselect.RESET;
                    Prodselect.CopyFilters(Rec);
                    IF Prodselect.FindFirst THEN
                        repeat
                            Prodselect."Select for Quote" := FALSE;
                            Prodselect.MODIFY;
                            MESSAGE('%1', Prodselect."Product Plan");
                        until Prodselect.Next() = 0;

                end;
            }
        }
    }
    var
        Prodselect: Record "Product Multi Selector";
}



