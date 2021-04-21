tableextension 50125 "Notification  Setup Ext" extends "Notification Setup"
{
    fields
    {
        field(50100; "SMS Message"; Text[250])
        {
            Caption = 'SMS Message';
            DataClassification = ToBeClassified;
        }
        field(50101; "Notification Start Period"; DateFormula)
        {
            Caption = 'Notification Start Period';
            DataClassification = ToBeClassified;
        }
        field(50102; "Holiday Date"; Date)
        {
            Caption = 'Holiday Date';
            DataClassification = ToBeClassified;
        }
    }
}
