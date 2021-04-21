report 51511009 "Memos Report"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Memos Report.rdl';

    dataset
    {
        dataitem(Memo; Memo)
        {
            RequestFilterFields = "Memo No";
            column(ApprovalNo_BudgetApproval; Memo."Memo No")
            {
            }
            column(DestinationGL_BudgetApproval; Memo."Memo No")
            {
            }
            column(AmountRequested_BudgetApproval; Memo."Memo No")
            {
            }
            column(CurrentBudget_BudgetApproval; Memo."Memo No")
            {
            }
            column(RequestingUser_BudgetApproval; Memo."Created By:")
            {
            }
            column(ReallocationSubject_BudgetApproval; Memo."Memo Header")
            {
            }
            column(memobody; memobody)
            {
            }
            column(Coname; corec.Name)
            {
            }
            /*column(Approver_Signature; usersetup.Picture)
            {
            }*/
            column(approverID; usersetup."User ID")
            {
            }
            column(Approval_Time; approvalentry."Last Date-Time Modified")
            {
            }
            column(CoLogo; corec.Picture)
            {
            }
            column(TransferRequestDate_BudgetApproval; Memo."Date Created")
            {
            }
            dataitem("Memo Lines"; "Memo Lines")
            {
                DataItemLink = "Memo No" = FIELD("Memo No");
                column(Member; "Memo Lines".Member)
                {
                }
                column(designation; designation)
                {
                }
                column(Department; "Memo Lines"."Department Name")
                {
                }
                column(jobgroup; jobgroup)
                {
                }
                column(lineamount; lineamount)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    usersetup.RESET;
                    usersetup.GET("Memo Lines".Member);
                    Emprec.RESET;
                    Emprec.GET(usersetup."Employee No.");
                    designation := Emprec."Job Title";
                    //jobgroup := Emprec."Salary Scale";
                    lineamount := "Memo Lines".Amount;

                    //usersetup.CALCFIELDS(Picture);
                end;

                trigger OnPreDataItem()
                begin
                    "Memo Lines".SETFILTER("Memo Lines"."Budget Name", '<>%1', '');
                end;
            }
            dataitem("Approval Comment Line"; "Approval Comment Line")
            {
                DataItemLink = "Document No." = FIELD("Memo No");
                DataItemTableView = WHERE("Table ID" = CONST(51511997));
                column(UserID_ApprovalCommentLine; "Approval Comment Line"."User ID")
                {
                }
                column(Comment_ApprovalCommentLine; "Approval Comment Line".Comment)
                {
                }
                /* column(Sentto_ApprovalCommentLine; "Approval Comment Line"."Sent to")
                {
                } */
                column(DateandTime_ApprovalCommentLine; "Approval Comment Line"."Date and Time")
                {
                }

                trigger OnPreDataItem()
                begin
                    "Approval Comment Line".SETFILTER(Comment, '<>%1', '');
                    //usersetup.CALCFIELDS(Picture);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                //CALCFIELDS("ERC Memo"."Memo Body");
                //"Memo Body".CREATEINSTREAM(instr);
                //instr.READ(memobody);
                memobody := Memo."Memo Body";
                corec.GET;
                corec.CALCFIELDS(Picture);

                approvalentry.RESET;
                approvalentry.SETFILTER("Document No.", Memo."Memo No");
                approvalentry.SETFILTER(Status, '%1', approvalentry.Status::Approved);
                IF approvalentry.FINDSET THEN BEGIN
                    usersetup.RESET;
                    usersetup.GET(approvalentry."Approver ID");
                    /*usersetup.CALCFIELDS(Picture);
                    IF usersetup.Picture.HASVALUE THEN BEGIN
                        //MESSAGE('...');
                    END;*/
                END;
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
        instr: InStream;
        outstr: OutStream;
        memobody: Text;
        approvalentry: Record "Approval Entry";
        corec: Record "Company Information";
        usersetup: Record "User Setup";
        approver: Text;
        Emprec: Record Employee;
        designation: Text;
        jobgroup: Text;
        lineamount: Decimal;
}

