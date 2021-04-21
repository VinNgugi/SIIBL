table 51511032 "Group Imprest Lines"
{
    // version FINANCE


    fields
    {
        field(1; "Imprest No"; Code[20])
        {
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate()
            begin
                /*IF Empl.GET("Employee No.") THEN
                 BEGIN
                   "Employee Name":=Empl."First Name"+' '+Empl."Last Name";
                 END;
                
                
                IF ImprestHeader.GET("Imprest No")  THEN BEGIN
                IF EmpAccmap.GET("Employee No.",ImprestHeader."Transaction Type") THEN
                 BEGIN
                  "Customer No":=EmpAccmap."Customer A/c";
                 END ELSE
                  ERROR(Text000,"Employee No.",ImprestHeader."Transaction Type");
                END;*/

            end;
        }
        field(3; "Employee Name"; Text[150])
        {
        }
        field(4; "Customer No"; Code[20])
        {
            TableRelation = Customer;
        }
        field(5; Amount; Decimal)
        {

            trigger OnValidate()
            begin
                CheckTotal;
            end;
        }
        field(6; "Actual Spent"; Decimal)
        {
        }
        field(7; "Remaining Amount"; Decimal)
        {
        }
        field(8; "Amount Requested"; Decimal)
        {

            trigger OnValidate()
            begin
                CheckTotal;
            end;
        }
        field(39; County; Code[30])
        {
            TableRelation = Counties;

            trigger OnValidate()
            begin
                /*PostRec.RESET;
                PostRec.SETRANGE("County Code",County);
                IF PostRec.FIND('-') THEN BEGIN
                "County Name":=PostRec."County Description";
                
                ReqHeader.RESET;
                ReqHeader.SETRANGE("No.","Imprest No");
                IF ReqHeader.FIND('-') THEN BEGIN
                  IF Empl.GET("Employee No.") THEN BEGIN
                  ImpRates.RESET;
                  ImpRates.SETRANGE("County Code",County);
                  ImpRates.SETRANGE("Job Grade",Empl."Salary Scale");
                  IF ImpRates.FIND('-') THEN BEGIN
                    IF Amount > ImpRates.Amount THEN
                    ERROR(Text002,Amount,ImpRates.Amount,PostRec."County Description",PostRec."County Code");
                    END;
                  END;
                END ELSE
                "County Name":='';
                END;*/

            end;
        }
        field(40; "County Name"; Text[30])
        {
            Editable = false;
        }
        field(41; Quantity; Decimal)
        {

            trigger OnValidate()
            begin
                VALIDATE("Unit Price");
            end;
        }
        field(42; "Unit of Measure"; Code[10])
        {
            TableRelation = "Unit of Measure";
        }
        field(43; "Unit Price"; Decimal)
        {

            trigger OnValidate()
            begin
                VALIDATE(County);
                Amount := Quantity * "Unit Price";
                VALIDATE(Amount);
                "Amount Requested" := Quantity * "Unit Price";
            end;
        }
        field(50055; "Imprest Purpose"; Option)
        {
            OptionCaption = 'DSA,OTHER';
            OptionMembers = DSA,OTHER;
        }
    }

    keys
    {
        key(Key1; "Imprest No", "Employee No.", "Customer No")
        {
        }
        key(Key2; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Empl: Record Employee;
        UsersRec: Record "User Setup";
        //EmpAccmap: Record "51511128";
        ImprestHeader: Record "Request Header";
        Text000: Label 'There is no employee account mapping for the Employee %1 for Transaction Type %2';
        Text001: Label 'The amount allocated to the employees has exceed the requested amount of %1 by %2 \ Check your allocations';
        //PostRec: Record 51511293;
        ReqHeader: Record "Request Header";
        Text002: Label 'Imprest Total Amount of %1 is Greater than %2 of your Allowable Allowance Amount for this City of %3 Postal Code %4';

    procedure CheckTotal()
    var
        ImprestHeader: Record "Request Header";
        //ImpLines: Record 51511393;
    begin
        /*IF ImprestHeader.GET("Imprest No") THEN;
          ImprestHeader.CALCFIELDS("Imprest Amount","Total Amount Requested");
        
        ImpLines.RESET;
        ImpLines.SETRANGE("Imprest No","Imprest No");
        ImpLines.SETFILTER("Employee No.",'<>%1',"Employee No.");
        ImpLines.CALCSUMS(Amount,"Amount Requested");
        
        IF ImpLines.Amount+Amount>ImprestHeader."Imprest Amount" THEN
          ERROR(Text001,ImprestHeader."Imprest Amount",((ImpLines.Amount+Amount)-ImprestHeader."Imprest Amount"));
        
        IF ImpLines."Amount Requested"+"Amount Requested">ImprestHeader."Total Amount Requested" THEN
          ERROR(Text001,ImprestHeader."Total Amount Requested",((ImpLines."Amount Requested"+"Amount Requested")-ImprestHeader."Total Amount Requested"));*/

    end;
}

