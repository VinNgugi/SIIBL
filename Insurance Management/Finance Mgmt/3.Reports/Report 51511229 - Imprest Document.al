report 51511229 "Imprest Document"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Imprest Document.rdl';

    dataset
    {
        dataitem("Request Header"; "Request Header")
        {
            RequestFilterFields = "No.";
            column(CompanyName; CompanyInformation.Name)
            {
            }
            column(CompanyAddress; CompanyInformation.Address)
            {
            }
            column(CompanyCity; CompanyInformation.City)
            {
            }
            column(CompanyPhone; CompanyInformation."Phone No.")
            {
            }
            column(CompanyPicture; CompanyInformation.Picture)
            {
            }
            column(ComapnyEmail; CompanyInformation."E-Mail")
            {
            }
            column(CompanyHomePage; CompanyInformation."Home Page")
            {
            }
            column(No_RequestHeader; "Request Header"."No.")
            {
            }
            column(GlobalDimension1Code_RequestHeader; "Request Header"."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_RequestHeader; "Request Header"."Global Dimension 2 Code")
            {
            }
            column(RequestDate_RequestHeader; "Request Header"."Request Date")
            {
            }
            column(DepartmentName_RequestHeader; "Request Header"."Department Name")
            {
            }
            column(EmployeeNo_RequestHeader; "Request Header"."Employee No")
            {
            }
            column(EmployeeName_RequestHeader; "Request Header"."Employee Name")
            {
            }
            column(PurposeofImprest_RequestHeader; "Request Header"."Purpose of Imprest")
            {
            }
            column(TripStartDate_RequestHeader; "Request Header"."Trip Start Date")
            {
            }
            column(TripExpectedEndDate_RequestHeader; "Request Header"."Trip Expected End Date")
            {
            }
            column(DestinationCountry_RequestHeader; "Request Header"."Destination Country")
            {
            }
            column(DestinationCity_RequestHeader; "Request Header"."Destination City")
            {
            }
            column(ChequeNo_RequestHeader; "Request Header"."Cheque No")
            {
            }
            column(PayMode_RequestHeader; "Request Header"."Pay Mode")
            {
            }
            column(PostedDate_RequestHeader; "Request Header"."Posted Date")
            {
            }
            column(PostedTime_RequestHeader; "Request Header"."Posted Time")
            {
            }
            column(PostedBy_RequestHeader; "Request Header"."Posted By")
            {
            }
            column(AccountNo_RequestHeader; "Request Header"."Account No.")
            {
            }
            column(SenderID; SenderID)
            {
            }
            column(DateTimeSend; DateTimeSend)
            {
            }
            /*column(SenderSignature; UserSetup.Picture)
            {
            }*/
            column(FirstApproverID; FirstApproverID)
            {
            }
            column(DateTimeFirstApprove; DateTimeFirstApprove)
            {
            }
            /*column(FirstApproveSignature; UserSetup1.Picture)
            {
            }*/
            column(SecondApproverID; SecondApproverID)
            {
            }
            column(DateTimeSecondApprove; DateTimeSecondApprove)
            {
            }
            /*column(SecondApproveSignature; UserSetup2.Picture)
            {
            }*/
            column(ThirdApproverID; ThirdApproverID)
            {
            }
            column(DateTimeThirdApprove; DateTimeThirdApprove)
            {
            }
            /*column(ThirdApproveSignature; UserSetup3.Picture)
            {
            }*/
            column(FourthApproverID; FourthApproverID)
            {
            }
            column(DateTimeFourthApprove; DateTimeFourthApprove)
            {
            }
            /*column(FourthApproveSignature; UserSetup4.Picture)
            {
            }*/
            column(FifthApproverID; FifthApproverID)
            {
            }
            column(DateTimeFifthApprove; DateTimeFifthApprove)
            {
            }
            /* column(FifthApproveSignature; UserSetup5.Picture)
             {
             }*/
            column(C_Name; CName)
            {
            }
            column(C_Email; CEmail)
            {
            }
            column(C_Address; CAddress)
            {
            }
            column(C_Adrress2; CAddress2)
            {
            }
            column(C_Page; Cpage)
            {
            }
            column(C_Phobe; Cphone)
            {
            }
            dataitem("Request Lines"; "Request Lines")
            {
                DataItemLink = "Document No" = FIELD("No.");
                RequestFilterFields = Committment;
                column(Description_RequestLines; "Request Lines".Description)
                {
                }
                column(Amount_RequestLines; "Request Lines".Amount)
                {
                }
                column(AccountNo_RequestLines; "Request Lines"."Account No")
                {
                }
                column(Quantity_RequestLines; "Request Lines".Quantity)
                {
                }
                column(UnitPrice_RequestLines; "Request Lines"."Unit Price")
                {
                }
                column(USDAmount_RequestLines; "Request Lines"."USD Amount")
                {
                }
                column(Destination; Destination)
                {
                }
                column(ExchangeRate_RequestLines; "Request Lines"."Exchange Rate")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // Destination:='';
                    // IF "Request Header"."International Travel2" THEN
                    //  Destination:="Request Lines"."Destination Country";
                    // IF "Request Header"."Local Travel2" THEN
                    //  Destination:="Request Lines"."Destination City";
                end;
            }

            trigger OnAfterGetRecord()
            begin

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
                CName := CompanyInformation.Name;
                CEmail := CompanyInformation."E-Mail";
                CAddress := CompanyInformation.Address;
                CAddress2 := CompanyInformation."Address 2";
                Cpage := CompanyInformation."Home Page";
                Cphone := CompanyInformation."Phone No.";


                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Table ID", 51511003);
                ApprovalEntry.SETRANGE("Document No.", "Request Header"."No.");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                IF ApprovalEntry.FINDFIRST THEN BEGIN
                    SenderID := ApprovalEntry."Sender ID";
                    DateTimeSend := FORMAT(ApprovalEntry."Date-Time Sent for Approval");
                    IF UserSetup.GET(SenderID) THEN BEGIN
                        //UserSetup.CALCFIELDS(Picture);
                    END;
                END;

                ApprovalEntry.RESET;
                ApprovalEntry.SETRANGE("Table ID", 51511003);
                ApprovalEntry.SETRANGE("Document No.", "Request Header"."No.");
                ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
                IF ApprovalEntry.FINDSET THEN BEGIN
                    IF ApprovalEntry."Sequence No." = 1 THEN BEGIN
                        FirstApproverID := ApprovalEntry."Approver ID";
                        DateTimeFirstApprove := FORMAT(ApprovalEntry."Last Date-Time Modified");
                        IF UserSetup1.GET(FirstApproverID) THEN BEGIN
                            //UserSetup1.CALCFIELDS(Picture);
                        END;
                    END;

                    IF ApprovalEntry."Sequence No." = 2 THEN BEGIN
                        SecondApproverID := ApprovalEntry."Approver ID";
                        DateTimeSecondApprove := FORMAT(ApprovalEntry."Last Date-Time Modified");
                        IF UserSetup2.GET(SecondApproverID) THEN BEGIN
                            ///UserSetup2.CALCFIELDS(Picture);
                        END;
                    END;

                    IF ApprovalEntry."Sequence No." = 3 THEN BEGIN
                        ThirdApproverID := ApprovalEntry."Approver ID";
                        DateTimeThirdApprove := FORMAT(ApprovalEntry."Last Date-Time Modified");
                        IF UserSetup3.GET(ThirdApproverID) THEN BEGIN
                            // UserSetup3.CALCFIELDS(Picture);
                        END;
                    END;

                    IF ApprovalEntry."Sequence No." = 4 THEN BEGIN
                        FourthApproverID := ApprovalEntry."Approver ID";
                        DateTimeFourthApprove := FORMAT(ApprovalEntry."Last Date-Time Modified");
                        IF UserSetup4.GET(FourthApproverID) THEN BEGIN
                            //UserSetup4.CALCFIELDS(Picture);
                        END;
                    END;

                    IF ApprovalEntry."Sequence No." = 5 THEN BEGIN
                        FifthApproverID := ApprovalEntry."Approver ID";
                        DateTimeFifthApprove := FORMAT(ApprovalEntry."Last Date-Time Modified");
                        IF UserSetup5.GET(FifthApproverID) THEN BEGIN
                            //UserSetup5.CALCFIELDS(Picture);
                        END;
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin

                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);
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
        CompanyInformation: Record "Company Information";
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        SenderID: Code[80];
        DateTimeSend: Text;
        SenderSignature: Variant;
        FirstApproverID: Code[80];
        DateTimeFirstApprove: Text;
        FirstApproveSignature: Variant;
        SecondApproverID: Code[80];
        DateTimeSecondApprove: Text;
        SecondApproveSignature: Variant;
        ThirdApproverID: Code[80];
        DateTimeThirdApprove: Text;
        ThirdApproveSignature: Variant;
        FourthApproverID: Code[80];
        DateTimeFourthApprove: Text;
        FourthApproveSignature: Variant;
        FifthApproverID: Code[80];
        DateTimeFifthApprove: Text;
        FifthApproveSignature: Variant;
        UserSetup1: Record "User Setup";
        UserSetup2: Record "User Setup";
        UserSetup3: Record "User Setup";
        UserSetup4: Record "User Setup";
        UserSetup5: Record "User Setup";
        UserSetup6: Record "User Setup";
        Destination: Text;
        CName: Text[80];
        CEmail: Text[80];
        CAddress: Text[80];
        CAddress2: Text[80];
        Cpage: Text[80];
        Cphone: Text;
        Name: Label 'East African School of Aviation';
        Email: Label 'info@easa.or.ke';
        BAdd: Label 'P.O BOX 31063';
        PAdd: Label '  North Airport Road,Embakasi';
        HPage: Label 'www.easa.ac.ke';
        Easaphone: Label '827470';
}

