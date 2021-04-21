xmlport 51404086 "Interaction Escalation Levels"
{
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement(EscalSetup;"Temp Interactions Escal. Setup")
            {
                XmlName = 'InteractionType';
                fieldattribute(ChannelNo;EscalSetup."Channel No.")
                {
                }
               /* fieldattribute(LevelCode;EscalSetup."Level Code")
                {
                }
                fieldattribute(LevelDuration;EscalSetup."Level Duration - Hours")
                {
                }
                fieldattribute(Email;EscalSetup."Distribution E-mail for Level")
                {
                }*/
           
                trigger OnAfterInsertRecord()
                begin
                    CLEAR(RecHeader);
                    RecHeader.SETCURRENTKEY(RecHeader."Channel No.","Level Code");
                    RecHeader.SETRANGE("Channel No.",EscalSetup."Channel No.");
                   // RecHeader.SETRANGE("Level Code",EscalSetup. Setup"."Level Code");
                    IF NOT RecHeader.FIND('-') THEN BEGIN
                    REPEAT
                   //RecHeader.TRANSFERFIELDS(EscalSetup. Setup);
                     IF RecHeader.INSERT(TRUE) THEN
                     EscalSetup."Channel No.":=RecHeader."Channel No.";
                   // EscalSetup."Channel Name":=RecHeader."Channel Name";
                  //   "Temp Interactions Escal. Setup"."Level Code":=RecHeader."Level Code";
                    // "Temp Interactions Escal. Setup"."Level Duration - Hours":=RecHeader."Level Duration - Hours";
                   //  "Temp Interactions Escal. Setup"."Distribution E-mail for Level":=RecHeader."Distribution E-mail for Level";
                   // "Temp Interactions Escal. Setup".MODIFY;
                    UNTIL  RecHeader.NEXT=0
                    END;
                end;

                trigger OnBeforeInsertRecord()
                begin
                     /*
                     LineNo:=LineNo+100;
                    "Temp Interactions Escal. Setup"."Comment No":= LineNo;
                       */

                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        LineNo:=0;

        EscalSetup.DELETEALL;
    end;

    var
        Interact: Record 51404207;
        //NoseriesMgt: Codeunit 396;
        //ClientSetup: Record 51404045;
        //Header: Record 51405080;
        LineNo: Integer;
        RecHeader: Record 51404207;
        TempHeader: Record 51405290;

    //procedure GetHeader(CurrRec: Record 51405080)
    //begin
        //Header:=CurrRec;
      //  ;
    //end;
}

