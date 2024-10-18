public with sharing class Scenario16 {
    /* Whenever a contact is inserted on an account, ensur that the new contact checkbox is check for the recently inserted contact while other related contact shoul have theirs unchecked*/
    public static void checkboxtrigger(List<Contact> conList) {

        Set<Id> accIds = new Set<Id>();
        Map<Id, Contact> recentConMap = new Map<Id, Contact>();
        List<Contact> contactsToUpdate = new List<Contact>();
        if(!conList.isEmpty()){
            for(Contact c : conList){
                if(c.AccountId != null && c.New_Contact__c == false){
                    accIds.add(c.AccountId);
                }
            }
        }

        if(!accIds.isEmpty()){
            List<Contact> RelatedCon = [Select Id, AccountId, New_Contact__c From Contact where AccountId in : accIds order by CreatedDate DESC];
            for (Contact con : RelatedCon){
                if(!recentConMap.containsKey(con.AccountId)){
                    recentConMap.put(con.AccountId, con);
                }
            }

            for (Contact c :RelatedCon){
                Contact conObject = recentConMap.get(c.AccountId);
                if(conObject.Id == c.Id && c.New_Contact__c == false){
                    c.New_Contact__c = true;
                    contactsToUpdate.add(c);
                }else{
                    if(c.New_Contact__c == true){
                        c.New_Contact__c = false;
                        contactsToUpdate.add(c);
                    }
                }
            }
        }
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }
}