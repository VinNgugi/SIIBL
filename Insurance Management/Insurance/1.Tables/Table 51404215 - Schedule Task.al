table 51404215 "Schedule Task"
{
    // version Scheduler

    // 
    // Object ID to Run - OnLookup()
    // IF Object.GET("Object Type to Run",'',"Object ID to Run") THEN;
    // Object.FILTERGROUP(2);
    // Object.SETRANGE(Type,"Object Type to Run");
    // Object.FILTERGROUP(0);
    // Objects.SETRECORD(Object);
    // Objects.SETTABLEVIEW(Object);
    // Objects.LOOKUPMODE := TRUE;
    // IF Objects.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //   Objects.GETRECORD(Object);
    //   VALIDATE("Object ID to Run",Object.ID);
    // END;
    // 
    // NameDataTypeSubtypeLength
    // ObjectRecordObject
    // ObjectsFormObjects

    Caption = 'Schedule Task';

    fields
    {
        field(10;"Schedule Group No.";Code[20])
        {
            Caption = 'Schedule Group No.';
            TableRelation = "Schedule Group"."No.";
        }
        field(20;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(30;"Object Type";Option)
        {
            Caption = 'Object Type';
            OptionCaption = 'Report,Dataport,Codeunit';
            OptionMembers = "Report",Dataport,"Codeunit";

            trigger OnValidate()
            begin
                CLEAR("Object ID");
                CLEAR(Description);
            end;
        }
        field(40;"Object ID";Integer)
        {
            Caption = 'Object ID';

            trigger OnLookup()
            var
                lrecObject: Record Object;
                lfrmObjects: Page 358;
            begin
                lrecObject.FILTERGROUP(2);
                CASE "Object Type" OF
                   "Object Type"::Report   : lrecObject.SETRANGE(Type,lrecObject.Type::Report);
                  // "Object Type"::Dataport : lrecObject.SETRANGE(Type,lrecObject.Type::Dataport);
                   "Object Type"::Codeunit : lrecObject.SETRANGE(Type,lrecObject.Type::Codeunit);
                END;
                lrecObject.FILTERGROUP(0);
                lfrmObjects.SETRECORD(lrecObject);
                lfrmObjects.SETTABLEVIEW(lrecObject);
                lfrmObjects.LOOKUPMODE := TRUE;
                IF (lfrmObjects.RUNMODAL = ACTION::LookupOK) THEN
                BEGIN
                   lfrmObjects.GETRECORD(lrecObject);
                   VALIDATE("Object ID",lrecObject.ID);
                END;
            end;

            trigger OnValidate()
            var
                lrecObject: Record Object;
            begin
                CLEAR(Description);
                CASE "Object Type" OF
                   "Object Type"::Report   : lrecObject.SETRANGE(Type,lrecObject.Type::Report);
                   //"Object Type"::Dataport : lrecObject.SETRANGE(Type,lrecObject.Type::Dataport);
                   "Object Type"::Codeunit : lrecObject.SETRANGE(Type,lrecObject.Type::Codeunit);
                END;
                lrecObject.SETRANGE(ID,"Object ID");

                IF lrecObject.FIND('-') THEN
                   Description := lrecObject.Name;
            end;
        }
        field(50;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(60;Enabled;Boolean)
        {
            Caption = 'Enabled';
        }
        field(70;"Parameter 1";Text[250])
        {
            Caption = 'Parameter 1';
        }
        field(80;"Parameter 2";Text[250])
        {
            Caption = 'Parameter 2';
        }
        field(90;"Parameter 3";Text[250])
        {
            Caption = 'Parameter 3';
        }
        field(100;"Parameter 4";Text[250])
        {
            Caption = 'Parameter 4';
        }
        field(110;"Parameter 5";Text[250])
        {
            Caption = 'Parameter 5';
        }
        field(120;"Parameter 6";Text[250])
        {
            Caption = 'Parameter 6';
        }
        field(130;"Parameter 7";Text[250])
        {
            Caption = 'Parameter 7';
        }
        field(140;"Parameter 8";Text[250])
        {
            Caption = 'Parameter 8';
        }
        field(150;"Parameter 9";Text[250])
        {
            Caption = 'Parameter 9';
        }
        field(160;"Parameter 10";Text[250])
        {
            Caption = 'Parameter 10';
        }
    }

    keys
    {
        key(Key1;"Schedule Group No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

