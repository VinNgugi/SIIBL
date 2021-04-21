table 51513124 "Claims Cue"
{
    // version AES-INS 1.0

    Caption = 'Sales Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "No. Of Claims"; Integer)
        {
            CalcFormula = Count(Claim);
            Caption = 'No. Of Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "No. Of Rejected Claims"; Integer)
        {
            CalcFormula = Count(Claim);
            Caption = 'Claims Rejected';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Total Reserves"; Integer)
        {
            CalcFormula = Count("G/L Entry" WHERE("Insurance Trans Type" = CONST("Claim Reserve")));
            Caption = 'Total Reserves';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Total Claims Outstanding"; Decimal)
        {
            Caption = 'Claims Outstanding';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Total Paid"; Decimal)
        {
            CalcFormula = Sum("G/L Entry".Amount WHERE("Insurance Trans Type" = CONST("Claim Payment")));
            Caption = 'Sales Return Orders - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "No. of Closed Claims"; Integer)
        {
            CalcFormula = Count(Claim WHERE("Claim Status" = CONST(Closed)));
            Caption = 'Closed Claims';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Reinsurance Share"; Integer)
        {
            AccessByPermission = TableData 110 = R;
            CalcFormula = Count("Sales Header" WHERE("Document Type" = FILTER(Order),
                                                      Status = FILTER(Released),
                                                      Ship = FILTER(true),
                                                      "Completely Shipped" = FILTER(false),
                                                      "Shipment Date" = FIELD("Date Filter2"),
                                                      "Responsibility Center" = FIELD("Responsibility Center Filter")));
            Caption = 'Partially Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "No. Of Items Due (Legal Diary)"; Integer)
        {
            AccessByPermission = TableData 110 = R;
            Caption = 'Average Days Delayed';
            Editable = false;
        }
        field(10; "No. Of Payments Due"; Integer)
        {
            CalcFormula = Count("Sales Invoice Header" WHERE("Document Exchange Status" = FILTER("Sent to Document Exchange Service" | "Delivery Failed")));
            Caption = 'Sales Invoices - Pending Document Exchange';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "No. of Services Due"; Integer)
        {
            CalcFormula = Count("Sales Cr.Memo Header" WHERE("Document Exchange Status" = FILTER("Sent to Document Exchange Service" | "Delivery Failed")));
            Caption = 'Sales Credit Memos - Pending Document Exchange';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "Date Filter2"; Date)
        {
            Caption = 'Date Filter 2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(22; "Responsibility Center Filter"; Code[10])
        {
            Caption = 'Responsibility Center Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetRespCenterFilter();
    var
        UserSetupMgt: Codeunit "User Setup Management";
        RespCenterCode: Code[10];
    begin
        RespCenterCode := UserSetupMgt.GetSalesFilter;
        IF RespCenterCode <> '' THEN BEGIN
            FILTERGROUP(2);
            SETRANGE("Responsibility Center Filter", RespCenterCode);
            FILTERGROUP(0);
        END;
    end;

    procedure CalculateAverageDaysDelayed() AverageDays: Decimal;
    var
        SalesHeader: Record "Sales Header";
        SumDelayDays: Integer;
        CountDelayedInvoices: Integer;
    begin
        /*FilterOrders(SalesHeader,FIELDNO(Delayed));
        IF SalesHeader.FINDSET THEN BEGIN
          REPEAT
            SumDelayDays += WORKDATE - SalesHeader."Shipment Date";
            CountDelayedInvoices += 1;
          UNTIL SalesHeader.NEXT = 0;
          AverageDays := SumDelayDays / CountDelayedInvoices;
        END;*/

    end;

    procedure CountOrders(FieldNumber: Integer): Integer;
    var
        CountSalesOrders: Query "Count Sales Orders";
        SalesOrderWithBlankShipmentDateCount: Integer;
    begin
        /*CountSalesOrders.SETRANGE(Status,CountSalesOrders.Status::Released);
        CountSalesOrders.SETRANGE(Completely_Shipped,FALSE);
        FILTERGROUP(2);
        CountSalesOrders.SETFILTER(Responsibility_Center,GETFILTER("Responsibility Center Filter"));
        FILTERGROUP(0);
        
        CASE FieldNumber OF
          FIELDNO("No. of  Vehicles out of Cover"):
            BEGIN
              CountSalesOrders.SETRANGE(Ship);
              CountSalesOrders.SETFILTER(Shipment_Date,GETFILTER("Date Filter2"));
            END;
          FIELDNO("Partially Shipped"):
            BEGIN
              CountSalesOrders.SETRANGE(Ship,TRUE);
              CountSalesOrders.SETFILTER(Shipment_Date,GETFILTER("Date Filter2"));
            END;
          FIELDNO(Delayed):
            BEGIN
              CountSalesOrders.SETRANGE(Ship);
              CountSalesOrders.SETRANGE(Shipment_Date,0D);
              CountSalesOrders.OPEN;
              CountSalesOrders.READ;
              SalesOrderWithBlankShipmentDateCount := CountSalesOrders.Count_Orders;
              CountSalesOrders.SETFILTER(Shipment_Date,GETFILTER("Date Filter"));
            END;
        END;
        CountSalesOrders.OPEN;
        CountSalesOrders.READ;
        EXIT(CountSalesOrders.Count_Orders - SalesOrderWithBlankShipmentDateCount);*/

    end;

    local procedure FilterOrders(var SalesHeader: Record "Sales Header"; FieldNumber: Integer);
    begin
        /*SalesHeader.SETRANGE("Document Type",SalesHeader."Document Type"::Order);
        SalesHeader.SETRANGE(Status,SalesHeader.Status::Released);
        SalesHeader.SETRANGE("Completely Shipped",FALSE);
        CASE FieldNumber OF
          FIELDNO("No. of  Vehicles out of Cover"):
            BEGIN
              SalesHeader.SETRANGE(Ship);
              SalesHeader.SETFILTER("Shipment Date",GETFILTER("Date Filter2"));
            END;
          FIELDNO("Partially Shipped"):
            BEGIN
              SalesHeader.SETRANGE(Ship,TRUE);
              SalesHeader.SETFILTER("Shipment Date",GETFILTER("Date Filter2"));
            END;
          FIELDNO(Delayed):
            BEGIN
              SalesHeader.SETRANGE(Ship);
              SalesHeader.SETFILTER("Shipment Date",GETFILTER("Date Filter"));
              SalesHeader.FILTERGROUP(2);
              SalesHeader.SETFILTER("Shipment Date",'<>%1',0D);
              SalesHeader.FILTERGROUP(0);
            END;
        END;
        FILTERGROUP(2);
        SalesHeader.SETFILTER("Responsibility Center",GETFILTER("Responsibility Center Filter"));
        FILTERGROUP(0);*/

    end;

    procedure ShowOrders(FieldNumber: Integer);
    var
        SalesHeader: Record "Sales Header";
    begin
        FilterOrders(SalesHeader, FieldNumber);
        PAGE.RUN(PAGE::"Sales Order List", SalesHeader);
    end;
}

