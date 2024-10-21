public with sharing class DeleteUserSchedulable implements Schedulable{
    public void execute (SchedulableContext sc) {
        DeleteUser.removeUserFromGroups();
    }
}