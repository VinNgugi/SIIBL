codeunit 51403203 "Schedule - Automatic Runner"
{
    // version Scheduler

    // ///(27.03.08 SS) Init
    //                  Codeunit that is called to sort out the automatic running of the schedule groups


    trigger OnRun()
    var
        lrecSchedGroup: Record "Schedule Group";
        lcuSchedGroup: Codeunit "SIPML Interactions";
    begin


        lrecSchedGroup.SETRANGE(Enabled, TRUE);

        IF lrecSchedGroup.FINDSET THEN
            REPEAT
                IF (lrecSchedGroup."Next Scheduled Date Time" < CURRENTDATETIME) THEN
           ///It is time for this group to be run
           BEGIN                                                                           ///Yes so run it
                    lrecSchedGroup."Last Date Time Executed" := CURRENTDATETIME;
                    //lcuSchedGroup.RUN(lrecSchedGroup);
                    lcuSchedGroup.RUN();                                          ///Run the tasks for the group
                    lrecSchedGroup.setNextScheduledDateTime;                                     ///Work out when it is next due to run
                    lrecSchedGroup.MODIFY(FALSE);                                                ///Work out when it is next due to run
                END;
            UNTIL lrecSchedGroup.NEXT = 0;
    end;
}

