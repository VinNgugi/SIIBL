table 51511042 Institutions
{
    // version FINANCE

    //DrillDownPageID = 51515526;
    //LookupPageID = 51515526;

    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; "Purchase Link"; Code[30])
        {
            TableRelation = "Receipts and Payment Types" WHERE(Type = CONST(Payment));
        }
        field(4; "Sale Link"; Code[30])
        {
            TableRelation = "Receipts and Payment Types" WHERE(Type = CONST(Receipt));
        }
        field(5; "Interest Link"; Code[30])
        {
            TableRelation = "Receipts and Payment Types" WHERE(Type = CONST(Receipt));
        }
        field(6; "Divident Link"; Code[30])
        {
            TableRelation = "Receipts and Payment Types" WHERE(Type = CONST(Receipt));
        }
        field(7; "Investment Posting Group"; Code[30])
        {
            TableRelation = "Investment Posting Groups".Code;
        }
        field(9; "Investment type"; Text[30])
        {
            TableRelation = "Investment Types";

            trigger OnValidate()
            begin
                IF InvestmentType.GET("Investment type") THEN
                    "Investment Type Name" := InvestmentType.Description;
            end;
        }
        field(10; "Investment Type Name"; Text[30])
        {
        }
        field(11; "Asset Type"; Option)
        {
            OptionCaption = ',Equity,Money Market';
            OptionMembers = ,Equity,"Money Market";
        }
        field(12; "Search Name"; Text[30])
        {
        }
        field(13; "Current Mkt Price"; Decimal)
        {
        }
        field(14; "Mkt Price date"; Date)
        {
        }
        field(15; Address; Text[50])
        {
        }
        field(16; Status; Option)
        {
            OptionCaption = 'Open,1st Approval,2nd Approval,Approved';
            OptionMembers = Open,"1st Approval","2nd Approval",Approved;
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

    var
        InvestmentType: Record "Investment Types";
}

