trigger Scenario24 on Task (before insert) {
    if(trigger.isBefore && trigger.isInsert){
        Scenario24.taskAssign(trigger.new);
    }
}