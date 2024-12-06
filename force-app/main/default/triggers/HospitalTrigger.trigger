trigger HospitalTrigger on Patient__c (after insert, after update) {
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate){
            PatientHandlerClass.allocateBed(trigger.new);
        }
    }
}