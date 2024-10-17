trigger Scenario5 on Account (before update) {
    if(trigger.isBefore && trigger.isUpdate){
        Scenario5.preventDeactivateAccount(trigger.newMap, trigger.oldMap);
    }
}