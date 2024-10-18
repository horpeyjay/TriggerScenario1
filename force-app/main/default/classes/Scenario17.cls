public with sharing class Scenario17 {
    /* When a contact is inserted, deleted or updated, then all related contact names and created date will be populated in the Parenct Account Description. Also, on update or delete of the parent , the existing contact will be updated or removed from the description */
    public static void contactUpdate(List<Contact> conList, Map<Id, Contact> conMap) {

        Set<Id> accIds = new Set<Id>();

        List<Account> accToUpdate = new List<Account>();

        if(!conList.isEmpty()){
            for(Contact con : conList){

                if(conMap != null){
                    oldCon = conMap.get(con.Id);
                    if(con.AccountId != oldCon.AccountId){
                        accIds.add(con.AccountId);
                        accIds.add(oldCon.AccountId);
                    }else{
                        accIds.add(con.AccountId);
                    }
                }else{
                    accIds.add(con.AccountId);
                }
            }
        }

        if(!accIds.isEmpty()){
            Map<Id, List<String>> accToContactInfo = new Map<Id, List<String>>();
            for(Contact c : [Select Id, Name, AccountId, CreatedDate from Contact where AccountId In : accIds]){
                String contactInfo = 'Contact Name is ' + c.Name + ' while the Created Date is ' + c.CreatedDate + '\n';
                if(!accToContactInfo.containsKey(c.AccountId)){
                    accToContactInfo.put(c.AccountId, new List<String>{contactInfo});
                }else{
                    accToContactInfo.get(c.AccountId).add(contactInfo);
                }
            }

            for(Id i : accIds){
                Account acc = new Account();
                acc.Id = i;

                if(accToContactInfo.containsKey(i)){
                    acc.Description = String.join(accToContactInfo.get(i), '');
                }else{
                    acc.Description = 'No related Contacts';
                }

                accToUpdate.add(acc);
            }
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
}