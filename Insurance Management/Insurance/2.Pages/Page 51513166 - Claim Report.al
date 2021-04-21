page 51513166 "Claim Report"
{
    // version AES-INS 1.0

    PageType = Card;
    SourceTable = "Claim Report Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                }
                field("Claim No."; "Claim No.")
                {
                }
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field("Reported By"; "Reported By")
                {
                }
                field("Appointment No."; "Appointment No.")
                {
                }
                field("Total Estimated Value"; "Total Estimated Value")
                {
                }
                field(Decision; Decision)
                {
                }
                field("Service Provider No."; "Service Provider No.")
                {
                }
                field(Name; Name)
                {
                }
                field(Class; Class)
                {
                }
            }
            /* part("Loss Type"; "Loss Type")
            {
                SubPageLink = "Claim Report No."=FIELD("No.");
                    UpdatePropagation = Both;
            } */
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
            }
            systempart(Notes; Notes)
            {
            }
            systempart(MyNotes; MyNotes)
            {
            }
            systempart(Links; Links)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Co&mments")
            {
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page 51513449;
                RunPageLink = "Table Name"=CONST(Claim),
                              "No."=FIELD("Claim No.");
            }
            action("Effect Report on Reserves")
            {

                trigger OnAction();
                begin
                    InsMgt.TransferReport2Reserve(Rec);
                end;
            }
        }
    }

    var
        InsMgt : Codeunit "Insurance management";
}

