page 51513198 "Cert Printed Card"
{
    // version AES-INS 1.0

    Editable = false;
    PageType = Card;
    SourceTable = "Certificate Printing";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Registration No."; "Registration No.")
                {
                }
                field(Make; Make)
                {
                }
                field("Year of Manufacture"; "Year of Manufacture")
                {
                }
                field("Type of Body"; "Type of Body")
                {
                }
                field("Cubic Capacity (cc)"; "Cubic Capacity (cc)")
                {
                }
                field("Seating Capacity"; "Seating Capacity")
                {
                }
                field("Carrying Capacity"; "Carrying Capacity")
                {
                }
                field("Vehicle License Class"; "Vehicle License Class")
                {
                }
                field("Certificate Status"; "Certificate Status")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Print Time"; "Print Time")
                {
                }
                field("Vehicle Usage"; "Vehicle Usage")
                {
                }
                field("Start Date"; "Start Date")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("Certificate No."; "Certificate No.")
                {
                }
                field("Certificate Type"; "Certificate Type")
                {
                }
                field("SACCO ID"; "SACCO ID")
                {
                }
                field("Route ID"; "Route ID")
                {
                }
                field("Policy Type"; "Policy Type")
                {
                }
                field(CertType; CertType)
                {
                    Caption = 'Certificate Type';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Cancel Certificate")
            {

                trigger OnAction();
                begin
                    Insmgt.CancelCert(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        IF PolicyRec.GET("Policy Type") THEN
            CertType := PolicyRec."short code";
    end;

    var
        CertPrint: Record "Certificate Printing";
        CertType: Code[20];
        PolicyRec: Record "Policy Type";
        Insmgt: Codeunit "Insurance management";
}

