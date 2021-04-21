table 51513129 EFT_TRGS
{
    // version AES-INS 1.0


    fields
    {
        field(1; "PV No."; Code[20])
        {
        }
        field(2; Name; Text[80])
        {
        }
        field(3; "Bank Code"; Code[10])
        {
        }
        field(4; "Bank account No"; Code[20])
        {
        }
        field(5; "Pay Mode"; Code[10])
        {
        }
        field(6; "Dr Account"; Code[20])
        {
        }
        field(7; Details; Text[80])
        {
        }
        field(8; Amount; Decimal)
        {
        }
        field(9; "Swift Code"; Code[20])
        {
        }
        field(10; Currency; Code[10])
        {
        }
        field(11; "Charged By"; Option)
        {
            OptionCaption = '" ,OUR,BEN,SHA"';
            OptionMembers = " ",OUR,BEN,SHA;
        }
        field(12; "Deal No"; Code[20])
        {
        }
        field(13; "EFT/RTGS Ref No."; Code[20])
        {
        }
        field(14; "Date Generated"; Date)
        {
        }
        field(15; "Time Generated"; Time)
        {
        }
        field(16; "Date and Time Generated"; DateTime)
        {
        }
        field(17; "User Generating"; Code[80])
        {
        }
        field(18; "No. Series"; Code[10])
        {
        }
        field(19; "Transaction date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "EFT/RTGS Ref No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF Paymodes.GET("Pay Mode") THEN BEGIN
            IF Paymodes.Type = Paymodes.Type::EFT THEN BEGIN


                IF "EFT/RTGS Ref No." = '' THEN BEGIN
                    GenLedgerSetup.GET;
                    GenLedgerSetup.TESTFIELD(GenLedgerSetup."EFT Nos.");
                    NoSeriesMgt.InitSeries(GenLedgerSetup."EFT Nos.", xRec."No. Series", 0D, "EFT/RTGS Ref No.", "No. Series");
                END
            END;

            IF Paymodes.Type = Paymodes.Type::RTGS THEN BEGIN


                IF "EFT/RTGS Ref No." = '' THEN BEGIN
                    GenLedgerSetup.GET;
                    GenLedgerSetup.TESTFIELD(GenLedgerSetup."RTGS Nos.");
                    NoSeriesMgt.InitSeries(GenLedgerSetup."RTGS Nos.", xRec."No. Series", 0D, "EFT/RTGS Ref No.", "No. Series");
                END
            END;
        END;
        "Time Generated" := TIME;
        "Date and Time Generated" := CURRENTDATETIME;
        "Date Generated" := TODAY;
        "User Generating" := USERID;
    end;

    var
        Paymodes: Record 51511006;
        GenLedgerSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

