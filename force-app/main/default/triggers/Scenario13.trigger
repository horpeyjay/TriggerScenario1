trigger Scenario13 on Account (after insert) {

    if(trigger.isAfter && trigger.isInsert){
        Scenario13.createMultipleContact(trigger.new);
    }

}