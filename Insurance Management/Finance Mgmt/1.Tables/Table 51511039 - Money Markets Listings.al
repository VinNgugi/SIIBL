table 51511039 "Money Markets Listings"
{
    // version FINANCE


    fields
    {
        field(1; "Issue No"; Code[30])
        {
        }
        field(2; "Issue Date"; Date)
        {
        }
        field(3; "Value Date"; Date)
        {
        }
        field(4; "Maturity Days"; Decimal)
        {
        }
        field(5; "Maturity Period"; Decimal)
        {

            trigger OnValidate()
            begin
                //COMM
                /*
                InvestmentSetup.GET;

                IF "Issue Date"<>0D THEN
                BEGIN
                NoOfDays:="Maturity Period"*InvestmentSetup."Rating Change Datetime";
                 "Maturity Days":="Maturity Period"*InvestmentSetup."Rating Change Datetime";
                "No of Interest Periods":="Maturity Period"*2;


                IF NoOfDays>9999 THEN BEGIN
                     NoOfDays1:=NoOfDays-9999;
                     NofDaysTxt1:=FORMAT(NoOfDays1)+'D';
                     NoOfDays:=9999;
                     NofDaysTxt:=FORMAT(NoOfDays)+'D';
                      NewDate:=CALCDATE(NofDaysTxt,"Issue Date");
                      FinalDate:=CALCDATE(NofDaysTxt1,NewDate);
                       "Maturity Date":=FinalDate;
                      //MESSAGE(FORMAT("Maturity Date"));

                     END ELSE  BEGIN
                     IF NoOfDays<=999   THEN
                     "Maturity Date":=FinalDate;
               NofDaysTxt:=FORMAT(NoOfDays)+'D';
                "Maturity Date":=CALCDATE(NofDaysTxt,"Issue Date");
               END;
                END;
                */

            end;
        }
        field(6; "Maturity Date"; Date)
        {
        }
        field(7; Coupon; Decimal)
        {
        }
        field(8; Yield; Decimal)
        {
        }
        field(9; Price; Decimal)
        {
        }
        field(10; "Issue Size Face Value"; Decimal)
        {
        }
        field(11; "No of Interest Periods"; Integer)
        {
        }
        field(12; "Investment Type Name"; Text[30])
        {
        }
        field(13; "Days To Maturity"; Integer)
        {
        }
        field(14; "Coupon Rate"; Text[30])
        {
        }
        field(15; Reopened; Text[30])
        {
        }
        field(16; "Investment Type"; Code[10])
        {
            TableRelation = "Investment Types";

            trigger OnValidate()
            begin
                IF InvestmentType.GET("Investment Type") THEN
                    "Investment Type Name" := InvestmentType.Description;
            end;
        }
    }

    keys
    {
        key(Key1; "Issue No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        //InvestmentSetup: Record "Investment Setup";
        NoOfDays: Integer;
        NofDaysTxt: Text[30];
        InvestmentType: Record "Investment Types";
        NoOfDays1: Integer;
        NofDaysTxt1: Text[30];
        NewDate: Date;
        FinalDate: Date;
}

