public with sharing class Scenario22 {
    /* calculate how much time a particular order has spend on a particular stage through out the order journey */
    public static void timePerStage(List<Order__c> orderList, Map<Id, Order__c> orderMap) {

        if(!orderList.isEmpty()){

            for(Order__c o : orderList){
                if(orderMap != null){
                    Order__c oldOrder = orderMap.get(o.Id);
                    if(o.Stage__c != oldOrder.Stage__c){
                        Datetime lastChangeDate = oldOrder.Last_Stage_Change__c;
                        if(oldOrder.Last_Stage_Change__c == null){
                            lastChangeDate = oldOrder.CreatedDate;
                        }
                        Long timeSpent = (Datetime.now().getTime() - lastChangeDate.getTime())/60000;

                        String stageEntries = '\n'+ Datetime.now().format() +' : changed from "'+ oldOrder.Stage__c + '" to "'+o.Stage__c+'". Time in previous stage  : ' + timeSpent + ' minutes.\n';

                        if(o.Stage_History__c == null){
                            o.Stage_History__c = stageEntries;
                        }else{
                            o.Stage_History__c += stageEntries;
                        }

                        o.Last_Stage_Change__c = Datetime.now();
                    }
                }
            }
        }
    }
}