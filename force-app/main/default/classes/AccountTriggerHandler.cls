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
}