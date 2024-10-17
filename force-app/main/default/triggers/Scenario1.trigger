trigger Scenario1 on Opportunity (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        Scenario1.oppConRole(trigger.new, trigger.oldMap);
    }
}