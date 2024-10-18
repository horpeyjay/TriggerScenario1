trigger Scenario3 on User (after update) {
    List<Id> inactiveUserIds = new List<Id>();

    for(User u : trigger.new){
        if(u.isActive == false && trigger.oldMap.get(u.Id).isActive == true){
            inactiveUserIds.add(u.id);
        }
    }
    Map<Id,Id> managerIdMap = new Map<Id,Id>(); //Manager Id is value and user Id is key
    if(inactiveUserIds.isEmpty()){
        return;
    }
    for (User u : [SELECT Id,ManagerId from User where Id in : inactiveUserIds]){
        if(u.ManagerId != null){
            managerIdMap.put(u.Id, u.ManagerId);
        }
    }
    if(managerIdMap.isEmpty()){
        return;
    }

    Scenario3.inactiveUser(inactiveUserIds, managerIdMap);
}