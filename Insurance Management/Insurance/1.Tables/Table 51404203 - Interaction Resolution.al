table 51404203 "Interaction Resolution"
{
    // version AES-PAS 1.0

    // //

    //DrillDownPageID = 51404258;
   // LookupPageID = 51404258;

    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;Descriptionx;Text[80])
        {
            CalcFormula = Lookup("Interaction Type".Description WHERE ("No."=FIELD("Interaction No.")));
            FieldClass = FlowField;
        }
        field(3;Cause;Text[200])
        {
            CalcFormula = Lookup("Interaction Cause".Description WHERE ("No."=FIELD("Cause No.")));
            FieldClass = FlowField;
        }
        field(4;"Interaction No.";Code[10])
        {
            TableRelation = "Interaction Type";

            trigger OnValidate()
            begin
                recInteractionType.GET("Interaction No.");
                Descriptionx := recInteractionType.Description;
            end;
        }
        field(5;"Cause No.";Code[10])
        {
            TableRelation = "Interaction Cause" WHERE ("Interaction No."=FIELD("Interaction No."));

            trigger OnValidate()
            begin
                recInteractionCause.GET("Cause No.");
                Cause := recInteractionCause.Description;
            end;
        }
        field(14;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(15;Description;Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"No.","Cause No.","Interaction No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        IF "No." = '' THEN BEGIN
          IF recInteractionsSetup.FINDFIRST THEN BEGIN
             recInteractionsSetup.TESTFIELD(recInteractionsSetup."Interaction Resolution Nos.");
             NoSeriesMgt.InitSeries(recInteractionsSetup."Interaction Resolution Nos.",xRec."No. Series",0D, "No.","No. Series");
          END;
        END;
    end;

    var
        ComplaintSetup: Record "Interactions Setup";
        NoSeriesMgt: Codeunit 396;
        recInteractionType: Record "Interaction Type";
        recInteractionCause: Record "Interaction Cause";
        recInteractionsSetup: Record "Interactions Setup";

    procedure AssistEdit(OldReso: Record "Interaction Resolution"): Boolean
    var
        Reso: Record "Interaction Resolution";
    begin
    end;
}

