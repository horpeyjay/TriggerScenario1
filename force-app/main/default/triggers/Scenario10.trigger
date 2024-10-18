trigger Scenario10 on Opportunity (after insert, after update, after undelete, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            Scenario10.updateAccDesc(trigger.new, null);
        }
        if(trigger.isUpdate){
            Scenario10.updateAccDesc(trigger.new, trigger.oldMap);
        }
        if(trigger.isDelete){
            Scenario10.updateAccDesc(trigger.old, null);
        }
    }
}