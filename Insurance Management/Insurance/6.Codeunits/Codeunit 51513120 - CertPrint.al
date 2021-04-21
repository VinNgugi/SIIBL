codeunit 51513120 CertPrint
{

    trigger OnRun();
    begin
    end;

    var
        CertLastNo: Integer;
        CertPrintingCopy: Record 51513071;

    procedure CertPrinting(var No: Code[10]);
    var
        InsuranceLine: Record 51513017;
        InsuranceHeader: Record 51513016;
        CertPrint: Record 51513071;
        InsuranceSetup: Record 51513014;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecLine: Record "Receipt Lines";
        Receipt: Record "Receipts Header";
    begin
        //IF Receipt.GET(PolicyNo) THEN BEGIN
        //WITH Receipt  DO BEGIN

        IF Receipt.GET(No) THEN BEGIN
            WITH Receipt DO BEGIN
                RecLine.RESET;
                RecLine.SETRANGE(RecLine."Receipt No.", Receipt."No.");
                RecLine.SETFILTER(RecLine."Applies to Doc. No", '<>%1', ' ');
                IF RecLine.FINDFIRST THEN BEGIN
                    REPEAT

                        IF InsuranceHeader.GET(InsuranceHeader."Document Type"::"Debit Note", RecLine."Applies to Doc. No") THEN BEGIN

                            InsuranceLine.RESET;
                            InsuranceLine.SETRANGE(InsuranceLine."Document No.", RecLine."Applies to Doc. No");
                            InsuranceLine.SETRANGE(InsuranceLine."Document Type", InsuranceLine."Document Type"::"Debit Note");
                            InsuranceLine.SETRANGE(InsuranceLine."Description Type", InsuranceLine."Description Type"::"Schedule of Insured");
                            //InsuranceLine.SETFILTER(InsuranceLine."Risk ID", '<>%1', ' ');
                            IF InsuranceLine.FIND('-') THEN BEGIN
                                REPEAT


                                    CertPrint.INIT;
                                    CertPrint."Document No." := InsuranceLine."Policy No";
                                    //CertPrint."Risk ID" := InsuranceHeader."No.";
                                    CertPrint."Family Name" := Receipt."No.";
                                    //CertPrint."First Name(s)" := InsuranceLine."Risk ID";
                                    //CertPrint."Cover Type":=InsuranceLine."Cover Type";
                                    //CertPrint."Height Unit" := InsuranceHeader."Insured No.";
                                    //.Height := InsuranceHeader."Insured Name";
                                    CertPrint."Date of Birth" := InsuranceHeader."Cover Start Date";
                                    //CertPrint."Relationship to Applicant" := InsuranceHeader."Cover End Date";
                                    // CertPrint."Cover Start Time":=Format(InsuranceHeader."From Time"); convert from text to time
                                    // CertPrint."Cover End Time":=InsuranceHeader."To Time";
                                    //CertPrint.Age := InsuranceHeader."Shortcut Dimension 1 Code";
                                    CertPrint.BMI := InsuranceLine."Seating Capacity";
                                    CertPrint."Policy No" := CertPrint."Policy No";
                                    CertPrintingCopy.RESET;
                                    IF CertPrintingCopy.FINDLAST THEN
                                        CertLastNo := CertPrintingCopy."Weight(Kg)";
                                    CertLastNo := CertLastNo + 1;
                                    CertPrint."Weight(Kg)" := CertLastNo;
                                    CertPrint.INSERT(TRUE);


                                    InsuranceLine.Status := InsuranceLine.Status::Expired;
                                    InsuranceLine.MODIFY(TRUE);




                                UNTIL InsuranceLine.NEXT = 0;
                            END;

                        END;
                    UNTIL RecLine.NEXT = 0;
                END
            END

        END

        //END
        //END;
    end;

    procedure CreditApproval(var CreditRequest: Record 51513074);
    var
        InsuranceLine: Record 51513017;
        InsuranceHeader: Record 51513016;
        CertPrint: Record 51513071;
        InsuranceSetup: Record 51513014;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecLine: Record "Receipt Lines";
        Receipt: Record "Receipts Header";
    begin
        InsuranceHeader.RESET;
        InsuranceHeader.SETRANGE(InsuranceHeader."Document Type", InsuranceHeader."Document Type"::"Debit Note");
        InsuranceHeader.SETRANGE(InsuranceHeader.Posted, TRUE);
        InsuranceHeader.SETRANGE(InsuranceHeader."Posting Date", CreditRequest."Credit Start Date", CreditRequest."Credit End Date");
        InsuranceHeader.SETRANGE(InsuranceHeader."Insured No.", CreditRequest."Customer ID");
        IF InsuranceHeader.FINDFIRST THEN
            REPEAT

                InsuranceLine.RESET;
                InsuranceLine.SETRANGE(InsuranceLine."Document No.", InsuranceHeader."No.");
                InsuranceLine.SETRANGE(InsuranceLine."Document Type", InsuranceLine."Document Type"::"Debit Note");
                InsuranceLine.SETRANGE(InsuranceLine."Description Type", InsuranceLine."Description Type"::"Schedule of Insured");
                //InsuranceLine.SETFILTER(InsuranceLine."Risk ID", '<>%1', ' ');
                IF InsuranceLine.FIND('-') THEN BEGIN
                    REPEAT


                        CertPrint.INIT;
                        CertPrint."Document No." := InsuranceLine."Policy No";
                        //CertPrint."Risk ID" := InsuranceHeader."No.";
                        CertPrint."Family Name" := Receipt."No.";
                        //CertPrint."First Name(s)" := InsuranceLine."Risk ID";
                        //CertPrint."Cover Type":=InsuranceLine."Cover Type";
                        //CertPrint."Height Unit" := InsuranceHeader."Insured No.";
                        //CertPrint.Height := InsuranceHeader."Insured Name";
                        CertPrint."Date of Birth" := InsuranceHeader."Cover Start Date";
                        //CertPrint."Relationship to Applicant" := InsuranceHeader."Cover End Date";
                        // CertPrint."Cover Start Time":=Format(InsuranceHeader."From Time"); convert from text to time
                        // CertPrint."Cover End Time":=InsuranceHeader."To Time";
                        //CertPrint.Age := InsuranceHeader."Shortcut Dimension 1 Code";
                        CertPrint.BMI := InsuranceLine."Seating Capacity";
                        CertPrint."Policy No" := CertPrint."Policy No";
                        CertPrintingCopy.RESET;
                        IF CertPrintingCopy.FINDLAST THEN
                            CertLastNo := CertPrintingCopy."Weight(Kg)";
                        CertLastNo := CertLastNo + 1;
                        CertPrint."Weight(Kg)" := CertLastNo;
                        CertPrint.INSERT(TRUE);


                        InsuranceLine.Status := InsuranceLine.Status::Expired;
                        InsuranceLine.MODIFY(TRUE);




                    UNTIL InsuranceLine.NEXT = 0;
                END;
            UNTIL InsuranceHeader.NEXT = 0;
    end;
}

