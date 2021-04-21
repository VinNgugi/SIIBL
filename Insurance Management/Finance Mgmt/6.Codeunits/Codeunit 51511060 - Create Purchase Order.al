codeunit 51511060 "Create Purchase Order"
{
    // version FINANCE


    trigger OnRun()
    begin
    end;

    var
        Purch: Record 38;
        PurchLines: Record 39;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PurchSetup: Record 312;
        LineNo: Integer;

    /*procedure CreatePOFramework(Contract: Record 51511404)
    var
        FrameLines: Record 51511449;
    begin
        FrameLines.RESET;
        FrameLines.SETRANGE(Contract, Contract.Code);
        FrameLines.SETFILTER("Quantity To Order", '<>%1', 0);
        IF FrameLines.FIND('-') THEN BEGIN
            PurchSetup.GET;
            Purch.INIT;
            Purch."Document Type" := Purch."Document Type"::Order;
            Purch."No." := NoSeriesMgt.GetNextNo(PurchSetup."Order Nos.", TODAY, TRUE);
            Purch."Buy-from Vendor No." := Contract.Supplier;
            Purch.VALIDATE("Buy-from Vendor No.");
            Purch."Document Date" := TODAY;
            Purch."Contract No" := Contract.Code;
            Purch.INSERT;
            LineNo := 10000;
            REPEAT
                PurchLines.INIT;
                PurchLines."Document No." := Purch."No.";
                PurchLines."Document Type" := PurchLines."Document Type"::Order;
                PurchLines."Line No." := LineNo;
                PurchLines.Type := FrameLines.Type;
                PurchLines."No." := FrameLines.No;
                PurchLines.VALIDATE(Type);
                PurchLines.VALIDATE("No.");
                PurchLines.Quantity := FrameLines."Quantity To Order";
                PurchLines.VALIDATE(Quantity);
                PurchLines."Direct Unit Cost" := FrameLines."Unit Price";
                PurchLines.VALIDATE("Direct Unit Cost");
                IF PurchLines.INSERT THEN BEGIN
                    FrameLines."Quantity To Order" := 0;
                    FrameLines.MODIFY;
                    LineNo := LineNo + 1000;
                END;

            UNTIL FrameLines.NEXT = 0;
            PAGE.RUN(50, Purch);
        END;
    end;*/

    procedure CreatePORequisition(ReqNo: Code[10])
    var
        ReqHeader: Record 51511398;
        ReqLines: Record 51511399;
        conf: Boolean;
    begin
        conf := CONFIRM('Are you sure you want to create LPO from the selected line?');
        IF FORMAT(conf) = 'Yes' THEN BEGIN
            ReqLines.RESET;
            ReqLines.SETRANGE("Request Generated", FALSE);
            //ReqLines.SETRANGE("Assigned User", USERID);
            ReqLines.SETRANGE("Procurement Ordered", FALSE);
            ReqLines.SETRANGE(Select, TRUE);
            IF ReqLines.FIND('-') THEN BEGIN

                ReqHeader.RESET;
                ReqHeader.GET(ReqLines."Requisition No");
                //IF ReqHeader."Assigned User ID" <> USERID THEN BEGIN
                // ERROR('Only user ' + ReqHeader."Assigned User ID" + 'can perform this Task.');
                //END;
                PurchSetup.GET;
                Purch.INIT;
                Purch."Document Type" := Purch."Document Type"::Order;
                Purch."No." := NoSeriesMgt.GetNextNo(PurchSetup."Order Nos.", TODAY, TRUE);
                //Purch."Buy-from Vendor No.":=Contract.Supplier;
                //Purch.VALIDATE("Buy-from Vendor No.");
                Purch."Document Date" := TODAY;
                //Purch."Requisition No" := ReqLines."Requisition No";
                Purch.INSERT;

                REPEAT
                    ReqLines."Request Generated" := TRUE;
                    ReqLines."Procurement Ordered" := TRUE;
                    ReqLines.MODIFY;
                UNTIL ReqLines.NEXT = 0;
                PAGE.RUN(50, Purch);
            END;
        END;
    end;
}

