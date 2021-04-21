report 51513111 "CIC EFT Test1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './CIC EFT Test1.rdlc';

    dataset
    {
        dataitem(DataItem15;51511000)
        {
            dataitem("PV Lines1";51511001)
            {
                DataItemLink = "PV No"=FIELD(No);
                column(Ref;"PV Lines1"."PV No")
                {
                }
                column(Name;"PV Lines1"."Account Name")
                {
                }
                column(BankCode;"PV Lines1"."KBA Branch Code")
                {
                }
                column(AccountNo;"PV Lines1"."Bank Account No")
                {
                }
                column(Amount;"PV Lines1"."Net Amount")
                {
                }
                column(PayMode;PV."Pay Mode")
                {
                }
                column(DRAcc;Bank."Bank Account No.")
                {
                }
                column(SwiftCode;Bank."SWIFT Code")
                {
                }
                column(Details;"PV Lines1".Description)
                {
                }
                column(Currency;PV.Currency)
                {
                }
                column(Date;PV.Date)
                {
                }
                column(ChargedBY;PV."Charge By")
                {
                }
                column(DealNumber;PV."Deal Number")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IF PV.GET("PV Lines1"."PV No") THEN
                     IF Bank.GET(PV."Paying Bank Account") THEN

                    IF GLsetup.GET THEN
                      IF PV.Currency='' THEN
                        Kurrency:=GLsetup."LCY Code"
                      ELSE
                        Kurrency:=PV.Currency;

                      RowNo := RowNo + 1;
                      EnterCell(RowNo,1,"PV Lines1"."PV No",FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,2,"PV Lines1"."Account Name",FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,3,"PV Lines1"."KBA Branch Code",FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,4,"PV Lines1"."Bank Account No",FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,5,FORMAT("PV Lines1"."Net Amount"),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Number);
                      EnterCell(RowNo,6,FORMAT(PV."Pay Mode"),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,7,FORMAT(Bank."Bank Account No."),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,8,FORMAT( Bank."SWIFT Code"),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,9,FORMAT("PV Lines1".Description),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,10,FORMAT(PV.Currency),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,11,FORMAT(PV.Date),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Date);
                      EnterCell(RowNo,12,FORMAT(PV."Charge By"),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                      EnterCell(RowNo,13,FORMAT(PV."Deal Number"),FALSE,FALSE,'',TempExcelBuffer."Cell Type"::Text);
                end;

                trigger OnPostDataItem();
                begin
                    //Window.CLOSE;

                    IF DoUpdateExistingWorksheet THEN BEGIN
                      ExcelBuf.UpdateBook(ServerFileName,SheetName);
                      ExcelBuf.WriteSheet('',COMPANYNAME,USERID);
                      ExcelBuf.CloseBook;
                      IF NOT TestMode THEN
                        ExcelBuf.DownloadAndOpenExcel;
                    END ELSE BEGIN
                      ExcelBuf.CreateBook(ServerFileName,BookName);
                      ExcelBuf.WriteSheet(SheetNames,COMPANYNAME,USERID);
                      ExcelBuf.CloseBook;
                      IF NOT TestMode THEN
                        ExcelBuf.OpenExcel;
                    END;
                    IF NOT TestMode THEN
                      //ExcelBuf.GiveUserControl;
                      ;
                end;
            }

            trigger OnPreDataItem();
            begin
                IF DoUpdateExistingWorksheet THEN BEGIN
                  IF ServerFileName = '' THEN
                    ServerFileName := FileMgt.UploadFile(Text002,ExcelFileExtensionTok);
                  IF ServerFileName = '' THEN
                    EXIT;
                  SheetName := TempExcelBuffer.SelectSheetsName(ServerFileName);
                  IF SheetName = '' THEN
                    EXIT;
                END;
                
                /*Window.OPEN(
                  Text000 +
                  '@1@@@@@@@@@@@@@@@@@@@@@\');
                Window.UPDATE(1,0);*/

            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        PV : Record 51511000;
        Bank : Record 270;
        GLsetup : Record 98;
        Kurrency : Code[10];
        ExcelBuf : Record 370 temporary;

        FileMgt: Codeunit 419;
        
        ServerFileName : Text;
        SheetName : Text[250];
        DoUpdateExistingWorksheet : Boolean;
        Text000 : Label 'Analyzing Data...\\';
        Text001 : Label 'Filters';
        Text002 : Label 'Update Workbook';
        ExcelFileExtensionTok : Label '.xlsx', Comment='{Locked}';
        TempExcelBuffer : Record 370;
        Window : Dialog;
        RowNo : Integer;
        TestMode : Boolean;
        BookName : Label 'TRANSCOOP_EFT';
        SheetNames : Label 'EFT';

    local procedure EnterCell(RowNo : Integer;ColumnNo : Integer;CellValue : Text[250];Bold : Boolean;UnderLine : Boolean;NumberFormat : Text[30];CellType : Option);
    begin
        ExcelBuf.INIT;
        ExcelBuf.VALIDATE("Row No.",RowNo);
        ExcelBuf.VALIDATE("Column No.",ColumnNo);
        ExcelBuf."Cell Value as Text" := CellValue;
        ExcelBuf.Formula := '';
        ExcelBuf.Bold := Bold;
        ExcelBuf.Underline := UnderLine;
        ExcelBuf.NumberFormat := NumberFormat;
        ExcelBuf."Cell Type" := CellType;
        ExcelBuf.INSERT;
    end;
}

