public with sharing class ContactPremiumHandlerClass {
    public static void contactUpdate(List<Contact> newList, Map<Id, Contact> oldMap){
        Set<Id> accIds = new Set<Id>();
        if(!newList.isEmpty()){
            Contact oldCon = new Contact();
            for(Contact con : newList){
                
                if(oldMap != null){
                    oldCon = oldMap.get(con.Id);
                    if(oldCon.AccountId != con.AccountId){
                        accIds.add(con.AccountId);
                        accIds.add(oldCon.AccountId);
                    }
                }else{
                    accIds.add(con.AccountId);
                }
            }
        }
        List<Case> casesToInsert = new List<Case>();
        if(!accIds.isEmpty()){
            Map<Id, Account> premiumAccountMap = new Map<Id, Account>([Select Name, Id, Type, OwnerId From Account where Type = 'Premium' and Id in : accIds]);

            for(Contact con : newList){
                if(premiumAccountMap.containsKey(con.AccountId)){
                    Account acc = premiumAccountMap.get(con.AccountId);
                    Case newCase = new Case();
                    newCase.Subject = 'New Contact Added: ' + con.LastName;
                    newCase.Description = 'The Contact with the name : ' + con.LastName +' , '+ con.FirstName + ' has been added to the account: ' + acc.Name;
                    newCase.ContactId = con.Id;
                    newCase.AccountId = con.AccountId;
                    newCase.OwnerId = acc.OwnerId;
                    casesToInsert.add(newCase);
                }
            }
        }

        if(!casesToInsert.isEmpty()){
            insert casesToInsert;
        }
    }
}