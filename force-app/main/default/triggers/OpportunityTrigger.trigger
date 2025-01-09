trigger OpportunityTrigger on Opportunity (before insert) {
    if(trigger.isBefore && trigger.isInsert) {
        OpportunityHandlerClass.oneOppDaily(trigger.new);
    }
}