trigger Scenario4 on Opportunity (after insert, after update, after undelete, after delete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            Scenario4.trackAmount(trigger.new, null);
        }
        if(trigger.isUpdate){
            Scenario4.trackAmount(trigger.new, trigger.oldMap);
        }
        if(trigger.isDelete){
            Scenario4.trackAmount(trigger.old, null);
        }
    }

}