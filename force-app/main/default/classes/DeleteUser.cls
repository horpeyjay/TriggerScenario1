public with sharing class DeleteUser {
    public static void removeUserFromGroups() {
        Groupmember[] gmList = new List<Groupmember>();
        Groupmember[] queueList = new List<Groupmember>();
        User[] inactiveUser = [Select Id From User where IsActive = false];
        Set<Id> userIds = new Set<Id>(); //set to store user Ids
        if(!inactiveUser.isEmpty()){
            for(User u : inactiveUser){
                userIds.add(u.Id);
            }
        }

        if(!userIds.isEmpty()){
            //get group members
            gmList = [SELECT Id, GroupId, UserOrGroupId FROM GroupMember WHERE UserOrGroupId IN :inactiveUser ];
            queueList = [Select Id, GroupId, UserOrGroupId From GroupMember where UserOrGroupId in : inactiveUser and Group.Type = 'Queue'];
        }

        if (!gmList.isEmpty()){
            delete gmList;
        }
    }
}