public with sharing class Scenario3 {
    /* Whenever a user get deactivated, assign all open opportunity records to the manager */
    @future
    public static void inactiveUser(List<Id> userIdList, Map<Id, Id> managerIdMap) {
        //Because setup objects(user, profiles) can't be modified in the same dml transactions as non-setup object(account, opportunity, case), I had to use future method for this task.
        List<Opportunity> oppsUpdate = new List<Opportunity>();
        for(Opportunity opp : [SELECT Id, Name, OwnerId FROM Opportunity WHERE StageName != 'Closed Won' AND StageName != 'Closed Lost' AND OwnerId IN :userIdList]){
            Id newownerId = managerIdMap.get(opp.OwnerId);
            if(newownerId != null){
                opp.OwnerId = newOwnerId;
                oppsUpdate.add(opp);
            } 
        }
        try{
            if(!oppsUpdate.isEmpty()){
                update oppsUpdate;
            }
        }catch(Exception ex){
            system.debug('Something went wrong while performing DML operation -->' + ex.getMessage());
        }
    }
}