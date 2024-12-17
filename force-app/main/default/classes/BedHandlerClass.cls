public with sharing class BedHandlerClass {
    public static void assignBedsToPatients(List<Bed__c> bedList){

        List<Patient__c> waitingListPatients = [Select Id, Priority__c, Admission_Status__c, Bed__c From Patient__c where Admission_Status__c = 'Waiting'];

        Map<String, List<Patient__c>> priorityMap = new Map<String, List<Patient__c>>();

        priorityMap.put('Critical', new List<Patient__c>());
        priorityMap.put('Emergency', new List<Patient__c>());
        priorityMap.put('Normal', new List<Patient__c>());

        for(Patient__c patient : waitingListPatients){
            if(priorityMap.containsKey(patient.Priority__c)){
                priorityMap.get(patient.Priority__c).add(patient);
            }
        }

        List<Patient__c> sortedPatients = new List<Patient__c>();

        for(String priority : new List<String>{'Critical', 'Emergency', 'Normal'}){
            sortedPatients.addAll(priorityMap.get(priority));
        }
        Set<Id> patientIds = new Set<Id>();
        for(Patient__c patient : sortedPatients){
            patientIds.add(patient.Id);
        }

        List<Waiting_List__c> waitingListRecords = [Select Id, Patient__c From Waiting_List__c where Patient__c in : patientIds];

        Map<Id, Waiting_List__c> waitingListMap = new Map<Id, Waiting_List__c>();

        for(Waiting_List__c waitingList : waitingListRecords){
            waitingListMap.put(waitingList.Patient__c, waitingList);
        }
        List<Patient__c> patientsToUpdate = new List<Patient__c>();
        List<Bed__c> bedsToUpdate = new List<Bed__c>();
        List<Waiting_List__c> waitingListToDelete = new List<Waiting_List__c>();
        for(Bed__c bed : bedList){
            if(!sortedPatients.isEmpty()){
                Patient__c patientToAssign = sortedPatients.remove(0);
                patientToAssign.Admission_Status__c = 'Admitted';
                patientToAssign.Bed__c = bed.Id;
                patientsToUpdate.add(patientToAssign);

                Bed__c bedToUpdate = new Bed__c(Id = bed.Id);
                bedToUpdate.Status__c = 'Occupied';
                bedsToUpdate.add(bedToUpdate);

                Waiting_List__c waitingRecords = waitingListMap.get(patientToAssign.Id);
                waitingListToDelete.add(waitingRecords);
            }
        }

        if(!patientsToUpdate.isEmpty()){
            update patientsToUpdate;
        }
        if(!bedsToUpdate.isEmpty()){
            update bedsToUpdate;
        }

        if(!waitingListToDelete.isEmpty()){
            delete waitingListToDelete;
        }
    }
}