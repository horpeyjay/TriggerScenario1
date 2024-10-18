public with sharing class Scenario20 {
    /* Update the parent account phone and all related contact phone when the contact phone field is update */
    public static void updateRelConPhone(List<Contact> conList, Map<Id,Contact> conMap ) {

        Map<Id, Contact> conPhoneMap = new Map<Id, Contact>();
        List<Contact> updatedConList = new List<Contact>();
        List<Account> updateaccList = new List<Account>();
        if(!conList.isEmpty()){
            for(Contact c : conList){

                if(conMap != null){
                    Contact oldCon = conMap.get(c.Id);
                    if(c.AccountId != null){
                        if(c.Phone != oldCon.Phone){
                            conPhoneMap.put(c.AccountId, c);
                        }
                    }
                }
            }
        }

        if(!conPhoneMap.isEmpty()){
            List<Contact> relatedConList = [Select Id, AccountId, Phone from Contact where AccountId in :conPhoneMap.keySet()];
            for(Contact con : relatedConList){
                if(conPhoneMap.containsKey(con.AccountId) && con.Phone != conPhoneMap.get(con.AccountId).Phone){
                    con.Phone = conPhoneMap.get(con.AccountId).Phone;
                    updatedConList.add(con);
                }
            }
            for(Id i : conPhoneMap.keySet()){
                Account acc = new Account(Id = i, Phone = conPhoneMap.get(i).Phone);
                updateaccList.add(acc);
            }
        }
        if(!updatedConList.isEmpty()){
            update updatedConList;
        }
        if(!updateaccList.isEmpty()){
            update updateaccList;
        }
    }
}