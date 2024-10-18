trigger Scenario23 on Order__c (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        Scenario23.highestTimeOrder(trigger.new, trigger.oldMap);
    }
}