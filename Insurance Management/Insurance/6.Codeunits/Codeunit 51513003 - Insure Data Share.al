codeunit 51513003 "Insure Data Share"
{

    trigger OnRun()
    begin

    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        outStreamReport: OutStream;
        inStreamReport: InStream;
        Parameters: Text;
        tempBlob: Codeunit "Temp Blob";
        Base64EncodedString: Text;
        Mail: Codeunit "SMTP Mail";
        SmtpConf: Record "SMTP Mail Setup";
        ToAddr: List of [Text];
        subject: Text[250];
        body: text[250];


    procedure SendRiskData(var InsureHeader: Record "Insure Header");
    var

        RowNo: Integer;
        ColumnNo: Integer;
        PolicyType: Record "Underwriter Policy Types";
        ProductSelection: Record "Product Multi selector";
        InsureLines: Record "Insure lines";
        ProductTemplate: Record "Policy Type Template";
        RecRef: RecordRef;
        FRef: FieldRef;
        RecId: RecordId;
        RiskF: Text[250];
        ExcelFileName: Text[250];
        InsurerLbl: Label 'RiskData_List';
        newLabel: Label 'Risk data exists';
        UnderWriterRec:Record Vendor;
    begin
        //MESSAGE('start');

        //*****
        
        rowno := 0;
        ProductSelection.RESET;
        ProductSelection.SETRANGE("Document Type", InsureHeader."Document Type");
        ProductSelection.SETRANGE("Document No.", InsureHeader."No.");
        ProductSelection.SETRANGE("Select for Quote", true);
        IF ProductSelection.FINDFIRST THEN begin  //prod selection

        

            repeat
            //MESSAGE('Testing..Clear the Buffer %1',ProductSelection."Underwriter Name");
                ExcelBuf.Reset;
                ExcelBuf.DeleteAll;
                RowNo:=0;
                
                InsureLines.RESET;
                Insurelines.SETRANGE(Insurelines."Document Type", InsureHeader."Document Type");
                InsureLines.SETRANGE(InsureLines."Document No.", InsureHeader."No.");
                InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::"Schedule of Insured");
                if InsureLines.FINDFIRST then begin

                    ColumnNo := 0;

                    repeat
                        RowNo := RowNo + 1;
                        ProductTemplate.RESET;
                        ProductTemplate.SetCurrentKey("Column Order");
                        ProductTemplate.SETRANGE(Underwriter, ProductSelection."Underwriter");
                        ProductTemplate.SETRANGE("Policy Type", ProductSelection."Product Plan");
                        If ProductTemplate.FindFirst then begin
                           // MESSAGE('here *** data exists');
                            ColumnNo := 0;
                            repeat
                                ColumnNo := ColumnNo + 1;


                                //If FRef.Get(ProductTemplate."Table No.", ProductTemplate."Field No.") THEN
                                RecRef.GetTable(InsureLines);
                                RecId := InsureLines.RecordId;
                                RecRef.Get(RecID);

                                FRef := RecRef.Field(ProductTemplate."Field No.");
                                RiskF := FORMAT(FRef.VALUE, 0, 9);
                                //EVALUATE(FRef,RiskF);
                             //   MESSAGE('xxxxxxx %1 Row=%2 and col=%3', RiskF, RowNo, ColumnNo);
                                Entercell(RowNo, ColumnNo, RiskF, false, false, '', ExcelBuf."Cell Type"::Text);


                            until ProductTemplate.next = 0;
                        end;
                    until Insurelines.next = 0;

                end;                //**BKK

                ExcelFileName:=ProductSelection."Underwriter Name"+'_'+InsureHeader."No."+'.xlsx';

                ExcelBuf.CreateNewBook(InsurerLbl);
                ExcelBuf.WriteSheet(InsurerLbl, CompanyName, UserId);
                ExcelBuf.SetFriendlyFilename(ExcelFileName);
                //ExcelBuf.GiveUserControl;
                ExcelBuf.CloseBook(); 

                
                ExportExcelFileToBlob(ExcelBuf, TempBlob);
                TempBlob.CreateInStream(inStreamReport);
                SmtpConf.GET();
                CLEAR(ToAddr);
                IF UnderWriterRec.GET(ProductSelection.UnderWriter) THEN
                IF UnderWriterRec."E-Mail"<>'' THEN
                ToAddr.Add(UnderWriterRec."E-Mail")
                ELSE
                ERROR('Please key in email address for %1',ProductSelection."Underwriter Name");
                Subject := 'Request for Quote';
                Body := 'Dear Sir/Madam, Please find attached Request for Quotation';
                Mail.CreateMessage('Business Central Mailing System', SmtpConf."User ID", ToAddr, Subject, Body);
                //Mail.AddAttachment(ExcelFileName);
                Mail.AddAttachmentStream(inStreamReport, ExcelFileName);

                Mail.Send();


                //MESSAGE('%1 and %2', ProductSelection."Underwriter Name", InsureHeader."No.");
            //

            until ProductSelection.NEXT = 0;
        end; //selection start
    end; //procedure 

    procedure ExportExcelFileToBlob(
    var TempExcelBuf: Record "Excel Buffer" temporary;
    var TempBlob: Codeunit "Temp Blob")
    var
        OutStr: OutStream;
    begin
        TempBlob.CreateOutStream(OutStr);
        TempExcelBuf.SaveToStream(OutStr, true);
    end;

    Procedure Entercell(RowNo: Integer;
        ColumnNo: Integer;
        CellValue: Text[250];
        Bold: Boolean;
        UnderLine: Boolean;
        NumberFormat: Text[30];
        CellType: Option)
    var
    //ExcelBuf: Record "Excel Buffer" temporary;
    begin
        ExcelBuf.INIT;
        ExcelBuf.VALIDATE("Row No.", RowNo);
        ExcelBuf.VALIDATE("Column No.", ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf."Cell Type" := CellType;
        ExcelBuf.INSERT;
    end;
}
codeunit 50215 SendEmailStream
{
    PROCEDURE ReportSendMail(ReportToSend: Integer; Recordr: RecordRef; ToAddr: List of [Text]; Subject: Text[100]; Body: Text[100]; AttachmentName: Text[100]): Boolean
    var
        outStreamReport: OutStream;
        inStreamReport: InStream;
        Parameters: Text;
        tempBlob: Codeunit "Temp Blob";
        Base64EncodedString: Text;
        Mail: Codeunit "SMTP Mail";
        SmtpConf: Record "SMTP Mail Setup";

    begin
        //SMTP
        SmtpConf.GET();
        TempBlob.CreateOutStream(outStreamReport);
        TempBlob.CreateInStream(inStreamReport);

        //Print Report
        Report.SaveAs(ReportToSend, Parameters, ReportFormat::Pdf, outStreamReport, Recordr);

        //Create mail
        CLEAR(Mail);
        Mail.CreateMessage('Business Central Mailing System', SmtpConf."User ID", ToAddr, Subject, Body);
        Mail.AddAttachmentStream(inStreamReport, AttachmentName);

        //Send mail
        EXIT(Mail.Send());
    end;

    PROCEDURE ReportSendMailWithExternalAttachment(ReportToSend: Integer; Recordr: RecordRef; TableID: Integer; DocNo: Text; ToAddr: List of [Text]; Subject: Text[100]; Body: Text[100]; AttachmentName: Text[100]): Boolean
    var
        TempBlob: Codeunit "Temp Blob";
        outStreamReport: OutStream;
        inStreamReport: InStream;
        TempBlobAtc: Array[10] of Codeunit "Temp Blob";
        outStreamReportAtc: Array[10] of OutStream;
        inStreamReportAtc: Array[10] of InStream;
        Parameters: Text;
        Mail: Codeunit "SMTP Mail";
        SmtpConf: Record "SMTP Mail Setup";

        // Attachments
        FullFileName: Text;
        DocumentAttachment: record "Document Attachment";
        i: Integer;

    begin
        //Email Config     
        SmtpConf.GET();
        clear(Mail);
        Mail.CreateMessage('Business Central Mailing System', SmtpConf."User ID", ToAddr, Subject, Body);

        //Generate blob from report
        TempBlob.CreateOutStream(outStreamReport);
        TempBlob.CreateInStream(inStreamReport);
        Report.SaveAs(ReportToSend, Parameters, ReportFormat::Pdf, outStreamReport, Recordr);
        Mail.AddAttachmentStream(inStreamReport, AttachmentName);
        i := 1;

        //Get attachment from the document - streams
        DocumentAttachment.Reset();
        DocumentAttachment.setrange("Table ID", TableID);
        DocumentAttachment.setrange("No.", DocNo);
        if DocumentAttachment.FindSet() then begin
            repeat
                if DocumentAttachment."Document Reference ID".HasValue then begin
                    TempBlobAtc[i].CreateOutStream(outStreamReportAtc[i]);
                    TempBlobAtc[i].CreateInStream(inStreamReportAtc[i]);
                    FullFileName := DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension";
                    if DocumentAttachment."Document Reference ID".ExportStream(outStreamReportAtc[i]) then begin
                        //Mail Attachments
                        Mail.AddAttachmentStream(inStreamReportAtc[i], FullFileName);
                    end;
                    i += 1;
                end;
            until DocumentAttachment.NEXT = 0;
        end;

        //Send mail
        exit(Mail.Send());

    end;

    local procedure AddAttachment(
    var SMTPMail: Codeunit "SMTP Mail";
    var TempExcelBuf: Record "Excel Buffer" temporary;
    BookName: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
    begin
        ExportExcelFileToBlob(TempExcelBuf, TempBlob);
        TempBlob.CreateInStream(InStr);
        SMTPMail.AddAttachmentStream(InStr, BookName);
    end;

    procedure ExportExcelFileToBlob(
        var TempExcelBuf: Record "Excel Buffer" temporary;
        var TempBlob: Codeunit "Temp Blob")
    var
        OutStr: OutStream;
    begin
        TempBlob.CreateOutStream(OutStr);
        TempExcelBuf.SaveToStream(OutStr, true);
    end;

}