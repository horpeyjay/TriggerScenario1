public with sharing class EventHandlerClass {
    /**
     * Author: horpeyjay
     * Task: Write a scenario to update the capacity of an event based on its DIstributions and set the status of the event distribution to waiting if the capacity is insufficient. 
     */
    public static void handleFullCapacity(List<Event_Distribution__c> eventDistriList) {
        Set<Id> eventIds = new Set<Id>();
        if(!eventDistriList.isEmpty()){
            for(Event_Distribution__c ed: eventDistriList){
                if(ed.Event__c != null){
                    eventIds.add(ed.Event__c);
                }
            }
        }
        Map<Id, Event__c> eventMap = new Map<Id, Event__c>([Select Id, Event_Capacity__c From Event__c where Id in : eventIds]);
        for(Event_Distribution__c ed: eventDistriList){
            Event__c parentEvent = eventMap.get(ed.Event__c);

            if(parentEvent != null){
                if(parentEvent.Event_Capacity__c == 0){
                    ed.Status__c = 'Waiting';
                }else{
                    
                    if(parentEvent.Event_Capacity__c < ed.Distribution__c){
                        ed.Status__c = 'Waiting';
                        ed.Distribution__c.addError('Event capacity is full. Kindly reduce the participants to avoid overcrowding');
                    }else{
                        parentEvent.Event_Capacity__c -= ed.Distribution__c;
                        ed.Status__c = 'Confirmed';
                    }
                }
            }
        }

        if(!eventMap.isEmpty()){
            update eventMap.values();
        }
    }
}