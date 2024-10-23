trigger InsertRecords on Initial_Fliers__c (after insert) {
    if(trigger.isAfter && trigger.IsInsert){
        InsertRecords.insertFliers(trigger.new);
    }

}