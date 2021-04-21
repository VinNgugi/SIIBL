report 51513575 "Sacco Analysis Report"
{
    // version AES-INS 1.0

    DefaultLayout = RDLC;
    RDLCLayout = './Insurance/5.Layouts/Sacco Analysis Report.rdl';

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Customer Type" = CONST(SACCO));
            column(Picture; CompInfor.Picture)
            {
            }
            column(CName; CompInfor.Name)
            {
            }
            column(CAddress; CompInfor.Address)
            {
            }
            column(CAdd2; CompInfor."Address 2")
            {
            }
            column(CCity; CompInfor.City)
            {
            }
            column(CPhoneNo; CompInfor."Phone No.")
            {
            }
            column(CEmail; CompInfor."E-Mail")
            {
            }
            column(CWeb; CompInfor."Home Page")
            {
            }
            column(CFaxno; CompInfor."Fax No.")
            {
            }
            column(No_Customer; Customer."No.")
            {
            }
            column(Name_Customer; Customer.Name)
            {
            }
            dataitem("Insure Lines"; "Insure Lines")
            {
                DataItemLink = "SACCO ID" = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.")
                                    WHERE("Document Type" = CONST(Policy),
                                          Status = CONST(Live),
                                          "Description Type" = CONST("Schedule of Insured"));
                column(RegistrationNo_InsureLines; "Insure Lines"."Registration No.")
                {
                }
                column(CubicCapacitycc_InsureLines; "Insure Lines"."Cubic Capacity (cc)")
                {
                }
                column(SeatingCapacity_InsureLines; "Insure Lines"."Seating Capacity")
                {
                }
                column(SACCOID_InsureLines; "Insure Lines"."SACCO ID")
                {
                }
                column(RouteID_InsureLines; "Insure Lines"."Route ID")
                {
                }
                column(CertificateNo_InsureLines; "Insure Lines"."Certificate No.")
                {
                }
                column(DocumentNo_InsureLines; "Insure Lines"."Document No.")
                {
                }
                column(RouteName; RouteName)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                RouteName := '';
                CompInfor.GET;
                CompInfor.CALCFIELDS(Picture);
                SaccoRoutes.SETRANGE(SaccoRoutes."SACCO ID", Customer."No.");
                IF SaccoRoutes.FINDFIRST THEN
                    RouteName := SaccoRoutes."Route Name";
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
        CompInfor: Record 79;
        CustCopy: Record Customer;
        SaccoRoutes: Record 51513072;
        RouteName: Text;
}

