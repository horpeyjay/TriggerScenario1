trigger Scenario20 on Contact (after update) {

    if(trigger.isAfter && trigger.isUpdate){
        Scenario20.updateRelConPhone(trigger.new, trigger.oldMap);
    }

}