table 51511020 "PE Temp Approval"
{
    // version FINANCE


    fields
    {
        field(1; "Code"; Code[30])
        {
        }
        field(2; Description; Text[250])
        {
        }
        field(3; Date; Date)
        {
        }
        field(4; "Employee No"; Code[30])
        {
            TableRelation = Employee WHERE(Status = FILTER(Active));
        }
        field(5; "Doc Request No"; Code[30])
        {
            TableRelation = IF ("Document Type" = FILTER(Imprest)) "Request Header" WHERE("Employee No" = FIELD("Employee No"),
                                                                                       Posted = FILTER(false),
                                                                                       Type = FILTER(Imprest),
                                                                                       Status = FILTER(Open))
            ELSE
            IF ("Document Type" = FILTER(PettyCash)) "Request Header" WHERE("Employee No" = FIELD("Employee No"),
                                                                                                                                                         Posted = FILTER(false),
                                                                                                                                                         Type = FILTER(PettyCash),
                                                                                                                                                         Status = FILTER(Open));
        }
        field(6; Approved; Boolean)
        {

            trigger OnValidate()
            begin
                "Date Approved" := TODAY;
                "Approved By" := USERID;
            end;
        }
        field(7; "Date Approved"; Date)
        {
        }
        field(8; "Approved By"; Code[90])
        {
        }
        field(9; "PE Code"; Code[50])
        {

            trigger OnLookup()
            begin
                /*GLSetup.GET;
                
                 PEAdmin.RESET;
                 PEAdmin.SETRANGE(PEAdmin.Code,GLSetup."Current Budget");
                 PAGE.RUN(51511971,PEAdmin);
                //IF PAGE.RUNMODAL(51511971,PEAdmin)=ACTION::LookupOK THEN BEGIN//END;
                */

                /*PEAdmin.RESET;
                PEAdmin.SETRANGE(PEAdmin.Code,GLSetup."Current Budget");
                IF PEAdmin.Find('-') THEN*/

                PAGE.RUN(51511962);

            end;
        }
        field(10; Archived; Boolean)
        {
        }
        field(11; "User ID"; Code[90])
        {
        }
        field(12; "Document Type"; Option)
        {
            OptionCaption = ' ,Imprest,PettyCash,Purchase Requisition';
            OptionMembers = " ",Imprest,PettyCash,"Purchase Requisition";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Date := TODAY;
        "User ID" := USERID;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        //PEAdmin: Record "Procurement Plan Header";
}

