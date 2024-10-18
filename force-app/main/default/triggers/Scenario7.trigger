trigger Scenario7 on Case (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            Scenario7.createFollowupTask(trigger.new, null);
        }
        if(trigger.isUpdate){
            Scenario7.createFollowupTask(trigger.new, trigger.oldMap);
        }
    }
}