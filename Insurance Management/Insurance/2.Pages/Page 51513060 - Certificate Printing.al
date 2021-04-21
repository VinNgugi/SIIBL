page 51513060 "Certificate Printing"
{
    // version AES-INS 1.0

    CardPageID = "Cert Print Card";
    Editable = false;
    PageType = List;
    UsageCategory=Lists;
    SourceTable = "Certificate Printing";
    SourceTableView = WHERE("Registration No." = FILTER(<> ''),
                            Printed = CONST(False));

    layout
    {
        area(content)
        {
            repeater(Group)
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
                field("Start Date"; "Start Date")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("Vehicle Usage"; "Vehicle Usage")
                {
                }
                field("Vehicle License Class"; "Vehicle License Class")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Policy No"; "Policy No")
                {
                }
                field("Certificate No."; "Certificate No.")
                {
                }
                field("Certificate Status"; "Certificate Status")
                {
                }
                field("Insured Name"; "Insured Name")
                {
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
                Promoted = true;
                PromotedCategory = "Report";

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
            action("Print Certificate")
            {
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction();
                begin

                    IF PostedDebitNote.GET(Rec."Document No.") THEN
                        IF Insmgt.CreditLimitExists(PostedDebitNote."Bill To Customer No.", PostedDebitNote."Document Date") THEN BEGIN
                            IF Insmgt.CreditLimitExceeded(PostedDebitNote."Bill To Customer No.", PostedDebitNote."Document Date") THEN
                                ERROR('Credit Limit exceeded please make payments to reduce your debt');
                        END
                        ELSE BEGIN
                            // MESSAGE('Credit limit does not exist for this period');
                            IF NOT Insmgt.CheckPaymentforDebitNote(Rec) THEN
                                ERROR('Debit Note %1 has not been paid, please pay before printing certificate', Rec."Document No.");
                        END;
                    Insmgt.CertPrintandReduceStocks(Rec);
                    /*
                      PolicyLines.SETRANGE(PolicyLines."Document Type",PolicyLines."Document Type"::Policy);
                       PolicyLines.SETRANGE(PolicyLines."Registration No.",CertPrint."Registration No.");
                       //PolicyLines.SETRANGE(PolicyLines.Status,PolicyLines.Status::Live);
                       IF PolicyLines.FINDLAST THEN
                         BEGIN
                    
                         PolicyLines."Certificate No.":=CertNo;
                         PolicyLines.MODIFY;
                         CertPrintCopy.RESET;
                         CertPrintCopy.SETRANGE(CertPrintCopy."Document No.",CertPrint."Document No.");
                         CertPrintCopy.SETRANGE(CertPrintCopy."Line No.",CertPrint."Line No.");
                         IF CertPrintCopy.FINDFIRST THEN
                         REPORT.RUNMODAL(51513107,FALSE,FALSE,CertPrintCopy);
                         CertPrintCopy.RESET;
                    
                         END;*/

                end;
            }
        }
    }

    var
        Insmgt: Codeunit "Insurance management";
        PolicyLines: Record "Insure Lines";
        CertPrintCopy: Record "Certificate Printing";
        CertPrint: Record "Certificate Printing";
        PostedDebitNote: Record "Insure Debit Note";
}

