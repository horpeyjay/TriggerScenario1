public with sharing class Scenario23 {
    /* Calculate the highest time for which the order stayed in a particular stage */
    public static void highestTimeOrder(List<Order__c> orderList, Map<Id, Order__c> orderMap) {
        Map<Id, String> infoMap = new Map<Id, String>();
        List<Order__c> orderToUpdate = new List<Order__c>();
        
        if (!orderList.isEmpty()) {
            for (Order__c order : orderList) {
                if (orderMap != null) {
                    Order__c oldOrder = orderMap.get(order.Id);
                    
                    // Check if the stage has changed
                    if (order.Stage__c != oldOrder.Stage__c) {
                        Datetime lastChangeDate = oldOrder.Last_Stage_Change__c;

                        // If Last_Stage_Change__c is null, use CreatedDate
                        if (lastChangeDate == null) {
                            lastChangeDate = oldOrder.CreatedDate;
                        }

                        // Calculate the time spent in the previous stage in minutes
                        Long timeSpent = (Datetime.now().getTime() - lastChangeDate.getTime()) / 60000;
                        
                        String maximumTime = oldOrder.Stage__c + ' : ' + timeSpent + ' minutes';
                        
                        System.debug('Calculated timeSpent: ' + timeSpent);
                        System.debug('Max Time String: ' + maximumTime);
                        
                        // Handle the case where Max_Time_In_Stage__c is null
                        if (order.Max_Time_In_Stage__c == null) {
                            infoMap.put(order.Id, maximumTime);
                        } else {
                            if (!infoMap.containsKey(order.Id)) {
                                infoMap.put(order.Id, order.Max_Time_In_Stage__c);
                            }
                            
                            // Split the existing max time carefully and handle parsing
                            String[] existingMaxTime = infoMap.get(order.Id).split(':');
                            if (existingMaxTime.size() == 2) {
                                try {
                                    Long existingTime = Long.valueOf(existingMaxTime[1].split(' ')[0]);
                                    System.debug('Existing Max Time in Stage: ' + existingTime);
                                    
                                    if (timeSpent > existingTime) {
                                        infoMap.put(order.Id, maximumTime);
                                    }
                                } catch (Exception e) {
                                    System.debug('Error parsing existing time: ' + e.getMessage());
                                }
                            }
                        }
                        
                        // Update the Last_Stage_Change__c field with the current datetime
                        order.Last_Stage_Change__c = Datetime.now();
                        orderToUpdate.add(order);
                    }
                }
            }

            // Update the Max_Time_In_Stage__c field for the orders to update
            for (Order__c order : orderToUpdate) {
                if (infoMap.containsKey(order.Id)) {
                    order.Max_Time_In_Stage__c = infoMap.get(order.Id);
                }
            }
        }
    }
}
