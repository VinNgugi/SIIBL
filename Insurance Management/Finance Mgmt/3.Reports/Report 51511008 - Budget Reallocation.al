report 51511008 "Budget Reallocation"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Budget Reallocation.rdl';

    dataset
    {
        dataitem("Budget Approval"; "Budget Approval")
        {
            RequestFilterFields = "Approval No";
            column(ApprovalNo_BudgetApproval; "Budget Approval"."Approval No")
            {
            }
            column(DestinationGL_BudgetApproval; "Budget Approval"."Destination G/L")
            {
            }
            column(AmountRequested_BudgetApproval; "Budget Approval"."Amount Requested")
            {
            }
            column(CurrentBudget_BudgetApproval; "Budget Approval"."Current Budget")
            {
            }
            column(RequestingUser_BudgetApproval; "Budget Approval"."Requesting User")
            {
            }
            column(ReallocationSubject_BudgetApproval; "Budget Approval"."Reallocation Subject")
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
            column(TransferRequestDate_BudgetApproval; "Budget Approval"."Transfer Request Date")
            {
            }
            /*   dataitem("Budget Reallocation Lines"; "Budget Reallocation Lines")
              {
                  DataItemLink = "Approval No"=FIELD("Approval No");
                  column(FromBudgetLine_BudgetReallocationLines; "Budget Reallocation Lines"."From Budget Line")
                  {
                  }
                  column(FromBudgetLineName_BudgetReallocationLines; "Budget Reallocation Lines"."From Budget Line Name")
                  {
                  }
                  column(ToBudgetLine_BudgetReallocationLines; "Budget Reallocation Lines"."To Budget Line")
                  {
                  }
                  column(ToBudgetLineName_BudgetReallocationLines; "Budget Reallocation Lines"."To Budget Line Name")
                  {
                  }
                  column(AvailableAmount_BudgetReallocationLines; "Budget Reallocation Lines"."Available Amount")
                  {
                  }
                  column(TransferAmount_BudgetReallocationLines; "Budget Reallocation Lines"."Transfer Amount")
                  {
                  }
                  column(FromDepartment_BudgetReallocationLines; "Budget Reallocation Lines"."From Department")
                  {
                  }
                  column(ToDepartment_BudgetReallocationLines; "Budget Reallocation Lines"."To Department")
                  {
                  }

                  trigger OnPreDataItem()
                  begin
                      "Budget Reallocation Lines".SETFILTER("Budget Reallocation Lines"."From Budget Line", '<>%1', '');
                  end;
              } */
            dataitem("Approval Comment Line"; "Approval Comment Line")
            {
                DataItemLink = "Document No." = FIELD("Approval No");
                DataItemTableView = WHERE("Table ID" = CONST(51511692));
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
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Budget Approval"."Re-Allocation Message");
                "Budget Approval"."Re-Allocation Message".CREATEINSTREAM(instr);
                instr.READ(memobody);

                corec.GET;
                corec.CALCFIELDS(Picture);

                approvalentry.RESET;
                //approvalentry.SETFILTER("Document Type",'%1',approvalentry."Document Type"::"Budget Approval");
                approvalentry.SETFILTER("Document No.", "Budget Approval"."Approval No");
                approvalentry.SETFILTER(Status, '%1', approvalentry.Status::Approved);
                IF approvalentry.FINDSET THEN BEGIN
                    usersetup.RESET;
                    usersetup.GET(approvalentry."Approver ID");
                    //usersetup.CALCFIELDS(Picture);
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
}

