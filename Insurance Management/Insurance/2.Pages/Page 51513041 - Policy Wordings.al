page 51513041 "Policy Wordings"
{
    // version AES-INS 1.0

    PageType = List;
    SourceTable = "Insure Lines";
    UsageCategory=Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Description Type";
                "Description Type")
                {
                }
                field("Text Type"; "Text Type")
                {
                }
                field(Description; Description)
                {
                    Style = Strong;
                    StyleExpr = Isbold;
                }
                field("Actual Value"; "Actual Value")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        IsBold := FALSE;
        IF "Text Type" = "Text Type"::Bold THEN
            IsBold := TRUE;
    end;

    var
        IsBold: Boolean;
}

