page 51513079 "Insured Card-Individual"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(Biodata)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Sex; Sex)
                {
                }
                field("Date of Birth"; "Date of Birth")
                {
                }
                field("Marital Status"; "Marital Status")
                {
                }
                field(Occupation; Occupation)
                {
                }
                field(Nationality; Nationality)
                {
                }
                field(PIN; PIN)
                {
                }
                field("ID/Passport No."; "ID/Passport No.")
                {
                }
            }
            group(Communication)
            {
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(City; City)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field(Mobile; Mobile)
                {
                }
            }
            group(Accounting)
            {
                field("Intermediary No."; "Intermediary No.")
                {
                }
                field("Intermediary Name"; "Intermediary Name")
                {
                }
                field(Balance; Balance)
                {
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {
                }
            }
            part("Policy List"; "Policy List")
            {
                SubPageLink = "Insured No." = FIELD("No.");
            }
            part("Quote List"; "Quote List")
            {
                SubPageLink = "Insured No." = FIELD("No.");
            }
            part("Claim Register List"; "Claim Register List")
            {
                SubPageLink = Insured = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Customer Type" := "Customer Type"::Insured;
        "Insured Type" := "Insured Type"::Individual;
    end;
}

