trigger Scenario8 on Case (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        Scenario8.caseLink(trigger.new);
    }
}