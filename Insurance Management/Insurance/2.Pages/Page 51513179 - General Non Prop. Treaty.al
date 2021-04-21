page 51513179 "General Non Prop. Treaty"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = Treaty;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Treaty Code"; "Treaty Code")
                {
                }
                field("Treaty description"; "Treaty description")
                {
                }
                field("Addendum Code"; "Addendum Code")
                {
                }
                field(Type; Type)
                {
                }
                field("Effective date"; "Effective date")
                {
                }
                field("Expiry Date"; "Expiry Date")
                {
                }
                field("Accounts preparation"; "Accounts preparation")
                {
                }
                field("Apportionment Type"; "Apportionment Type")
                {
                }
                field("Class of Insurance"; "Class of Insurance")
                {
                }
                field("Treaty Status"; "Treaty Status")
                {
                }
                field("Territory Code"; "Territory Code")
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field(Broker; Broker)
                {
                }
                field("Broker Name"; "Broker Name")
                {
                }
                field("Contract Currency Code"; "Contract Currency Code")
                {
                }
                field("Settlement Currency Code"; "Settlement Currency Code")
                {
                }
                field(Blocked; Blocked)
                {
                }
                field("Claim Notification Period"; "Claim Notification Period")
                {
                }
                field("Lead Reinsurer"; "Lead Reinsurer")
                {
                }
            }
            group("Additional Information")
            {
                field("Quota Share"; "Quota Share")
                {
                }
                field(Surplus; Surplus)
                {
                }
                field(Facultative; Facultative)
                {
                }
                field("Exess of loss"; "Exess of loss")
                {
                }
                field(Warranty; Warranty)
                {
                }
                field("Minimum Premium Deposit (MDP)"; "Minimum Premium Deposit (MDP)")
                {
                }
                field("MDP No. Of Instalments"; "MDP No. Of Instalments")
                {
                }
                field("Limit Of Indemnity"; "Limit Of Indemnity")
                {
                }
                field("Automatic Cover Limit"; "Automatic Cover Limit")
                {
                }
                field("Premium Rate"; "Premium Rate")
                {
                }
                field("Actual Premium"; "Actual Premium")
                {
                }
                field("Main Class Code"; "Main Class Code")
                {
                }
                field("Premium Calculation Method"; "Premium Calculation Method")
                {
                }
                field("Reinstatement Premium Method"; "Reinstatement Premium Method")
                {
                }
                field("Total Resinsurance Share"; "Total Resinsurance Share")
                {
                }
            }
            part("XOL Layers"; "XOL Layers")
            {
                SubPageLink = "Treaty Code" = FIELD("Treaty Code"), "Addendum Code" = FIELD("Addendum Code");
            }
            part("Reinsurance Loadings"; "Reinsurance Loadings")
            {
            }
            group("EXCESS LOSS")
            {
            }
            part("XOL Reinsurers"; 51513045)
            {
                Caption = 'XOL Reinsurers';
                SubPageLink = "Excess of loss" = CONST(True),
                              "Treaty Code" = FIELD("Treaty Code"),
                              "Addendum Code" = FIELD("Addendum Code");
            }
            group("Audit Trail")
            {
                field("Created By"; "Created By")
                {
                }
                field("Date Created"; "Date Created")
                {
                }
                field("Sent For Approval"; "Sent For Approval")
                {
                }
                field("Date Sent For Approval"; "Date Sent For Approval")
                {
                }
                field("Approved By"; "Approved By")
                {
                }
                field("Approval Date"; "Approval Date")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            group(Approve)
            {
                action("Send for Approval")
                {
                }
                action("Approve Treaty")
                {
                }
            }
            group(Treaty)
            {
               /*  action("Cedant Commission Setup")
                {
                    RunObject = Page "LIFE Commissions";
                    RunPageLink = " Treaty Code" = FIELD("Treaty Code"),
                                  "Addendum Code" = FIELD("Addendum Code");
                }
                action("Medical Tests")
                {
                    RunObject = Page 51513385;
                    RunPageLink = "Treaty Code" = FIELD("Treaty Code"),
                                  "Addendum Code" = FIELD("Addendum Code");
                }
                action("Free Cover Limit")
                {
                    RunObject = Page 51513386;
                    RunPageLink = "Treaty Code" = FIELD("Treaty Code"),
                                  "Addendum Code" = FIELD("Addendum Code");
                }
                action("View Addendum")
                {
                    RunObject = Page 51513387;
                    RunPageLink = "Treaty Code" = FIELD("Treaty Code");
                } */
                action("Create Addendum")
                {

                    trigger OnAction();
                    begin


                        IF CONFIRM('Are you sure you want to ammend this treaty?', FALSE) THEN BEGIN
                            TESTFIELD("Expiry Date");
                            //Insert in main treaty table
                            TreatyVal.INIT;
                            TreatyVal."Treaty Code" := "Treaty Code";
                            TreatyVal."Addendum Code" := "Addendum Code" + 1;
                            TreatyVal."Treaty Description" := "Treaty description";
                            //TreatyVal."Ceding office":="Ceding office";
                            //TreatyVal."Ceding office Name":="Ceding office Name";
                            //TreatyVal."Cedant Commission":="Cedant Commission";
                            TreatyVal.Broker := Broker;
                            TreatyVal."Broker Name" := "Broker Name";
                            TreatyVal."Broker Commision" := "Broker Commision";
                            TreatyVal."Currency Code" := "Contract Currency Code";
                            TreatyVal."Cash call limit" := "Cash call limit";
                            TreatyVal."Quota Share" := "Quota Share";
                            TreatyVal.Surplus := Surplus;
                            TreatyVal.Facultative := Facultative;
                            TreatyVal."Exess of loss" := "Exess of loss";
                            TreatyVal."Quota share Retention" := "Quota share Retention";
                            TreatyVal."Surplus Retention" := "Surplus Retention";
                            TreatyVal."Cedant quota percentage" := "Cedant quota percentage";
                            TreatyVal."Premium income period" := "Premium income period";
                            TreatyVal."Premiun reserve period" := "Premiun reserve period";
                            TreatyVal."Profit commission percentage" := "Profit commission percentage";
                            TreatyVal."Commission period" := "Commission period";
                            TreatyVal."Premium reserve cf period" := "Premium reserve cf period";
                            TreatyVal."Premium reserve cf percentage" := "Premium reserve cf percentage";
                            TreatyVal."Claims period" := "Claims period";
                            TreatyVal."Admin Expenses percentage" := "Admin Expenses percentage";
                            TreatyVal."Effective date" := CALCDATE('CD+1D', "Expiry Date");
                            TreatyVal."Accounts preparation" := "Accounts preparation";
                            TreatyVal."Free Cover Limit" := "Free Cover Limit";
                            TreatyVal."Treaty Type" := "Treaty Type";
                            TreatyVal."Treaty Status" := "Treaty Status"::Pending;

                            TreatyVal."Territory Code" := "Territory Code";
                            TreatyVal."Country/Region Code" := "Country/Region Code";
                            TreatyVal."Expiry Date" := 20991231D;
                            TreatyVal.Type := Type;
                            TreatyVal."Max Free Cover limit" := "Max Free Cover limit";
                            TreatyVal."Max Age Limit" := "Max Age Limit";
                            TreatyVal."Date Created" := TODAY;
                            TreatyVal."Created By" := USERID;
                            //TreatyVal."Rider Commission":="Rider Commission";
                            //TreatyVal."Renewal Cedant Commision":="Renewal Cedant Commision";
                            //TreatyVal."Renewal Rider Commision":="Renewal Rider Commision";
                            //TreatyVal."Mandatory Cession Percentage":="Mandatory Cession Percentage";
                            TreatyVal."Renewal Broker Commision" := "Renewal Broker Commision";

                            //TreatyVal.Blocked:=Blocked;
                            TreatyVal.INSERT(TRUE);


                            //Blocked:=TRUE;
                            //MODIFY;

                            //Insert in Treaty products table.
                            TreatyProducts.RESET;
                            TreatyProducts.SETRANGE(TreatyProducts."Treaty Code", "Treaty Code");
                            TreatyProducts.SETRANGE(TreatyProducts."Addendum Code", "Addendum Code");
                            IF TreatyProducts.FIND('-') THEN BEGIN
                                REPEAT
                                    TreatyProducts1.INIT;
                                    TreatyProducts1."Product Code" := TreatyProducts."Product Code";
                                    TreatyProducts1."Treaty Code" := TreatyProducts."Treaty Code";
                                    TreatyProducts1.Rider := TreatyProducts.Rider;
                                    TreatyProducts1."Addendum Code" := "Addendum Code" + 1;
                                    TreatyProducts1."Product Decription" := TreatyProducts."Product Decription";
                                    TreatyProducts1."Quota Share" := TreatyProducts."Quota Share";
                                    TreatyProducts1.Surplus := TreatyProducts.Surplus;
                                    TreatyProducts1.Facultative := TreatyProducts.Facultative;
                                    TreatyProducts1."Exess of loss" := TreatyProducts."Exess of loss";
                                    TreatyProducts1."Quota share Retention" := TreatyProducts."Quota share Retention";
                                    TreatyProducts1."Surplus Retention" := TreatyProducts."Surplus Retention";
                                    TreatyProducts1."Cedant quota percentage" := TreatyProducts."Cedant quota percentage";

                                    TreatyProducts1.INSERT(TRUE);
                                UNTIL TreatyProducts.NEXT = 0;
                            END;

                            //Insert in reassurance share table
                            ReassuranceShare.RESET;
                            ReassuranceShare.SETRANGE(ReassuranceShare."Treaty Code", "Treaty Code");
                            ReassuranceShare.SETRANGE(ReassuranceShare."Addendum Code", "Addendum Code");

                            IF ReassuranceShare.FIND('-') THEN BEGIN
                                REPEAT
                                    ReassuranceShare1.INIT;
                                    ReassuranceShare1."Treaty Code" := "Treaty Code";
                                    ReassuranceShare1."Qouta Share" := ReassuranceShare."Qouta Share";
                                    ReassuranceShare1.Surplus := ReassuranceShare.Surplus;
                                    ReassuranceShare1.Facultative := ReassuranceShare.Facultative;
                                    ReassuranceShare1."Excess of loss" := ReassuranceShare."Excess of loss";
                                    ReassuranceShare1."Reassurer code" := ReassuranceShare."Reassurer code";
                                    ReassuranceShare1."Addendum Code" := "Addendum Code" + 1;
                                    ReassuranceShare1."Reasurer Name" := ReassuranceShare."Reasurer Name";
                                    ReassuranceShare1."Percentage %" := ReassuranceShare."Percentage %";
                                    ReassuranceShare1."% Of Remainder" := ReassuranceShare."% Of Remainder";
                                    ReassuranceShare1.INSERT(TRUE);
                                UNTIL ReassuranceShare.NEXT = 0;
                            END;


                            //Block the prevoius treaty.
                            TreatyVal.GET("Treaty Code", "Addendum Code");
                            TreatyVal.Blocked := TRUE;
                            TreatyVal.MODIFY;

                            TreatyProducts.RESET;
                            TreatyProducts.SETRANGE(TreatyProducts."Treaty Code", "Treaty Code");
                            TreatyProducts.SETRANGE(TreatyProducts."Addendum Code", "Addendum Code");
                            IF TreatyProducts.FIND('-') THEN BEGIN
                                REPEAT
                                    TreatyProducts.Blocked := TRUE;
                                    TreatyProducts.MODIFY;

                                UNTIL TreatyProducts.NEXT = 0;
                            END;


                            ReassuranceShare.RESET;
                            ReassuranceShare.SETRANGE(ReassuranceShare."Treaty Code", "Treaty Code");
                            ReassuranceShare.SETRANGE(ReassuranceShare."Addendum Code", "Addendum Code");

                            IF ReassuranceShare.FIND('-') THEN BEGIN
                                REPEAT
                                    ReassuranceShare.Blocked := TRUE;
                                    ReassuranceShare.MODIFY;
                                UNTIL ReassuranceShare.NEXT = 0;
                            END;



                            //Run the treaty form with the new record.
                            PAGE.RUN(51513382, TreatyVal);

                            MESSAGE('A new treaty has been created.Please make the necessary changes on this treaty');

                        END;
                    end;
                }
                action("Group Schemes")
                {
                   /*  RunObject = Page 51513388;
                    RunPageLink = "Treaty Code" = FIELD("Treaty Code"); */
                }
                action("Policy Holders")
                {
                }
                action("Minimum Deposit Premium -Payment schedule")
                {
                    Caption = 'Generate MDP schedule';

                    trigger OnAction();
                    begin
                        InsMgt.DrawMDPPayScheduleTreaty(Rec);
                    end;
                }
                action("View MDP schedule")
                {
                    Caption = 'MDP schedule';
                    RunObject = Page 51513451;
                    RunPageLink = "Treaty Code" = FIELD("Treaty Code"),
                                  "Treaty Addendum" = FIELD("Addendum Code");
                }
            }
        }
    }

    trigger OnClosePage();
    begin
        CALCFIELDS("Total Resinsurance Share");

        IF "Total Resinsurance Share" <> 100 THEN
            ERROR('The percentage share is %1 not 100% please Check before Closing PAGE', "Total Resinsurance Share");
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Treaty Type" := "Treaty Type"::Cession;
        "Apportionment Type" := "Apportionment Type"::"Non-proportional";
        Type := Type::"General Business";
    end;

    var
        TreatyVal: Record "LIFE Treaty";
        TreatyProducts: Record "Treaty  Products";
        TreatyProducts1: Record "Treaty  Products";
        ReassuranceShare: Record "Reassurance Share";
        ReassuranceShare1: Record "Reassurance Share";
        InteractTemplLanguage: Record 5103;
        UserRole: Record 2000000053;
        Mail: Codeunit 397;
        compinfo: Record 79;
        MailDescription: Text[200];
        Text1: Label 'Please Approve Treaty Number::';
        Text2: Label 'Addendum Number::';
        InsMgt: Codeunit "Insurance management";
}

