trigger Scenario25 on Opportunity (before delete) {
    if(trigger.isBefore && trigger.isDelete){
        Scenario25.oppTask(trigger.old);
    }

}