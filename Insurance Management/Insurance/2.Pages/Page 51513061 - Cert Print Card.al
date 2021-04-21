page 51513061 "Cert Print Card"
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
            action("Preview Certificate")
            {

                trigger OnAction();
                begin

                    CertPrint.RESET;
                    CertPrint.SETRANGE(CertPrint."Document No.", "Document No.");
                    CertPrint.SETRANGE(CertPrint."Registration No.", "Registration No.");
                    REPORT.RUN(51513110, TRUE, TRUE, CertPrint);
                    CertPrint.RESET;

                    //REPORT.RUN(51513107,TRUE,TRUE,Rec);
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
}

