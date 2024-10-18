public with sharing class Scenario18 {
    /* update account description field with the second highest amount from related opportunities */
    public static void updateAccDesc(List<Opportuntiy> oppList, Map<Id, Opportunity> oppMap) {
        Set<Id> accountIds = new Set<Id>();
        List<Account> accsToUpdate = new List<Account>();
        if(!oppList.isEmpty()){
            for(Opportunity o : oppList){
                if(oppMap != null){
                    Opportunity oldOpp = oppMap.get(o.Id);
                    if(o.Amount != oldOpp.Amount){
                        accountIds.add(o.AccountId);
                    }else if(o.AccountId != oldOpp.AccountId){
                        accountIds.add(o.Id);
                        accountIds.add(oldOpp.Id);
                    }
                }else if(o.AccountId != null && o.Amount != null){
                    accountIds.add(o.Id);
                }
            }
        }
        if(!accountIds.isEmpty()){
            Decimal highestAmount = 0;
            Decimal secondHighestAmount = 0;
            for(Opportunity opp : [Select Id, AccountId, Amount From Opportunity where AccountId in : accountIds]){
                if(opp.Amount > highestAmount){
                    secondHighestAmount = highestAmount;
                    highestAmount = opp.Amount;
                }else if(opp.Amount > secondHighestAmount && opp.Amount < highestAmount){
                    secondHighestAmount = opp.Amount;
                }
            }
            List<Account> accList = [Select Id, Description From Account where Id in : accountIds];
            if(!accList.isEmpty()){
                for(Account a : accList){
                    a.Description = ' The Second Highest Amount: ' + secondHighestAmount;
                    accsToUpdate.add(a);
                }
            }
        }
        if(!accsToUpdate.isEmpty()){
            update accsToUpdate;
        }
    }
}