trigger Scenario6 on Account (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            Scenario6.createRelContact(trigger.new, null);
        }
        if(trigger.isUpdate){
            Scenario6.createRelContact(trigger.new, trigger.oldMap);
        }
    }
}