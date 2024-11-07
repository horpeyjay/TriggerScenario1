public with sharing class DealReviewHandlerClass {

    /*
        on closed won opportunities, share the deal review records with the manager of the opportunity owner. 
    */
    public static void DealReview(List<Opportunity> closedWonOpps, Map<Id, Opportunity> oldOppMap) {

        Set<Id> oppIds = new Set<Id>();
        Set<Id> ownerIds = new Set<Id>();
        if(!closedWonOpps.isEmpty()){
            for(Opportunity newOpp : closedWonOpps){
                Opportunity opp = new Opportunity();
                if(oldOppMap != null){
                    opp = oldOppMap.get(newOpp.Id);

                    if(opp.StageName != 'Closed Won' && newOpp.StageName == 'Closed Won'){

                        oppIds.add(newOpp.Id);

                        ownerIds.add(newOpp.OwnerId);
                    }
                }
            }
        }
        List<Deal_Review__Share> shareList = new List<Deal_Review__Share>();
        if(!oppIds.isEmpty()){
            List<Deal_Review__c> reviewList = [select Id, Opportunity__c, Opportunity__r.OwnerId from Deal_Review__c where Opportunity__c IN :oppIds];

            Map<Id, Id> ownerToManagerMap = new Map<Id, Id>();

            List<User> userList = [Select Id, ManagerId From User where Id In : ownerIds ];

            For(User u : userList){
                ownerToManagerMap.put(u.Id, u.ManagerId);
            }

            for (Deal_Review__c dr : reviewList){
                Id managerId = ownerToManagerMap.get(dr.Opportunity__r.OwnerId);
                Deal_Review__Share drs = new Deal_Review__Share();
                drs.ParentId = dr.Id;
                drs.UserOrGroupId = managerId;
                drs.AccessLevel = 'Read';
                
                shareList.add(drs);
            }
        }

        if(!shareList.isEmpty()){
            insert shareList;
        }
    }
}