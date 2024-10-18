public with sharing class Scenario14 {
    /* when an account gets updated, send an email to the account's owner with the details of the contacts modified between the last update and current update of account */
    public static void sendEmailOnUpdateContact(List<Account> accList, Map<Id,Account> oldAccountMap) {
        Map<Id, Datetime> accountLastUpdateMap = new Map<Id, Datetime>();
        Set<Id> ownerIds = new Set<Id>();
        Account oldAcc = new Account();
        if(!accList.isEmpty()){
            for (Account a : accList){
                if(oldAccountMap != null){
                    oldAcc = oldAccountMap.get(a.Id);

                    if (a.LastModifiedDate != oldAcc.LastModifiedDate){
                        accountLastUpdateMap.put(a.Id, oldAcc.LastModifiedDate);
                        ownerIds.add(a.OwnerId);
                    }
                }
            }
        }

        if(!accountLastUpdateMap.isEmpty()){
            List<Contact> updatedCons = [Select Id, LastModifiedDate, AccountId, Name From Contact where AccountId in : accountLastUpdateMap.keySet() and LastModifiedDate > : accountLastUpdateMap.values() and LastModifiedDate <= :System.now()];

            string body = 'The following contacts  were updated: \n';
            for (Contact con : updatedCons){
                body += 'Name ' + con.Name ='\n'; 
            }
            Map<Id, User> ownerIdMap = new Map<Id, User>([Select Id, Email from User where Id in : ownerIds]);
            Map<Id, String> accountOwnerEmail = new Map<Id,String>();
            for(Account acc : accList){
                if(ownerIdMap.containsKey(acc.OwnerId)){
                    accountOwnerEmail.put(acc.Id, ownerIdMap.get(acc.OwnerId).Email);
                }
            }
            List<Messaging.SingleEmailMessage> emails = new List<messaging.SingleEmailMessage>();
            for(Id accId : accountOwnerEmail.keySet()){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>(accountOwnerEmail.get(accId)));
                email.setSubject('Update contacts in your account');
                email.setPlainTextBody(body);
                emails.add(email);
            }
            Messaging.sendEmail(emails);
        }
    }
}