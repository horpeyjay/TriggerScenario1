trigger Scenario18 on Opportunity (after insert , after update, after undelete, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            Scenario18.updateAccDesc(trigger.new, null);
        }
        if(trigger.isUpdate){
            Scenario18.updateAccDesc(trigger.new, trigger.oldMap);
        }
        if(trigger.isDelete){
            Scenario18.updateAccDesc(trigger.old, null);
        }
    }
}