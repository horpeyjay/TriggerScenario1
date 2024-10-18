trigger Scenario14 on Account (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        Scenario14.sendEmailOnUpdateContact(trigger.new, trigger.oldMap);
    }
}