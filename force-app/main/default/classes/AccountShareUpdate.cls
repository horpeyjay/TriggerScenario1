public with sharing class AccountShareUpdate {
    /* Write a trigger to manage account sharing with secondary owners. The triggers should grant access to the secondary owner when the account is create ro update and sure that access transferred when the seconddary owner chages removing access for the old owner and granting it to the new owner */ 
    public static void createSharingAccount(List<Account> accList) {
        List<AccountShare> sharingRecords = new List<AccountShare>();
        if(!accList.isEmpty()){
            for(Account acc : accList){
                if(acc.Secondary_Owner__c != null){
                    AccountShare accShare = new AccountShare();
                    accShare.AccountId = acc.Id;
                    accShare.UserOrGroupId = acc.Secondary_Owner__c;
                    accShare.AccountAccessLevel = 'Read';
                    accShare.OpportunityAccessLevel = 'None';
                    sharingRecords.add(accShare);
                }
            }
        }
        if(!sharingRecords.isEmpty()){

            try{
                insert sharingRecords;
            }catch(Exception ex){
                System.debug('Exception Message: '+ex.getMessage());
            }
        }
    }

    //second method for update
    public static void updateSharingAccount(Map<Id,Account> accOldMap, Map<Id,Account> accNewMap){
        List<AccountShare> deleteSharingAccount = new List<AccountShare>();
        List<AccountShare> newSharingAccount = new List<AccountShare>();
        Set<Id> accIds = new Set<Id>();

        for(Id accountId : accNewMap.keySet()){
            Account oldAcc = accOldMap.get(accountId);
            Account newAcc = accNewMap.get(accountId);

            if(oldAcc.Secondary_Owner__c != newAcc.Secondary_Owner__c){
                accIds.add(oldAcc.Id);
            }
        }
        if(!accIds.isEmpty()){
            List<AccountShare> existingShare = [Select Id, AccountId, UserOrGroupId From AccountShare where AccountId In : accIds];

            Map<Id, AccountShare> existingShareMap = new Map<Id, AccountShare>();

            for(AccountShare accShare : existingShare){
                existingShareMap.put(accShare.AccountId, accShare);
            }

            for(Id accId : accIds){
                Account oldAcc = accOldMap.get(accId);
                Account newAcc = accNewMap.get(accId);

                if(oldAcc.Secondary_Owner__c != null){
                    AccountShare oldShare = existingShareMap.get(oldAcc.Id);

                    if(oldShare != null && oldShare.UserOrGroupId == oldAcc.Secondary_Owner__c){
                        deleteSharingAccount.add(oldShare);
                    }

                    if(newAcc.Secondary_Owner__c != null){
                        AccountShare accShare = new AccountShare();
                        accShare.AccountId = newAcc.Id;
                        accShare.UserOrGroupId = newAcc.Secondary_Owner__c;
                        accShare.AccountAccessLevel = 'Read';
                        accShare.OpportunityAccessLevel = 'None';
                        newSharingAccount.add(accShare);
                    }
                }
            }
        }

        if(!deleteSharingAccount.isEmpty()){
            delete deleteSharingAccount;
        }

        if(!newSharingAccount.isEmpty()){
            insert newSharingAccount;
        }
    }
}