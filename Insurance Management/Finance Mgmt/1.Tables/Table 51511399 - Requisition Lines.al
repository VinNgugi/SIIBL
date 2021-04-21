table 51511399 "Requisition Lines"
{
    // version PROC

    /* DrillDownPageID = 51511921;
    LookupPageID = 51511921; */

    fields
    {
        field(1;"Requisition No";Code[22])
        {

            trigger OnValidate()
            begin
               /*  IF ReqHeader.GET("Requisition No") THEN BEGIN
                 "Procurement Plan":=ReqHeader."Procurement Plan";
                 "Global Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
                 "Global Dimension 2 Code":=ReqHeader."Global Dimension 2 Code";
                 "ShortCut Dimension 3 Code":=ReqHeader."Global Dimension 3 Code";
                 END; */
            end;
        }
        field(2;"Line No";Integer)
        {
            AutoIncrement = true;

            trigger OnValidate()
            begin
               /*  IF ReqHeader.GET("Requisition No") THEN
                BEGIN
                 "Procurement Plan":=ReqHeader."Procurement Plan";
                 "Global Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
                 "Global Dimension 2 Code":=ReqHeader."Global Dimension 2 Code";
                 "ShortCut Dimension 3 Code":=ReqHeader."Global Dimension 3 Code";
                 "Asset Disposal":=ReqHeader."Asset Disposal";
                END; */
            end;
        }
        field(3;Type;Option)
        {
            Editable = false;
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item),Non Stock Item,Category';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)","Non Stock Item",Category;
        }
        field(4;No;Code[10])
        {
            Editable = false;
            /* TableRelation = IF (Type=CONST("Non Stock Item")) "G/L Account"."No." WHERE ("No."=FILTER(1000101..6000699),
                                                                                     "Account Type"=CONST(Posting))
                                                                                     ELSE IF (Type=CONST(Item)) Item."No." WHERE ("Inventory Posting Group"=FILTER(<>' '),
                                                                                                                                Blocked=CONST(false))
                                                                                                                                ELSE IF (Type=CONST("G/L Account")) "G/L Account"."No." WHERE ("No."=FILTER(1000101..6000699),
                                                                                                                                                                                           "Account Type"=CONST(Posting))
                                                                                                                                                                                           ELSE IF (Type=FILTER("Fixed Asset"),
                                                                                                                                                                                                    "Asset Disposal"=FILTER(false)) "Fixed Asset"."No."
                                                                                                                                                                                                    ELSE IF ("Asset Disposal"=FILTER(Yes),
                                                                                                                                                                                                             Type=FILTER("Fixed Asset")) "Maintenance Lines"."Asset No" WHERE ("Batch No"=FIELD("Batch No")); */

            trigger OnValidate()
            begin
                 /* IF Type=Type::Item THEN
                 BEGIN
                 IF ItemRec.GET(No) THEN
                 BEGIN
                   Description:=ItemRec.Description;
                   "Unit of Measure":=ItemRec."Base Unit of Measure";
                   ItemRec.CALCFIELDS(ItemRec.Inventory);
                   "Quantity in Store":=ItemRec.Inventory;
                   IF xRec."Unit Price" = 0 THEN BEGIN
                   "Unit Price":=ItemRec."Unit Cost";
                     END;
                     END;
                  END;

                 IF Type=Type::"Fixed Asset" THEN
                 BEGIN
                 IF FixedAsset.GET(No) THEN
                 BEGIN
                   Description:=FixedAsset.Description;
                 END;
                 END;

                 glAccountNo:=Factory.FnGetAccountToCommit(Type,No);
                "Budget G/L Account":=glAccountNo;
                "Approved Budget Amount":=Factory.FnGetBudgetedAmount(glAccountNo,"Current Budget",'','');
                "Actual Expense":=Factory.FnGetTotalExpenditure(glAccountNo,"Current Budget",'','');
                "Commitment Amount":=Factory.FnGetCommittedAmount(glAccountNo,"Current Budget",'','');
                "Reserved Amount":=Factory.FnGetReservedAmount(glAccountNo,"Current Budget",'','');
                "Available amount":="Approved Budget Amount"-("Actual Expense"+"Reserved Amount"+"Commitment Amount");
                IF "Available amount" < 0 THEN
                "Available amount":=0; */
                //MESSAGE('GLAccount %1 Budgeted Amount%2 ActualExpense%3 Committedamount%4 AvailablAmount%5 Reserved AMount%6',"Budget G/L Account","Approved Budget Amount","Actual Expense","Commitment Amount","Available amount","Reserved Amou
            end;
        }
        field(5;Description;Text[250])
        {
        }
        field(6;Quantity;Decimal)
        {

            trigger OnValidate()
            begin
                /*  Amount:=Quantity*"Unit Price";
                 IF ReqHeader.GET("Requisition No") THEN BEGIN
                  IF ReqHeader.Status<>ReqHeader.Status::Open THEN
                  ERROR('You cannot Modify Quantity at this stage');
                  END;


                 IF ReqHeader.GET("Requisition No") THEN BEGIN
                IF ReqHeader."Requisition Type"=ReqHeader."Requisition Type"::"Store Requisition" THEN BEGIN
                           IF Type=Type::Item THEN BEGIN
                               IF ItemRec.GET(No) THEN BEGIN
                                Description:=ItemRec.Description;
                                ItemRec.CALCFIELDS(ItemRec.Inventory);
                                "Quantity in Store":=ItemRec.Inventory;
                               END;
                           END;
                           "Quantity Approved":=Quantity;


                           IF "Quantity in Store"<Quantity THEN
                             MESSAGE ('Quantity in store of %1 of Stock Item %2 is less than that requisitioned of %3',"Quantity in Store",Description,Quantity);
                END;

                END; */

                /* CALCFIELDS("Requisition Type2");
                IF "Requisition Type2"="Requisition Type2"::"Store Requisition" THEN BEGIN 
                      IF Type=Type::Item THEN BEGIN
                               IF ItemRec.GET(No) THEN BEGIN
                                       IF (("Quantity in Store"-Quantity)<(ItemRec."Minimum Stock Level")) THEN BEGIN
                                           MESSAGE('The Requested Quantity will Reduce the Quantity Available Beyond the Irriducible Minimum Balance.You may not be issued with the all the items requested until the items are replenished!');
                                       END; 
                               END;
                       END;*/
                //END;

                /* ReqHeader.RESET;
                 IF ReqHeader.GET("Requisition No") THEN BEGIN
                  "Requisition Date":=ReqHeader."Requisition Date";
                  "Requisition Type":=ReqHeader."Requisition Type";
                  "Asset Disposal":="Asset Disposal";
                 END; 

                  VALIDATE(No);*/
            end;
        }
        field(7;"Unit of Measure";Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(8;"Unit Price";Decimal)
        {

            trigger OnValidate()
            begin
                  IF Quantity <= 0 THEN
                  ERROR('Please enter the quantity first');

                  Amount:=Quantity*"Unit Price";
                 // IF ReqHeader.GET("Requisition No") THEN BEGIN
                 // IF ReqHeader.Status<>ReqHeader.Status::Open THEN
                  ERROR('You cannot Modify the Unit Price at this stage');
                  //END;

                  IF FnCheckBudgetAvailability = FALSE THEN
                     ERROR('Total Amounts of Lines Exceeeds the Avalaible Amount For Procurement Item No: %1!',"Procurement Plan Item");
            end;
        }
        field(9;Amount;Decimal)
        {
            Editable = false;

            trigger OnValidate()
            begin
                  Reqlines1.RESET;
                  Reqlines1.SETFILTER(Reqlines1."Requisition No","Requisition No");
                  Reqlines1.SETFILTER("Procurement Plan",'%1',"Procurement Plan");
                  Reqlines1.SETFILTER("Procurement Plan Item",'%1',"Procurement Plan Item");
                  IF Reqlines1.FINDSET THEN
                    REPEAT
                     linesamount:=linesamount+Reqlines1.Amount;
                    UNTIL Reqlines1.NEXT=0;
                 IF linesamount > "Available amount" THEN
                   BEGIN
                    ERROR('Total Amounts of Lines Exceeeds the Avalaible Amount For Procurement Item No: %1!',"Procurement Plan Item");
                     END;
                // VALIDATE(No);
                // VALIDATE("Unit Price");
            end;
        }
        field(10;"Procurement Plan";Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(11;"Procurement Plan Item";Integer)
        {
            /* TableRelation = "Procurement Plan"."Plan Item No" WHERE ("Plan Year"=FIELD("Procurement Plan"),
                                                                     "Board Approved"=CONST(Yes),
                                                                     "Global Dimension 1 Code"=FIELD("Global Dimension 1 Code")); */

            trigger OnValidate()
            begin
/* 
                 IF ProcurementPlan.GET("Procurement Plan","Global Dimension 1 Code","Procurement Plan Item") THEN
                       BEGIN
                     IF ProcurementPlan."Procurement Type"=ProcurementPlan."Procurement Type"::Goods THEN
                       BEGIN
                       Type:=Type::Item;
                       No:=ProcurementPlan."No.";

                        END;
                 IF ProcurementPlan."Procurement Type"<>ProcurementPlan."Procurement Type"::Goods THEN
                     BEGIN
                      Type:=Type::"G/L Account";
                      No:=ProcurementPlan."Source of Funds";
 */
                      //END;
                //    "Budget Line":=ProcurementPlan."Source of Funds";
                //     Description:=ProcurementPlan."Item Description";
                //     "Global Dimension 2 Code":=ProcurementPlan."Global Dimension 2 Code";
                //     "ShortCut Dimension 3 Code":=ProcurementPlan."Shortcut Dimension 3 Code";
                //    "Unit of Measure":=ProcurementPlan."Unit of Measure";
                //    "Unit Price":=ProcurementPlan."Unit Price";
                    //ProcurementPlan.CALCFIELDS("Committed Amount","Actual Spent");
                    //"Budget G/L Account":=ProcurementPlan."Source of Funds";
                    //"Procurement Method":=ProcurementPlan."Procurement Method";
                    //"Commitment Amount":=ProcurementPlan."Committed Amount";
                    //"Available amount":=ProcurementPlan."Estimated Cost"-"Commitment Amount";
                   //END;
                  // VALIDATE(No);

            end;
        }
        field(12;"Budget Line";Code[10])
        {
        }
        field(13;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Department';
            Editable = true;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(14;"Amount LCY";Decimal)
        {
        }
        field(15;Select;Boolean)
        {

            trigger OnValidate()
            begin
                //Check that not more than one request is selected
                RequsitionLines.RESET;
                //RequsitionLines.SETRANGE("Assigned User",USERID);
                RequsitionLines.SETRANGE(Select,TRUE);
                RequsitionLines.SETRANGE(Created,FALSE);
                RequsitionLines.SETRANGE("Procurement Ordered",FALSE);
                IF RequsitionLines.FIND('-') THEN BEGIN
                  REPEAT
                    IF RequsitionLines."Requisition No"<>Rec."Requisition No" THEN
                      ERROR('You cannot select from two different requisitions');
                    UNTIL RequsitionLines.NEXT=0;
                  END;
            end;
        }
        field(16;"Request Generated";Boolean)
        {
        }
        field(17;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(22;"Process Type";Option)
        {
            OptionMembers = " ",Direct,RFQ,RFP,Tender;

            trigger OnValidate()
            begin
                IF "Process Type"="Process Type"::Direct THEN BEGIN
                  MESSAGE('Please Note that you will be required to attach justification Memo before an LPO can be generated with Direct Procurement');
                END;
            end;
        }
        field(23;"Quantity Approved";Decimal)
        {
            Editable = true;
        }
        field(24;"Quantity in Store";Decimal)
        {
            Editable = false;
        }
        field(25;"Approved Budget Amount";Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(26;"Commitment Amount";Decimal)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(27;"Actual Expense";Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE ("G/L Account No."=FIELD("Budget Line")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(28;"Available amount";Decimal)
        {
            Editable = false;
        }
        field(29;"Requisition Status";Option)
        {
            OptionMembers = " ",Approved,Rejected;
        }
        field(30;"Requisition Date";Date)
        {
        }
        field(31;"Requisition Type";Option)
        {
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Purchase Requisition,Store Requisition,Imprest,Claim-Accounting,Appointment,Payment Voucher,Asset Disposal';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Purchase Requisition","Store Requisition",Imprest,"Claim-Accounting",Appointment,"Payment Voucher","Asset Disposal";
        }
        field(32;"Location Code";Code[100])
        {
            TableRelation = Location;
        }
        field(33;"Issued Quantity";Decimal)
        {

            trigger OnValidate()
            begin
                IF "Issued Quantity" > "Quantity in Store" THEN
                  ERROR(Txt0003,"Quantity in Store","Issued Quantity");

                IF "Issued Quantity" < 0 THEN
                  ERROR(Txt0004,"Quantity in Store","Issued Quantity");
            end;
        }
        field(34;"Activity Type";Option)
        {
            OptionCaption = ',WorkPlan,Admin & PE,Proc Plan';
            OptionMembers = ,WorkPlan,"Admin & PE","Proc Plan";

            trigger OnValidate()
            begin
                  /* IF ReqHeader.GET("Requisition No") THEN
                    BEGIN
                      IF ReqHeader.Status<>ReqHeader.Status::Open THEN
                      ERROR('You cannot Modify the Activity Type at this stage');
                    END; */
            end;
        }
        field(35;"Current Budget";Code[100])
        {
            TableRelation = "G/L Budget Name";
        }
        field(36;Activity;Code[20])
        {

            trigger OnValidate()
            begin
                  /* IF ReqHeader.GET("Requisition No") THEN
                    BEGIN
                      IF ReqHeader.Status <> ReqHeader.Status::Open THEN
                      ERROR('You cannot Modify the Activity at this stage');
                    END; */
                
                GLSetup.GET;
                
                CASE "Activity Type" OF
                 "Activity Type"::WorkPlan:
                  BEGIN
                  /* WorkPlan.RESET;
                  WorkPlan.SETRANGE(Code,Activity);
                  WorkPlan.SETFILTER("Budget Filter",GLSetup."Current Budget");
                  IF WorkPlan.FIND('+') THEN
                    BEGIN
                    "Procurement Type":="Procurement Type"::" ";
                     Activity:=WorkPlan.Code;
                     Type:=Type::"3";
                     No:=WorkPlan."G/L Account";
                     VALIDATE(No);
                     //Description:=WorkPlan.Name;
                    //"Global Dimension 1 Code":=WorkPlan."Global Dimension 1 Code";
                    //"Global Dimension 2 Code":=WorkPlan."Global Dimension 2 Code";
                    "Available amount":=WorkPlan.Amount; */
                   END;
                  END;
                  //"Activity Type"::"Admin & PE":
                   BEGIN
                
                   /* AdminPlan.RESET;
                   AdminPlan.SETRANGE("PE Activity Code",Activity);
                   AdminPlan.SETFILTER("Budget Filter",GLSetup."Current Budget");
                   IF AdminPlan.FIND('+') THEN
                     BEGIN
                        Activity:=AdminPlan."PE Activity Code";
                        "Procurement Type":="Procurement Type"::" ";
                        Type:=Type::"3";
                        No:=AdminPlan."G/L Account";
                        VALIDATE(No);
                         //Description:=AdminPlan.Name;
                        //"Global Dimension 1 Code":=AdminPlan."Global Dimension 1 Code";
                        //"Global Dimension 2 Code":=AdminPlan."Global Dimension 2 Code";
                        "Available amount":=AdminPlan.Amount;
                     END; */
                   END;
                  //"Activity Type"::"Proc Plan":
                
                   BEGIN
                    /*
                   ProcurementPlan.RESET;
                   ProcurementPlan.SETRANGE("Plan Item No",Activity);
                   //ProcurementPlan.SETRANGE(Type,"Procurement Type"); //Add Department Filter
                   ProcurementPlan.SETFILTER("Budget Filter",GLSetup."Current Budget");
                   IF ProcurementPlan.FIND('+') THEN BEGIN
                    "Procurement Type":=ProcurementPlan.Type;;
                   // Type:=ProcurementPlan.Type;
                    Activity:=ProcurementPlan."Plan Item No";
                    No:=ProcurementPlan."No.";
                    VALIDATE(No);
                     Description:=ProcurementPlan."Item Description";
                     //"Commitment Amount":=;
                     "Unit Price":=ProcurementPlan."Unit Price";
                    //"Global Dimension 1 Code":=ProcurementPlan."Global Dimension 1 Code";
                    //"Global Dimension 2 Code":=ProcurementPlan."Global Dimension 2 Code";
                    "Available amount":=ProcurementPlan."Estimated Cost";
                
                   END;
                   */
                
                   END;
                
                 //END;

            end;
        }
        field(37;Committed;Boolean)
        {
        }
        field(38;"Procurement Type";Option)
        {
            OptionCaption = ' ,G/L Account,Item,,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,,"Fixed Asset","Charge (Item)";
        }
        field(39;"PE Allowed";Boolean)
        {
        }
        field(50000;"Process Type2";Option)
        {
            OptionMembers = " ",Direct,RFQ,RFP,Tender,"Low Value ";
        }
        /*field(50001;"Attached LPO";Code[20])
         {
            CalcFormula = Lookup("Purchase Header"."No." WHERE ("Requisition No"=FIELD("Requisition No")));
            FieldClass = FlowField;
        } 
        field(50002;"Attached LPO Status";Option)
        {
            CalcFormula = Lookup("Purchase Header".Status WHERE ("No."=FIELD("Attached LPO")));
            FieldClass = FlowField;
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Held,Issued,Received,Closed,Cancelled,Archived;
        }*/
        field(50003;"LPO Generated";Boolean)
        {
        }
        field(50004;"Does not require TOR";Boolean)
        {
        }
        field(50005;"Item Receipt Batch";Integer)
        {
            TableRelation = "Commitment Entries" WHERE ("Procurement Plan"=FIELD(No),
                                                        "Remaining Quanity"=FILTER(>0),
                                                        Amount=FILTER(>0));

            trigger OnValidate()
            var
                commitrec: Record 51511014;
            begin
                // commitrec.RESET;
                // IF commitrec.GET("Item Receipt Batch") THEN BEGIN
                //   IF Quantity>commitrec.Quantity THEN BEGIN
                //      //ERROR('The Quantity you Put is More than Available Amount for that batch!!!');
                //   END;
                //   "Quantity Approved":=commitrec."Remaining Quanity";
                //   //Quantity:=commitrec.Quantity;
                //   "Quanitity in Batch":=commitrec."Remaining Quanity";
                //   "Unit Price":=commitrec."Unit Cost";
                // END;
            end;
        }
        field(50006;"Quanitity in Batch";Integer)
        {
        }
        field(50007;"Source of Funds";Code[20])
        {
            TableRelation = "G/L Account"."No." WHERE (Blocked=CONST(false));
        }
        field(50008;Ordered;Boolean)
        {
        }
        /*field(50009;"Requisition Type2";Option)
        {
            CalcFormula = Lookup("Requisition Header"."Requisition Type" WHERE ("No."=FIELD("Requisition No")));
            FieldClass = FlowField;
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,None,Purchase Requisition,Store Requisition,Imprest,Claim-Accounting,Appointment,Payment Voucher';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Purchase Requisition","Store Requisition",Imprest,"Claim-Accounting",Appointment,"Payment Voucher";
        } */
        field(50010;"Procurement Ordered";Boolean)
        {
        }
        field(50011;"Procurement Plan Item2";Integer)
        {
            /* TableRelation = 51511301.Field2 WHERE (Field1=FIELD("Procurement Plan"),
                                                        Field17=FIELD("Global Dimension 1 Code")); 
        }
        field(50012;procplanItm;Code[20])
        {
            TableRelation = 51511301.Field1 WHERE (Field1=FIELD("Procurement Plan"),
                                                        Field50038=FIELD("Global Dimension 1 Code"));*/
        }
        /* field(50013;"Assigned User";Code[50])
        {
            CalcFormula = Lookup("Requisition Header"."Assigned User ID" WHERE ("No."=FIELD("Requisition No")));
            FieldClass = FlowField;
            TableRelation = "User Setup";
        } */
        field(50014;"LPO Generated No";Code[40])
        {
            TableRelation = "Purchase Header"."No.";
        }
        field(50015;"Reserved Amount";Decimal)
        {
            FieldClass = Normal;
        }
        field(50030;"Budget G/L Account";Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account";
        }
        field(50031;Category;Code[20])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Supplier Category";

            trigger OnValidate()
            begin
               /*  IF SupplierCategory.GET(Category) THEN
                  BEGIN
                    "Category Name":=SupplierCategory.Description;
                  END; */
            end;
        }
        field(50032;"Category Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50033;StartDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50034;Duration;DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                EndDate:=CALCDATE(Duration,StartDate);
            end;
        }
        field(50035;EndDate;Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50036;Status;Option)
        {
            //CalcFormula = Lookup("Requisition Header".Status WHERE ("No."=FIELD("Requisition No")));
            Caption = 'Status';
            Editable = true;
            FieldClass = FlowField;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment,Rejected';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment",Rejected,Archived;
        }
        field(50037;"Date Of Assignment";Date)
        {
            //CalcFormula = Lookup("Requisition Header"."Date of Assignment" WHERE ("No."=FIELD("Requisition No")));
            FieldClass = FlowField;
        }
        field(50038;"ShortCut Dimension 3 Code";Code[20])
        {
            Caption = 'Sub Cartegory';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(3));
        }
        field(50039;"Prequalification File Name";Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50040;Created;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50041;Planned;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50042;Balance;Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50043;"Category Created";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50044;EOI;Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50045;"Asset Disposal";Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50046;"Book Value";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50047;"Reserved Price";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50048;"Acquisition Date";Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50049;"Acquisition Cost";Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50050;"Batch No";Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50051;"Serial No.";Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50052;"Procurement Method";Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Procurement Methods".Code;
        }
    }

    keys
    {
        key(Key1;"Requisition No",Category,"Line No")
        {
        }
        key(Key2;"Procurement Plan")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Requisition No")
        {
        }
    }

    trigger OnDelete()
    begin
        /* IF ReqHeader.GET("Requisition No") THEN BEGIN
        IF ReqHeader.Status<>ReqHeader.Status::Open THEN
        ERROR('You cannot delete the requisition lines at this stage'); 
        END;*/
    end;

    trigger OnInsert()
    begin
        /* GLSetup.GET;
        "Current Budget":=GLSetup."Current Budget";
        IF ReqHeader.GET("Requisition No") THEN BEGIN
         "Procurement Plan":=ReqHeader."Procurement Plan";
         "Global Dimension 1 Code":=ReqHeader."Global Dimension 1 Code";
         "Global Dimension 2 Code":=ReqHeader."Global Dimension 2 Code";
         "ShortCut Dimension 3 Code":=ReqHeader."Global Dimension 3 Code";
         "Asset Disposal":=ReqHeader."Asset Disposal";
         "Requisition Type":=ReqHeader."Requisition Type"
         END;

        IF ReqHeader.Status<>ReqHeader.Status::Open THEN
        ERROR('You cannot add more lines at this stage'); */
    end;

    var
        //ReqHeader: Record 51511398;
        //ProcurementPlan: Record 51511391;
        ItemRec: Record 27;
        RequsitionLines: Record 51511399;
        Mail: Codeunit 397;
        "Employee Name": Text[30];
        CompInfo: Record 79;
        GLAccount: Record 15;
        Text000: Label 'The Purchases & Payables Setup doesnt exist';
        Text001: Label 'Generating a Purchase Requisition based on the store requisition';
        Text002: Label 'Quantity in store of %1 of Stock Item %2 is less than that requisitioned of %3';
       // AdminPlan: Record 51511390;
        //WorkPlan: Record 51511205;
        GLSetup: Record 51511018;
        TravelRates: Record 51511017;
        RequestHeader: Record 51511003;
        BudgetEntry: Record 96;
        GLEntry: Record 17;
        Committment: Decimal;
        BudgetAmount: Decimal;
        Balance: Decimal;
        CustLedger: Record 21;
        TransactionTypeRec: Record 51511015;
        ReceiptsHeader: Record 51511027;
        RequestLines: Record 51511004;
        TotalActual: Decimal;
        TotalAmount: Decimal;
        Expenses: Decimal;
        BudgetAvailable: Decimal;
        Committments: Record 51511014;
        CommittedAmount: Decimal;
        CommitmentEntries: Record 51511014;
        //ImprestHeader: Record 51511398;
        TotalCommittedAmount: Decimal;
        CashMngt: Record 51511018;
        TempPEApp: Record 51511020;
        SETUPREC: Record 312;
        Reqlines1: Record 51511399;
        linesamount: Decimal;
        //Reqheader1: Record 51511398;
        glAccountNo: Code[20];
        Factory: Codeunit 51511015;
        //SupplierCategory: Record 51511394;
        Txt0003: Label 'You cannot issue more than quantity in store.\\ Quantity in store is %1 and quantity requisitioned is %2.';
        Txt0004: Label 'You cannot issue quantities less than 0';
        FixedAsset: Record 5600;

    procedure GeneratePR()
    var
        //PRHeader: Record 51511398;
        PRLines: Record 51511399;
        NoSeriesMgt: Codeunit 396;
        PPSetup: Record 312;
        UsersRec: Record 91;
        Emp: Record 5200;
        window: Dialog;
    begin
        window.OPEN(Text001);
        IF NOT PPSetup.GET THEN
         ERROR(Text000);
        //PPSetup.TESTFIELD("Purchase Req No");
        //PRHeader.INIT;
        //PRHeader."RequisiUSERIDtion Type":=PRHeader."Requisition Type"::"Purchase Requisition";
        //PRHeader."No.":=NoSeriesMgt.GetNextNo(PPSetup."Purchase Req No",TODAY,TRUE);
        IF UsersRec.GET() THEN
        BEGIN
        IF Emp.GET(UsersRec."Employee No.") THEN
        BEGIN
        // PRHeader."Employee Code":=Emp."No.";
        // PRHeader."Employee Name":=Emp."First Name"+' '+Emp."Last Name";
        // PRHeader."Global Dimension 1 Code":=Emp."Global Dimension 1 Code";
        // PRHeader."Global Dimension 2 Code":=Emp."Global Dimension 2 Code";
        END;
        END;
        /* PRHeader."Procurement Plan":=PPSetup."Effective Procurement Plan";
        PRHeader."Requisition Date":=TODAY;
        PRHeader."Raised by":=USERID;

        IF NOT PRHeader.GET(PRHeader."No.") THEN
         PRHeader.INSERT;
        window.CLOSE; */
        PAGE.RUN(51511171);
    end;

    local procedure FnCheckBudgetAvailability(): Boolean
    begin
        linesamount:=0;
        SETUPREC.RESET;
        SETUPREC.GET;
        Reqlines1.RESET;
        Reqlines1.SETFILTER(Reqlines1."Requisition No","Requisition No");
        Reqlines1.SETFILTER(Reqlines1."Procurement Plan",'%1',"Procurement Plan");
        Reqlines1.SETFILTER(Reqlines1."Procurement Plan Item",'%1',"Procurement Plan Item");
        IF Reqlines1.FINDSET THEN
         REPEAT
           linesamount:=linesamount+Reqlines1.Amount;
         UNTIL Reqlines1.NEXT=0;

        IF linesamount > "Available amount" THEN BEGIN
          Rec."Unit Price":=0;
          Rec.Amount:=0;
          Rec.MODIFY;
          COMMIT;
        EXIT(FALSE);
        END;
        EXIT(TRUE);
          //=========================================================================
    end;
}

