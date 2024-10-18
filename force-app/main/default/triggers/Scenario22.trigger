trigger Scenario22 on Order__c (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        Scenario22.timePerStage(trigger.new, trigger.oldMap);
    }
}