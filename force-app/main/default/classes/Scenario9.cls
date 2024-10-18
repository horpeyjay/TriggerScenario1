public with sharing class Scenario9 {
    /* Update related Contacts with the lastest country value on account whenever it changes */
    public static void countryUpdates(List<Account> accLists, Map<Id,Account> oldAccMap) {

        Set<Id> accIds = new Set<Id>();
        Map<Id,Account> accMap = new Map<Id,Account>();
        if(!accLists.isEmpty()){
            for(Account a : accLists){

                if(oldAccMap != null){
                    Account oldAcc = oldAccMap.get(a.Id);
                    if(a.Country__c != oldAcc.Country__c){
                        accIds.add(a.Id);
                    }
                }else{
                    accIds.add(a.Id);
                }
            }
            accMap.put(a.Id, a);
        }
        List<Contact> insertContact = new List<Contact>();
        if(!accMap.isEmpty()){
            List<Contact> conList = [Select Id, Account_Country__c, AccountId From Contact where AccountId In : accMap.keySet()];

            if(!conList.isEmpty()){
                for(Contact c : conList){
                    if(AccMap.containsKey(c.AccountId)){
                        c.Account_Country__c = accMap.get(c.AccountId).Country__c;
                        insertContact.add(c);
                    }
                }
            }
        }

        if(!insertContact.isEmpty()){
            update insertContact;
        }
    }
}