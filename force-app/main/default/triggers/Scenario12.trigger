trigger Scenario12 on Candidate__c (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        Scenario12.candidateJuncObject(trigger.new);
    }

}