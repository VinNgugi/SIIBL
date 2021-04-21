page 51511067 "Memo Lines"
{
    // version FINANCE

    PageType = ListPart;
    SourceTable = "Memo";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Memo No"; "Memo No")
                {
                    Visible = false;
                }
                field("Budget Name"; "Budget Name")
                {
                    Visible = false;
                }
                /* field(Member; Member)
                {
                    Editable = linefieldedit;
                } */
                field(Department; Department)
                {
                    Editable = false;
                    Visible = false;
                }
               /*  field("Department Name"; "Department Name")
                {
                    Editable = false;
                } */
                /* field("Line No"; "Line No")
                {
                    Visible = false;
                } */
               /*  field("G/L Account"; "G/L Account")
                {
                    Editable = linefieldedit;
                } */
                /* field("G/L Account Name"; "G/L Account Name")
                {
                    Editable = false;
                } */
                /* field(Description; Description)
                {
                    Editable = linefieldedit;
                } */
                /* field(Quantity; Quantity)
                {
                    Editable = linefieldedit;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    Editable = linefieldedit;
                }
                field("Unit Price"; "Unit Price")
                {
                    Editable = linefieldedit;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field(Combine; Combine)
                {
                    Editable = Createimpresteditable;
                    Visible = false;
                }
                field("Create Imprest"; "Create Imprest")
                {
                    Editable = Createimpresteditable;
                    Visible = Hidecreateimprest;
 
                    trigger OnValidate()
                    begin
                        //Confirm if Committed Amount Exists============
                        commitrec1.RESET;
                        commitrec1.SETRANGE("Document No.", "Memo No");
                        commitrec1.SETRANGE(Memo, TRUE);
                        commitrec1.SETRANGE("Memo Member", USERID);
                        commitrec1.SETRANGE("Finance Released", TRUE);
                        IF commitrec1.FINDSET THEN BEGIN
                            ERROR('The Your Memo Line has been Released From Commitment By Finance.\Please Enquire from Finance Team.');
                        END;
                        //==============================================
                        IF "Create Imprest" = TRUE THEN BEGIN
                            ercmemo.RESET;
                            ercmemo.GET("Memo No");
                            //commitcu.CreateImprest(ercmemo);
                            CurrPage.CLOSE;
                        END;
                        IF "Create Imprest" = FALSE THEN BEGIN
                            ERROR('Imprest Already Created');
                        END;
                    end;
                }*/
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //MESSAGE(Member);
        /* IF Member = USERID THEN BEGIN
            Createimpresteditable := TRUE;
        END;
        IF Member <> USERID THEN BEGIN
            Createimpresteditable := FALSE;
        END; */
    end;

    trigger OnAfterGetRecord()
    begin
        //ERROR('..'+"Memo No");
        memoheader.RESET;
        memoheader.GET("Memo No");
        IF memoheader.Status = memoheader.Status::Open THEN BEGIN
            linefieldedit := TRUE;
        END;
        IF memoheader.Status <> memoheader.Status::Open THEN BEGIN
            linefieldedit := FALSE;
            Hidecreateimprest := TRUE;
        END;
        //Combine := TRUE;
        IF memoheader.Status <> memoheader.Status::Open THEN BEGIN
            Hidecreateimprest := FALSE;
        END;
        IF memoheader.Status = memoheader.Status::Released THEN BEGIN
            linefieldedit := FALSE;
            ercmemolines.RESET;
            ercmemolines.SETRANGE("Memo No", memoheader."Memo No");
            ercmemolines.SETRANGE(Member, USERID);
            IF ercmemolines.FINDSET THEN BEGIN
                Hidecreateimprest := TRUE;
            END;
        END;
    end;

    trigger OnOpenPage()
    begin
        linefieldedit := TRUE;
        Hidecreateimprest := FALSE;
    end;

    var
        memoheader: Record Memo;
        linefieldedit: Boolean;
        Createimpresteditable: Boolean;
        Hidecreateimprest: Boolean;
        ercmemo: Record Memo;
        ercmemolines: Record "Memo Lines";
        commitrec1: Record "Commitment Entries";
        commitrec2: Record "Memo Lines";
}

