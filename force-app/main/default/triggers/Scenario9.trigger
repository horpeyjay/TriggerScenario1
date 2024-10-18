trigger Scenario9 on Contact (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        Scenario9.countryUpdates(trigger.new, trigger.oldMap);
    }
}