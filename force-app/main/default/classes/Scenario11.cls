public with sharing class Scenario11 {
    /* when a contact is inserted on an account, check if the account has existing opportunities. if so update account description with the total amount of opps founds. if not create a new opp */
    public static void createOppsCon(List<Contact> conList) {
        Set<Id> accIds = new Set<Id>();
        if(!conList.isEmpty()){
            for(Contct c : conList){
                if(c.AccountId != null){
                    accIds.add(c.AccountId);
                }
            }
        }
        List<Account> accDetails = [Select Id, Description, Name From account where Id in :accIds];
        Map<Id, Decimal> oppAmountMap = new Map<Id, Decimal>();
        List<Account> accToUpdate = new List<Account>();
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        if(!accIds.isEmpty()){
            List<Opportunity> oppList = [Select Id, AccountId, Amount From Opportunity where AccountId in : accIds];

            if(!oppList.isEmpty()){
                for(Opportunity o : oppList){
                    if(oppAmountMap.containsKey(o.AccountId)){
                        oppAmountMap.put(o.AccountId, oppAmountMap.get(o.AccountId).Amount + o.Amount);
                    }else{
                        oppAmountMap.put(o.AccountId, oppAmountMap.get(o.AccountId).Amount);
                    }
                }

                for(Account acc : accDetails){
                    if(oppAmountMap.containsKey(acc.Id)){
                        acc.Description ='Total Opportunity amount is' + oppAmountMap.get(acc.Id);
                        accToUpdate.add(acc);
                    }
                }
            }
            if(accToUpdate.size() > 0){
                update accToUpdate;
            }
        }else{
            for(Account acc : accDetails){
                Opportunity newOpp = new Opportunity(Name = 'Test '+acc.Name, StageName = 'Closed Won', CloseDate = Date.today() + 15, AccountId = acc.Id, Amount = 100);
                oppsToInsert.add(newOpp);
                acc.Description = 'Inserted Opportunity Amount is '+ newOpp.Amount;
                accToUpdate.add(acc);
            }
        }
        if(oppsToInsert.size() > 0){
            insert oppsToInsert;
        }
        if(!accToUpdate.isEmpty()){
            update accToUpdate;
        }
    }
}