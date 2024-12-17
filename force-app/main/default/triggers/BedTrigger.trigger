trigger BedTrigger on Bed__c (after update) {
    List<Bed__c> availableBeds = new List<Bed__c>();
    for(Bed__c bed : trigger.new){
        if(bed.Status__c == 'Available' && trigger.oldMap.get(bed.Id).Status__c == 'Occupied'){
            availableBeds.add(bed);
        }
    }

    if(!availableBeds.isEmpty()){
        BedHandlerClass.assignBedsToPatients(availableBeds);
    }
}