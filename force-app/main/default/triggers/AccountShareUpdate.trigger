trigger AccountShareUpdate on Account (after insert, after update) {

    if(trigger.isAfter){
        if(trigger.isInsert){
            AccountShareUpdate.createSharingAccount(trigger.new);
        }
        if(trigger.isUpdate){
            AccountShareUpdate.updateSharingAccount(trigger.oldMap, trigger.newMap);
        }
    }

}