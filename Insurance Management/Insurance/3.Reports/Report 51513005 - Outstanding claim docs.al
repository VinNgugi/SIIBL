report 51513005 "Outstanding claim docs"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Outstanding claim docs.rdl';

    dataset
    {
        dataitem("Claim"; "Claim")
        {
            DataItemTableView = SORTING(Class);
            PrintOnlyIfDetail = true;
            RequestFilterFields = Class, "Date of Occurence", "When Reported", "Insurer Policy No", Insured, Country;
            column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(USERID; USERID)
            {
            }
            column(Claimfilter; Claimfilter)
            {
            }
            column(Claim__Insurer_Policy_No_; Claim."Policy No")
            {
            }
            column(Claim__Insurer_s_Claim_No__; Claim."Claim No")
            {
            }
            column(Claim__Date_of_Occurence_; "Date of Occurence")
            {
            }
            column(Claim_Particulars; Particulars)
            {
            }
            column(Claim_Claim__Class_Description_; Claim."Class Description")
            {
            }
            column(Claim_Claim__Name_of_Insured_; Claim."Name of Insured")
            {
            }
            column(SCHEDULE_OF_OUTSTANDING_DOCUMENTATION_PER_CLAIMCaption; SCHEDULE_OF_OUTSTANDING_DOCUMENTATION_PER_CLAIMCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(POLICY_NUMBERCaption; POLICY_NUMBERCaptionLbl)
            {
            }
            column(CLAIM_NUMBERCaption; CLAIM_NUMBERCaptionLbl)
            {
            }
            column(PARTICULARSCaption; PARTICULARSCaptionLbl)
            {
            }
            column(POLICY_CLASSCaption; POLICY_CLASSCaptionLbl)
            {
            }
            column(DATECaption; DATECaptionLbl)
            {
            }
            column(INSUREDCaption; INSUREDCaptionLbl)
            {
            }
            column(Claim_Claim_No; "Claim No")
            {
            }
            dataitem(DataItem3863; "Insurance Documents")
            {
                DataItemLink = "Document No" = FIELD("Claim No");
                DataItemTableView = SORTING("Document Type", "Document No", "Entry No.")
                                    WHERE(Required = CONST(True),
                                          Received = CONST(False));
                column(Insurance_Documents__Document_Name_; "Document Name")
                {
                }
                column(Insurance_Documents__Date_Required_; "Date Required")
                {
                }
                column(Insurance_Documents_Required; Required)
                {
                }
                column(Insurance_Documents_Received; Received)
                {
                }
                column(Insurance_Documents_Comment; Comment)
                {
                }
                column(Insurance_Documents__Date_Required_Caption; FIELDCAPTION("Date Required"))
                {
                }
                column(Insurance_Documents_RequiredCaption; FIELDCAPTION(Required))
                {
                }
                column(Insurance_Documents_ReceivedCaption; FIELDCAPTION(Received))
                {
                }
                column(CommentsCaption; CommentsCaptionLbl)
                {
                }
                column(Outstanding_DocumentationCaption; Outstanding_DocumentationCaptionLbl)
                {
                }
                column(Insurance_Documents_Document_Type; "Document Type")
                {
                }
                column(Insurance_Documents_Document_No; "Document No")
                {
                }
                column(Insurance_Documents_Entry_No_; "Entry No.")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                CurrentStatus := '';
                CurrentStatus2 := '';

                IF STRLEN(Claim."Current Status") >= 65 THEN BEGIN
                    CurrentStatus := COPYSTR(Claim."Current Status", 1, 65);
                    CurrentStatus2 := COPYSTR(Claim."Current Status", 66, 65);
                END
                ELSE
                    CurrentStatus := Claim."Current Status";
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

    trigger OnPreReport();
    begin
        Claimfilter := Claim.GETFILTERS;
    end;

    var
        CurrentStatus: Text[80];
        CurrentStatus2: Text[80];
        CurrentStatus3: Text[80];
        Claimfilter: Text[250];
        SCHEDULE_OF_OUTSTANDING_DOCUMENTATION_PER_CLAIMCaptionLbl: Label 'SCHEDULE OF OUTSTANDING DOCUMENTATION PER CLAIM';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        POLICY_NUMBERCaptionLbl: Label 'POLICY NUMBER';
        CLAIM_NUMBERCaptionLbl: Label 'CLAIM NUMBER';
        PARTICULARSCaptionLbl: Label 'PARTICULARS';
        POLICY_CLASSCaptionLbl: Label 'POLICY CLASS';
        DATECaptionLbl: Label 'DATE';
        INSUREDCaptionLbl: Label 'INSURED';
        CommentsCaptionLbl: Label 'Comments';
        Outstanding_DocumentationCaptionLbl: Label 'Outstanding Documentation';
}

