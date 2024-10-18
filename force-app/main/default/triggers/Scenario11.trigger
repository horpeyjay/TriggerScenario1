trigger Scenario11 on Contact (after insert) {
    if(trigger.isAfter && trigger.isInsert){
        Scenario11.createOppsCon(trigger.new);
    }
}