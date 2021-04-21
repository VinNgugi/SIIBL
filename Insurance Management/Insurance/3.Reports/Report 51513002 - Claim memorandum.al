report 51513002 "Claim memorandum"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Claim memorandum.rdl';

    dataset
    {
        dataitem("Claim"; "Claim")
        {
            column(Logo; CompanyInfo.Picture)
            {
            }
            column(Title; Text1)
            {
            }
            column(DateIssued; WORKDATE)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyAddress2; CompanyInfo."Address 2")
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyWeb; CompanyInfo."Home Page")
            {
            }
            column(CustName; Cust.Name)
            {
            }
            column(CustAddress; Cust.Address)
            {
            }
            column(CustAddress2; Cust."Address 2")
            {
            }
            column(CustCity; Cust.City)
            {
            }
            column(Insured; Claim."Name of Insured")
            {
            }
            column(ClaimNo; Claim."Claim No")
            {
            }
            column(VehicleReg; Claim."Registration No.")
            {
            }
            column(PolicyNo; Claim."Policy No")
            {
            }
            column(DateOfOccurence; Claim."Date of Occurence")
            {
            }
            column(Contactname; ContactName)
            {
            }
            column(PolicyClass; Claim."Class Description")
            {
            }
            dataitem("Insurance Documents"; "Insurance Documents")
            {
                DataItemLink = "Document No" = FIELD("Claim No");
                column(DocClaimNo; "Insurance Documents"."Document No")
                {
                }
                column(DocumentName_InsuranceDocuments; "Insurance Documents"."Document Name")
                {
                }
                column(Received_InsuranceDocuments; "Insurance Documents".Received)
                {
                }
                column(Enclosed_InsuranceDocuments; "Insurance Documents".Enclosed)
                {
                }
                column(ToFollow_InsuranceDocuments; "Insurance Documents"."To Follow")
                {
                }
                column(Required_InsuranceDocuments; "Insurance Documents".Required)
                {
                }
                column(Enclosed; Enclosedtxt)
                {
                }
                column(ToFollow; tofollowtxt)
                {
                }
                column(RequiredTxt; RequiredTxt)
                {
                }

                trigger OnAfterGetRecord();
                begin

                    Enclosedtxt := '';
                    tofollowtxt := '';
                    RequiredTxt := '';
                    Printline := FALSE;
                    IF "Insurance Documents".Enclosed THEN
                        Printline := TRUE;
                    IF "Insurance Documents"."To Follow" THEN
                        Printline := TRUE;

                    IF "Insurance Documents".Required THEN
                        Printline := TRUE;


                    IF "Insurance Documents".Enclosed THEN
                        Enclosedtxt := 'X';
                    IF "Insurance Documents"."To Follow" THEN
                        tofollowtxt := 'X';

                    IF "Insurance Documents".Required THEN
                        RequiredTxt := 'X';
                end;
            }
            dataitem("Comment Line"; "Comment Line")
            {
                DataItemTableView = WHERE("Table Name" = CONST(14));
                column(Comment_CommentLine; "Comment Line".Comment)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                IF Cust.GET(Claim.Insured) THEN BEGIN
                    ContactName := Cust.Contact;
                END;
            end;

            trigger OnPreDataItem();
            begin

                CompanyInfo.GET;
                FormatAddr.Company("CompanyAddr", "CompanyInfo");
                CompanyInfo.CALCFIELDS(Picture);
                IF ClaimNo <> '' THEN
                    Claim.SETRANGE(Claim."Claim No", ClaimNo);
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
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record 79;
        CompanyAddr: array[8] of Text[60];
        FormatAddr: Codeunit 365;
        ClaimNo: Code[20];
        Cust: Record Customer;
        Vend: Record Vendor;
        CustAddr: array[8] of Text[50];
        VendAddr: array[8] of Text[50];
        Enclosedtxt: Text[30];
        tofollowtxt: Text[30];
        RequiredTxt: Text[30];
        UserName: Text[30];
        UserREC: Record "User Setup";
        Printline: Boolean;
        PersonItem: Text[180];
        ContactName: Text[250];
        ccName1: Text[250];
        ccName2: Text[250];
        ccName3: Text[250];
        Text1: Label 'CLAIM MEMORANDUM';

    procedure GetClaimID(var ClaimNumber: Code[20]);
    begin
        ClaimNo := ClaimNumber;
    end;
}

