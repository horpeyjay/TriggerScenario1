trigger Scenario16 on Contact (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        Scenario16.checkboxtrigger(trigger.new);
    }
}