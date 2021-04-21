page 51513114 "Policy Instalments"
{
    // version AES-INS 1.0

    DataCaptionFields = "Policy Type", "No. Of Instalments";
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Policy Instalments";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No. Of Instalments"; "No. Of Instalments")
                {
                }
                field(Description; Description)
                {
                }
                field("% Loading"; "% Loading")
                {
                }
                field("% Discount"; "% Discount")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Create Instalments")
            {
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    InsMgt.CreateClassInstalmentRatio(Rec);
                end;
            }
            action("Instalments & Ratio")
            {
                RunObject = Page "Instalment Ratio";
                RunPageLink ="Policy Type"=FIELD("Policy Type"),
                              "Underwriter Code"=Field("Underwriter Code"),
                              "No. Of Instalments"=FIELD("No. Of Instalments");
            }
        }
    }

    var
        InsMgt : Codeunit "Insurance management";
}

