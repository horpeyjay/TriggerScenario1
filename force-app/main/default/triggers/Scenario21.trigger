trigger Scenario21 on Case (after delete) {
    if(trigger.isAfter && trigger.isDelete){
        Scenario21.deleteCase(trigger.old);
    }

}