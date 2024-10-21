@isTest
public class DeleteUserTest {
    
    @testSetup
    static void setupData() {
        // Create a test user and mark it as inactive
        User testUser = new User(
            Username = 'testoranage@kloudpoint123yurtwert.org',
            LastName = 'Test',
            Email = 'testoranage@kloudpoint123yurtwert.org',
            Alias = 'tuser',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            LanguageLocaleKey = 'en_US'
        );
        insert testUser;

        testUser.IsActive = false;
        update testUser;

        // Create a test public group
        Group testGroup = new Group(Name = 'Test Group', Type = 'Regular');
        insert testGroup;

        // Create a test queue
        Group testQueue = new Group(Name = 'Test Queue', Type = 'Queue');
        insert testQueue;

        // Add the user to the group
        GroupMember gm = new GroupMember(GroupId = testGroup.Id, UserOrGroupId = testUser.Id);
        insert gm;

        // Add the test user to the queue
        GroupMember gm1 = new GroupMember(GroupId = testQueue.Id, UserOrGroupId = testUser.Id);
        insert gm1;

    }

    @isTest
    static void testCleanup() {
        Test.startTest();
        DeleteUser.removeUserFromGroups();
        Test.stopTest();

        // Assert that the group member has been removed
        List<GroupMember> groupMembers = [SELECT Id FROM GroupMember WHERE Group.Name = 'Test Group'];
        System.assertEquals(0, groupMembers.size());
    }
}
