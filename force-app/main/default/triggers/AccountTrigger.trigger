trigger AccountTrigger on Account (before insert, before delete, before update) {
    if(Trigger.isBefore && trigger.isInsert){
        AccountTriggerHandler.CreateAccounts(Trigger.new);
    }

    if(trigger.isBefore && trigger.isDelete){
        AccountTriggerHandler.preventContactDeletion(trigger.old);
    }

    if(trigger.isBefore && trigger.isUpdate){
        AccountTriggerHandler.preventAccUpdateIn1Hour(trigger.new, trigger.oldMap);
    }
}