report 51511000 "Generate PV Lines"
{
    // version FINANCE

    DefaultLayout = RDLC;
    RDLCLayout = './Finance Mgmt/5.Layouts/Generate PV Lines.rdl';

    dataset
    {
        dataitem("Request Header"; "Request Header")
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Request Date", "Approval Date";
            column(Request_Header1__No__; "No.")
            {
            }
            column(Request_Header1__Employee_No_; "Employee No")
            {
            }
            column(Request_Header1__Employee_Name_; "Employee Name")
            {
            }
            column(Request_Header1__Total_Amount_Requested_; ImprestBal)
            {
            }
            column(Request_Header1__Total_Amount_Requested_1; "Imprest Amount")
            {
            }
            column(Request_Header1__Transaction_Type_; "Transaction Type")
            {
            }
            column(Request_Header1__No__Caption; FIELDCAPTION("No."))
            {
            }
            column(Request_Header1__Employee_No_Caption; FIELDCAPTION("Employee No"))
            {
            }
            column(Request_Header1__Employee_Name_Caption; FIELDCAPTION("Employee Name"))
            {
            }
            column(Request_Header1__Total_Amount_Requested_Caption1; FIELDCAPTION("Imprest Amount"))
            {
            }
            column(Request_Header1__Total_Amount_Requested_Caption; ImprestBal)
            {
            }
            column(Request_Header1__Transaction_Type_Caption; FIELDCAPTION("Transaction Type"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLSetup.GET;
                ImprestBal := 0;
                IF "Request Header"."Attached to PV No" <> '' THEN BEGIN
                    PV2.RESET;
                    PV2.SETFILTER(No, "Request Header"."Attached to PV No");
                    PV2.SETFILTER(Status, '<>%1', PV2.Status::Open);
                    PV2.SETFILTER(Date, '<>%1', 0D);
                    IF PV2.FINDSET THEN BEGIN
                        //ERROR('%1..',PV.No);
                        CurrReport.SKIP;
                    END;
                    // CurrReport.SKIP;
                END;

                //=================================================================================================================================================
                ImprestBal := 0;
                "Request Header".CALCFIELDS("Request Header"."Total Amount Requested", "Request Header"."Imprest Amount");
                IF "Request Header"."Petty Cash Serials" <> '' THEN
                    CurrReport.SKIP;

                /* IF "Request Header"."Imprest Amount" >= GLSetup."Cash Limit" THEN
                    CurrReport.SKIP;
                IF "Request Header"."Transaction Type" = 'IMPREST' THEN BEGIN
                    //ERROR("Request Header"."No.");
                    IF "Request Header"."Imprest Amount" >= GLSetup."Cash Limit" THEN
                        CurrReport.SKIP; */
                "Request Header".CALCFIELDS("Request Header"."Total Amount Requested", "Request Header"."Imprest Balance");
                ImprestBal := "Request Header"."Imprest Amount";//"Request Header"."Total Amount Requested"-
                ClaimBal := "Request Header"."Imprest Amount";//"Request Header"."Total Amount Requested"-
                IF ImprestBal <= 0 THEN
                    CurrReport.SKIP;
                // Lineno+=1000;

                PVlines.INIT;
                PVlines."PV No" := PV.No;
                PVlines."Line No" := PVlines."Line No" + 1000;
                PVlines."Account Type" := PVlines."Account Type"::Customer;
                PVlines."Account No" := "Request Header"."Customer A/C";
                PVlines.VALIDATE(PVlines."Account No");
                //PVlines."Gross Amount" := ImprestBal;
                PVlines.Description := "Request Header"."Employee Name" + '-Imprest';
                //PVlines.Transactionref := 'ATTAIN-' + "Request Header"."No.";

                IF Empl.GET("Request Header"."Employee No") THEN BEGIN
                    //PVlines."Bank Account No" := Empl."Bank Account Number";
                    //PVlines."KBA Branch Code" := Empl."Employee's Bank";
                   // PVlines."Employee No" := Empl."No.";
                   // PVlines.VALIDATE("Employee No");
                END;
                PVlines.Amount := ImprestBal;
                PVlines."Net Amount" := ROUND(ImprestBal, 0.1);
                PVlines."Loan No" := "No.";
                IF Cust.GET(PVlines."Account No") THEN
                    PVlines."Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
                PVlines.INSERT;


                IF "Request Header"."Transaction Type" = 'CLAIM' THEN BEGIN
                    Lineno += 10000;
                    "Request Header".CALCFIELDS("Request Header"."Total Amount Requested");
                    //ERROR('tell us value %1 %2',"Request Header"."Total Amount Requested","Request Header"."Imprest/Advance No");
                    RequestLines1.RESET;
                    RequestLines1.SETRANGE("Document No", "Request Header"."Imprest/Advance No");
                    RequestLines1.CALCSUMS("Requested Amount");
                    ImprestBal := "Request Header"."Total Amount Requested" - RequestLines1."Requested Amount";
                    //ERROR('first %1 second %2',"Request Header"."Total Amount Requested",RequestLines1."Requested Amount");
                    IF ImprestBal <= 0 THEN
                        CurrReport.SKIP;
                    IF (ImprestBal) <= GLSetup."Cash Limit" THEN
                        CurrReport.SKIP;
                    //IF "Request Header"."Claim accounting Balance">=0 THEN
                    //IF  ("Request Header"."Total Amount Requested"-RequestLines1."Requested Amount")<=0 THEN //====added by mike
                    // CurrReport.SKIP;

                    // "Request Header".CALCFIELDS("Request Header".Balance,"Request Header"."Total Amount Requested");
                    IF (ImprestBal) > GLSetup."Cash Limit" THEN
                    //IF ("Request Header"."Total Amount Requested"-RequestLines1."Requested Amount")<=GLSetup."Cash Limit" THEN
                    BEGIN
                        PVlines.INIT;
                        PVlines."PV No" := PV.No;
                        PVlines."Line No" := Lineno;//PVlines."Line No"+1000;
                        PVlines."Account Type" := PVlines."Account Type"::Customer;
                        PVlines."Account No" := "Request Header"."Customer A/C";
                        PVlines.VALIDATE(PVlines."Account No");
                        PVlines.Description := "Request Header"."Employee Name" + '-Imprest Refund';
                        //PVlines.Transactionref := 'ATTAIN-' + "Request Header"."No.";
                        IF Empl.GET("Request Header"."Employee No") THEN BEGIN
                            //PVlines."Bank Account No" := Empl."Bank Account Number";
                            //PVlines."KBA Branch Code" := Empl."Employee's Bank";
                            //PVlines."Employee No" := Empl."No.";
                        END;

                        PVlines."Account Name" := "Request Header"."Employee Name";
                        //PVlines.Amount:=-"Request Header"."Claim accounting Balance";
                        PVlines.Amount := ImprestBal;//"Request Header"."Total Amount Requested"-"Request Header"."Imprest Amount";
                        //PVlines."Gross Amount" := ImprestBal;//"Request Header"."Total Amount Requested"-"Request Header"."Imprest Amount";
                        PVlines."Net Amount" := ROUND(ImprestBal, 0.1);
                        //PVlines."Loan No":="Request Header"."Imprest/Advance No";
                        PVlines."Loan No" := "Request Header"."No.";
                        IF Cust.GET(PVlines."Account No") THEN
                            PVlines."Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";

                        IF PVlines.Amount <= 0 THEN
                            CurrReport.SKIP;

                        IF PVlines.Amount <> 0 THEN
                            PVlines.INSERT;


                    END
                    ELSE
                        CurrReport.SKIP;
                END;

                /* IF ("Request Header"."Document Type" = "Request Header"."Document Type"::Refund) OR ("Request Header"."Document Type" = "Request Header"."Document Type"::"Claim/Refund") THEN BEGIN
                    Lineno += 11000;
                    //ERROR('434334');
                    "Request Header".CALCFIELDS("Request Header"."Total Amount Requested", "Request Header"."Imprest Balance");
                    ClaimBal := "Request Header"."Total Amount Requested";//"Request Header"."Total Amount Requested"-
                    ImprestBal := "Request Header"."Total Amount Requested";//"Request Header"."Total Amount Requested"-"Request Header"."Imprest Balance";
                                                                            //ERROR('AMOUNT %1',ImprestBal);
                    IF (ImprestBal) <= GLSetup."Cash Limit" THEN
                        CurrReport.SKIP;
                    IF ClaimBal <= 0 THEN
                        CurrReport.SKIP;
                    PVlines.INIT;
                    PVlines."PV No" := PV.No;
                    PVlines."Line No" := Lineno;//PVlines."Line No"+11000;
                    PVlines."Account Type" := PVlines."Account Type"::Customer;
                    PVlines."Account No" := "Request Header"."Customer A/C";
                    PVlines.VALIDATE(PVlines."Account No");
                    PVlines.Description := "Request Header"."Employee Name" + '-Claim Refund';
                    PVlines.Transactionref := 'ATTAIN-' + "Request Header"."No.";
                    IF Empl.GET("Request Header"."Employee No") THEN BEGIN
                        PVlines."Bank Account No" := Empl."Bank Account Number";
                        PVlines."KBA Branch Code" := Empl."Employee's Bank";
                        PVlines."Employee No" := Empl."No.";
                    END;
                    PVlines.Amount := ClaimBal;//"Request Header"."Total Amount Requested"-"Request Header"."Imprest Amount";
                    PVlines."Gross Amount" := ClaimBal;//"Request Header"."Total Amount Requested"-"Request Header"."Imprest Amount";
                    PVlines."Net Amount" := ROUND(ClaimBal, 0.1);//"Request Header"."Total Amount Requested"-"Request Header"."Imprest Amount";
                    PVlines."Loan No" := "No.";
                    IF Cust.GET(PVlines."Account No") THEN
                        PVlines."Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
                    IF PVlines.Amount <= 0 THEN
                        CurrReport.SKIP;
                    IF PVlines.Amount <> 0 THEN
                        PVlines.INSERT;


                    //PVlines.INSERT;
                    IF Cust.GET(PVlines."Account No") THEN
                        PVlines."Shortcut Dimension 2 Code" := Cust."Global Dimension 2 Code";
                    PVlines.MODIFY;


                    //END;
                    bankrec.RESET;
                    bankrec.SETRANGE(Code, PVlines."KBA Branch Code");
                    IF bankrec.FINDFIRST THEN BEGIN
                        PVlines."Branch Name" := bankrec.Name;
                        PVlines."Bank Name" := bankrec.Name;

                        PVlines.MODIFY;
                    END;
                    //==========mark request has done=====================
                    IF RequestHeader.GET("Request Header"."No.") THEN BEGIN
                        RequestHeader."Attached to PV No" := PV.No;
                        RequestHeader.MODIFY;
                        // MESSAGE('goog');
                    END;
                    //========================================================================================================================================================

                end; */
            end;

            trigger OnPreDataItem()
            begin

                LastFieldNo := FIELDNO("No.");
                GLSetup.GET;
                //SETFILTER("Request Header"."Attached to PV No",'%1','');
                SETFILTER(Status, '%1', Status::Released);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        GLSetup: Record "General Ledger Setup";
        PV: Record Payments1;
        PVlines: Record 51511001;
        ImprestBal: Decimal;
        Cust: Record Customer;
        bankrec: Record 51511010;
        custledgerentries: Record "Cust. Ledger Entry";
        pvheader: Record Payments1;
        Lineno: Integer;
        PV2: Record Payments1;
        RequestHeader1: Record "Request Header";
        RequestHeader: Record "Request Header";
        RequestLines1: Record 51511004;
        ClaimBal: Decimal;
        Empl: Record Employee;

    procedure GetPV(var PVHeader: Record Payments1)
    var
        PVLines: Record 51511001;
    begin
        PV.COPY(PVHeader);
        //MESSAGE('%1',PV.No);



        //REMOVED CODE FROM ONAFTER LOAD
        //MESSAGE('%1...%2',"Request Header"."No.","Request Header".Type);
        /*
        IF "Request Header".Type="Request Header".Type::"Claim-Accounting" THEN BEGIN
            CurrReport.SKIP;
        END;
        "Request Header".CALCFIELDS("Request Header"."Imprest Amount");
        //MESSAGE('%1..%2',"Request Header"."Imprest Amount","Request Header".Type);
        IF "Request Header".Type="Request Header".Type::Imprest THEN BEGIN
            IF "Request Header"."Imprest Amount"<=GLSetup."Cash Limit" THEN
            CurrReport.SKIP;
        END;
        ImprestBal:=0;
        IF "Request Header".Type="Request Header".Type::Imprest THEN
        BEGIN
                        // MESSAGE('...');
                         "Request Header".CALCFIELDS("Request Header"."Imprest Amount","Request Header"."Imprest Balance");
                         ImprestBal:="Request Header"."Imprest Amount"-"Request Header"."Imprest Balance";
                         ImprestBal:="Request Header"."Imprest Amount";
                         IF ImprestBal=0 THEN
                         CurrReport.SKIP;

                         //MESSAGE('1..');

                         PVlines.INIT;
                         PVlines."PV No":=PV.No;
                        // PVlines."Line No":=PVlines."Line No"+10000+Lineno;
                         PVlines."Line No":=PVlines."Line No"+1000;
                         PVlines."Account Type":=PVlines."Account Type"::Customer;
                         PVlines."Account No":="Request Header"."Customer A/C";
                         PVlines.VALIDATE(PVlines."Account No");
                         PVlines.Description:="Request Header"."Employee Name"+'-Imprest';
                         PVlines.Amount:=ImprestBal;
                         PVlines."Net Amount":=ImprestBal;
                         PVlines.VALIDATE(PVlines.Amount);
                         PVlines."Loan No":="No.";
                         PVlines.Commitno:="Request Header"."No.";
                         //=============================bank info names
                         bankrec.RESET;
                         bankrec.SETFILTER(Code,PVlines."KBA Branch Code");
                         IF bankrec.FINDSET THEN BEGIN
                            PVlines."Branch Name":=bankrec.Name;
                            //PVlines."Bank Name":=bankrec.
                         END;
                         //==========================================
                         IF Cust.GET(PVlines."Account No") THEN
                         PVlines."Shortcut Dimension 2 Code":=Cust."Global Dimension 2 Code";
                         PVlines.INSERT;
                         "Request Header"."Attached to PV No":=PV.No;
                         "Request Header".MODIFY;
                        // MESSAGE('imprest added...');
        END;

        IF "Request Header".Type="Request Header".Type::"Claim/Refund" THEN
        BEGIN
                            "Request Header".CALCFIELDS("Request Header"."Imprest Amount");
                           // MESSAGE('**%1..',"Request Header"."Imprest Amount");
                           IF "Request Header"."Imprest Amount"=0 THEN
                              CurrReport.SKIP;
                            "Request Header".CALCFIELDS("Request Header".Balance,"Request Header"."Imprest Amount");
                            IF ("Request Header"."Imprest Amount")<>0 THEN
                            BEGIN

                             PVlines.INIT;
                             PVlines."PV No":=PV.No;
                             //PVlines."Line No":=PVlines."Line No"+10000+Lineno;
                             PVlines."Line No":=PVlines."Line No"+1000;
                             PVlines."Account Type":=PVlines."Account Type"::Customer;
                             PVlines."Account No":="Request Header"."Customer A/C";
                             PVlines.VALIDATE(PVlines."Account No");
                             PVlines.Description:="Request Header"."Employee Name"+'-Imprest Refund';
                             PVlines."Account Name":="Request Header"."Employee Name";
                             PVlines.Amount:="Request Header"."Imprest Amount"; //MESSAGE('%1',PVlines.Amount);
                             PVlines.VALIDATE(Amount);
                             PVlines."Net Amount":=ImprestBal;
                             PVlines."Loan No":="Request Header"."Imprest/Advance No";                      IF Cust.GET(PVlines."Account No") THEN
                             PVlines."Shortcut Dimension 2 Code":=Cust."Global Dimension 2 Code";
                             PVlines."Applies to Doc. No":="Request Header"."No.";
                             //======================cust ledger entry===========
                             custledgerentries.RESET;
                             custledgerentries.SETFILTER("Customer No.","Request Header"."Customer A/C");
                             custledgerentries.SETFILTER("Document No.","Request Header"."No.");
                             IF custledgerentries.FINDSET THEN BEGIN
                                 PVlines."Applies-to Doc. Type":=custledgerentries."Document Type";
                             END;
                             //==================================================
                             //=============================bank info names
                             bankrec.RESET;
                             bankrec.SETFILTER(Code,PVlines."KBA Branch Code");
                             IF bankrec.FINDSET THEN BEGIN
                                PVlines."Branch Name":=bankrec.Name;
                                //PVlines."Bank Name":=bankrec.
                             END;
                         //==========================================
                             IF PVlines.Amount<>0 THEN
                             PVlines.INSERT;

                            // MESSAGE('claim added...');

                            "Request Header"."Attached to PV No":=PV.No;
                            "Request Header".MODIFY;
                            END
                            ELSE
                            CurrReport.SKIP;
        END;

        IF "Request Header".Type="Request Header".Type::"Leave Application" THEN
        BEGIN
        "Request Header".CALCFIELDS("Request Header"."Imprest Amount");
         PVlines.INIT;
         PVlines."PV No":=PV.No;
        // PVlines."Line No":=PVlines."Line No"+10000+Lineno;
         PVlines."Line No":=PVlines."Line No"+1000;
         PVlines."Account Type":=PVlines."Account Type"::Customer;
         PVlines."Account No":="Request Header"."Customer A/C";
         PVlines.VALIDATE(PVlines."Account No");
         PVlines.Description:="Request Header"."Employee Name"+'-Claim Refund';
         PVlines.Amount:="Request Header"."Imprest Amount"-"Request Header"."Total Amount Requested";
         PVlines."Loan No":="No.";
         IF Cust.GET(PVlines."Account No") THEN
         PVlines."Shortcut Dimension 2 Code":=Cust."Global Dimension 2 Code";
        PVlines.INSERT;
        END;
        */

    end;
}

