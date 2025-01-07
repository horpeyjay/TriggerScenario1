trigger AccountTrigger on Account (before insert, before delete) {
    if(Trigger.isBefore && trigger.isInsert){
        AccountTriggerHandler.CreateAccounts(Trigger.new);
    }

    if(trigger.isBefore && trigger.isDelete){
        AccountTriggerHandler.preventContactDeletion(trigger.old);
    }
}