public with sharing class Scenario8 {
    /* Link case to contact based on the email supplied in the Supplied_Email__c field. if the email is different, create a new contact to link the case to */
    public static void caseLink(List<Case> newCaseList) {

        //set to store the email of the case
        Set<String> emailCon = new Set<String>();
        //create a map to store the email and contact Id
        Map<String, Id> conEmailMap = new Map<String, Id>();
        Map<String, Contact> emailToContact = new Map<String, Contact>();
        if(!newCaseList.isEmpty()){
            for(Case ca : newCaseList){
                if(ca.Supplied_Email__c != null){
                    emailCon.add(ca.Supplied_Email__c);
                }
            }
        }
        if(!emailCon.isEmpty()){
            //fetch all contact with email present in the set
            List<Contact> conList = [Select Id, Email From Contact where Email in : emailCon];

            if(!conList.isEmpty()){
                for(Contact c : conList){
                    conEmailMap.put(c.Email, c.Id);
                }
            }
        }
        List<Contact> consToInsert = new List<Contact>();
        for (Case cs : newCaseList){
            if(cs.Supplied_Email__c != null && conEmailMap.containsKey(cs.Supplied_Email__c)){
                cs.ContactId = conEmailMap.get(cs.Supplied_Email__c);
            }else{
                //create a contact with the email present in the case
                Contact con = new Contact();
                con.Email = cs.Supplied_Email__c;
                con.LastName = 'Test Account';
                consToInsert.add(con);
                emailToContact.put(con.Supplied_Email__c, con);
            }
        }
        
        if(!consToInsert.isEmpty()){
            insert consToInsert;

            for(case c : newCaseList){
                if(c.Supplied_Email__c != null && emailToContact.containsKey(c.Supplied_Email__c)){
                    c.ContactId = emailToContact.get(c.Supplied_Email__c).Id;
                }
            }
        }
    }
}