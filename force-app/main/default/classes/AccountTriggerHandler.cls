public class AccountTriggerHandler {
    public static void CreateAccounts(List<Account> newAccounts){
        if(!newAccounts.isEmpty()){
            for(Account a : newAccounts){
                a.ShippingState = a.BillingState;
            }
        }
    }

    public static void preventContactDeletion(List<Account> accList){
        /**
         * Author: Oni Opeyemi
         * Task: Prevent Deletion of Related Contacts when the parent account is deleted
         */
        Set<Id> accIds = new Set<Id>();
        if(!accList.isEmpty()){
            for(Account a : accList){
                accIds.add(a.Id);
            }
        }
        List<Contact> contactsToUpdate = new List<Contact>();
        try{
            List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accIds];
            for(Contact c : contacts){
                c.AccountId = null;
                contactsToUpdate.add(c);
            }
        }catch(Exception e){
            System.debug('Error: '+e.getMessage());
        }

        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }

    Public static void preventAccUpdateIn1Hour(List<Account> newAccList, Map<Id, Account> oldAccountMap){
        /**
         * Author: Oni Opeyemi
         */
        if(!newAccList.isEmpty()){
            for(Account acc : newAccList){
                Account oldAcc = oldAccountMap.get(acc.Id);
                if(oldAcc != null && oldAcc.LastModifiedDate.addHours(1) > system.now()){
                    acc.addError('you cannot update this account within 1 hour from the last modification');
                }
            }
        }
    }
    
}