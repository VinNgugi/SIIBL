report 51513011 ExtendRisk
{
    // version AES-INS 1.0

    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1; 2000000026)
        {
            DataItemTableView = SORTING(Number)
                                WHERE(Number = CONST(1));
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'Select Risk';
                group(Options)
                {
                    Caption = 'Options';
                    field(SelectVehicle; SelectVehicle)
                    {
                        Caption = 'Vehicle Registration No.:';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        InsMngt.ExtendPolicyCoverRisk(SelectVehicle);
    end;

    var
        SelectVehicle: Code[20];
        InsMngt: Codeunit "Insurance management";
}

