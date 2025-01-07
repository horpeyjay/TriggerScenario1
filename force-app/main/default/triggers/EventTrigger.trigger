trigger EventTrigger on Event_Distribution__c (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        EventHandlerClass.handleFullCapacity(trigger.new);
    }
}