public with sharing class Scenario2 {
    /*Whenever the Escalation required checkbox is checked for a case, a follow-up task is created for the primary contact on Account */
    public static void taskContact(List<Case> caseList, Map<Id, Case> oldCaseMap) {

        Set<Id> accIds = new Set<Id>();
        Map<Id, Contact> conMap = new Map<Id, Contact>();
        List<Task> insertTask = new List<Task>();
        if(!caseList.isEmpty()){
            for(Case ca : caseList){
                Case oldCase = oldCaseMap.get(ca.Id);
                if(ca.Escalation_Required__c == true && ca.AccountId != null && oldCase.Escalation_Required__c == false){
                    accIds.add(ca.AccountId);
                }
            }
        }

        if(!accIds.isEmpty()){
            List<Contact> contactList = [Select Id, AccountId, Primary_Contact__c From Contact where AccountId in : accIds and Primary_Contact__c = true Order by LastModifiedDate Limit 1];

            for (Contact c : contactList){
                conMap.put(c.AccountId, con);
            }
            for(Case ca : caseList){
                if(!conMap.isEmpty() && conMap.containsKey(ca.AccountId)){
                    Contact primaryCon = conMap.get(ca.AccountId);
                    Task taskObject = new Task();
                    taskObject.Subject = 'Escalation';
                    taskObject.WhatId = ca.Id;
                    taskObject.WhoId = primaryCon.Id;
                    taskObject.Status = 'Not Started';
                    taskObject.Priority = 'High';
                    taskObject.Description = 'Escalation Required';
                    insertTask.add(taskObject);
                }
            }
        }
        try{
            if(!insertTask.isEmpty()){
                insert insertTask;
            }
        }catch(Exception e){
            System.debug('Error occured while inserting the task --> ' + e.getMessage());
        }
    }
}