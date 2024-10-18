public with sharing class Scenario24 {
    /* if Task priority is high, assign it to account owner manager else, assign it to user whose manager is the account owner */
    public static void taskAssign(List<Task>taskList) {

        Set<Id> accIds = new Set<Id>();
        if(!taskList.isEmpty()){
            for(Task t : taskList){
                if(t.WhatId != null && String.valueOf(t.WhatId).startsWith('001')){
                    accIds.add(t.WhatId);
                }
            }
        }
        if(!accIds.isEmpty()){
            List<Account> accList = [Select Id, ownerId, owner.ManagerId From Account where Id in : accIds];

            Map<Id,Account> accMap = new Map<Id,Account>();
            Set<Id> userIds = new Set<Id>();

            for(Account a : accList){
                accMap.put(a.Id, a);
                userIds.add(a.OwnerId);
            }
            Map<Id, List<User>> usersManager = new Map<Id, List<User>>();
            for(User u : [Select Id, ManagerId from User where ManagerId in : userIds and isActive = TRUE]){
                if(!usersManager.containsKey(u.ManagerId)){
                    usersManager.put(u.ManagerId, new List<User>(u));
                }
                usersManager.get(u.ManagerId).add(u);
            }

            for(Task trcd : taskList){
                if(accMap.containsKey(trcd.WhatId)){
                    Account accRecord = accMap.get(trcd.WhatId);
                    if(trcd.Priority == 'High'){
                        trcd.OwnerId = accRecord.Onwer.ManagerId;
                    }else if(trcd.Priority == 'Low' || trcd.Priority == 'Normal'){
                        List<User> users = usersManager.get(accRecord.OwnerId);
                        if(users != null && users.size() > 0){
                            trcd.OwnerId = users.get(0).Id;
                        }
                    }
                }
            }
        }
    }
}