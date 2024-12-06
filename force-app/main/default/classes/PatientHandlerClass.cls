public with sharing class PatientHandlerClass {
    private static Map<String, List<Bed__c>> getAvailableBed(String category){
        List<Bed__c> beds = [Select Id, Category__c, Status__c From Bed__c where Status__c = 'Available' and Category__c = : category];
        Map<String, List<Bed__c>> bedMap = new Map<String, List<Bed__c>>();
        if(!beds.isEmpty()){
           for(Bed__c b : beds){
               if(!bedMap.containsKey(b.Category__c)){
                   bedMap.put(b.Category__c, new List<Bed__c>());
               }
               bedMap.get(b.Category__c).add(b);
           }
        }
        return bedMap;
    }
    
    public static void allocateBed(List<Patient__c> patients){

        List<Patient__c> updatedPatients = new List<Patient__c>();
        List<Bed__c> bedsToUpdate = new List<Bed__c>();
        List<Waiting_List__c> waitingListToInsert = new List<Waiting_List__c>();
        if(!patients.isEmpty()){
            for(Patient__c p : patients){
                if(p.Admission_Status__c != 'Waiting') continue;

                String patientPriority = p.Priority__c;
                Bed__c allocateBed = null;

                Map<String, List<Bed__c>> availableBeds = getAvailableBed(patientPriority);

                if(availableBeds.containsKey(patientPriority)){
                    List<Bed__c> bedsPriority = availableBeds.get(patientPriority);

                    if(!bedsPriority.isEmpty()){
                        allocateBed = bedsPriority.remove(0);
                    }
                }
                if(allocateBed != null){
                    Patient__c updatedPatient = new Patient__c(Id = p.Id, Bed__c = allocateBed.Id, Admission_Status__c = 'Admitted');
                    updatedPatients.add(updatedPatient);

                    allocateBed.Status__c = 'Occupied';
                    bedsToUpdate.add(allocateBed);
                }else{
                    Waiting_List__c waitingListRecord = new Waiting_List__c();
                    waitingListRecord.Patient__c = p.id;
                    waitingListRecord.Status__c = 'Waiting for Bed';
                    waitingListToInsert.add(waitingListRecord);
                }
            }
        }

        if(!bedsToUpdate.isEmpty()){
            update bedsToUpdate;
        }

        if(!waitingListToInsert.isEmpty()){
            insert waitingListToInsert;
        }

        if(!updatedPatients.isEmpty()){
            update updatedPatients;
        }
    }
}