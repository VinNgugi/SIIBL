table 51511053 "User Posting SetUp"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "User ID"; Code[20])
        {
            TableRelation = User;

        }
        field(2; "Gen Jnl Template"; Code[20])
        {
            TableRelation = "Gen. Journal Batch"."Journal Template Name" where("Template Type" = const(General));
        }
        field(3; "Gen Jnl Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Gen Jnl Template"));
        }
        field(4; "Pymt Jnl Template"; Code[20])
        {
            TableRelation = "Gen. Journal Batch"."Journal Template Name" where("Template Type" = const(Payments));
        }
        field(5; "Pymt Jnl Batch"; Code[20])
        {
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Pymt Jnl Template"));
        }
    }

    keys
    {
        key(PK; "User ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}