public with sharing class Scenario4 {
    /* Show Max Opportunity Closed Amount with using the aggregate function */
    public static void trackAmount(List<Opportunity> oppList, Map<Id, Opportunity> oppMap) {
        Set<Id> accIds = new Set<Id>();
        if(!oppList.isEmpty()){
            for(Opportunity o : oppList){
                if(oppMap != null){
                    oldOpp = oppMap.get(o.Id);
                    if(o.AccountId != oldOpp.AccountId){
                        accIds.add(o.AccountId);
                        accIds.add(oldOpp.AccountId);
                    }else{
                        accIds.add(o.AccountId);
                    }
                }else{
                    accIds.add(o.AccountId);
                }
            }
        }
        if(!accIds.isEmpty()){
            List<Opportunity> relatedOpps = [Select Id, AccountId, Amount From Opportunity Where AccountId In : accIds And isClosed = true];
            Map<Id, Decimal> AccOppAmountMap = new Map<Id,Decimal>(); //Map to store account Id and the max opportuity amount
            for (Opportunity o : relatedOpps){
                Decimal maxAmount = AccOppAmountMap.get(o.AccountId);

                if(maxAmount == null || maxAmount < o.Amount){
                    AccOppAmountMap.put(o.AccountId, o.Amount);
                }
            }
        }
        List<Account> accToUpdate = new List<Account>();
        for(Id accId : accIds){
            Decimal maxAmount = AccOppAmountMap.get(accId);

            Account acc = new Account(Id = accId, Max_Closed_Opportunity_Amount__c = maxAmount);

            accToUpdate.add(acc);
        }

        if(!accToUpdate.isEmpty()){
        update accToUpdate;
        }
    }
}