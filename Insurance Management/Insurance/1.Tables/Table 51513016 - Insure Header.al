table 51513016 "Insure Header"
{
    // version AES-INS 1.0

    DrillDownPageID = 51513058;
    LookupPageID = 51513058;

    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = ' ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement,Insurer Quotes';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement,"Insurer Quotes";
        }
        field(2; "No."; Code[30])
        {
        }
        field(3; "Insured No."; Code[20])
        {
            TableRelation = Customer;

            trigger OnValidate();
            begin
                IF Cust.GET("Insured No.") THEN BEGIN
                    "Insured Name" := Cust.Name;
                    IF "Agent/Broker" = '' THEN
                        "Agent/Broker" := Cust."Intermediary No.";
                    VALIDATE("Agent/Broker");
                    "Date of Birth" := Cust."Date of Birth";
                    "ID/Passport No." := Cust."ID/Passport No.";
                    "Insured Address" := Cust.Address;
                    "Insured Address 2" := Cust."Address 2";
                    Occupation := Cust.Occupation;
                    "Phone No." := Cust."Phone No.";

                END
                ELSE BEGIN
                    //Insetup.GET();
                    //"Insure Template Code":=Insetup."Insure Template Code";
                END;
                //MESSAGE('%1',Cust.Name)
            end;
        }
        field(4; "Family Name"; Text[20])
        {

            trigger OnValidate();
            begin
                //"Family Name":= insmangmt.StandardizeNames("Family Name");

                //"Insured Name":=FORMAT(Title)+' '+"First Names(s)"+ ' ' +"Family Name";


                /*IF Insetup.GET THEN
                BEGIN
                IF "Insured No."='' THEN
                "Insure Template Code":=Insetup."Insure Template Code";
                END;*/

            end;
        }
        field(5; "First Names(s)"; Text[20])
        {

            trigger OnValidate();
            begin
                //"First Names(s)":= insmangmt.StandardizeNames("First Names(s)");
                //"Insured Name":=FORMAT(Title)+' '+"First Names(s)"+ ' ' +"Family Name";
            end;
        }
        field(6; Title; Option)
        {
            OptionMembers = Mr,Mrs,Ms,Dr,Prof;

            trigger OnValidate();
            begin
                //"Insured Name":=FORMAT(Title)+' '+"First Names(s)"+ ' ' +"Family Name";
            end;
        }
        field(7; "Marital Status"; Option)
        {
            OptionMembers = Single,Married,Divorced,"Widowed ";
        }
        field(8; Sex; Enum Gender)
        {
            //OptionMembers = Male,Female;
        }
        field(9; "Date of Birth"; Date)
        {

            trigger OnValidate();
            begin

                Age := InsMngt.AgeCalculator("Date of Birth", "Document Date");
                //Test if age is valid
                //InsMngt.TestValidAge(Rec);
                //VALIDATE(Age);
            end;
        }
        field(10; "Height Unit"; Option)
        {
            OptionMembers = m,ft,inches,cm;
        }
        field(11; Height; Decimal)
        {
            DecimalPlaces = 1 : 2;

            trigger OnValidate();
            begin
                /*IF "Height Unit"="Height Unit"::ft THEN
                 "Height (m)":=Height*0.3048;
                 IF "Height Unit"="Height Unit"::inches THEN
                 "Height (m)":=Height*0.0254;
                 IF "Height Unit"="Height Unit"::cm THEN
                 "Height (m)":=Height*0.01;
                 IF "Height Unit"="Height Unit"::m THEN
                 "Height (m)":=Height;*/

            end;
        }
        field(12; "Weight Unit"; Option)
        {
            OptionMembers = Kg,Lbs,Stone;
        }
        field(13; Weight; Decimal)
        {

            // trigger OnValidate();


            // IF "Weight Unit" = "Weight Unit"::Lbs THEN begin
            /*"Weight (Kg)":=Weight*0.45;

            IF "Weight Unit"="Weight Unit"::Kg THEN
            "Weight (Kg)":=Weight;

             IF "Weight Unit"="Weight Unit"::Stone THEN
            "Weight (Kg)":=Weight*6.35;



            //BMI:=insmangmt.CalculateBMIenglish(Weight,Height);

            //IF "Weight Unit"="Weight Unit"::Kg THEN
             BMI:=insmangmt.CalculateBMImetric("Weight (Kg)","Height (m)");  */

            //end;
        }
        field(14; Industry; Text[20])
        {
            TableRelation = "Industry Group";
        }
        field(15; Occupation; Text[130])
        {
        }
        field(16; Nationality; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(17; "Country of Residence"; Code[10])
        {
            TableRelation = "Country/Region";

            trigger OnValidate();
            begin
                /* IF Country.GET("Country of Residence") THEN
                 // "Country of Residence Desc":=Country.Name;

                  IF Nationality="Country of Residence" THEN

                  //Test validity
                  BEGIN
                  Insetup.GET;

                  IF ZonedCountries.GET(Insetup."Default Zone","Country of Residence") THEN
                  BEGIN
                  IF NOT ZonedCountries."Allowed for Nationals" THEN
                  ERROR ('Sorry a %1 National living in %2 is not allowed to take this policy',"Nationality Description",
                  "Country of Residence Desc");
                  END;
                  END;

                  {//Fill area based on availability of
                   CountriesPerArea.RESET;
                   CountriesPerArea.SETRANGE(CountriesPerArea.Country,"Country of Residence");
                   IF CountriesPerArea.FIND('+') THEN
                   "Area of Cover":=CountriesPerArea.Area;}*/

            end;
        }
        field(18; Mobile; Code[14])
        {
        }
        field(19; "Premium Payment Frequency"; Option)
        {
            OptionMembers = " ","Annual Payment","Bi-Annual Payment","Quarterly Payment","Monthy Payment";
        }
        field(20; Forms; Text[130])
        {

            trigger OnValidate();
            begin
                /* IF AreaofCover.GET("Area of Cover","Policy Type") THEN
                 BEGIN

                 OptionsSelected.RESET;
                 OptionsSelected.SETRANGE(OptionsSelected."Document Type","Document Type");
                 OptionsSelected.SETRANGE(OptionsSelected."No.","No.");
                 OptionsSelected.SETRANGE(OptionsSelected.Code,AreaofCover."Default Option");
                 IF OptionsSelected.FIND('-') THEN
                 BEGIN

                 OptionsSelected.Selected:=TRUE
                 END
                 ELSE
                 OptionsSelected.Selected:=FALSE;
                 OptionsSelected.MODIFY;
                 END;   */

            end;
        }
        field(21; "Policy Type"; Code[20])
        {
            //TableRelation = "Policy Type".Code;
            TableRelation = IF ("Business Type" = CONST(Brokerage)) "Underwriter Policy Types".Code where("Underwriter Code" = field(Underwriter)) ELSE
            IF ("Business Type" = CONST("Insurance Company")) "Policy Type".Code;

            trigger OnValidate();
            begin
                case "Business Type" of
                    "Business Type"::Brokerage:
                        begin
                            InsuranceDocs.RESET;
                            InsuranceDocs.SETRANGE(InsuranceDocs."Document Type", "Document Type");
                            InsuranceDocs.SETRANGE(InsuranceDocs."Document No", "No.");
                            //InsuranceDocs.DELETEALL;
                            IF NOT InsuranceDocs.FINDFIRST THEN BEGIN


                                DocumentsRequired.RESET;
                                DocumentsRequired.SETRANGE(DocumentsRequired."Policy Type", "Policy Type");
                                DocumentsRequired.SETRANGE(DocumentsRequired."Transaction Type", DocumentsRequired."Transaction Type"::Underwriting);
                                DocumentsRequired.SETRANGE(DocumentsRequired.Code, "Endorsement Type");
                                IF DocumentsRequired.FINDFIRST THEN
                                    REPEAT
                                        InsuranceDocs.INIT;
                                        InsuranceDocs."Document Type" := "Document Type";
                                        InsuranceDocs."Document No" := "No.";
                                        InsuranceDocs."Document Name" := DocumentsRequired."Document Name";
                                        InsuranceDocs.Required := DocumentsRequired.Mandatory;
                                        InsuranceDocs.INSERT;

                                    //MESSAGE('Document %1 Inserted',DocumentsRequired."Document Name");

                                    UNTIL DocumentsRequired.NEXT = 0;

                            END;


                            OptionsSelected.RESET;
                            OptionsSelected.SETRANGE(OptionsSelected."Document Type", "Document Type");
                            OptionsSelected.SETRANGE(OptionsSelected."No.", "No.");
                            OptionsSelected.DELETEALL;



                            //InsuranceType.RESET;

                            /*IF "Cover Type"="Cover Type"::Individual THEN
                            InsuranceType.SETFILTER(InsuranceType."Option Applicable to",'<>%1',InsuranceType."Option Applicable to"::Group);

                            IF "Cover Type"="Cover Type"::Group THEN
                            InsuranceType.SETFILTER(InsuranceType."Option Applicable to",'<>%1',InsuranceType."Option Applicable to"::Individual);*/

                            /*IF EndorsmentTypeRec."Action Type"<>EndorsmentTypeRec."Action Type"::New THEN

                            InsuranceType.SETFILTER(InsuranceType."Applicable to",'<>%1',InsuranceType."Applicable to"::New);
                                MESSAGE('Endorsement is NOT new and therefore exclude stamp duty')

                            IF NOT EndorsmentTypeRec."Charge for Cert Printing" THEN
                            InsuranceType.SETFILTER(InsuranceType."Applicable to",'<>%1',InsuranceType."Applicable to"::"Certificate Charge");

                            IF EndorsmentTypeRec."Action Type"<>EndorsmentTypeRec."Action Type"::New THEN
                              BEGIN
                            InsuranceType.SETFILTER(InsuranceType."Applicable to",'<>%1',InsuranceType."Applicable to"::New);
                                MESSAGE('Endorsement is NOT new and therefore exclude stamp duty')
                              END; */

                            /*IF InsuranceType.FIND('-') THEN
                            BEGIN

                            REPEAT
                               OptionsSelected.INIT;
                               OptionsSelected."Document Type":="Document Type";
                               OptionsSelected."No.":="No.";
                               OptionsSelected.Code:=InsuranceType.Code;
                               OptionsSelected.VALIDATE(OptionsSelected.Code);
                               OptionsSelected.Description:=InsuranceType.Description;
                               OptionsSelected."Discount %":=InsuranceType."Discount Percentage";
                               OptionsSelected."Loading %":=InsuranceType."Loading Percentage";
                               OptionsSelected."Discount Amount":=InsuranceType."Discount Amount";
                               OptionsSelected."Loading Amount":=InsuranceType."Loading Amount";
                               IF EndorsmentTypeRec.GET("Endorsement Type") THEN
                               IF ((InsuranceType."Applicable to"=InsuranceType."Applicable to"::All) OR ((EndorsmentTypeRec."Action Type"=EndorsmentTypeRec."Action Type"::New) AND
                               (InsuranceType."Applicable to"=InsuranceType."Applicable to"::New)) OR ((EndorsmentTypeRec."Charge for Cert Printing") AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::"Certificate Charge"))
                               OR ((EndorsmentTypeRec."Action Type"=EndorsmentTypeRec."Action Type"::"Yellow Card") AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::COMESA))) THEN
                               BEGIN
                               OptionsSelected.INSERT;
                               IF InsuranceType."Applicable to"=InsuranceType."Applicable to"::All THEN
                               MESSAGE('%1 -applies to all',InsuranceType.Description);

                               IF ((EndorsmentTypeRec."Action Type"=EndorsmentTypeRec."Action Type"::New) AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::New)) THEN
                               MESSAGE('%1 -applies to New and Policy is new',InsuranceType.Description);

                               IF ((EndorsmentTypeRec."Charge for Cert Printing") AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::"Certificate Charge")) THEN
                               MESSAGE('%1 -Endorsement is chargeable and setup is for chargeable',InsuranceType.Description);
                               //END;
                               MESSAGE('Description=%1',InsuranceType.Description);
                               END;
                               UNTIL InsuranceType.NEXT=0;

                               END;*/


                            IF PolicyRecs.GET("Policy Type",Underwriter) THEN BEGIN
                                "Policy Description" := COPYSTR(PolicyRecs.Description, 1, 50);
                                "Commission Due" := PolicyRecs."Commision % age(SIIBL)";
                                "Mode of Conveyance" := PolicyRecs.Conveyance;
                                "Shortcut Dimension 3 Code" := PolicyRecs.Class;
                                Term:=PolicyRecs."Default Term";

                            END
                            ELSE
                                ERROR('Policy is non-existent');



                            /* saleslinerec.RESET;
                             saleslinerec.SETRANGE(saleslinerec."Document Type","Document Type");
                             saleslinerec.SETRANGE(saleslinerec."Document No.","No.");
                             IF saleslinerec.FIND('+') THEN
                             LastNo:=saleslinerec."Line No.";

                             //Delete if already exists

                             InsurerPolicyDetails.RESET;
                             InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails.Insurer,"Agent/Broker");
                             InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails."Policy Type","Policy Type");
                             IF InsurerPolicyDetails.FIND('-') THEN
                             BEGIN
                             REPEAT

                              saleslinerec.INIT;
                              saleslinerec."Document Type":="Document Type";
                              saleslinerec."Document No.":="No.";
                              LastNo:=LastNo+10000;
                              saleslinerec."Line No.":= LastNo;
                              saleslinerec.Description:=InsurerPolicyDetails.Description;
                              saleslinerec."Actual Value":=InsurerPolicyDetails."Actual Value";
                              saleslinerec."Description Type":=InsurerPolicyDetails."Description Type";
                              saleslinerec."Text Type":=InsurerPolicyDetails."Text Type";
                              saleslinerec.INSERT;

                             UNTIL InsurerPolicyDetails.NEXT=0;
                             END
                             ELSE
                             BEGIN
                             PolicyDetails.RESET;
                             PolicyDetails.SETRANGE(PolicyDetails."Policy Type","Policy Type");
                             IF PolicyDetails.FIND('-') THEN
                             BEGIN
                             REPEAT
                              saleslinerec.INIT;
                              saleslinerec."Document Type":="Document Type";
                              saleslinerec."Document No.":="No.";
                              LastNo:=LastNo+10000;
                              saleslinerec."Line No.":= LastNo;
                              saleslinerec.Description:=PolicyDetails.Description;
                              saleslinerec."Description Type":=PolicyDetails."Description Type";
                              saleslinerec."Actual Value":=PolicyDetails."Actual Value";
                              saleslinerec."Text Type":=PolicyDetails."Text Type";
                              saleslinerec.INSERT;


                             UNTIL PolicyDetails.NEXT=0;
                             END;
                             END;*/


                            IF PolicyRecs.GET("Policy Type",Underwriter) THEN BEGIN
                                "Policy Description" := COPYSTR(PolicyRecs.Description, 1, 50);
                                "Commission Due" := PolicyRecs."Commision % age(SIIBL)";
                                "Mode of Conveyance" := PolicyRecs.Conveyance;
                            END
                            ELSE
                                ERROR('Policy is non-existent');

                            ProductBenRiders.RESET;
                            ProductBenRiders.SETRANGE(ProductBenRiders."Product Code", "Policy Type");
                            IF ProductBenRiders.FINDFIRST THEN BEGIN
                                InsureCoverSelection.RESET;
                                InsureCoverSelection.SETRANGE(InsureCoverSelection."Document Type", "Document Type");
                                InsureCoverSelection.SETRANGE(InsureCoverSelection."No.", "No.");
                                InsureCoverSelection.DELETEALL;
                                REPEAT
                                    InsureCoverSelection.INIT;
                                    InsureCoverSelection."Document Type" := "Document Type";
                                    InsureCoverSelection."No." := "No.";
                                    InsureCoverSelection.Code := ProductBenRiders."Benefit Code";
                                    InsureCoverSelection.Description := ProductBenRiders."Benefit Name";
                                    InsureCoverSelection."Loading %" := ProductBenRiders."Premium Rate";
                                    InsureCoverSelection."Loading Amount" := ProductBenRiders."Unit Amount";
                                    IF ProductBenRiders."Benefit Type" = ProductBenRiders."Benefit Type"::Main THEN
                                        InsureCoverSelection.Selected := TRUE;
                                    IF NOT InsureCoverSelection.GET(InsureCoverSelection."Document Type", InsureCoverSelection."No.", InsureCoverSelection.Code) THEN
                                        InsureCoverSelection.INSERT;
                                UNTIL ProductBenRiders.NEXT = 0;
                            END;
                        end;
                    "Business Type"::"Insurance Company":
                        begin
                            InsuranceDocs.RESET;
                            InsuranceDocs.SETRANGE(InsuranceDocs."Document Type", "Document Type");
                            InsuranceDocs.SETRANGE(InsuranceDocs."Document No", "No.");
                            //InsuranceDocs.DELETEALL;
                            IF NOT InsuranceDocs.FINDFIRST THEN BEGIN


                                DocumentsRequired.RESET;
                                DocumentsRequired.SETRANGE(DocumentsRequired."Policy Type", "Policy Type");
                                DocumentsRequired.SETRANGE(DocumentsRequired."Transaction Type", DocumentsRequired."Transaction Type"::Underwriting);
                                DocumentsRequired.SETRANGE(DocumentsRequired.Code, "Endorsement Type");
                                IF DocumentsRequired.FINDFIRST THEN
                                    REPEAT
                                        InsuranceDocs.INIT;
                                        InsuranceDocs."Document Type" := "Document Type";
                                        InsuranceDocs."Document No" := "No.";
                                        InsuranceDocs."Document Name" := DocumentsRequired."Document Name";
                                        InsuranceDocs.Required := DocumentsRequired.Mandatory;
                                        InsuranceDocs.INSERT;

                                    //MESSAGE('Document %1 Inserted',DocumentsRequired."Document Name");

                                    UNTIL DocumentsRequired.NEXT = 0;

                            END;


                            OptionsSelected.RESET;
                            OptionsSelected.SETRANGE(OptionsSelected."Document Type", "Document Type");
                            OptionsSelected.SETRANGE(OptionsSelected."No.", "No.");
                            OptionsSelected.DELETEALL;



                            //InsuranceType.RESET;

                            /*IF "Cover Type"="Cover Type"::Individual THEN
                            InsuranceType.SETFILTER(InsuranceType."Option Applicable to",'<>%1',InsuranceType."Option Applicable to"::Group);

                            IF "Cover Type"="Cover Type"::Group THEN
                            InsuranceType.SETFILTER(InsuranceType."Option Applicable to",'<>%1',InsuranceType."Option Applicable to"::Individual);*/

                            /*IF EndorsmentTypeRec."Action Type"<>EndorsmentTypeRec."Action Type"::New THEN

                            InsuranceType.SETFILTER(InsuranceType."Applicable to",'<>%1',InsuranceType."Applicable to"::New);
                                MESSAGE('Endorsement is NOT new and therefore exclude stamp duty')

                            IF NOT EndorsmentTypeRec."Charge for Cert Printing" THEN
                            InsuranceType.SETFILTER(InsuranceType."Applicable to",'<>%1',InsuranceType."Applicable to"::"Certificate Charge");

                            IF EndorsmentTypeRec."Action Type"<>EndorsmentTypeRec."Action Type"::New THEN
                              BEGIN
                            InsuranceType.SETFILTER(InsuranceType."Applicable to",'<>%1',InsuranceType."Applicable to"::New);
                                MESSAGE('Endorsement is NOT new and therefore exclude stamp duty')
                              END; */

                            /*IF InsuranceType.FIND('-') THEN
                            BEGIN

                            REPEAT
                               OptionsSelected.INIT;
                               OptionsSelected."Document Type":="Document Type";
                               OptionsSelected."No.":="No.";
                               OptionsSelected.Code:=InsuranceType.Code;
                               OptionsSelected.VALIDATE(OptionsSelected.Code);
                               OptionsSelected.Description:=InsuranceType.Description;
                               OptionsSelected."Discount %":=InsuranceType."Discount Percentage";
                               OptionsSelected."Loading %":=InsuranceType."Loading Percentage";
                               OptionsSelected."Discount Amount":=InsuranceType."Discount Amount";
                               OptionsSelected."Loading Amount":=InsuranceType."Loading Amount";
                               IF EndorsmentTypeRec.GET("Endorsement Type") THEN
                               IF ((InsuranceType."Applicable to"=InsuranceType."Applicable to"::All) OR ((EndorsmentTypeRec."Action Type"=EndorsmentTypeRec."Action Type"::New) AND
                               (InsuranceType."Applicable to"=InsuranceType."Applicable to"::New)) OR ((EndorsmentTypeRec."Charge for Cert Printing") AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::"Certificate Charge"))
                               OR ((EndorsmentTypeRec."Action Type"=EndorsmentTypeRec."Action Type"::"Yellow Card") AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::COMESA))) THEN
                               BEGIN
                               OptionsSelected.INSERT;
                               IF InsuranceType."Applicable to"=InsuranceType."Applicable to"::All THEN
                               MESSAGE('%1 -applies to all',InsuranceType.Description);

                               IF ((EndorsmentTypeRec."Action Type"=EndorsmentTypeRec."Action Type"::New) AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::New)) THEN
                               MESSAGE('%1 -applies to New and Policy is new',InsuranceType.Description);

                               IF ((EndorsmentTypeRec."Charge for Cert Printing") AND (InsuranceType."Applicable to"=InsuranceType."Applicable to"::"Certificate Charge")) THEN
                               MESSAGE('%1 -Endorsement is chargeable and setup is for chargeable',InsuranceType.Description);
                               //END;
                               MESSAGE('Description=%1',InsuranceType.Description);
                               END;
                               UNTIL InsuranceType.NEXT=0;

                               END;*/


                            IF PolicyRecs.GET("Policy Type",Underwriter) THEN BEGIN
                                "Policy Description" := COPYSTR(PolicyRecs.Description, 1, 50);
                                "Commission Due" := PolicyRecs."Commision % age(SIIBL)";
                                "Mode of Conveyance" := PolicyRecs.Conveyance;
                                "Shortcut Dimension 3 Code" := PolicyRecs.Class;

                            END
                            ELSE
                                ERROR('Policy is non-existent');



                            /* saleslinerec.RESET;
                             saleslinerec.SETRANGE(saleslinerec."Document Type","Document Type");
                             saleslinerec.SETRANGE(saleslinerec."Document No.","No.");
                             IF saleslinerec.FIND('+') THEN
                             LastNo:=saleslinerec."Line No.";

                             //Delete if already exists

                             InsurerPolicyDetails.RESET;
                             InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails.Insurer,"Agent/Broker");
                             InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails."Policy Type","Policy Type");
                             IF InsurerPolicyDetails.FIND('-') THEN
                             BEGIN
                             REPEAT

                              saleslinerec.INIT;
                              saleslinerec."Document Type":="Document Type";
                              saleslinerec."Document No.":="No.";
                              LastNo:=LastNo+10000;
                              saleslinerec."Line No.":= LastNo;
                              saleslinerec.Description:=InsurerPolicyDetails.Description;
                              saleslinerec."Actual Value":=InsurerPolicyDetails."Actual Value";
                              saleslinerec."Description Type":=InsurerPolicyDetails."Description Type";
                              saleslinerec."Text Type":=InsurerPolicyDetails."Text Type";
                              saleslinerec.INSERT;

                             UNTIL InsurerPolicyDetails.NEXT=0;
                             END
                             ELSE
                             BEGIN
                             PolicyDetails.RESET;
                             PolicyDetails.SETRANGE(PolicyDetails."Policy Type","Policy Type");
                             IF PolicyDetails.FIND('-') THEN
                             BEGIN
                             REPEAT
                              saleslinerec.INIT;
                              saleslinerec."Document Type":="Document Type";
                              saleslinerec."Document No.":="No.";
                              LastNo:=LastNo+10000;
                              saleslinerec."Line No.":= LastNo;
                              saleslinerec.Description:=PolicyDetails.Description;
                              saleslinerec."Description Type":=PolicyDetails."Description Type";
                              saleslinerec."Actual Value":=PolicyDetails."Actual Value";
                              saleslinerec."Text Type":=PolicyDetails."Text Type";
                              saleslinerec.INSERT;


                             UNTIL PolicyDetails.NEXT=0;
                             END;
                             END;*/


                            IF PolicyRecs.GET("Policy Type",Underwriter) THEN BEGIN
                                "Policy Description" := COPYSTR(PolicyRecs.Description, 1, 50);
                                "Commission Due" := PolicyRecs."Commision % age(SIIBL)";
                                "Mode of Conveyance" := PolicyRecs.Conveyance;
                            END
                            ELSE
                                ERROR('Policy is non-existent');

                            ProductBenRiders.RESET;
                            ProductBenRiders.SETRANGE(ProductBenRiders."Product Code", "Policy Type");
                            IF ProductBenRiders.FINDFIRST THEN BEGIN
                                InsureCoverSelection.RESET;
                                InsureCoverSelection.SETRANGE(InsureCoverSelection."Document Type", "Document Type");
                                InsureCoverSelection.SETRANGE(InsureCoverSelection."No.", "No.");
                                InsureCoverSelection.DELETEALL;
                                REPEAT
                                    InsureCoverSelection.INIT;
                                    InsureCoverSelection."Document Type" := "Document Type";
                                    InsureCoverSelection."No." := "No.";
                                    InsureCoverSelection.Code := ProductBenRiders."Benefit Code";
                                    InsureCoverSelection.Description := ProductBenRiders."Benefit Name";
                                    InsureCoverSelection."Loading %" := ProductBenRiders."Premium Rate";
                                    InsureCoverSelection."Loading Amount" := ProductBenRiders."Unit Amount";
                                    IF ProductBenRiders."Benefit Type" = ProductBenRiders."Benefit Type"::Main THEN
                                        InsureCoverSelection.Selected := TRUE;
                                    IF NOT InsureCoverSelection.GET(InsureCoverSelection."Document Type", InsureCoverSelection."No.", InsureCoverSelection.Code) THEN
                                        InsureCoverSelection.INSERT;
                                UNTIL ProductBenRiders.NEXT = 0;
                            END;
                        end;
                end;
            end;
        }
        field(22; "Agent/Broker"; Code[20])
        {

            TableRelation = Customer WHERE("Customer Type" = CONST("Agent/Broker"));

            trigger OnValidate();
            begin
                IF Cust.GET("Agent/Broker") THEN BEGIN
                    "Brokers Name" := Cust.Name;
                    IF Cust."Insured Type" <> Cust."Insured Type"::Direct THEN
                        "Bill To Customer No." := "Agent/Broker"
                    ELSE
                        "Bill To Customer No." := "Insured No.";


                    /*commissionTab.RESET;
                    commissionTab.SETRANGE(commissionTab.UnderWriter,"Agent/Broker");
                    commissionTab.SETRANGE(commissionTab.Code,"Policy Type");
                    IF commissionTab.FIND('-') THEN
                    BEGIN
                    IF commissionTab."Commision Calculation"=commissionTab."Commision Calculation"::"% age of Premium" THEN
                    "Commission Payable 1":=commissionTab."Commission %age"
                    ELSE
                     "Commission Payable 1":=commissionTab.Amount;}
                    
                    END
                    ELSE
                    ERROR('Please Setup Commission Due from %1', Vendor.Name);
                    */
                END;

            end;
        }
        field(23; Underwriter; Code[20])
        {
            TableRelation = Vendor."No.";

            trigger OnValidate();
            begin
                IF vendor.GET(Underwriter) THEN BEGIN
                    "Underwriter Name" := Vendor.Name;

                END;

                saleslinerec.RESET;
                saleslinerec.SETRANGE(saleslinerec."Document Type", "Document Type");
                saleslinerec.SETRANGE(saleslinerec."Document No.", "No.");
                IF saleslinerec.FIND('+') THEN
                    LastNo := saleslinerec."Line No.";

                //Delete if already exists

                /*InsurerPolicyDetails.RESET;
                InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails.Insurer,"Agent/Broker");
                InsurerPolicyDetails.SETRANGE(InsurerPolicyDetails."Policy Type","Policy Type");
                IF InsurerPolicyDetails.FIND('-') THEN
                BEGIN
                REPEAT

                 saleslinerec.INIT;
                 saleslinerec."Document Type":="Document Type";
                 saleslinerec."Document No.":="No.";
                 LastNo:=LastNo+10000;
                 saleslinerec."Line No.":= LastNo;
                 saleslinerec.Description:=InsurerPolicyDetails.Description;
                 saleslinerec."Actual Value":=InsurerPolicyDetails."Actual Value";
                 saleslinerec."Description Type":=InsurerPolicyDetails."Description Type";
                 saleslinerec."Text Type":=InsurerPolicyDetails."Text Type";
                 saleslinerec.INSERT;

                UNTIL InsurerPolicyDetails.NEXT=0;
                END
                ELSE
                BEGIN
                PolicyDetails.RESET;
                PolicyDetails.SETRANGE(PolicyDetails."Policy Type","Policy Type");
                IF PolicyDetails.FIND('-') THEN
                BEGIN
                REPEAT
                 saleslinerec.INIT;
                 saleslinerec."Document Type":="Document Type";
                 saleslinerec."Document No.":="No.";
                 LastNo:=LastNo+10000;
                 saleslinerec."Line No.":= LastNo;
                 saleslinerec.Description:=PolicyDetails.Description;
                 saleslinerec."Description Type":=PolicyDetails."Description Type";
                 saleslinerec."Actual Value":=PolicyDetails."Actual Value";
                 saleslinerec."Text Type":=PolicyDetails."Text Type";
                 saleslinerec.INSERT;


                UNTIL PolicyDetails.NEXT=0;
                END;
                END; */

            end;
        }
        field(24; "Exclude from Renewal"; Option)
        {
            OptionMembers = No,Yes;
        }
        field(25; "Brokers Name"; Text[50])
        {
            Editable = false;
            Caption = 'Agent Name';
        }
        field(26; "Underwriter Name"; Text[60])
        {
            Editable = false;
        }
        field(27; "Discount %"; Decimal)
        {
            Editable = true;

            trigger OnValidate();
            begin
                /*SalesLine.RESET;
                SalesLine.SETRANGE(SalesLine."Document Type","Document Type");
                SalesLine.SETRANGE(SalesLine."Document No.","No.");
                SalesLine.SETRANGE(SalesLine."Description Type",SalesLine."Description Type"::"Schedule of Insured");
                IF SalesLine.FIND('-') THEN
                REPEAT
                    IF SalesLine."Gross Premium"<>0 THEN
                    BEGIN
                     SalesLine."Reduction %":="Discount %";

                     SalesLine.VALIDATE(SalesLine."Reduction %");
                     SalesLine.MODIFY;
                    END;
                UNTIL SalesLine.NEXT=0; */

            end;
        }
        field(28; "Insurance Type"; Code[10])
        {

            trigger OnValidate();
            begin
                //"Premium Amount" := insmangmt.CalculatePremium(Age,"Policy Type","Insurance Type","Order Date","Payment Terms Code",
                //"Area of Cover","Excess Level");

                //Update Cover Details


                /*QuoteCoverDetails.RESET;
                //QuoteCoverDetails.SETRANGE(QuoteCoverDetails."Insurance Type","Insurance Type");
                QuoteCoverDetails.SETRANGE(QuoteCoverDetails."Document No.","No.");
                IF QuoteCoverDetails.FIND('-') THEN
                QuoteCoverDetails.DELETEALL;
                
                
                CoverDetails.RESET;
                CoverDetails.SETRANGE(CoverDetails."Insurance Type","Insurance Type");
                IF CoverDetails.FIND('-') THEN
                REPEAT
                
                   QuoteCoverDetails.INIT;
                   QuoteCoverDetails."Document No.":="No.";
                   QuoteCoverDetails."No.":=CoverDetails."Cover Id";
                   QuoteCoverDetails."Insurance Type":=CoverDetails."Insurance Type";
                   QuoteCoverDetails.Type:=CoverDetails.Type;
                   QuoteCoverDetails."Policy Type":=CoverDetails."Policy Type";
                   QuoteCoverDetails.Description:=CoverDetails.Description;
                   QuoteCoverDetails."Type Description":=CoverDetails."Type Description";
                   QuoteCoverDetails."Text Type":=CoverDetails."Text Type";
                   QuoteCoverDetails.INSERT;
                
                
                UNTIL CoverDetails.NEXT=0;
                
                
                   IF InsuranceType.GET("Insurance Type","Policy Type","Policy Class") THEN
                   BEGIN
                    "Cover Type Description":=InsuranceType.Description;
                
                   OptionsSelected.RESET;
                   OptionsSelected.SETRANGE(OptionsSelected."Document Type","Document Type");
                   OptionsSelected.SETRANGE(OptionsSelected."No.","No.");
                   OptionsSelected.SETRANGE(OptionsSelected.Code,InsuranceType."Default Option");
                   IF OptionsSelected.FIND('-') THEN
                   BEGIN
                
                   OptionsSelected.Selected:=TRUE;
                   OptionsSelected.MODIFY;
                   END
                
                   END; */

            end;
        }
        field(29; "Premium Amount"; Decimal)
        {
        }
        field(30; "Effective Start date"; Date)
        {
        }
        field(31; "Group Name"; Text[30])
        {
        }
        field(32; "Excess Level"; Code[10])
        {

            trigger OnValidate();
            begin
                /*IF "Cover Type"="Cover Type"::Individual THEN
                "Premium Amount" := insmangmt.CalculatePremium(Age,"Policy Type","Insurance Type","Document Date","Payment Terms Code",
                "Area of Cover","Excess Level");
                
                { saleslinerec.RESET;
                 saleslinerec.SETRANGE(saleslinerec."Document Type","Document Type");
                 saleslinerec.SETRANGE(saleslinerec."Document No.","No.");
                 saleslinerec.SETRANGE(saleslinerec."Cover Type",saleslinerec."Cover Type"::Dependant);
                 IF saleslinerec.FIND('-') THEN
                 REPEAT
                   saleslinerec."Insured No.":="Insured No.";
                   saleslinerec."Area of Cover":="Area of Cover";
                   saleslinerec."Policy Type":="Policy Type";
                   saleslinerec."Insurance Type":="Insurance Type";
                   saleslinerec.VALIDATE(saleslinerec."Insurance Type");
                
                   saleslinerec.VALIDATE(saleslinerec.Age);
                   saleslinerec.Quantity:=1;
                   saleslinerec."Unit Price":=saleslinerec."Gross Premium";
                   saleslinerec.VALIDATE(saleslinerec."Unit Price");
                   saleslinerec."Gen. Bus. Posting Group":="Gen. Bus. Posting Group";
                   saleslinerec."VAT Bus. Posting Group":="VAT Bus. Posting Group";
                   IF Insetup.GET THEN BEGIN
                   saleslinerec."VAT Bus. Posting Group":=Insetup."Default VAT Bus. Posting Group";
                   SalesLine."VAT Prod. Posting Group":=Insetup."Default VAT Pro. Posting Group";
                
                
                   END;
                
                   saleslinerec.VALIDATE(saleslinerec.Quantity);
                
                   saleslinerec.MODIFY;
                
                UNTIL saleslinerec.NEXT=0; }
                
                   {IF PolicyExcess.GET("Policy Type","Insurance Type","Excess Level") THEN
                   BEGIN
                
                   OptionsSelected.RESET;
                   OptionsSelected.SETRANGE(OptionsSelected."Document Type","Document Type");
                   OptionsSelected.SETRANGE(OptionsSelected."No.","No.");
                   OptionsSelected.SETRANGE(OptionsSelected.Code,PolicyExcess."Default Option");
                   IF OptionsSelected.FIND('-') THEN
                   BEGIN
                
                   OptionsSelected.Selected:=TRUE
                   END
                   ELSE
                   OptionsSelected.Selected:=FALSE;
                   OptionsSelected.MODIFY;
                   END;   } */

            end;
        }
        field(33; "Policy No"; Code[30])
        {
            Editable = false;
            TableRelation = "Insure Header"."No." WHERE("Document Type" = CONST(Policy));

            trigger OnValidate();
            begin
                //"Posting Description":=COPYSTR(STRSUBSTNO('POLICY %1-%2',"Policy No","Policy Type"),1,50);
            end;
        }
        field(34; "Quote Type"; Option)
        {
            Editable = true;
            InitValue = New;
            OptionMembers = " ",New,Modification,Renewal;
        }
        field(35; "No. of Lives"; Integer)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(36; "No. of Members"; Integer)
        {
            FieldClass = Normal;
        }
        field(37; "No. of Dependants"; Integer)
        {
            FieldClass = Normal;
        }
        field(38; "Broker #2"; Code[20])
        {

            trigger OnValidate();
            begin
                /*IF  Vendor.GET("Broker #2") THEN
                 BEGIN
                 "Broker #2 Name":=Vendor.Name;
                  commissionTab.RESET;
                  commissionTab.SETRANGE(commissionTab."UnderWriter/Broker","Broker #2");
                  commissionTab.SETRANGE(commissionTab."Policy Type","Policy Type");
                  IF commissionTab.FIND('-') THEN
                  BEGIN
                  IF commissionTab."Commision Calculation"=commissionTab."Commision Calculation"::"% age of Premium" THEN
                  "Commission Payable 1":=commissionTab."% age"
                  ELSE
                    "Commission Payable 1":=commissionTab.Amount;

                  END
                  ELSE
                  ERROR('Please Setup Commission Due from %1', Vendor.Name);
                 END; */

            end;
        }
        field(39; "Broker #3"; Code[10])
        {

            trigger OnValidate();
            begin
                /* IF  Vendor.GET("Broker #3") THEN
                  BEGIN
                  "Broker #3 Name":=Vendor.Name;
                   commissionTab.RESET;
                   commissionTab.SETRANGE(commissionTab."UnderWriter/Broker","Broker #3");
                   commissionTab.SETRANGE(commissionTab."Policy Type","Policy Type");
                   IF commissionTab.FIND('-') THEN
                   BEGIN
                   IF commissionTab."Commision Calculation"=commissionTab."Commision Calculation"::"% age of Premium" THEN
                   "Commission Payable 1":=commissionTab."% age"
                   ELSE
                     "Commission Payable 1":=commissionTab.Amount;
                
                   END
                   ELSE
                   ERROR('Please Setup Commission Due from %1', Vendor.Name);
                  END; */

            end;
        }
        field(40; "Broker #2 Name"; Text[20])
        {
            Editable = false;
        }
        field(41; "Broker #3 Name"; Text[20])
        {
            Editable = false;
        }
        field(42; "Commission Due"; Decimal)
        {
        }
        field(43; "Commission Payable 1"; Decimal)
        {
        }
        field(44; "Commission Payable 2"; Decimal)
        {
        }
        field(45; "Commission Payable 3"; Decimal)
        {
        }
        field(46; "Correspondence Country/State"; Code[10])
        {
            TableRelation = "Country/Region";
        }
        field(47; "Phone No."; Text[20])
        {
        }
        field(48; "Fax No"; Text[20])
        {
        }
        field(49; "E-mail"; Text[30])
        {
        }
        field(50; "Payment Method"; Option)
        {
            OptionMembers = Annual,"Bi-Annual",Quarterly,Monthly;
        }
        field(51; "Cover Type"; Option)
        {
            OptionMembers = " ",Individual,Group;
        }
        field(52; "Total Premium Amount"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("No."),
                                                           "Description Type" = CONST("Schedule of Insured")));
            DecimalPlaces = 2 : 2;
            Editable = false;
            FieldClass = FlowField;
        }
        field(53; "Total  Discount Amount"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".Amount WHERE("Description Type" = CONST(Deductible)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(54; "Total Commission Due"; Decimal)
        {



            Editable = false;
        }
        field(55; "Total Commission Owed"; Decimal)
        {
            Editable = false;
        }
        field(56; "Total Training Levy"; Decimal)
        {
            Editable = false;
        }
        field(57; "Total Stamp Duty"; Decimal)
        {
            Editable = false;
        }
        field(58; "Total Tax"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("No."),
                                                           Tax = CONST(true)));
            FieldClass = FlowField;
        }
        field(59; "From Date"; Date)
        {

            trigger OnValidate();
            begin


                IF InsSetup.GET THEN
                    IF NOT InsSetup."Allow BackDating of Policy" THEN
                        IF "From Date" < WORKDATE THEN
                            ERROR('You cannot backdate a policy start date');

                IF PolicyRecs.GET("Policy Type",Underwriter) THEN BEGIN
                    
                    IF FORMAT(PolicyRecs.Period) = '1Y' THEN BEGIN
                        "To Date" := CALCDATE('1Y', "From Date");
                        "Expected Renewal Date" := CALCDATE('1Y', "From Date");
                        "From Time" := PolicyRecs."Start Time";
                        "To Time" := PolicyRecs."End Time";
                    END
                    ELSE BEGIN
                        "To Date" := CALCDATE('1Y', "From Date") - 1;
                        "Expected Renewal Date" := CALCDATE('1Y', "From Date");
                    END;
                END;

                IF TermRec.GET(Term) THEN BEGIN
                    "To Date" := CALCDATE(TermRec.Term, "From Date") - 1;
                    "Expected Renewal Date" := CALCDATE(TermRec.Term, "From Date");
                    "From Time" := PolicyRecs."Start Time";
                    "To Time" := PolicyRecs."End Time";
                END;
            end;
        }
        field(60; "To Date"; Date)
        {
        }
        field(61; "From Time"; Text[4])
        {
        }
        field(62; "To Time"; Text[4])
        {
        }
        field(63; "Policy Status"; Option)
        {
            Editable = true;
            OptionCaption = '" ,Live,Expired,Lapsed,Cancelled,Renewed,Suspended"';
            OptionMembers = " ",Live,Expired,Lapsed,Cancelled,Renewed,Suspended;
        }
        field(64; "Expected Renewal Date"; Date)
        {
        }
        field(65; "Expected Renewal Time"; Time)
        {
        }
        field(66; "Modification Type"; Option)
        {
            OptionMembers = " ",Addition,Deletion;
        }
        field(67; "Policy Class"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            Trigger OnValidate();
            begin
                Underwriterproducts.RESET;
                UnderWriterProducts.SETRANGE(UnderWriterProducts.Class, "Policy Class");
                IF UnderWriterProducts.FINDFIRST THEN begin
                    ;
                    ProductSelector.RESET;
                    ProductSelector.SETRANGE(ProductSelector."Document No.", "No.");
                    Productselector.DELETEALL;



                    repeat


                        ProductSelector.INIT;
                        ProductSelector."Document Type" := "Document Type";
                        ProductSelector."Document No." := "No.";
                        ProductSelector.Underwriter := UnderwriterProducts."Underwriter code";
                        ProductSelector."Product Plan" := UnderwriterProducts."Code";
                        ProductSelector.VALIDATE(ProductSelector.Underwriter);
                        ProductSelector.VALIDATE(ProductSelector."Product Plan");
                        IF NOT ProductSelector.GET(ProductSelector."Document Type", ProductSelector."Document No.", ProductSelector.UnderWriter, ProductSelector."Product Plan")
                        THEN
                            ProductSelector.INSERT;



                    until UnderWriterProducts.NEXT = 0;
                end;
            END;





        }
        field(68; "Cover Period"; Code[20])
        {
            TableRelation = "Payment Terms";
        }
        field(69; "Mid Term Adjustment Factor"; Decimal)
        {
            Editable = false;
        }
        field(70; "Copied from No."; Code[20])
        {
        }
        field(71; "Payment Mode"; Code[10])
        {
            TableRelation = "Payment Method";
        }
        field(72; "Total Net Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                           "Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(73; "Insurer Policy No"; Code[20])
        {
        }
        field(74; "Created By"; Code[80])
        {
            Editable = false;
            TableRelation = User;
        }
        field(75; "Follow Up Person"; Code[80])
        {
            TableRelation = User;
        }
        field(76; "Follow Up Date"; Date)
        {
        }
        field(77; "Renewal Date"; Date)
        {
        }
        field(78; "Vessel Name"; Text[30])
        {
        }
        field(79; "Mode of Conveyance"; Text[150])
        {
        }
        field(80; "Response Period"; DateTime)
        {
        }
        field(81; "Policy Description"; Text[50])
        {
            Editable = false;
        }
        field(82; "Cover Type Description"; Text[50])
        {
            Editable = false;
        }
        field(83; "Total Sum Insured"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = Sum("Insure Lines"."Sum Insured" WHERE("Document Type" = FIELD("Document Type"),
                                                                  "Document No." = FIELD("No.")));

        }
        field(84; "Order Hereon"; Decimal)
        {
        }
        field(85; "Insured Name"; Text[80])
        {
        }
        field(86; "ID/Passport No."; Code[20])
        {
        }
        field(87; "PIN No."; Code[20])
        {
        }
        field(88; "No. Series"; Code[10])
        {
        }
        field(89; "Posting Date"; Date)
        {
        }
        field(90; "Document Date"; Date)
        {

            trigger OnValidate();
            begin
                InsSetup.GET;

                "Quote Expiry Date" := CALCDATE(InsSetup."Quotation Validity Period", "Document Date");
                "Posting Date" := "Document Date";

                IF "Document Type" <> "Document Type"::Endorsement THEN BEGIN
                    "From Date" := "Document Date";

                    VALIDATE("From Date");
                END;
                IF xRec."Document Date" <> 0D THEN BEGIN
                    IF xRec."Document Date" <> "Document Date" THEN BEGIN
                        VALIDATE("Cover End Date");

                    END;
                END;

                IF "Document Type" = "Document Type"::Endorsement THEN BEGIN
                    //"Original Cover Start Date":="Cover Start Date";
                    IF "Action Type" <> "Action Type"::Resumption THEN
                        "Mid Term Adjustment Factor" := InsMngt.CalculateMidTermFactor(Rec);
                    //"Cover Start Date":="Document Date";


                    IF "No. Of Days" = 0 THEN
                        "No. Of Days" := ("Cover End Date" - "Document Date") + 1;

                    "No. Of Months" := InsMngt.GetNoOfMonths("Original Cover Start Date", "Document Date");

                    NoOfDayz := InsMngt.GetNoOfDays("Original Cover Start Date", "Document Date");
                    // MESSAGE('No of days=%1 and months=%2',NoOfDayz,"No. Of Months");
                    IF "No. Of Months" > 0 THEN BEGIN
                        shortCover.RESET;
                        shortCover.SETRANGE(shortCover."Table Type", shortCover."Table Type"::Monthly);
                        IF shortCover.FINDFIRST THEN
                            REPEAT
                                IF (("No. Of Months" >= shortCover."Starting No. of Period") AND ("No. Of Months" <= shortCover."Ending No. of  Period")) THEN BEGIN
                                    "Short Term Cover" := shortCover.Code;
                                    "Short term Cover Percent" := shortCover."Percentage Of Prem. Applicable";

                                END;
                            UNTIL shortCover.NEXT = 0;
                    END
                    ELSE BEGIN
                        shortCover.RESET;
                        shortCover.SETRANGE(shortCover."Table Type", shortCover."Table Type"::Daily);
                        REPEAT
                            IF ((NoOfDayz >= shortCover."Starting No. of Period") AND (NoOfDayz <= shortCover."Ending No. of  Period")) THEN BEGIN
                                "Short Term Cover" := shortCover.Code;
                                "Short term Cover Percent" := shortCover."Percentage Of Prem. Applicable";

                            END;
                        UNTIL shortCover.NEXT = 0;
                    END;

                    IF "Action Type" = "Action Type"::Resumption THEN BEGIN
                        /* PolicyHeader.RESET;
                         PolicyHeader.SETRANGE(PolicyHeader."Document Type",PolicyHeader."Document Type"::Policy);
                         PolicyHeader.SETRANGE(PolicyHeader."Policy.","Policy No");
                         PolicyHeader.SETRANGE(PolicyHeader."Action Type",PolicyHeader."Action Type"::Suspension);
                         IF PolicyHeader.FINDLAST THEN
                           BEGIN*/
                        "Cover Start Date" := "Document Date";
                        //NoOfDays:=(PolicyHeader."Cover Start Date"-PolicyHeader."Document Date")+1;
                        EVALUATE(AwardPeriod, FORMAT("No. Of Days") + 'D');
                        "Cover End Date" := CALCDATE(AwardPeriod, "Cover Start Date");
                        //"Mid Term Adjustment Factor":=PolicyHeader."Mid Term Adjustment Factor";

                    END;

                END;






                VALIDATE("Cover End Date");
                VALIDATE("Policy Type");

            end;
        }
        field(91; "No. Of Instalments"; Integer)
        {
            TableRelation = "No. of Instalments";

            trigger OnValidate();
            begin

                IF xRec."No. Of Instalments" <> "No. Of Instalments" THEN BEGIN

                    InsureLines.RESET;
                    InsureLines.SETRANGE(InsureLines."Document Type", "Document Type");
                    InsureLines.SETRANGE(InsureLines."Document No.", "No.");
                    InsureLines.SETRANGE(InsureLines."Description Type", InsureLines."Description Type"::"Schedule of Insured");
                    IF InsureLines.FINDFIRST THEN BEGIN
                        REPEAT

                            InsureLines."No. Of Instalments" := "No. Of Instalments";
                            IF InsureLines."Seating Capacity" <> 0 THEN
                                InsureLines.VALIDATE(InsureLines."Seating Capacity");
                            InsureLines.MODIFY;


                        UNTIL InsureLines.NEXT = 0;

                    END;
                    IF "Cover Start Date" <> 0D THEN
                        VALIDATE("Cover Start Date");

                END;



                IF "From Date" <> 0D THEN BEGIN  //Read from Instalment Percentage setups
                    PaymentSchedule.RESET;
                    PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", "Document Type");
                    PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", "No.");
                    PaymentSchedule.DELETEALL;
                    IF PolicyRecs.GET("Policy Type",Underwriter) THEN BEGIN
                        IF PolicyRecs.Comprehensive THEN BEGIN
                            InstalmentRatioRec.RESET;
                            InstalmentRatioRec.SETRANGE(InstalmentRatioRec."Policy Type", "Policy Type");
                            InstalmentRatioRec.SETRANGE(InstalmentRatioRec."No. Of Instalments", "No. Of Instalments");
                            IF InstalmentRatioRec.FINDFIRST THEN BEGIN
                                StartDate := "From Date";
                                REPEAT
                                    PaymentSchedule.INIT;
                                    PaymentSchedule."Document Type" := "Document Type";
                                    PaymentSchedule."Document No." := "No.";
                                    PaymentSchedule."Payment No" := InstalmentRatioRec."Instalment No";
                                    PaymentSchedule."Due Date" := StartDate;
                                    PaymentSchedule."Cover Start Date" := PaymentSchedule."Due Date";
                                    PaymentSchedule."Period Length" := InstalmentRatioRec."Period Length";
                                    PaymentSchedule."Instalment Percentage" := InstalmentRatioRec.Percentage;
                                    PaymentSchedule."Cover End Date" := CALCDATE(PaymentSchedule."Period Length", PaymentSchedule."Cover Start Date") - 1;
                                    StartDate := CALCDATE(InstalmentRatioRec."Period Length", StartDate);
                                    //MESSAGE('Inserting....');
                                    PaymentSchedule.INSERT;
                                UNTIL InstalmentRatioRec.NEXT = 0;
                            END
                            ELSE
                                ERROR('%1 No. of Instalments must be setup for comprehensive cover please set it up before proceeding', "No. Of Instalments");
                        END;
                    END;
                END;
            end;
        }
        field(92; "Currency Code"; Code[20])
        {
            TableRelation = Currency;
        }
        field(93; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate();
            begin
                /*IF "Currency Factor" <> xRec."Currency Factor" THEN
                  UpdateSalesLines(FIELDCAPTION("Currency Factor"),FALSE);*/

            end;
        }
        field(94; "Premium Financier"; Code[20])
        {
            TableRelation = Customer WHERE("Customer Type" = CONST(IPF));

            trigger OnValidate();
            begin
                IF Cust.GET("Premium Financier") THEN
                    "Premium Financier Name" := Cust.Name;
            end;
        }
        field(95; "Premium Financier Name"; Text[50])
        {
        }
        field(96; "Salesperson Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
        }
        field(97; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(98; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(99; "Dimension Set ID"; Integer)
        {
        }
        field(100; "Insured Address"; Text[80])
        {
        }
        field(101; "Insured Address 2"; Text[80])
        {
        }
        field(102; "Post Code"; Code[10])
        {
            TableRelation = "Post Code";
        }
        field(103; "Quotation No."; Code[20])
        {
        }
        field(104; "Cover Start Date"; Date)
        {

            trigger OnValidate();
            begin

                IF InsSetup.GET THEN
                    IF NOT InsSetup."Allow BackDating of Policy" THEN
                        IF "Cover Start Date" < WORKDATE THEN
                            ERROR('You cannot backdate a Cover start date');



                /*PolicyHeader.RESET;
                PolicyHeader.SETRANGE(PolicyHeader."Document Type",PolicyHeader."Document Type"::Policy);
                PolicyHeader.
                PolicyHeader.SETRANGE(PolicyHeader."Policy No","Policy No");
                PolicyHeader.SETFILTER(PolicyHeader."Cover End Date",'<=%1',"Cover Start Date");
                IF PolicyHeader.FINDFIRST THEN
                  ERROR('Policy %1 already exists and will cause an overlap of dates',PolicyHeader."Policy No");*/



                IF PolicyRecs.GET("Policy Type",UnderWriter) THEN
                    IF NOT PolicyRecs.Comprehensive THEN BEGIN //Comprehensive
                        IF NoOfInstalments.GET("No. Of Instalments") THEN BEGIN //No of instal
                            PeriodTxt := FORMAT(NoOfInstalments."Period Length");
                            ExtendedCoverDFTxt := InsMngt.GetNewPeriodLength(NoOfInstalments."Period Length", "No. Of Cover Periods");
                            //MESSAGE('%1',ExtendedCoverDFTxt);
                            EVALUATE(ExtendedCoverDF, ExtendedCoverDFTxt);
                            IF "No. Of Cover Periods" = 1 THEN BEGIN
                                IF (("Action Type" = "Action Type"::Suspension) OR ("Action Type" = "Action Type"::Substitution) OR ("Action Type" = "Action Type"::Cancellation) OR
                                 ("Action Type" = "Action Type"::"Yellow Card") OR ("Action Type" = "Action Type"::Addition)) THEN BEGIN
                                END
                                ELSE BEGIN
                                    IF FORMAT(NoOfInstalments."Last Instalment Period Length") <> '' THEN BEGIN //last instalment period
                                        IF "No. Of Instalments" = "Instalment No." THEN BEGIN //Last instalment
                                            IF "Cover Start Date" <> 0D THEN
                                                "Cover End Date" := CALCDATE(NoOfInstalments."Last Instalment Period Length", "Cover Start Date") - 1;
                                        END
                                        ELSE BEGIN //Not last instalment
                                            IF "Cover Start Date" <> 0D THEN
                                                "Cover End Date" := CALCDATE(NoOfInstalments."Period Length", "Cover Start Date") - 1;
                                        END //Not last instalment
                                    END
                                    ELSE BEGIN
                                        IF "Cover Start Date" <> 0D THEN
                                            "Cover End Date" := CALCDATE(NoOfInstalments."Period Length", "Cover Start Date") - 1;
                                    END;
                                END;
                            END
                            ELSE BEGIN

                                IF (("Action Type" = "Action Type"::Suspension) OR ("Action Type" = "Action Type"::Substitution) OR ("Action Type" = "Action Type"::Cancellation) OR
                                 ("Action Type" = "Action Type"::"Yellow Card") OR ("Action Type" = "Action Type"::Addition)) THEN BEGIN
                                END
                                ELSE BEGIN


                                    IF FORMAT(NoOfInstalments."Last Instalment Period Length") <> '' THEN BEGIN //last instalment period

                                        IF "No. Of Instalments" = "Instalment No." THEN BEGIN //Last instalment
                                            IF "Cover Start Date" <> 0D THEN
                                                "Cover End Date" := CALCDATE(NoOfInstalments."Last Instalment Period Length", "Cover Start Date") - 1;
                                        END
                                        ELSE BEGIN //Not last instalment
                                            IF "Cover Start Date" <> 0D THEN
                                                "Cover End Date" := CALCDATE(ExtendedCoverDF, "Cover Start Date") - 1;
                                        END //Not last instalment
                                    END
                                    ELSE BEGIN
                                        IF "Cover Start Date" <> 0D THEN
                                            "Cover End Date" := CALCDATE(ExtendedCoverDF, "Cover Start Date") - 1;
                                    END;


                                    // IF "Cover Start Date"<>0D THEN
                                    // "Cover End Date":=CALCDATE(ExtendedCoverDF,"Cover Start Date")-1;




                                END;
                            END;
                        END; //No of Instal
                    END //Comrehensive
                    ELSE BEGIN
                        PaymentSchedule.RESET;
                        PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", "Document Type");
                        PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", "No.");
                        PaymentSchedule.SETRANGE(PaymentSchedule."Payment No", "Instalment No.");

                        IF PaymentSchedule.FINDFIRST THEN BEGIN
                            IF (("Action Type" = "Action Type"::Suspension) OR ("Action Type" = "Action Type"::Substitution) OR ("Action Type" = "Action Type"::Cancellation)) THEN BEGIN
                            END
                            ELSE BEGIN
                                PeriodTxt := FORMAT(NoOfInstalments."Period Length");
                                "Cover End Date" := CALCDATE(PaymentSchedule."Period Length", "Cover Start Date") - 1;
                            END;

                        END
                        ELSE
                            MESSAGE('Payment schedule not define for %1 %2', "Document Type", "No.");
                    END;

                IF "Action Type" = "Action Type"::Resumption THEN BEGIN

                    EVALUATE(AwardPeriod, FORMAT("No. Of Days") + 'D');
                    "Cover End Date" := CALCDATE(AwardPeriod, "Cover Start Date") - 1;

                END;

                //Review later-added by Bkk for Demo Purposes
                IF TermRec.GET(Term) THEN BEGIN
                    "Cover End Date" := CALCDATE(TermRec.Term, "Cover Start Date") - 1;
                    //"Expected Renewal Date":=CALCDATE(TermRec.Term,"From Date");
                    //"From Time":=PolicyRecs."Start Time";
                    // "To Time":=PolicyRecs."End Time";
                END;
                //

            end;
        }
        field(105; "Cover End Date"; Date)
        {

            trigger OnValidate();
            begin
                /*shortCover.RESET;
                shortCover.SETRANGE(shortCover."Ending No. of  Period",InsMngt.GetNoOfMonths("Cover Start Date","Cover End Date"));
                IF shortCover.FINDLAST THEN
                BEGIN
                "Short Term Cover":=shortCover.Code;
                   "No. Of Months":=shortCover."Ending No. of  Period";
                   "Short term Cover Percent":=shortCover."Percentage Of Prem. Applicable";
                 END;*/
                //VALIDATE("Short Term Cover");
                //MESSAGE('doing it');
                IF "Action Type" = "Action Type"::"Yellow Card" THEN BEGIN
                    ComesaTable.RESET;
                    ComesaTable.SETRANGE(ComesaTable."No. Of Months", InsMngt.GetNoOfMonths("Cover Start Date", "Cover End Date"));
                    IF ComesaTable.FINDFIRST THEN BEGIN
                        "Short term Cover Percent" := ComesaTable."% of Annual Premium";
                        //MESSAGE('No. of months=%1 and Percentage =%2',InsMngt.GetNoOfMonths("Cover Start Date","Cover End Date"),"Short term Cover Percent");
                    END
                    ELSE BEGIN
                        ComesaTable.RESET;
                        ComesaTable.SETRANGE(ComesaTable."No. Of Months", 1);
                        IF ComesaTable.FINDFIRST THEN BEGIN
                            "Short term Cover Percent" := ComesaTable."% of Annual Premium";
                            //MESSAGE('No. of months=%1 and Percentage =%2',InsMngt.GetNoOfMonths("Cover Start Date","Cover End Date"),"Short term Cover Percent");
                        END
                    END;
                END;
                IF "Document Type" = "Document Type"::Endorsement THEN BEGIN

                    //"Mid Term Adjustment Factor":=InsMngt.CalculateMidTermFactor(Rec);
                    IF "Action Type" = "Action Type"::Resumption THEN BEGIN
                        /*PolicyHeader.RESET;
                        PolicyHeader.SETRANGE(PolicyHeader."Document Type",PolicyHeader."Document Type"::Policy);
                        PolicyHeader.SETRANGE(PolicyHeader."No.","Policy No");
                        IF PolicyHeader.FINDLAST THEN
                          BEGIN
                            MESSAGE('found suspended policy');
                            "Cover Start Date":="Document Date";
                            NoOfDays:=(PolicyHeader."Cover Start Date"-PolicyHeader."Document Date")+1;
                            "No. Of Days":=NoOfDays;
                            EVALUATE(AwardPeriod,FORMAT(NoOfDays)+'D');
                            "Cover End Date":=CALCDATE(AwardPeriod,"Cover Start Date");
                            "Mid Term Adjustment Factor":=PolicyHeader."Mid Term Adjustment Factor";

                          END;*/

                    END;
                END;

            end;
        }
        field(106; Posted; Boolean)
        {
        }
        field(107; "Posted By"; Code[80])
        {
        }
        field(108; "Posted DateTime"; DateTime)
        {
        }
        field(109; "Short Term Cover"; Code[20])
        {
            TableRelation = "Short Term Cover";

            trigger OnValidate();
            begin
                IF shortCover.GET("Short Term Cover") THEN BEGIN

                    "Cover Start Date" := "From Date";
                    "Cover End Date" := CALCDATE(shortCover."Period Length", "Cover Start Date") - 1;
                    "No. Of Months" := shortCover."Ending No. of  Period";
                    "Short term Cover Percent" := shortCover."Percentage Of Prem. Applicable";
                END;
            end;
        }
        field(110; "No. Of Months"; Integer)
        {
        }
        field(111; "Short term Cover Percent"; Decimal)
        {
        }
        field(112; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(113; "Language Code"; Code[10])
        {
        }
        field(114; "Payment Terms Code"; Code[10])
        {
            TableRelation = "Payment Terms";
        }
        field(115; "Bill To Customer No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(116; "No. Printed"; Integer)
        {
        }
        field(117; "Endorsement Type"; Code[20])
        {
            Editable = false;
            TableRelation = "Endorsement Types";

            trigger OnValidate();
            begin
                IF EndorsmentTypeRec.GET("Endorsement Type") THEN BEGIN
                    "Action Type" := EndorsmentTypeRec."Action Type";
                    "Premium Calculation Basis" := EndorsmentTypeRec."Premium Calculation basis";
                    IF (("Action Type" = "Action Type"::New) OR ("Action Type" = "Action Type"::Renewal)) THEN
                        "Instalment No." := 1;

                END;
            end;
        }
        field(118; "Action Type"; Option)
        {
            Editable = false;
            OptionCaption = '" ,Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,Yellow Card,Additional Riders"';
            OptionMembers = "  ",Extension,Cancellation,Suspension,Resumption,Substitution,Revision,Nil,Addition,Renewal,New,"Yellow Card","Additional Riders";
        }
        field(119; "Instalment No."; Integer)
        {
            TableRelation = "Instalment Payment Plan"."Payment No" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("No."));
        }
        field(120; "Quote Expiry Date"; Date)
        {
        }
        field(121; "Premium Calculation Basis"; Option)
        {
            OptionMembers = " ","Pro-rata","Short term","Full Premium";
        }
        field(122; "Endorsement Policy No."; Code[30])
        {
        }
        field(123; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }
        field(124; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));

            trigger OnValidate();
            begin
                ValidateShortcutDimCode(4, "Shortcut Dimension 4 Code");
            end;
        }
        field(125; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(126; "Insure Template Code"; Code[10])
        {
            Caption = 'Insure Template Code';
            TableRelation = "Customer Template";

            trigger OnValidate();
            var
                SellToCustTemplate: Record "Customer Template";
            begin
                TESTFIELD("Document Type", "Document Type"::Quote);
                TESTFIELD(Status, Status::Open);

                IF NOT InsertMode AND
                   ("Insure Template Code" <> xRec."Insure Template Code") AND
                   (xRec."Insure Template Code" <> '')
                THEN BEGIN
                    IF HideValidationDialog THEN
                        Confirmed := TRUE
                    ELSE
                        Confirmed := CONFIRM(Text004, FALSE, FIELDCAPTION("Insure Template Code"));
                    IF Confirmed THEN BEGIN
                        InsureLines.RESET;
                        InsureLines.SETRANGE("Document Type", "Document Type");
                        InsureLines.SETRANGE("Document No.", "No.");
                        IF "Insure Template Code" = '' THEN BEGIN
                            IF NOT InsureLines.ISEMPTY THEN
                                ERROR(Text005, FIELDCAPTION("Insure Template Code"));
                            INIT;
                            InsSetup.GET;
                            "No. Series" := xRec."No. Series";
                            InitRecord;
                            InitNoSeries;
                            EXIT;
                        END;
                    END ELSE BEGIN
                        "Insure Template Code" := xRec."Insure Template Code";
                        EXIT;
                    END;
                END;

                IF SellToCustTemplate.GET("Insure Template Code") THEN BEGIN
                    //Code removed

                    //Can insert details to be defaulted like the posting
                END;

                IF NOT InsertMode AND
                   ((xRec."Insure Template Code" <> "Insure Template Code") OR
                    (xRec."Currency Code" <> "Currency Code"))
                THEN
                    ;//RecreateSalesLines(FIELDCAPTION("Insure Template Code"));
            end;
        }
        field(127; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact;

            trigger OnLookup();
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                IF "Contact No." <> '' THEN
                    IF Cont.GET("Contact No.") THEN
                        Cont.SETRANGE("Company No.", Cont."Company No.")
                    ELSE BEGIN
                        ContBusinessRelation.RESET;
                        ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                        ContBusinessRelation.SETRANGE("No.", "Insured No.");
                        IF ContBusinessRelation.FINDFIRST THEN
                            Cont.SETRANGE("Company No.", ContBusinessRelation."Contact No.")
                        ELSE
                            Cont.SETRANGE("No.", '');
                    END;

                IF "Contact No." <> '' THEN
                    IF Cont.GET("Contact No.") THEN;
                IF PAGE.RUNMODAL(0, Cont) = ACTION::LookupOK THEN BEGIN
                    xRec := Rec;
                    VALIDATE("Contact No.", Cont."No.");
                END;
            end;

            trigger OnValidate();
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
                TESTFIELD(Status, Status::Open);

                IF ("Contact No." <> xRec."Contact No.") AND
                   (xRec."Contact No." <> '')
                THEN BEGIN
                    IF ("Contact No." = '') AND ("Opportunity No." <> '') THEN
                        ERROR(Text049, FIELDCAPTION("Contact No."));
                    IF HideValidationDialog OR NOT GUIALLOWED THEN
                        Confirmed := TRUE
                    ELSE
                        Confirmed := CONFIRM(Text004, FALSE, FIELDCAPTION("Contact No."));
                    IF Confirmed THEN BEGIN
                        InsureLines.RESET;
                        InsureLines.SETRANGE("Document Type", "Document Type");
                        InsureLines.SETRANGE("Document No.", "No.");
                        IF ("Contact No." = '') AND ("Insured No." = '') THEN BEGIN
                            IF NOT InsureLines.ISEMPTY THEN
                                ERROR(Text005, FIELDCAPTION("Contact No."));
                            INIT;
                            InsureLines.GET;
                            /*"No. Series" := xRec."No. Series";
                            InitRecord;
                            InitNoSeries;*/
                            EXIT;
                        END;
                        IF "Opportunity No." <> '' THEN BEGIN
                            Opportunity.GET("Opportunity No.");
                            IF Opportunity."Contact No." <> "Contact No." THEN BEGIN
                                MODIFY;
                                Opportunity.VALIDATE("Contact No.", "Contact No.");
                                Opportunity.MODIFY;
                            END
                        END;
                    END ELSE BEGIN
                        Rec := xRec;
                        EXIT;
                    END;
                END;

                ContBusinessRelation.RESET;
                ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                ContBusinessRelation.SETRANGE(ContBusinessRelation."Contact No.", "Contact No.");
                IF ContBusinessRelation.FINDFIRST THEN BEGIN
                    "Insured No." := ContBusinessRelation."No.";
                    //VALIDATE("Insured No.");
                    "Insured Name" := "Contact Name";
                END;



                IF ("Insured No." <> '') AND ("Contact No." <> '') THEN BEGIN
                    Cont.GET("Contact No.");
                    ContBusinessRelation.RESET;
                    ContBusinessRelation.SETCURRENTKEY("Link to Table", "No.");
                    ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
                    ContBusinessRelation.SETRANGE("No.", "Insured No.");
                    IF ContBusinessRelation.FINDFIRST THEN
                        ;
                    /*IF ContBusinessRelation."Contact No." <> Cont."Company No." THEN
                       ERROR(Text038,Cont."No.",Cont.Name,"Insured No.");*/
                END;

                IF Cont.GET("Contact No.") THEN BEGIN

                    "Contact Name" := Cont.Name;
                    "Salesperson Code" := Cont."Salesperson Code";

                END;
                //UpdateSellToCust("Contact No.");

            end;
        }
        field(128; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = IF ("Document Type" = FILTER(<> Quote)) Opportunity."No." WHERE("Contact No." = FIELD("Contact No."), Closed = CONST(false))
            ELSE
            IF ("Document Type" = CONST(Quote)) Opportunity."No." WHERE("Contact No." = FIELD("Contact No."));

            trigger OnValidate();
            begin
                LinkSalesDocWithOpportunity(xRec."Opportunity No.");
            end;
        }
        field(129; "Contact Name"; Text[30])
        {
        }
        field(130; "No. Of Days"; Integer)
        {
        }
        field(131; "Original Cover Start Date"; Date)
        {
        }
        field(132; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = '" ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund"';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(133; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';

            trigger OnLookup();
            begin
                /*TESTFIELD("Bal. Account No.",'');
                CustLedgEntry.SETCURRENTKEY("Customer No.",Open,Positive,"Due Date");
                CustLedgEntry.SETRANGE("Customer No.","Bill-to Customer No.");
                CustLedgEntry.SETRANGE(Open,TRUE);
                IF "Applies-to Doc. No." <> '' THEN BEGIN
                  CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                  CustLedgEntry.SETRANGE("Document No.","Applies-to Doc. No.");
                  IF CustLedgEntry.FINDFIRST THEN;
                  CustLedgEntry.SETRANGE("Document Type");
                  CustLedgEntry.SETRANGE("Document No.");
                END ELSE
                  IF "Applies-to Doc. Type" <> 0 THEN BEGIN
                    CustLedgEntry.SETRANGE("Document Type","Applies-to Doc. Type");
                    IF CustLedgEntry.FINDFIRST THEN;
                    CustLedgEntry.SETRANGE("Document Type");
                  END ELSE
                    IF Amount <> 0 THEN BEGIN
                      CustLedgEntry.SETRANGE(Positive,Amount < 0);
                      IF CustLedgEntry.FINDFIRST THEN;
                      CustLedgEntry.SETRANGE(Positive);
                    END;
                
                ApplyCustEntries.SetSales(Rec,CustLedgEntry,SalesHeader.FIELDNO("Applies-to Doc. No."));
                ApplyCustEntries.SETTABLEVIEW(CustLedgEntry);
                ApplyCustEntries.SETRECORD(CustLedgEntry);
                ApplyCustEntries.LOOKUPMODE(TRUE);
                IF ApplyCustEntries.RUNMODAL = ACTION::LookupOK THEN BEGIN
                  ApplyCustEntries.GetCustLedgEntry(CustLedgEntry);
                  GenJnlApply.CheckAgainstApplnCurrency(
                    "Currency Code",CustLedgEntry."Currency Code",GenJnILine."Account Type"::Customer,TRUE);
                  "Applies-to Doc. Type" := CustLedgEntry."Document Type";
                  "Applies-to Doc. No." := CustLedgEntry."Document No.";
                END;
                CLEAR(ApplyCustEntries);
                */

            end;

            trigger OnValidate();
            begin
                /*IF "Applies-to Doc. No." <> '' THEN
                {  TESTFIELD("Bal. Account No.",'');}
                
                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                  SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.");
                  SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");
                END ELSE
                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                    SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.")
                  ELSE
                    IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                      SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");*/

            end;
        }
        field(134; "Source of Business"; Code[20])
        {
            TableRelation = "Source Of Business";

            trigger OnValidate();
            begin
                IF SourceofBusiness.GET("Source of Business") THEN
                    "Source of Business Type" := SourceofBusiness.Type;
            end;
        }
        field(135; "Business Source Name"; Text[50])
        {
        }
        field(136; "Total Comprehensive Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Lines"."Gross Premium" WHERE("Document Type" = FIELD("Document Type"),
                                                                    "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(137; "Total TPO Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Lines"."TPO Premium" WHERE("Document Type" = FIELD("Document Type"),
                                                                  "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(138; "Total PLL Premium"; Decimal)
        {
            CalcFormula = Sum("Insure Lines".PLL WHERE("Document Type" = FIELD("Document Type"),
                                                        "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(139; "Total Extra Premium"; Decimal)
        {
            CalcFormula = Sum("Additional Benefits".Premium WHERE("Document Type" = FIELD("Document Type"),
                                                                   "Document No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(140; "Applied Amount"; Decimal)
        {
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Document No." = FIELD("Applies-to Doc. No.")));
            FieldClass = FlowField;
        }
        field(141; "No. Of Cover Periods"; Integer)
        {

            trigger OnValidate();
            begin
                VALIDATE("No. Of Instalments");
                IF "Cover Start Date" <> 0D THEN
                    VALIDATE("Cover Start Date");
            end;
        }
        field(142; "Cancellation Reason"; Code[20])
        {
            TableRelation = "Cancellation Reasons";

            trigger OnValidate();
            begin
                IF CancelReasonRec.GET("Cancellation Reason") THEN
                    "Cancellation Reason Desc" := CancelReasonRec.Description;
            end;
        }
        field(143; "Cancellation Reason Desc"; Text[30])
        {
            Editable = false;
        }
        field(144; "Premium Finance %"; Decimal)
        {
        }
        field(145; "Source of Business Type"; Option)
        {
            OptionCaption = '" ,Employee,Customer,Vendor,Contact,Campaign"';
            OptionMembers = " ",Employee,Customer,Vendor,Contact,Campaign;
        }
        field(146; "Source of Business No."; Code[20])
        {
            TableRelation = IF ("Source of Business Type" = CONST(Employee)) Employee
            ELSE
            IF ("Source of Business Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source of Business Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source of Business Type" = CONST(Contact)) Contact
            ELSE
            IF ("Source of Business Type" = CONST(Campaign)) Campaign;

            trigger OnValidate();
            begin
                IF "Source of Business Type" = "Source of Business Type"::Employee THEN BEGIN
                    IF Employee.GET("Source of Business No.") THEN
                        "Business Source Name" := Employee."First Name" + ' ' + Employee."Last Name";
                END;
                IF "Source of Business Type" = "Source of Business Type"::Customer THEN BEGIN
                    IF Cust.GET("Source of Business No.") THEN
                        "Business Source Name" := Cust.Name;
                END;
                IF "Source of Business Type" = "Source of Business Type"::Vendor THEN BEGIN
                    IF Vend.GET("Source of Business No.") THEN
                        "Business Source Name" := Vend.Name;
                END;

                IF "Source of Business Type" = "Source of Business Type"::Campaign THEN BEGIN
                    IF Campaign.GET("Source of Business No.") THEN
                        "Business Source Name" := Campaign.Description;
                END;
            end;
        }
        field(147; Age; Integer)
        {

        }
        field(148; "Sum Assured"; Decimal)
        {

        }
        field(149; "Pay-out Commencement Date"; Date)
        {

        }
        field(150; "Pay-out Frequency"; Integer)
        {
            Tablerelation = "Policy Instalments"."No. Of Instalments";
            
             trigger onvalidate();
             var
               
             begin
                 
                validate(Term);

                If TermRec.GET(Term) then
                 
                TermP:=TermRec."No. Of Periods";
                AnnuityRate:=BrokerMngt.GetAnnuityRate(Age,TermP,Sex);

                 Annuity:=BrokerMngt.CalcGrossPay("Sum Assured",AnnuityRate,"Pay-out Frequency");
                 
                     MESSAGE('Annuity =%1',Annuity);




             end;

                  


        }
        field(151;Annuity;Decimal)
        {

        }

        field(152;"Guaranteed Period";Code[20])
        {
           Tablerelation="Product Terms"."Term Code" where ("Underwriter Code"=FIELD(Underwriter),"Product Code"=Field("Policy Type"));
        }
    
    
        field(153;"Escalation Percentage";Decimal)
        {

        }
        field(154;"Deffered Period";Dateformula)
        {
            
        }
        field(5043; "No. of Archived Versions"; Integer)
        {

            Editable = false;
            FieldClass = FlowField;
            Caption = 'No. of Archived Versions';
            CalcFormula = Max("Sales Header Archive"."Version No." WHERE("Document Type" = FIELD("Document Type"),
                                                                          "No." = FIELD("No."),
                                                                          "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence")));

        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5049; "Posting No."; Code[20])
        {
        }
        field(5050; "Posting No. Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(5051; Term; Code[20])
        {
            Caption='Policy Term';
            TableRelation = "Product Terms"."Term Code" WHERE("Product Code" = FIELD("Policy Type"),
            "Underwriter Code" = FIELD(Underwriter));

            trigger OnValidate();
            begin
                IF TermRec.GET(Term) THEN
                    "No. Of Cover Periods" := TermRec."No. Of Periods";
                   
                   ProductTerm.reset;
                   ProductTerm.setrange("Underwriter Code","Underwriter");
                   ProductTerm.setrange("Product Code","Policy Type");
                   ProductTerm.setrange(ProductTerm."Term Code",Term);
                   If productterm.findfirst then
                   begin
                       If termRec.GET(ProductTerm."Deffered/Saving Period") then
                       begin
                       "Deffered Period":=TermRec.Term;
                       "Pay-out Commencement Date":=CALCDATE(TermRec.Term,"From Date");
                       end;

                     
                   end;

            end;
        }
        field(5052; "Approval Document Type"; Enum "Approval Document Type")
        {

        }
        field(5053; "Sales Agent"; code[20])
        {
            TableRelation = Vendor."No." Where("Vendor Type" = CONST(Agent));

            trigger Onvalidate();
            begin
                //Message('Start');
                if Vendor.Get("Sales Agent") then
                    "Brokers Name" := Vendor.Name
                else
                    "Brokers Name" := '';
                    //MESSAGE('gets here');

                CommissionTab.Reset;
                CommissionTab.setrange(CommissionTab.Underwriter, Underwriter);
                CommissionTab.setrange(CommissionTab."Policy Type", "Policy Type");
                CommissionTab.setrange(CommissionTab."Agent Code", "Sales Agent");
                CommissionTab.setrange(CommissionTab."Commission Calculation Type", CommissionTab."Commission Calculation Type"::"Percentage of Comm Receivable");
                IF CommissionTab.findfirst THEN begin
                    "Commission payable 1" := CommissionTab."% age";
                    //Message('Commission Updated =%1 and setup=%2',"Commission payable 1",CommissionTab."% age" );

                end;

            end;


        }
        field(5054; "Business Type"; Enum "Business Type")
        {

        }
        field(5055; "Parent Quote No"; Code[20])
        {

        }


    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
        key(Key2; "Insured No.")
        {
        }
        key(Key3; "Contact No.")
        {
        }
        key(Key4; "Cover Start Date")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        IF "Document Type" = "Document Type"::Policy THEN
            ERROR('You cannot delete policy record directly');

        InsureLines.RESET;
        InsureLines.SETRANGE(InsureLines."Document Type", "Document Type");
        InsureLines.SETRANGE(InsureLines."Document No.", "No.");
        InsureLines.DELETEALL;

        DiscLines.RESET;
        DiscLines.SETRANGE(DiscLines."Document Type", "Document Type");
        DiscLines.SETRANGE(DiscLines."No.", "No.");
        DiscLines.DELETEALL;

        CoinsuranceLines.RESET;
        CoinsuranceLines.SETRANGE(CoinsuranceLines."Document Type", "Document Type");
        CoinsuranceLines.SETRANGE(CoinsuranceLines."No.", "No.");
        CoinsuranceLines.DELETEALL;

        PaymentSchedule.RESET;
        PaymentSchedule.SETRANGE(PaymentSchedule."Document Type", "Document Type");
        PaymentSchedule.SETRANGE(PaymentSchedule."Document No.", "No.");
        PaymentSchedule.DELETEALL;


        //MESSAGE('Deleting %1 Number %2',"Document Type","No.");
    end;

    trigger OnInsert();
    begin
        "Created By" := USERID;
        "Posting Date" := WORKDATE;
        "Document Date" := WORKDATE;
        CustomerTemplate.RESET;
        IF CustomerTemplate.FINDFIRST THEN
            "Insure Template Code" := CustomerTemplate.Code;


        IF UserSetupDetails.GET(USERID) THEN BEGIN
            "Shortcut Dimension 1 Code" := UserSetupDetails."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := UserSetupDetails."Global Dimension 2 Code";
        END;

        IF "Document Type" = "Document Type"::Quote THEN BEGIN //Quote


            IF "Quote Type" = "Quote Type"::New THEN BEGIN
                IF "No." = '' THEN BEGIN
                    TestNoSeries;
                    NoSeriesMgt.InitSeries(InsSetup."New Quotation Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
                    EndorsmentTypeRec.RESET;
                    EndorsmentTypeRec.SETRANGE(EndorsmentTypeRec."Action Type", EndorsmentTypeRec."Action Type"::New);
                    IF EndorsmentTypeRec.FINDFIRST THEN BEGIN
                        "Endorsement Type" := EndorsmentTypeRec.Code;
                        "Shortcut Dimension 4 Code" := EndorsmentTypeRec."Shortcut Dimension 4 Code";

                        //VALIDATE("Shortcut Dimension 4 Code");
                        VALIDATE("Endorsement Type");
                    END;
                END;
            END;

            IF "Quote Type" = "Quote Type"::Renewal THEN BEGIN
                IF "No." = '' THEN BEGIN
                    TestNoSeries;
                    NoSeriesMgt.InitSeries(InsSetup."Renewal Quote Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
                END;
            END;

            IF "Quote Type" = "Quote Type"::Modification THEN BEGIN
                IF "No." = '' THEN BEGIN
                    //MESSAGE('Attempting to create an additional quote');
                    TestNoSeries;
                    NoSeriesMgt.InitSeries(InsSetup."Modification Quote Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
                END;
            END;
        END;

        IF "Document Type" = "Document Type"::"Accepted Quote" THEN BEGIN //Debit
            TestNoSeries;
            NoSeriesMgt.InitSeries(InsSetup."Accepted Quote Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
            //Posting no
            //"Posting No. Series":=InsSetup."Posted Debit Notes";
            EndorsmentTypeRec.RESET;
            EndorsmentTypeRec.SETRANGE(EndorsmentTypeRec."Action Type", EndorsmentTypeRec."Action Type"::New);
            IF EndorsmentTypeRec.FINDFIRST THEN BEGIN
                "Endorsement Type" := EndorsmentTypeRec.Code;
                "Shortcut Dimension 4 Code" := EndorsmentTypeRec."Shortcut Dimension 4 Code";

                //VALIDATE("Shortcut Dimension 4 Code");
                VALIDATE("Endorsement Type");
            END;
        END;


        IF "Document Type" = "Document Type"::"Debit Note" THEN BEGIN //Debit
            TestNoSeries;
            NoSeriesMgt.InitSeries(InsSetup."Debit Note", xRec."No. Series", "Posting Date", "No.", "No. Series");
            //Posting no
            message('Debit note No %1', "No.");
            "Posting No. Series" := InsSetup."Posted Debit Notes";
        END;

        IF "Document Type" = "Document Type"::"Credit Note" THEN BEGIN //Debit
            TestNoSeries;
            NoSeriesMgt.InitSeries(InsSetup."Credit Note", xRec."No. Series", "Posting Date", "No.", "No. Series");
            "Posting No. Series" := InsSetup."Posted Credit Notes";
        END;


        IF "Document Type" = "Document Type"::Endorsement THEN BEGIN //Debit
            IF EndorsmentTypeRec.GET("Endorsement Type") THEN BEGIN
                TestNoSeries;
                NoSeriesMgt.InitSeries(EndorsmentTypeRec."No. Series", xRec."No. Series", "Posting Date", "No.", "No. Series");
                "Endorsement Type" := EndorsmentTypeRec.Code;
                VALIDATE("Endorsement Type");
            END;
        END;
        IF "Document Type" = "Document Type"::"Insurer Quotes" THEN BEGIN //Debit
            if "No." = '' then begin
                InsSetup.Get();
                InsSetup.TestField("Insurer Quote Nos");
                NoSeriesMgt.InitSeries(InsSetup."Insurer Quote Nos", xRec."No. Series", "Posting Date", "No.", "No. Series");
            end;

        END;





        "No. Of Cover Periods" := 1;


        /*IF "Document Type"="Document Type"::Policy THEN
        BEGIN //Debit
        "No.":=InsMngt.GeneratePolicyNos(Rec);
        END;*/

        IF GetFilterCustNo <> '' THEN
            VALIDATE("Insured No.", GetFilterCustNo);

        IF GetFilterContNo <> '' THEN
            VALIDATE("Contact No.", GetFilterContNo);
        //MESSAGE('%1',GetFilterContNo);

        //********************************Insert Business Type*****************************//
        If InsSetup.Get() then
            "Business Type" := CUEnumAssignment.FnGetBusinessType(InsSetup."Business Type");
        //********************************Insert Business Type*****************************//

    end;

    trigger OnModify();
    begin
        IF "Document Type" = "Document Type"::Policy THEN
            ERROR('You cannot modify policy record directly');
    end;

    var
        saleslinerec: Record "Insure Lines";
        InsSetup: Record "Insurance setup";
        CUEnumAssignment: Codeunit "Enum Assignment Mgmt";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cust: Record Customer;
        PolicyRecs: Record "Underwriter Policy Types";
        OptionsSelected: Record "Insure Header Loading_Discount";
        InsuranceType: Record "Loading and Discounts Setup";
        LastNo: Integer;
        InsurerPolicyDetails: Record "Insurer Policy Details";
        PolicyDetails: Record "Policy Details";
        DimMgt: Codeunit 408;
        Vendor: Record Vendor;
        InsMngt: Codeunit "Insurance management";
        shortCover: Record "Short Term Cover";
        InsureLines: Record "Insure Lines";
        EndorsmentTypeRec: Record "Endorsement Types";
        DiscLines: Record "Insure Header Loading_Discount";
        CoinsuranceLines: Record "Coinsurance Reinsurance Lines";
        PaymentSchedule: Record "Instalment Payment Plan";
        NoOfInstalments: Record "No. of Instalments";
        PolicyHeader: Record "Insure Header";
        NoOfDays: Integer;
        AwardPeriod: DateFormula;
        UserSetupDetails: Record "User Setup Details";
        ProductSelector: Record "Product Multi Selector";
        UnderWriterProducts: Record "Underwriter Policy Types";
        Text000: Label 'Do you want to print shipment %1?';
        Text001: Label 'Do you want to print invoice %1?';
        Text002: Label 'Do you want to print credit memo %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more purchase orders.';
        Text007: Label '%1 cannot be greater than %2 in the %3 table.';
        Text009: Label 'Deleting this document will cause a gap in the number series for shipments. An empty shipment %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. An empty posted invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. An empty posted credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text015: Label 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\Do you want to change %1?';
        Text017: Label 'You must delete the existing sales lines before you can change %1.';
        Text018: Label 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.\';
        Text019: Label 'You must update the existing sales lines manually.';
        Text020: Label 'The change may affect the exchange rate used in the price calculation of the sales lines.';
        Text021: Label 'Do you want to update the exchange rate?';
        Text022: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text023: Label 'Do you want to print return receipt %1?';
        Text024: Label 'You have modified the %1 field. The recalculation of VAT may cause penny differences, so you must check the amounts afterward. Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: Label 'Your identification is set up to process from %1 %2 only.';
        Text028: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text030: Label 'Deleting this document will cause a gap in the number series for return receipts. An empty return receipt %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text031: Label 'You have modified %1.\\';
        Text032: Label 'Do you want to update the lines?';
        Text067: Label '%1 %4 with amount of %2 has already been authorized on %3 and is not expired yet. You must void the previous authorization before you can re-authorize this %1.';
        Text068: Label 'There is nothing to void.';
        Text069: Label 'The selected operation cannot complete with the specified %1.';
        Text035: Label 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?';
        Text037: Label 'Contact %1 %2 is not related to customer %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than customer %3.';
        Text039: Label 'Contact %1 %2 is not related to a customer.';
        Text040: Label 'A won opportunity is linked to this order.\It has to be changed to status Lost before the Order can be deleted.\Do you want to change the status for this opportunity now?';
        Text043: Label 'Wizard Aborted';
        Text044: Label 'The status of the opportunity has not been changed. The program has aborted deleting the order.';
        Text045: TextConst ENU = 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text048: Label 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?';
        Text049: Label 'The %1 field cannot be blank because this quote is linked to an opportunity.';
        Text051: Label 'The sales %1 %2 already exists.';
        Text052: Label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text053: Label 'You must cancel the approval process if you wish to change the %1.';
        Text055: Label 'Do you want to print prepayment invoice %1?';
        Text054: Label 'Do you want to print prepayment credit memo %1?';
        Text056: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text057: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text061: Label '%1 is set up to process from %2 %3 only.';
        Text062: Label 'You cannot change %1 because the corresponding %2 %3 has been assigned to this %4.';
        Text063: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\Do you want to continue?';
        Text064: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text066: Label 'You cannot change %1 to %2 because an open inventory pick on the %3.';
        Text070: Label 'You cannot change %1  to %2 because an open warehouse shipment exists for the %3.';
        Text071: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        Text072: Label 'There are unpaid prepayment invoices related to the document of type %1 with the number %2.';
        SynchronizingMsg: Label 'Synchronizing ...\ from: Sales Header with %1\ to: Assembly Header with %2.';
        ShippingAdviceErr: Label 'This order must be a complete shipment.';
        InsertMode: Boolean;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        SkipSellToContact: Boolean;
        CustomerTemplate: Record "Customer Template";
        NoOfDayz: Integer;
        InstalmentRatioRec: Record "Instalment Ratio";
        DocumentsRequired: Record "Documents Required";
        InsuranceDocs: Record "Insurance Documents";
        InstalmentRatio: Record "Instalment Ratio";
        StartDate: Date;
        PeriodTxt: Text;
        PeriodLenthDF: DateFormula;
        ExtendedCoverDF: DateFormula;
        ExtendedCoverDFTxt: Text;
        CancelReasonRec: Record "Cancellation Reasons";
        ComesaTable: Record "Yellow Card Tables";
        Employee: Record Employee;
        Vend: Record Vendor;
        Campaign: Record Campaign;
        Contact: Record Contact;
        SourceofBusiness: Record "Source Of Business";
        LastPeriodText: Text;
        LastPeriodDF: DateFormula;
        TermRec: Record Term;
        ProductTerm: Record "Product Terms";
        InsureCoverSelection: Record "Insure Header Cover Selection";
        ProductBenRiders: Record "Product Benefits & Riders";
        UnderwriterPolicyType: Record "Underwriter Policy types";

        CommissionTab: Record "Commissions Setup";

        BrokerMngt: Codeunit "Broker management";
        AnnuityRate:Decimal;
        GuaranteeYrs:Integer;
       
       
       
        TermP:integer;        
        


    local procedure TestNoSeries(): Boolean;
    begin
        InsSetup.GET;

        CASE "Document Type" OF
            "Document Type"::Quote:
                BEGIN
                    InsSetup.TESTFIELD(InsSetup."New Quotation Nos");
                    InsSetup.TESTFIELD(InsSetup."Renewal Quote Nos");
                    InsSetup.TESTFIELD(InsSetup."Modification Quote Nos");
                END;
            "Document Type"::"Debit Note":
                BEGIN
                    //SalesSetup.TESTFIELD("Invoice Nos.");
                    //SalesSetup.TESTFIELD("Posted Invoice Nos.");
                END;

            // SalesSetup.TESTFIELD("Return Order Nos.");
            "Document Type"::"Credit Note":
                BEGIN
                    // SalesSetup.TESTFIELD("Credit Memo Nos.");
                    // SalesSetup.TESTFIELD("Posted Credit Memo Nos.");
                END;
            "Document Type"::"Insurer Quotes":
                begin
                    InsSetup.TESTFIELD(InsSetup."Insurer Quote Nos");
                end;
        // "Document Type"::policy:
        // InsSetup.TESTFIELD(InsSetup."Policy Nos");
        END;
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        IF "No." <> '' THEN
            MODIFY;

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF InsureLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    procedure InsureLinesExist(): Boolean;
    begin
        InsureLines.RESET;
        InsureLines.SETRANGE("Document Type", "Document Type");
        InsureLines.SETRANGE("Document No.", "No.");
        EXIT(InsureLines.FINDFIRST);
    end;

    local procedure GetFilterCustNo(): Code[20];
    begin
        IF GETFILTER("Insured No.") <> '' THEN
            IF GETRANGEMIN("Insured No.") = GETRANGEMAX("Insured No.") THEN
                EXIT(GETRANGEMAX("Insured No."));
    end;

    local procedure GetFilterContNo(): Code[20];
    begin
        IF GETFILTER("Contact No.") <> '' THEN
            IF GETRANGEMIN("Contact No.") = GETRANGEMAX("Contact No.") THEN
                EXIT(GETRANGEMAX("Contact No."));
    end;

    procedure CreateTodo();
    var
        TempTodo: Record "To-do" temporary;
    begin
        TESTFIELD("Contact No.");
        //TempTodo.CreateToDoFromSalesHeader(Rec);
    end;

    procedure ShowDocDim();
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", STRSUBSTNO('%1 %2', "Document Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        IF OldDimSetID <> "Dimension Set ID" THEN BEGIN
            MODIFY;
            IF InsureLinesExist THEN
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer);
    var
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        IF NewParentDimSetID = OldParentDimSetID THEN
            EXIT;
        IF NOT CONFIRM(Text051) THEN
            EXIT;

        InsureLines.RESET;
        InsureLines.SETRANGE("Document Type", "Document Type");
        InsureLines.SETRANGE("Document No.", "No.");
        InsureLines.LOCKTABLE;
        IF InsureLines.FIND('-') THEN
            REPEAT
                NewDimSetID := DimMgt.GetDeltaDimSetID(InsureLines."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                IF InsureLines."Dimension Set ID" <> NewDimSetID THEN BEGIN
                    InsureLines."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      InsureLines."Dimension Set ID", InsureLines."Shortcut Dimension 1 Code", InsureLines."Shortcut Dimension 2 Code");
                    InsureLines.MODIFY;
                END;
            UNTIL InsureLines.NEXT = 0;
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20]);
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Sales, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        IF (OldDimSetID <> "Dimension Set ID") AND InsureLinesExist THEN BEGIN
            MODIFY;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        END;
    end;

    procedure InitRecord();
    begin
        /*SalesSetup.GET;
        
        CASE "Document Type" OF
          "Document Type"::Quote,"Document Type"::Order:
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Invoice Nos.");
              NoSeriesMgt.SetDefaultSeries("Shipping No. Series",SalesSetup."Posted Shipment Nos.");
              IF "Document Type" = "Document Type"::Order THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Prepayment No. Series",SalesSetup."Posted Prepmt. Inv. Nos.");
                NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series",SalesSetup."Posted Prepmt. Cr. Memo Nos.");
              END;
            END;
          "Document Type"::Invoice:
            BEGIN
              IF ("No. Series" <> '') AND
                 (SalesSetup."Invoice Nos." = SalesSetup."Posted Invoice Nos.")
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Invoice Nos.");
              IF SalesSetup."Shipment on Invoice" THEN
                NoSeriesMgt.SetDefaultSeries("Shipping No. Series",SalesSetup."Posted Shipment Nos.");
            END;
          "Document Type"::"Return Order":
            BEGIN
              NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Credit Memo Nos.");
              NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series",SalesSetup."Posted Return Receipt Nos.");
            END;
          "Document Type"::"Credit Memo":
            BEGIN
              IF ("No. Series" <> '') AND
                 (SalesSetup."Credit Memo Nos." = SalesSetup."Posted Credit Memo Nos.")
              THEN
                "Posting No. Series" := "No. Series"
              ELSE
                NoSeriesMgt.SetDefaultSeries("Posting No. Series",SalesSetup."Posted Credit Memo Nos.");
              IF SalesSetup."Return Receipt on Credit Memo" THEN
                NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series",SalesSetup."Posted Return Receipt Nos.");
            END;
        END;
        
        IF "Document Type" IN ["Document Type"::Order,"Document Type"::Invoice,"Document Type"::Quote] THEN
          BEGIN
          "Shipment Date" := WORKDATE;
          "Order Date" := WORKDATE;
        END;
        IF "Document Type" = "Document Type"::"Return Order" THEN
          "Order Date" := WORKDATE;
        
        IF NOT ("Document Type" IN ["Document Type"::"Blanket Order","Document Type"::Quote]) AND
           ("Posting Date" = 0D)
        THEN
          "Posting Date" := WORKDATE;
        
        IF SalesSetup."Default Posting Date" = SalesSetup."Default Posting Date"::"No Date" THEN
          "Posting Date" := 0D;
        
        "Document Date" := WORKDATE;
        
        VALIDATE("Location Code",UserSetupMgt.GetLocation(0,Cust."Location Code","Responsibility Center"));
        
        IF "Document Type" IN ["Document Type"::"Return Order","Document Type"::"Credit Memo"] THEN BEGIN
          GLSetup.GET;
          Correction := GLSetup."Mark Cr. Memos as Corrections";
        END;
        
        "Posting Description" := FORMAT("Document Type") + ' ' + "No.";
        
        Reserve := Reserve::Optional;
        
        IF InvtSetup.GET THEN
          VALIDATE("Outbound Whse. Handling Time",InvtSetup."Outbound Whse. Handling Time");
        
        "Responsibility Center" := UserSetupMgt.GetRespCenter(0,"Responsibility Center");*/

    end;

    local procedure InitNoSeries();
    begin
        /*IF xRec."Shipping No." <> '' THEN BEGIN
          "Shipping No. Series" := xRec."Shipping No. Series";
          "Shipping No." := xRec."Shipping No.";
        END;
        IF xRec."Posting No." <> '' THEN BEGIN
          "Posting No. Series" := xRec."Posting No. Series";
          "Posting No." := xRec."Posting No.";
        END;
        IF xRec."Return Receipt No." <> '' THEN BEGIN
          "Return Receipt No. Series" := xRec."Return Receipt No. Series";
          "Return Receipt No." := xRec."Return Receipt No.";
        END;
        IF xRec."Prepayment No." <> '' THEN BEGIN
          "Prepayment No. Series" := xRec."Prepayment No. Series";
          "Prepayment No." := xRec."Prepayment No.";
        END;
        IF xRec."Prepmt. Cr. Memo No." <> '' THEN BEGIN
          "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
          "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
        END;*/

    end;

    procedure AssistEdit(OldSalesHeader: Record "Insure Header"): Boolean;
    var
        SalesHeader2: Record "Insure Header";
    begin
        /*WITH Insure DO BEGIN
          COPY(Rec);
          SalesSetup.GET;
          TestNoSeries;
          IF NoSeriesMgt.SelectSeries(GetNoSeriesCode,OldSalesHeader."No. Series","No. Series") THEN BEGIN
            IF ("Insured No." = '') AND ("Contact No." = '') THEN BEGIN
              HideCreditCheckDialogue := FALSE;
              CheckCreditMaxBeforeInsert;
              HideCreditCheckDialogue := TRUE;
            END;
            NoSeriesMgt.SetSeries("No.");
            IF SalesHeader2.GET("Document Type","No.") THEN
              ERROR(Text051,LOWERCASE(FORMAT("Document Type")),"No.");
            Rec := SalesHeader;
            EXIT(TRUE);
          END;
        END;*/

    end;

    local procedure UpdateSellToCont(CustomerNo: Code[20]);
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        //MESSAGE('Customer =%1',CustomerNo);

        IF Cust.GET(CustomerNo) THEN BEGIN
            IF Cust."Primary Contact No." <> '' THEN
                "Contact No." := Cust."Primary Contact No."
            ELSE BEGIN
                ContBusRel.RESET;
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "Insured No.");
                IF ContBusRel.FINDFIRST THEN
                    "Contact No." := ContBusRel."Contact No."
                ELSE
                    "Contact No." := '';
            END;
            "Contact No." := Cust.Contact;
        END;
    end;

    local procedure UpdateBillToCont(CustomerNo: Code[20]);
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        IF Cust.GET(CustomerNo) THEN BEGIN
            IF Cust."Primary Contact No." <> '' THEN
                "Contact No." := Cust."Primary Contact No."
            ELSE BEGIN
                ContBusRel.RESET;
                ContBusRel.SETCURRENTKEY("Link to Table", "No.");
                ContBusRel.SETRANGE("Link to Table", ContBusRel."Link to Table"::Customer);
                ContBusRel.SETRANGE("No.", "Insured No.");
                IF ContBusRel.FINDFIRST THEN
                    "Contact No." := ContBusRel."Contact No."
                ELSE
                    "Contact No." := '';
            END;
            "Contact No." := Cust.Contact;
        END;
    end;

    local procedure UpdateSellToCust(ContactNo: Code[20]);
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Template";
        ContComp: Record Contact;
    begin
        //MESSAGE('Getting In Contact=%1',ContactNo);

        IF Cont.GET(ContactNo) THEN
            "Contact No." := Cont."No."

        ELSE BEGIN
            MESSAGE('Blank contact');
            "Contact No." := '';
            EXIT;
        END;

        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table", "Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table", ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.", Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
            IF ("Insured No." <> '') AND
               ("Insured No." <> ContBusinessRelation."No.")
            THEN
                ERROR(Text037, Cont."No.", Cont.Name, "Insured No.");
            IF "Insured No." = '' THEN BEGIN
                SkipSellToContact := TRUE;
                VALIDATE("Insured No.", ContBusinessRelation."No.");
                SkipSellToContact := FALSE;
            END;
        END ELSE BEGIN
            IF (("Document Type" = "Document Type"::Quote) OR
                ("Document Type" = "Document Type"::"Insurer Quotes"))

             THEN BEGIN
                Cont.TESTFIELD("Company No.");
                ContComp.GET(Cont."Company No.");
                "Contact Name" := ContComp."Company Name";

                "Insured Address" := ContComp.Address;
                "Insured Address 2" := ContComp."Address 2";

                "Post Code" := ContComp."Post Code";


                IF ("Insure Template Code" = '') AND (NOT CustTemplate.ISEMPTY) THEN
                    VALIDATE("Insure Template Code", Cont.FindCustomerTemplate);
            END ELSE
                ERROR(Text039, Cont."No.", Cont.Name);
        END;

        IF Cont.Type = Cont.Type::Person THEN
            "Contact Name" := Cont.Name
        ELSE
            IF Customer.GET("Insured No.") THEN
                "Contact No." := Customer.Contact
            ELSE
                "Contact No." := '';

        IF (("Document Type" = "Document Type"::Quote) OR
           ("Document Type" = "Document Type"::"Insurer Quotes"))


        THEN BEGIN
            IF Customer.GET("Insured No.") OR Customer.GET(ContBusinessRelation."No.") THEN BEGIN
                IF Customer."Copy Sell-to Addr. to Qte From" = Customer."Copy Sell-to Addr. to Qte From"::Company THEN BEGIN
                    Cont.TESTFIELD("Company No.");
                    Cont.GET(Cont."Company No.");
                END;
            END ELSE BEGIN
                Cont.TESTFIELD("Company No.");
                Cont.GET(Cont."Company No.");
            END;
            "Insured Address" := Cont.Address;
            "Insured Address 2" := Cont."Address 2";


        END;
        IF ("Insured No." = "Insured No.") OR
           ("Insured No." = '')
        THEN
            VALIDATE("Contact No.", "Contact No.");
    end;

    local procedure UpdateBillToCust(ContactNo: Code[20]);
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Template";
        ContComp: Record Contact;
    begin
        /*IF Cont.GET(ContactNo) THEN BEGIN
          "Contact No." := Cont."No.";
          IF Cont.Type = Cont.Type::Sacco THEN
            "Contact No." := Cont.Name
          ELSE
            IF Cust.GET("Insured No.") THEN
              "Contact No." := Cust.Contact
            ELSE
              "Contact No." := '';
        END ELSE BEGIN
          "Contact No." := '';
          EXIT;
        END;
        
        ContBusinessRelation.RESET;
        ContBusinessRelation.SETCURRENTKEY("Link to Table","Contact No.");
        ContBusinessRelation.SETRANGE("Link to Table",ContBusinessRelation."Link to Table"::Customer);
        ContBusinessRelation.SETRANGE("Contact No.",Cont."Company No.");
        IF ContBusinessRelation.FINDFIRST THEN BEGIN
          IF "Insured No." = '' THEN BEGIN
            SkipBillToContact := TRUE;
            VALIDATE("Insured No.",ContBusinessRelation."No.");
            SkipBillToContact := FALSE;
            "Bill-to Customer Template Code" := '';
          END ELSE
            IF "Insured No." <> ContBusinessRelation."No." THEN
              ERROR(Text037,Cont."No.",Cont.Name,"Insured No.");
        END ELSE BEGIN
          IF "Document Type" = "Document Type"::Quote THEN BEGIN
            Cont.TESTFIELD("Company No.");
            ContComp.GET(Cont."Company No.");
            "Bill-to Name" := ContComp."Company Name";
            "Bill-to Name 2" := ContComp."Name 2";
            "Bill-to Address" := ContComp.Address;
            "Bill-to Address 2" := ContComp."Address 2";
            "Bill-to City" := ContComp.City;
            "Bill-to Post Code" := ContComp."Post Code";
            "Bill-to County" := ContComp.County;
            "Bill-to Country/Region Code" := ContComp."Country/Region Code";
            "VAT Registration No." := ContComp."VAT Registration No.";
            VALIDATE("Currency Code",ContComp."Currency Code");
            "Language Code" := ContComp."Language Code";
            IF ("Bill-to Customer Template Code" = '') AND (NOT CustTemplate.ISEMPTY) THEN
              VALIDATE("Bill-to Customer Template Code",Cont.FindCustomerTemplate);
          END ELSE
            ERROR(Text039,Cont."No.",Cont.Name);
        END;
        */

    end;

    procedure LinkSalesDocWithOpportunity(OldOpportunityNo: Code[20]);
    var
        SalesHeader: Record "Insure Header";
        Opportunity: Record Opportunity;
    begin
        IF "Opportunity No." <> OldOpportunityNo THEN BEGIN
            IF "Opportunity No." <> '' THEN
                IF Opportunity.GET("Opportunity No.") THEN BEGIN
                    Opportunity.TESTFIELD(Status, Opportunity.Status::"In Progress");
                    IF Opportunity."Sales Document No." <> '' THEN BEGIN
                        IF CONFIRM(Text048, FALSE, Opportunity."Sales Document No.", Opportunity."No.") THEN BEGIN
                            IF SalesHeader.GET("Document Type"::Quote, Opportunity."Sales Document No.") THEN BEGIN
                                SalesHeader."Opportunity No." := '';
                                SalesHeader.MODIFY;
                            END;
                            UpdateOpportunityLink(Opportunity, Opportunity."Sales Document Type"::Quote, "No.");
                        END ELSE
                            "Opportunity No." := OldOpportunityNo;
                    END ELSE
                        UpdateOpportunityLink(Opportunity, Opportunity."Sales Document Type"::Quote, "No.");
                END;
            IF (OldOpportunityNo <> '') AND Opportunity.GET(OldOpportunityNo) THEN
                UpdateOpportunityLink(Opportunity, Opportunity."Sales Document Type"::" ", '');
        END;
    end;

    local procedure UpdateOpportunityLink(Opportunity: Record Opportunity; SalesDocumentType: Option; SalesHeaderNo: Code[20]);
    begin
        Opportunity."Sales Document Type" := SalesDocumentType;
        Opportunity."Sales Document No." := SalesHeaderNo;
        Opportunity.MODIFY;
    end;

    local procedure newProcedure()
    begin
        //MESSAGE('Inside the procedure=%1', "Insure Template Code");
        TESTFIELD("Insure Template Code");
    end;

    procedure CheckCustomerCreated(Prompt: Boolean): Boolean;
    var
        Cont: Record Contact;
        OnlineProfiles: Record "Online Profiles";
        OnlineAccountTypes: Record "Online AccountTypes";
        ContBusRelation: Record "Contact Business Relation";




    begin
        IF "Insured No." <> '' THEN
            EXIT(TRUE);

        /*IF Prompt THEN
            IF NOT CONFIRM(Text035, TRUE) THEN
                EXIT(FALSE);
                */

        IF "Insured No." = '' THEN BEGIN
            TESTFIELD("Contact No.");
            CustomerTemplate.RESET;
            IF CustomerTemplate.FINDFIRST then
                "Insure Template Code" := CustomerTemplate.Code;
            MODIFY;
            //MESSAGE('Check customer  created ..Insure Template=%1', "Insure Template Code");
            newProcedure();
            Cont.GET("Contact No.");
            ContBusRelation.reset;
            ContBusRelation.Setrange(ContBusRelation."Contact No.", "Contact No.");
            ContBusRelation.setrange(ContBusRelation."Link to Table", ContBusRelation."Link to Table"::Customer);
            IF ContBusRelation.findfirst then begin
                "Insured No." := ContBusRelation."No.";
                MODIFY;
                //message('Insured no=%1', "Insured No.");
            end
            else begin

                Cont.CreateInsured("Insure Template Code");
                COMMIT;

                GET("Document Type", "No.");
            end;
        END;

        IF "Insured No." = '' THEN BEGIN
            TESTFIELD("Insured No.");
            TESTFIELD("Insure Template Code");
            Cont.GET("Contact No.");
            //Cont.CreateInsured("Insure Template Code");
            COMMIT;
            GET("Document Type", "No.");
        END;
        OnlineProfiles.RESET;
        OnlineProfiles.SETRANGE(OnlineProfiles.CustomerID, "Contact No.");
        IF OnlineProfiles.FINDFIRST THEN BEGIN

            OnlineProfiles.CustomerID := "Insured No.";
            OnlineProfiles.MODIFY;
            // MESSAGE('New Customer id=%1',"Insured No.");
        END;
        EXIT(("Insured No." <> '') AND ("Insured No." <> ''));
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnCheckInsurePostRestrictions();
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnCustomerCreditLimitExceeded();
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnCustomerCreditLimitNotExceeded();
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    procedure OnCheckInsureReleaseRestrictions();
    begin
    end;

    procedure CheckAvailableCreditLimit(): Decimal;
    var
        Customer: Record Customer;
        AvailableCreditLimit: Decimal;
    begin
        IF NOT Customer.GET("Bill To Customer No.") THEN
            Customer.GET("Insured No.");

        AvailableCreditLimit := Customer.CalcAvailableCredit;

        IF AvailableCreditLimit < 0 THEN
            OnCustomerCreditLimitExceeded
        ELSE
            OnCustomerCreditLimitNotExceeded;

        EXIT(AvailableCreditLimit);
    end;
}

