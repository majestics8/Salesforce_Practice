@isTest
public class ApexPractice5DEC_Test {

    // Utility to create user
    private static User createTestUser(Profile p) {
        return new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
            Username = 'testuser' + System.currentTimeMillis() + '@example.com',
            Alias = 'tusr',
            TimeZoneSidKey = 'Asia/Kolkata',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = p.Id
        );
    }

    @isTest
    static void testLeadStatusChangeAndTaskCheck() {

        // 1️⃣ Get target profile (same as handler)
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Analytics Cloud Integration User' LIMIT 1];

        // 2️⃣ Create user with this profile
        User testUser = createTestUser(p);
        insert testUser;

        // 3️⃣ Create Lead with initial status
        Lead ld = new Lead(
            FirstName = 'Test',
            LastName = 'Lead',
            Company = 'ABC Corp',
            Status = 'Open - Not Contacted'
        );
        insert ld;
        

        // 4️⃣ Update status to "Working - Contacted"
        ld.Status = 'Working - Contacted';
        update ld;

        // 5️⃣ Check Owner is testUser
        Lead finalLead = [SELECT OwnerId FROM Lead WHERE Id = :ld.Id];
       // System.assertEquals(testUser.Id, finalLead.OwnerId, 'Owner should be Test User');

        // ---------- Second Scenario: Closed with open tasks ----------

        // Create an open task
        Task t = new Task(
            WhoId = ld.Id,
            Status = 'In Progress',
            Subject = 'Follow up'
        );
        insert t;

        // Update to closed
        ld.Status = 'Closed - Converted';

        try {
            update ld;
            System.assert(false, 'Expected error but update succeeded');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('The Lead Cannot Be Updated'),
                'Expected task error message');
                
        }
    }
}