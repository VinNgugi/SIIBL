table 51513445 "Endorsement Types"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Accounting Actions"; Option)
        {
            OptionCaption = '" ,Debit Note,Credit Note,Both,No Impact"';
            OptionMembers = " ","Debit Note","Credit Note",Both,"No Impact";
        }
        field(4; "Premium Calculation basis"; Option)
        {
            OptionMembers = " ","Pro-rata","Short term","Full Premium";
        }
        field(5; "Action Type"; Option)
        {
            OptionCaption = '" ,Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,Yellow Card,Additional Riders"';
            OptionMembers = " ",Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,"Yellow Card","Additional Riders";
        }
        field(6; "No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(7; "Policy Risk Actions"; Option)
        {
            OptionCaption = '" ,Cancel,Create New,Cancel and Create New,No Impact"';
            OptionMembers = " ",Cancel,"Create New","Cancel and Create New","No Impact";
        }
        field(8; "Certificate Actions"; Option)
        {
            OptionCaption = '" ,Cancel,Create New,Cancel and Create New,No Impact,Suspend"';
            OptionMembers = " ",Cancel,"Create New","Cancel and Create New","No Impact",Suspend;
        }
        field(9; "Charge for Cert Printing"; Boolean)
        {
        }
        field(10; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(11; "Yellow Card"; Boolean)
        {
        }
        field(12; "Requires Cancellation Reason"; Boolean)
        {
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
}

