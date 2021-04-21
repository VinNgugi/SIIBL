table 51513162 "Medical Test Header"
{
    // version AES-INS 1.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "User Requesting"; Code[20])
        {
        }
        field(3; "Medical Provider"; Code[20])
        {
            TableRelation = Vendor;

            trigger OnValidate();
            begin
                //IF vendor.GET("Medical Provider") THEN
            end;
        }
        field(4; "Document Type"; Option)
        {
            OptionCaption = '" ,Quote,Accepted Quote,Debit Note,Credit Note,Policy,Endorsement"';
            OptionMembers = " ",Quote,"Accepted Quote","Debit Note","Credit Note",Policy,Endorsement;
            TableRelation = "Insure Lines"."Document Type" WHERE("Description Type" = CONST("Schedule of Insured"));
        }
        field(5; "Document No."; Code[30])
        {
            TableRelation = "Insure Lines"."Document No." WHERE("Description Type" = CONST("Schedule of Insured"));
        }
        field(6; "Member ID"; Integer)
        {
            TableRelation = "Insure Lines"."Line No." WHERE("Description Type" = CONST("Schedule of Insured"));

            trigger OnValidate();
            begin
                /* IF RiskData.GET("Risk ID") THEN
                 BEGIN
                 Make:=RiskData.Make;
                  Model:=RiskData.Model;
                  "Engine No.":=RiskData."Engine No.";
                  "Chassis No.":=RiskData."Chassis No.";
                  "Year of Manufacture":=RiskData."Year of Manufacture";
                  "Vehicle Tonnage":=RiskData.Tonnage;
                  "Vehicle License Class":=RiskData."License Class";
                  //"SACCO ID":=RiskData.Capacity;
                  "Route ID":=RiskData.Route;
                 END;*/
                IF InsureLines.GET("Document Type", "Document No.", "Member ID") THEN BEGIN
                    "Family Name" := InsureLines."Family Name";
                    "First names" := InsureLines."First Name(s)";

                END;

            end;
        }
        field(7; "Family Name"; Text[50])
        {
        }
        field(8; "First names"; Text[80])
        {
        }
        field(9; "Date of Birth"; Date)
        {
        }
        field(10; Sex; Option)
        {
            OptionCaption = '" ,Male,Female"';
            OptionMembers = " ",Male,Female;
        }
        field(11; "Medical Practitioner Name"; Text[30])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        InsureLines: Record "Insure Lines";
        vendor: Record Vendor;
}

