public with sharing class Scenario10 {
    /* Update account description with opportunity name that has the highest amount */
    public static void updateAccDesc(List<Opportunity> OppList, Map<Id,Opportunity>OppMap) {
        Set<Ids> accIds = new Set<Ids>();
        List<Account> accToUpdate = new List<Account>();
        if(!OppList.isEmpty()){
            for(Opportunity o : OppList){
                if(OppMap != null){
                    Opportunity oldOpp = OppMap.get(o.Id);
                    if(o.Id != oldOpp.Id){
                        accIds.add(o.Id);
                        accIds.add(oldOpp.Id);
                    }elseif(oldOpp.Amount != o.Amount){
                        accIds.add(o.Id);
                    }
                }else{
                    accIds.add(o.Id);
                }
            }
        }

        if(!accIds.isEmpty()){
            List<Opportunity> relatedOpps = [Select Id, AccountId, Amount, Name From Opportunity where AccountId in : accIds and Amount!= null];
            Map<Id, Opportunity> accMap = new Map<Id,Opportunity>();
            if(!relatedOpps.isEmpty()){
                for(Opportunity o : relatedOpps){
                    if(!accMap.containsKey(o.AccountId)|| o.Amount > accMap.get(o.AccountId).Amount){
                        accMap.put(o.AccountId, o);
                    }
                }
            }
            for(Id i : accIds){
                Account acc = new Account();
                acc.Id = i;
                acc.Description = 'Opportunity with highest Amount is '+ accMap.get(i).Name;
                accToUpdate.add(acc);
            }
        }

        if(!accToInsert.isEmpty()){
            update accToUpdate;
        }
    }
}