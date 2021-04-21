page 51513148 "MV Cert receipt List"
{
    // version AES-INS 1.0

    CardPageID = "MV Cert receipt Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = Certificates;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch No"; "Batch No")
                {
                }
                field(Date; Date)
                {
                }
                field("Type Code"; "Type Code")
                {
                }
                field(Type; Type)
                {
                }
                field("Serial No Form"; "Serial No Form")
                {
                }
                field("Serioa No To"; "Serioa No To")
                {
                }
                field(Insurer; Insurer)
                {
                }
            }
        }
    }

    actions
    {
    }
}

