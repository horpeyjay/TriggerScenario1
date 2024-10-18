public with sharing class Scenario5 {
    /* Prevent Deactivation of Account which have active Contacts */
    public static void preventDeactivateAccount(Map<Id, Account> newAccMap, Map<Id, Account> oldAccMap) {
        Set<Id> accIds = new Set<Id>();
        for(Contact con : [Select AccountId from Contact where AccountId in: newAccMap.keySet() And IsActive = true]){
            accIds.add(con.AccountId);
        }

        for(Account acc : newAccMap.values()){
            Account oldAcc = oldAccMap.get(acc.Id);
            if(oldAcc.Status__c == 'Active'){
                if(acc.Status__c == 'Inactive' && accIds.contains(acc.Id)){
                    acc.addError('You can not Deactivate an Account with active contacts');
                }
            }
        }
    }
}