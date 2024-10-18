trigger Scenario19 on Product__c (before insert, before update) {
   if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate)){
       Scenario19.preventProduct(trigger.new);
   }
}