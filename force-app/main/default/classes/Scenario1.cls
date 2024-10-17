public with sharing class Scenario1 {
/*
    Whenever the opp type get updated then insert a new oppContactRole according to the opportunity type. Delete the existing oppConRole and if no contact present with the same type, then show error
*/
    public static void oppConRole(List<Opportunity> newOppList, Map<Id, Opportunity> OldOppMap) {

        Map<Id,String> oppTypeMap = new Map<Id,String>();
        Set<Id> accIds = new Set<Id>();
        Map<String,Contact>oppConMap = new Map<String, Contact>();
        if(!newOppList.isEmpty()){
            for(Opportunity o : newOppList){
                Opportunity oldopp = OldOppMap.get(o.Id);
                if(o.AccountId != null && o.Type__c != oldopp.Type__c){
                    accIds.add(o.AccountId);
                    oppTypeMap.put(o.Id, Type__c);
                }
            }
        }
        if(!accIds.isEmpty() && !oppTypeMap.isEmpty()){
            List<Contact> relContact = [Select Id, Type__c From Contact where AccountId in : accIds and Type__c in : oppTypeMap.values() order by LastModifiedDate Limit 1];
            for(Contact c : relContact){
                oppConMap.put(c.Type__c, c);

            }

            for(Opportunity opp : newOppList){
                if(oppTypeMap.containsKey(opp.Id)){
                    contact conType = oppConMap.get(opp.Type__c);

                    if(conType != null){
                        OpportunityContactRole oppconRole = new OpportunityContactRole();
                        oppconRole.OpportunityId = opp.Id;
                        oppconRole.ContactId = conType.Id;
                        newList.add(oppconRole);
                    }else{
                        opp.addError('No contact found with the type:' + opp.Type__c);
                    }
                }
            }
            if(!newList.isEmpty()){
                List<OpportunityContactRole> existingRole = [Select Id from OpportunityContactRole where OpportunityId in : oppTypeMap.keySet()];
                if(!existingRole.isEmpty()){
                    delete existingRole;
                }
                insert newList;
            }
        }
        List<OpportunityContactRole> newList = new List<OpportunityContactRole>();
    }
}