public with sharing class Scenario7 {
    /* Whenever the create task checkbox is checked on the case on an account, create a follow-up task on the primary contact associated with the account */
    public static void createFollowupTask(List<Case> newCaseList, Map<Id,Case> oldCaseMap) {

        Set<Id> accIds = new Set<Id>();
        Map<Id,Id> contactAccountMap = new Map<Id, Id>(); //map to store account and contact Ids
        List<Task> taskToInsert = new List<Task>();
        if(!newCaseList.isEmpty()){
            for(Case ca : newCaseList){
                if(oldCaseMap != null){
                    case oldCase = oldCaseMap.get(ca.Id);
                    if(ca.Create_Task__c == true && oldCase.Create_Task__c == false){
                        accIds.add(ca.AccountId);
                    }
                }else{
                    accIds.add(ca.AccountId);
                }
            }
        }

        if(!accIds.isEmpty()){
            List<Contact> primaryCon = [Select Id, AccountId, Primiary_Contact__c From Contact where AccountId in : accIds and Primiary_Contact__c = true Order by LastModifiedDate Limit 1];

            for(Contact c : primaryCon){
                contactAccountMap.put(c.AccountId, c.Id);
            }

            for (Case ca : newCaseList){
                if(ca.Create_Task__c == true && contactAccountMap.containsKey(ca.AccountId)){
                    Task taskObject = new Task();
                    taskObject.Subject = 'Follow-Up';
                    taskObject.WhatId = ca.Id;
                    taskObject.WhoId = contactAccountMap.get(ca.AccountId);
                    taskObject.Status = 'Not Started';
                    taskObject.ActivityDate = Date.today() + 3;
                    taskObject.Priority = 'Normal';
                    taskToInsert.add(taskObject);
                }
            }
        }

        if(!taskToInsert.isEmpty()){
            insert taskToInsert;
        }
    }
}