public with sharing class Scenario13 {
    /* create contacts based on the numbers entered by the user in the number of contacts field while creating account */
    public static vodi createMultipleContact(List<Account> accList) {

        List<Contact> consToInsert = new List<Contact>();
        if(!accList.isEmpty()){
            for (Account acc : accList){

                if(acc.Number_Of_Contacts__c != null && Number_Of_Contacts__c <= 10){
                    for(integer i = 1; i <= acc.Number_Of_Contacts__c; i++){

                        Contact con = new Contact();
                        con.FirstName = 'Test';
                        con.LastName = acc.Name + i;
                        con.AccountId = acc.Id;
                        consToInsert.add(con);
                    }
                }else{
                    acc.addError('Maximum number of contact allowed is 10');
                }
            }
        }
        if(!consToInsert.isEmpty()){
            insert consToInsert;
        }
    }
}