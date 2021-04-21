xmlport 50106 "loan trans"
{
    // version AES-INS 1.0

    DefaultFieldsValidation = false;
    Format = VariableText;

    schema
    {
        textelement(loans)
        {
            /*tableelement("Loan Application1"; "Loan Application1")
            {
                XmlName = 'loan_app';
                fieldelement(no; "Loan Application1"."Loan No")
                {
                }
                fieldelement(appdate; "Loan Application1"."Application Date")
                {
                }
                fieldelement(prod_type; "Loan Application1"."Loan Product Type")
                {
                }
                fieldelement(Amt_requested; "Loan Application1"."Amount Requested")
                {
                }
                fieldelement(Amt_approved; "Loan Application1"."Approved Amount")
                {
                }
                fieldelement(LoanStatus; "Loan Application1"."Loan Status")
                {
                }
                fieldelement(IssuedDate; "Loan Application1"."Issued Date")
                {
                }
                fieldelement(Instalment; "Loan Application1"."No. Of Instalment")
                {
                }
                fieldelement(Repayment; "Loan Application1"."Periodic Repayment")
                {
                }
                fieldelement(FlatP; "Loan Application1"."Flat Rate Principal")
                {
                }
                fieldelement(FlatI; "Loan Application1"."Flat Rate Interest")
                {
                }
                fieldelement(IntRate; "Loan Application1"."Interest Rate")
                {
                }
                fieldelement(NoSeries; "Loan Application1"."No Series")
                {
                }
                fieldelement(IntCalcMethod; "Loan Application1"."Interest Calculation Method")
                {
                }
                fieldelement(EmpNo; "Loan Application1"."Employee No")
                {
                }
                fieldelement(EmpName; "Loan Application1"."Employee Name")
                {
                }
                fieldelement(payrollgroup; "Loan Application1"."Payroll Group")
                {
                }
                fieldelement(description; "Loan Application1".Description)
                {
                }
                fieldelement(openingloan; "Loan Application1"."Opening Loan")
                {
                }
                fieldelement(totalrepayment; "Loan Application1"."Total Repayment")
                {
                }
                fieldelement(datefilter; "Loan Application1"."Date filter")
                {
                }
                fieldelement(periodrepayment; "Loan Application1"."Period Repayment")
                {
                }
                fieldelement(interest; "Loan Application1".Interest)
                {
                }
                fieldelement(interestimp; "Loan Application1"."Interest Imported")
                {
                }
                fieldelement(principalimp; "Loan Application1"."principal imported")
                {
                }
                fieldelement(interestrateper; "Loan Application1"."Interest Rate Per")
                {
                }
            }*/
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
}

