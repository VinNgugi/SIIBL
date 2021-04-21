page 51511051 "Staff Posting Group"
{
    // version FINANCE

    PageType = List;
    SourceTable = "Staff Posting Group";

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Salary Account"; "Salary Account")
                {
                    Caption = 'Basic Salary Account';
                }
                field("Income Tax Account"; "Income Tax Account")
                {
                }
                field("SSF Employer Account"; "SSF Employer Account")
                {
                    Caption = 'NSSF Employer Account';
                }
                field("SSF Employee Account"; "SSF Employee Account")
                {
                    Caption = 'NSSF Total Account';
                }
                field("Pension Employer Acc"; "Pension Employer Acc")
                {
                }
                field("Pension Employee Acc"; "Pension Employee Acc")
                {
                }
                field("Net Salary Payable"; "Net Salary Payable")
                {
                }
                field("Fringe benefits"; "Fringe benefits")
                {
                    Caption = 'Fringe Benefits';
                }
                field("Employee Provident Fund Acc."; "Employee Provident Fund Acc.")
                {
                    Visible = false;
                }
                field("Is Temporary"; "Is Temporary")
                {
                }
                field("Is Permanent"; "Is Permanent")
                {
                }
                field("Is Intern"; "Is Intern")
                {
                }
                field("Is Contract"; "Is Contract")
                {
                }
                field("Seconded Employees"; "Seconded Employees")
                {
                }
                field("Tax Percentage"; "Tax Percentage")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Posting Group")
            {
                Caption = 'Posting Group';
                action("Accounts Mapping")
                {
                    Caption = 'Accounts Mapping';
                    RunObject = Page 51511052;
                    RunPageLink = "Posting Group"=FIELD(Code);
                }
            }
        }
    }
}

