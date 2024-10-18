trigger Scenario15 on Opportunity (after insert, after update) {
    if(trigger.isAfter &&(trigger.isInsert || trigger.isUpdate)){
        Scenario15.sendEmailOnOpps(trigger.new);
    }
}