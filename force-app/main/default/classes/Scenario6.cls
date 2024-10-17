public with sharing class Scenario6 {
    /* Create a related contact when the create contact checkbox is ticked on account update or insert */
    public static void createRelContact(List<Account> accList, Map<Id,Account>accMap) {
        Set<Id> accIds = new Set<Id>();
        List<Contact> conToInsert = new List<Contact>();
        if(!accList.isEmpty()){
            
            for(Account acc : accList){
                if(accMap != null){
                    Account oldAcc = accMap.get(acc.Id);
                    if(acc.Create_Contact__c == true && oldAcc.Create_Contact__c == false){
                        accIds.add(acc.Id);
                    }
                }else{
                    accIds.add(acc.Id);
                }  
                Contact con = new Contact(FirstName = acc.Name, LastName = 'Contact', Phone = acc.Phone, AccountId = acc.Id);
                conToInsert.add(con);
            }
            
        }

        if(!conToInsert.isEmpty()){
            insert conToInsert;
        }
    }
}