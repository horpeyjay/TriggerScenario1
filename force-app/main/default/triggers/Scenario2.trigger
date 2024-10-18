trigger Scenario2 on Case (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        Scenario2.taskContact(trigger.new, trigger.oldMap);
    }
}