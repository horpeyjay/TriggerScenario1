public with sharing class InsertRecords {
    public static void insertFliers(List<Initial_Fliers__c> newFliersList) {
        // Set to store Flier Ids
        Set<Id> flierIds = new Set<Id>();

        // List to add new fliers
        List<Flier__c> fliersToInsert = new List<Flier__c>();

        // List to add frequent flier details
        List<Frequent_Flier_Details__c> frequentFlierToInsert = new List<Frequent_Flier_Details__c>();

        // Map to track existing fliers by unique key (Name + Flier Number)
        Map<String, Flier__c> existingFliersMap = new Map<String, Flier__c>();

        // Set to gather unique Name + Flier Number combinations for querying existing records
        Set<String> uniqueFliers = new Set<String>();

        // Gather unique Name + Flier Number combinations
        for (Initial_Fliers__c initF : newFliersList) {
            String uniqueKey = initF.First_Name__c + '_' + initF.Frequent_Flier_Number__c;
            uniqueFliers.add(uniqueKey);
        }

        // Query existing fliers based on the unique Name + Flier Number combinations
        if (!uniqueFliers.isEmpty()) {
            List<Flier__c> existingFliers = [
                SELECT Id, Name, Flier_Number__c, Last_Name__c 
                FROM Flier__c 
                WHERE Flier_Number__c IN :uniqueFliers
            ];

            // Populate the map with existing fliers
            for (Flier__c f : existingFliers) {
                String uniqueKey = f.Name + '_' + f.Flier_Number__c;
                existingFliersMap.put(uniqueKey, f);
                flierIds.add(f.Id); // Add existing flier IDs to the set
            }
        }

        // Process the new fliers list
        for (Initial_Fliers__c initF : newFliersList) {
            String uniqueKey = initF.First_Name__c + '_' + initF.Frequent_Flier_Number__c;

            // If the flier doesn't exist in the map, create a new one
            if (!existingFliersMap.containsKey(uniqueKey)) {
                Flier__c newFlier = new Flier__c();
                newFlier.Name = initF.First_Name__c;
                newFlier.Last_Name__c = initF.Last_Name__c;
                newFlier.Flier_Number__c = initF.Frequent_Flier_Number__c;
                newFlier.Join_Date__c = initF.Join_Date__c;
                fliersToInsert.add(newFlier);

                // Add the unique key to prevent future duplicates
                existingFliersMap.put(uniqueKey, null); // Will update with the ID after insertion
            }
        }

        // Insert new fliers if there are any
        if (!fliersToInsert.isEmpty()) {
            insert fliersToInsert;

            // Update the map with the newly inserted fliers' Ids
            for (Flier__c f : fliersToInsert) {
                String uniqueKey = f.Name + '_' + f.Flier_Number__c;
                existingFliersMap.put(uniqueKey, f);
                flierIds.add(f.Id);
            }
        }

        // Handle Frequent Flier Details for the inserted or existing fliers
        if (!flierIds.isEmpty()) {
            Flier__c[] newInsertedFlierRecords = [SELECT Id, Flier_Number__c, Name, Last_Name__c FROM Flier__c WHERE Id IN :flierIds];

            for (Flier__c fl : newInsertedFlierRecords) {
                for (Initial_Fliers__c initFlier : newFliersList) {
                    // Match the flier by Name and Flier Number
                    if (fl.Flier_Number__c == initFlier.Frequent_Flier_Number__c && 
                        fl.Name == initFlier.First_Name__c && 
                        fl.Last_Name__c == initFlier.Last_Name__c) {

                        Frequent_Flier_Details__c fld = new Frequent_Flier_Details__c();
                        fld.Additional_Snack__c = initFlier.Additional_Snack__c;
                        fld.Arrival_Airport__c = initFlier.Arrival_Airport__c;
                        fld.Departing_Airport__c = initFlier.Departing_Airport__c;
                        fld.Checked_Bags__c = initFlier.of_Included_Checked_Bags__c;
                        fld.Flight_Delayed__c = initFlier.Flight_Delayed__c;
                        fld.Inquiry_Type__c = initFlier.Inquiry_Type__c;
                        fld.Lounge_used__c = initFlier.Lounge_used__c;
                        fld.Planned_Snack__c = initFlier.Planned_Snack__c;
                        fld.Total_Checked_Bags__c = initFlier.Total_of_Checked_Bags__c;
                        fld.Flier_Name__c = fl.Id; // Link to Flier__c record
                        fld.Name = initFlier.Most_Recent_Flight__c;

                        frequentFlierToInsert.add(fld);
                    }
                }
            }
        }

        // Insert Frequent Flier Details if there are any
        if (!frequentFlierToInsert.isEmpty()) {
            insert frequentFlierToInsert;
        }
    }
}
