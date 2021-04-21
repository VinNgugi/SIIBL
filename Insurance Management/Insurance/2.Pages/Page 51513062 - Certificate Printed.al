page 51513062 "Certificate Printed"
{
    // version AES-INS 1.0

    CardPageID = "Cert Printed Card";
    Editable = true;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Certificate Printing";
    SourceTableView = WHERE(Printed = CONST(True));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Certificate No."; "Certificate No.")
                {
                    Caption = 'Certificate No';
                    Editable = false;
                }
                field("Registration No."; "Registration No.")
                {
                    Editable = false;
                }
                field(Make; Make)
                {
                    Editable = false;
                }
                field("Year of Manufacture"; "Year of Manufacture")
                {
                    Editable = false;
                }
                field("Type of Body"; "Type of Body")
                {
                    Editable = false;
                }
                field("Cubic Capacity (cc)"; "Cubic Capacity (cc)")
                {
                    Editable = false;
                }
                field("Seating Capacity"; "Seating Capacity")
                {
                    Editable = false;
                }
                field("Carrying Capacity"; "Carrying Capacity")
                {
                    Editable = false;
                }
                field("Start Date"; "Start Date")
                {
                    Editable = false;
                }
                field("End Date"; "End Date")
                {
                    Editable = false;
                }
                field("Vehicle Usage"; "Vehicle Usage")
                {
                    Editable = false;
                }
                field("Vehicle License Class"; "Vehicle License Class")
                {
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    Editable = false;
                }
                field("Policy No"; "Policy No")
                {
                    Editable = false;
                }
                field("Insured No."; "Insured No.")
                {
                    Editable = false;
                }
                field("Certificate Status"; "Certificate Status")
                {
                    Editable = false;
                }
                field("Insured Name"; "Insured Name")
                {
                    Editable = false;
                }
                field("cancellation Reason"; "cancellation Reason")
                {
                }
                field("cancellation Reason Desc"; "cancellation Reason Desc")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Print Certificate")
            {
                Visible = false;

                trigger OnAction();
                begin
                    Insmgt.CertPrintandReduceStocks(Rec);
                end;
            }
            action("Cancel Certificate")
            {

                trigger OnAction();
                begin
                    Insmgt.CancelCert(Rec);
                end;
            }
        }
    }

    var
        Insmgt: Codeunit "Insurance management";
}

