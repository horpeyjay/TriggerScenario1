public with sharing class Scenario25 {
    /* when an opp record is deleted, all related task associated with the opportunity should be moved to another opportunity under the same account if one exists. if no other opportunity exists under the same account, then delete those related task as well */
    public static void oppTask(List<Opportunity>oppList) {
        Set<Id> accountIds = new Set<Id>();
        Map<Id,Opportunity> delOpps = new Map<Id, Opportunity>();
        List<Task> taskToUpdate = new List<Task>();
        List<Task> taskToDelete = new List<Task>();
        if(!oppList.isEmpty()){
            for(Opportunity opp : oppList){
                if(opp.AccountId != null){
                    accountIds.add(opp.AccountId);
                    delOpps.put(opp.Id, opp);
                }
            }
        }
        List<Task>relTask = [Select Id, WhatId from Task where WhatId in : delOpps.keySet()];

        if(!relTask.isEmpty()){
            List<Opportunity> openOpps = [Select Id, AccountId From Opportunity where AccountId In : accountIds and isClosed = false and Id not in : delOpps.keySet()];

            Map<Id, Opportunity> accToOppMap = new Map<Id, Opportunity>(); //map to store account Id and open opportunities

            for(Opportunity opp : openOpps){
                accToOppMap.put(opp.AccountId, opp);
            }

            //iterate over the related task
            for(Task t : relTask){
                Opportunity delOpprelated = delOpps.get(t.WhatId);
                if(delOpprelated != null && accToOppMap.containsKey(delOpprelated.AccountId)){
                    t.WhatId = accToOppMap.get(delOpprelated.AccountId).Id;
                    taskToUpdate.add(t);
                }else{
                    taskToDelete.add(t);
                }
            }
        }
        

        if(!taskToUpdate.isEmpty()){
            update taskToUpdate;
        }
        if(!taskToDelete.isEmpty()){
            delete taskToDelete;
        }
    }
}