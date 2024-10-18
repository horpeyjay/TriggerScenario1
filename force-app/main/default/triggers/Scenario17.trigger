trigger Scenario17 on Contact (after insert, after update, after delete, after undelete) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUndelete){
            Scenario17.contactUpdate(trigger.new, null);
        }
        if(trigger.isUpdate){
            Scenario17.contactUpdate(trigger.new, trigger.oldMap);
        }
        if(trigger.isDelete){
            Scenario17.contactUpdate(trigger.old, null);
        }
    }
}