public with sharing class OpportunityHandlerClass {
    public static void oneOppDaily(List<Opportunity> oppsList){

        Map<Id, List<Opportunity>> accIdToOppsMap = new Map<Id, List<Opportunity>>();
        if(!oppsList.isEmpty()){
            for(Opportunity opp : oppsList){
                if(opp.AccountId != null){
                    if(accIdToOppsMap.containsKey(opp.AccountId)){
                        accIdToOppsMap.get(opp.AccountId).add(opp);
                    }else{
                        accIdToOppsMap.put(opp.AccountId, new List<Opportunity>{opp});
                    }
                }
            }
        }

        List<Opportunity> existingOpps = [Select AccountId, CreatedDate From Opportunity Where AccountId in : accIdToOppsMap.keySet() And CreatedDate >= :Date.today() And CreatedDate < :Date.today().addDays(1)];

        Set<Id> accountWithOpps = new Set<Id>();

        for(Opportunity opp : existingOpps){
            accountWithOpps.add(opp.AccountId);
        }

        for(Opportunity opp : oppsList){
            if(opp.AccountId != null && accountWithOpps.contains(opp.AccountId)){
                opp.addError('Only one opportunity can be created per day');
            }else if(opp.AccountId != null && accIdToOppsMap.get(opp.AccountId).size()> 1){
                opp.addError('You are attempting to add multiple opportunity. Only one opportunity can be created per day');
            }
        }
    }
}