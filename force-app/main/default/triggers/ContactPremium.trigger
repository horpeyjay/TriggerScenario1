trigger ContactPremium on Contact (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert){
            ContactPremiumHandlerClass.contactUpdate(trigger.new, null);
        }

        if(trigger.isUpdate){
            ContactPremiumHandlerClass.contactUpdate(trigger.new, trigger.oldMap);
        }
    }
}