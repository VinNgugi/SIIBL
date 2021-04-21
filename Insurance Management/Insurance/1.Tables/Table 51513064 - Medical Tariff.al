table 51513064 "Medical Tariff"
{
    // version AES-INS 1.0


    fields
    {
        field(1;Provider;Code[10])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                  IF ProviderRec.GET(Provider) THEN
                  "Provider Name":=ProviderRec.Name;
            end;
        }
        field(2;"Service Code";Code[10])
        {
            NotBlank = true;
            TableRelation = "Service Listing";

            trigger OnValidate();
            begin
                  /* IF ServListing.GET("Service Code") THEN
                   BEGIN
                   Description:=ServListing.Description;
                   END; */

            end;
        }
        field(3;Cost;Decimal)
        {

            trigger OnValidate();
            begin
                  IF Minimum=0 THEN
                  Minimum:=Cost;
                  IF Maximum=0 THEN
                  Maximum:=Cost;
            end;
        }
        field(4;Description;Text[130])
        {
        }
        field(5;"Effective Date";Date)
        {
        }
        field(6;"Provider Name";Text[80])
        {
        }
        field(7;Minimum;Decimal)
        {
        }
        field(8;Maximum;Decimal)
        {
        }
    }

    keys
    {
        key(Key1;Provider)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ProviderRec : Record Vendor;
}

