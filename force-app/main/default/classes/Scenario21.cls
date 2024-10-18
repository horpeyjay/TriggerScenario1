public with sharing class Scenario21 {
    /* Create a task and send an email to account owner whenever a case is deleted from an account */
    public static void deleteCase(List<Case>caseList) {

        Set<Id> ownerIds = new Set<Id>();
        Set<Id> accIds = new Set<Id>();
        List<Task> tasksToInsert = new List<Task>();
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

        if(!caseList.isEmpty()){
            for (Case ca : caseList){
                if(ca.AccountId != null){
                    accIds.add(ca.AccountId);
                }
            }
        }

        if(!accIds.isEmpty()){
            Map<Id,Account> accMap = new Map<Id,Account>([Select Id, Owner.Email, Name From Account where Id in : accIds]);

            for(Case caRcd : caseList){
                if(caRcd.AccountId != null && accMap.containsKey(caRcd.AccountId)){
                    Account acc = accMap.get(caRcd.AccountId);
                    Task newTask = new Task ();
                    newTask.Subject = 'Case Delete : ' + caRcd.CaseNumber;
                    newTask.Description = 'A case has been deleted from ' + accMap.get(caRcd.AccountId).Name + ' account';
                    newTask.WhatId = acc.Id;
                    newTask.OwnerId = acc.OwnerId;
                    newTask.Status = 'Not Started';
                    newTask.Priority = 'Normal';

                    tasksToInsert.add(newTask);

                    if (acc.Owner.Email != null){
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                        String body = 'Hello, \n A case with Account ' + acc.Name + ' was deleted ';
                        email.setToAddresses(new List<String>{acc.Owner.Email});
                        email.setSubject('Case deleted : ' + acc.Name);
                        email.setPlainTextBody(body);
                        emails.add(email);
                    }
                }
            }
        }
        if(!tasksToInsert.isEmpty()){
            insert tasksToInsert;
        }

        if(!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }
    }
}