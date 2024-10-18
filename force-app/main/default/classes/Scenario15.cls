public with sharing class Scenario15 {
    /* whenever and opportunity is created or update and amount greater than $10000 then send email to the record owner */
    public static void sendEmailOnOpps(List<Opportunity> oppList) {
        //set to store owner id
        Set<Id> ownerIds = new Set<Id>();
        if(!oppList.isEmpty()){
            for(Opportunity o : oppList){
                if(o.Amount != null && o.Amount > 10000){
                    ownerIds.add(o.OwnerId);
                }
            }
        }
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        if(!ownerIds.isEmpty()){
            Map<Id, User> ownerMap = new Map<Id, User>([Select Id, Name from User where Id in :ownerIds]);

            for(Opportunity opp : oppList){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new List<String>{opp.OwnerId});

                string ownerName = ownerMap.containsKey(opp.OwnerId) ? ownerMap.get(opp.OwnerId).Name : '';
                email.setSubject('Opportunity Amount Exceeding Threshold');
                email.setPlainTextBody('Dear '+ ownerName +', \n\n') + 'The Opportunity "' + opp.Name + '" amount is exceeding the threshold. Please review and take necessary action. \n\n' +
                'Thanks \n' + 'Management \n';
                emails.add(email);
            }
        }
        if (!emails.isEmpty()){
            Messaging.sendEmail(emails);
        }  
    }
}