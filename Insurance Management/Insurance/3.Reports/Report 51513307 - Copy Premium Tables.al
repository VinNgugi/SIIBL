report 51513307 "Copy Premium Tables"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Copy Premium Tables.rdl';

    dataset
    {
        dataitem("Premium Table"; "Premium Table")
        {
            RequestFilterFields = "Code";
            dataitem("Premium table Lines"; "Premium table Lines")
            {
                DataItemLink = "Premium Table" = FIELD(Code);

                trigger OnAfterGetRecord();
                begin
                    PremTablelinesCopy.INIT;
                    PremTablelinesCopy.TRANSFERFIELDS("Premium table Lines");
                    PremTablelinesCopy."Premium Table" := Premtable.Code;
                    PremTablelinesCopy."Policy Type" := Premtable."Policy Type";
                    PremTablelinesCopy."Effective Date" := Premtable."Effective Date";
                    PremTablelinesCopy."Vehicle Type" := Premtable."Vehicle Class";
                    PremTablelinesCopy."Vehicle Usage" := Premtable."Vehicle Usage";
                    IF NOT PremTablelinesCopy.GET(PremTablelinesCopy."Premium Table", PremTablelinesCopy."Seating Capacity", PremTablelinesCopy.Instalments, PremTablelinesCopy."Policy Type") THEN
                        PremTablelinesCopy.INSERT;
                end;
            }

            trigger OnPreDataItem();
            begin
                PremTablelines.RESET;
                PremTablelines.SETRANGE(PremTablelines."Premium Table", Premtable.Code);
                //ERROR('%1',Premtable.Code);
                PremTablelines.DELETEALL;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Premtable: Record "Premium Table";
        PremTablelines: Record "Premium table Lines";
        PremTablelinesCopy: Record "Premium table Lines";

    procedure GetRec(var PremiumTable: Record "Premium Table");
    begin
        Premtable.COPY(PremiumTable);
    end;
}

