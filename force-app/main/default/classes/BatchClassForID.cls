public with sharing class BatchClassForID implements Database.Batchable<SObject> {
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, First_Name__c, Last_Name__c, Frequent_Flier_Number__c, Join_Date__c FROM Flight_Upcoming__c WHERE Flier__c = null');
    }

    public void execute(Database.BatchableContext bc, List<Flight_Upcoming__c> scope) {
        // Retrieve only Flier__c records with matching criteria to reduce volume
        Set<String> firstNames = new Set<String>();
        Set<String> lastNames = new Set<String>();
        for (Flight_Upcoming__c flight : scope) {
            firstNames.add(flight.First_Name__c);
            lastNames.add(flight.Last_Name__c);
        }
        
        Map<String, Flier__c> flierMap = new Map<String, Flier__c>();
        for (Flier__c flier : [SELECT Id, Name, Last_Name__c, Flier_Number__c, Join_Date__c 
                               FROM Flier__c 
                               WHERE Name IN :firstNames AND Last_Name__c IN :lastNames]) {
            String key = flier.Name + '-' + flier.Last_Name__c + '-' + flier.Flier_Number__c + '-' + flier.Join_Date__c;
            flierMap.put(key, flier);
        }

        List<Flight_Upcoming__c> flightsToUpdate = new List<Flight_Upcoming__c>();
        for (Flight_Upcoming__c flight : scope) {
            String key = flight.First_Name__c + '-' + flight.Last_Name__c + '-' + flight.Frequent_Flier_Number__c + '-' + flight.Join_Date__c;
            if (flierMap.containsKey(key)) {
                flight.Flier__c = flierMap.get(key).Id;
                flightsToUpdate.add(flight);
            }
        }
        
        if (!flightsToUpdate.isEmpty()) {
            update flightsToUpdate;
        }
    }

    public void finish(Database.BatchableContext bc) {
        // Get the AsyncApexJob ID for the current job
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email 
                            FROM AsyncApexJob  
                            WHERE Id = :bc.getJobId()];
        
        // Send an email to the submitter
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {job.CreatedBy.Email});
        mail.setSubject('Apex Sharing Recalculation ' + job.Status);
        mail.setPlainTextBody(
            'The batch Apex job processed ' + job.TotalJobItems +
            ' batches with ' + job.NumberOfErrors + ' failures.'
        );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}

/* Call this code in anonymous apex 

BatchClassForID batch = new BatchClassForID();
Integer batchSize = 200; // Optional, set batch size (default is 200)
Database.executeBatch(batch, batchSize);

*/