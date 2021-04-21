table 51513179 "Payment Instalment Plan"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement,Posted Debit Note,Posted Credit Note,Treaty,Claim Invoice,Post Dated Cheque,Amicable Settlements"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement,"Posted Debit Note","Posted Credit Note",Treaty,"Claim Invoice","Post dated Cheque","Amicable Settlements";
        }
        field(2; "Document No."; Code[30])
        {
        }
        field(3; "Payment No"; Integer)
        {
            NotBlank = true;
        }
        field(4; "Due Date"; Date)
        {
        }
        field(5; "Amount Due"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(6; "Amount Paid"; Decimal)
        {
        }
        field(7; Paid; Boolean)
        {

            trigger OnValidate();
            begin
                /*IF xRec.Paid THEN
                ERROR('This Instalment has already been paid');


                 IF Paid THEN
                 BEGIN
                 IF PolicyRec.GET("Document Type","Document No.") THEN
                 BEGIN
                  //Create a payment Transaction
                    GenJnline.INIT;
                    GenJnline."Journal Template Name":='GENERAL';
                    GenJnline."Journal Batch Name":='DEFAULT';

                    GenJnlineCopy.RESET;
                    GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name",GenJnline."Journal Template Name");
                    GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name",GenJnline."Journal Batch Name");
                    IF GenJnlineCopy.FIND('+') THEN
                    LineNo:=GenJnlineCopy."Line No.";


                    GenJnline."Line No.":=LineNo+10000;
                    GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
                    GenJnline."Account No.":=PolicyRec."Agent/Broker";
                    GenJnline."Posting Date":="Due Date";
                    GenJnline."Document No.":=FORMAT("Payment No");
                    GenJnline.Description:='Premium Payment';
                    GenJnline.Amount:=ROUND("Amount Due");
                    GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::Customer;
                    GenJnline."Bal. Account No.":=PolicyRec."Sell-to Customer No.";
                    GenJnline.INSERT;

                    //PostGnjnline.RUN(GenJnline);

                  //Create Commissions Cr-Commissios Received account
                   //Dr-Underwriter
                   InSetup.GET;
                    GenJnline.INIT;
                    GenJnline."Journal Template Name":='GENERAL';
                    GenJnline."Journal Batch Name":='COMMISS';
                    GenJnlineCopy.RESET;
                    GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name",GenJnline."Journal Template Name");
                    GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name",GenJnline."Journal Batch Name");
                    IF GenJnlineCopy.FIND('+') THEN
                    LineNo:=GenJnlineCopy."Line No.";


                    GenJnline."Line No.":=LineNo+10000;
                    GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
                    GenJnline."Account No.":=PolicyRec."Agent/Broker";
                    GenJnline."Posting Date":="Due Date";
                    GenJnline."Document No.":=FORMAT("Payment No");
                    GenJnline.Description:='Commission Received';
                    GenJnline.Amount:=ROUND("Amount Due"*(PolicyRec."Commission Due"/100));
                    //GenJnline."Document Type":=GenJnline."Document Type"::Payment;
                    GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
                    GenJnline."Bal. Account No.":=InSetup."Commission Received";
                    GenJnline.INSERT;
                    PostGnjnline.RUN(GenJnline);


                  //Create Commissions payable
                 // Dr-Broker
                 // Cr-Commission Payable Acc
                    GenJnline.INIT;
                    GenJnline."Journal Template Name":='GENERAL';
                    GenJnline."Journal Batch Name":='BROKER';
                    GenJnlineCopy.RESET;
                    GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Template Name",GenJnline."Journal Template Name");
                    GenJnlineCopy.SETRANGE(GenJnlineCopy."Journal Batch Name",GenJnline."Journal Batch Name");
                    IF GenJnlineCopy.FIND('+') THEN
                    LineNo:=GenJnlineCopy."Line No.";


                    GenJnline."Line No.":=LineNo+10000;
                    GenJnline."Account Type":=GenJnline."Account Type"::Vendor;
                    GenJnline."Account No.":=PolicyRec."Agent/Broker";
                    GenJnline."Posting Date":="Due Date";
                    GenJnline."Document No.":=FORMAT("Payment No");
                    GenJnline.Description:='Commission Received';
                    GenJnline.Amount:=-ROUND("Amount Due"*(PolicyRec."Commission Payable 1"/100));
                    //GenJnline."Document Type":=GenJnline."Document Type"::Payment;
                    GenJnline."Bal. Account Type":=GenJnline."Bal. Account Type"::"G/L Account";
                    GenJnline."Bal. Account No.":=InSetup."Commission Payable";
                    GenJnline.INSERT;
                    PostGnjnline.RUN(GenJnline);


                 END;



                 END; */

            end;
        }
        field(8; "Account No."; Code[20])
        {
            TableRelation = Customer;
        }
        field(9; "Cheque No."; Code[20])
        {
        }
        field(10; "Instalment Percentage"; Decimal)
        {
        }
        field(11; "Period Length"; DateFormula)
        {
        }
        field(12; "Cover Start Date"; Date)
        {
        }
        field(13; "Cover End Date"; Date)
        {
        }
        field(14; Manual; Boolean)
        {
        }
        field(16; "Cheque Date"; Date)
        {
        }
        field(17; "Drawer/Payee Name"; Text[30])
        {
        }
        field(18; "Drawer/Payee Account No."; Code[20])
        {
        }
        field(19; "Bank Code"; Code[10])
        {
            //TableRelation = "Employee Bank AccountX1".Code;
        }
        field(20; "Insured No."; Code[20])
        {

        }
        field(21; "Insured Name"; Text[250])
        {

        }
        field(22; "Underwriter Code"; Code[20])
        {

        }
        field(23; "Underwriter Name"; Text[200])
        {

        }
        field(24;"Instalment Type";enum InstalmentType)
        {

        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Payment No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        //PolicyRec : Record "Policy Type";
        GenJnline: Record "Gen. Journal Line";
        GenJnlineCopy: Record "Gen. Journal Line";
        LineNo: Integer;
}

