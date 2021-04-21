table 51404201 "Interaction Type"
{
    // version AES-PAS 1.0

   DrillDownPageID = 51404256;
      LookupPageID = 51404256;

    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;Description;Text[80])
        {
        }
        field(3;"Interaction Type";Option)
        {
            Caption = 'Interaction Type';
            OptionCaption = 'Request,Complaint,Enquiry,Observation,Outbound Calls';
            OptionMembers = Request,Complaint,Enquiry,Observation,"Outbound Calls";
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = true;
        }
        field(4;Status;Option)
        {
            OptionCaption = 'Active, In-Active';
            OptionMembers = Active," In-Active";
        }
        field(50000;"Day Start Time";Time)
        {
        }
        field(50001;"Day End Time";Time)
        {
        }
        field(50002;"Escalation Expiration -Hrs";Integer)
        {
        }
        field(50003;"Assigned to Business Unit";Code[30])
        {

            trigger OnValidate()
            begin
                /*IF Contrib.GET("Assigned to Business Unit") THEN
                "Assigned to Business Name":=Contrib.Name;
                "Business Unit Email":=Contrib.Email;
                */

            end;
        }
        field(50004;"Business Unit Email";Text[50])
        {
        }
        field(50005;"Assigned to Business Name";Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //test
        IF NOT Usersetup.GET(USERID) THEN
        BEGIN
        User.RESET;
        User.SETRANGE("User Name",USERID);
        IF User.FINDFIRST THEN
        //UserSID:=
        UserName:=IdentityManagement.UserName(User."Windows Security ID");
        //error('%1',userName);

        Usersetup.RESET;
        Usersetup.SETRANGE(Usersetup."User ID", UserName);
        IF Usersetup.FINDFIRST THEN BEGIN
        //error('%1',usersetup."profile");
        Profile.RESET;
        //Profile.SETRANGE("Profile ID", Usersetup.Profile);
        //IF Profile."Edit Interaction List" = FALSE THEN

          //ERROR('You dont have authorization to make chages');
         END ELSE
        Usersetup.RESET;
        Usersetup.SETRANGE(Usersetup."User ID", USERID);
        IF Usersetup.FINDFIRST THEN BEGIN

        Profile.RESET;
        //Profile.SETRANGE("Profile ID", Usersetup.Profile);
        // IF Profile."Edit Interaction List" = FALSE THEN

          //ERROR('You dont have authorization to make chages');
        END;
        END;
    end;

    trigger OnModify()
    begin
        /*User.RESET;
        User.SETRANGE("User Name",USERID);
        IF User.FINDFIRST THEN
        //UserSID:=
        UserName:=IdentityManagement.UserName(User."Windows Security ID");
        
        
        Usersetup.RESET;
        Usersetup.SETRANGE(Usersetup."User ID", UserName);
        IF Usersetup.FINDFIRST THEN BEGIN
        Profile.RESET;
        Profile.SETRANGE("Profile ID", Usersetup.Profile);
        IF Profile."Edit Interaction List" = FALSE THEN
          ERROR('You dont have authorization to make chages');
         END;
         */
        
        //test
        IF NOT Usersetup.GET(USERID) THEN
        BEGIN
        User.RESET;
        User.SETRANGE("User Name",USERID);
        IF User.FINDFIRST THEN
        //UserSID:=
        UserName:=IdentityManagement.UserName(User."Windows Security ID");
        //error('%1',userName);
        
        Usersetup.RESET;
        Usersetup.SETRANGE(Usersetup."User ID", UserName);
        IF Usersetup.FINDFIRST THEN BEGIN
        //error('%1',usersetup."profile");
        Profile.RESET;
        //Profile.SETRANGE("Profile ID", Usersetup.Profile);
        //IF Profile."Edit Interaction List" = FALSE THEN
        
          //ERROR('You dont have authorization to make chages');
         END ELSE
        Usersetup.RESET;
        Usersetup.SETRANGE(Usersetup."User ID", USERID);
        IF Usersetup.FINDFIRST THEN BEGIN
        
        //Profile.RESET;
      //  Profile.SETRANGE("Profile ID", Usersetup.Profile);
        //IF Profile."Edit Interaction List" = FALSE THEN
        
          //ERROR('You dont have authorization to make chages');
        END;
        END;

    end;

    var
        recInteractionType: Record "Interaction Type";
        ComplaintSetup: Record "Interactions Setup";
        //NoSeriesMgt: Codeunit NoSeriesManagement;
        Comp: Record 51404201;
        Usersetup: Record "User setup";
        "Profile": Record 2000000072;
        User: Record User;
        IdentityManagement: Codeunit 9801;
        UserName: Text;
        UserSID: Guid;

    procedure AssistEdit(OldComp: Record 51404201): Boolean
    var
        //Comp: Record 51404031;
    begin
    end;
}

