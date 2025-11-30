@IsTest
private class apexpractice29NOV1_ExistingOCR_Test {
    @IsTest
    static void test_existingOcrForPrimary_isUpdated() {
        // Create a contact
        Contact c = new Contact(LastName = 'TestContact');
        insert c;

        // Create an opportunity   (no primary initially)
        Opportunity opp = new Opportunity(
            Name = 'Test Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today()
        );
        insert opp;

        // Insert an OpportunityContactRole for that contact (existing OCR)
        OpportunityContactRole existingOcr = new OpportunityContactRole(
            OpportunityId = opp.Id,
            ContactId = c.Id,
            Role = 'Influencer', //some non Decision Maker role to ensure update happens
            IsPrimary = false
        );
        insert existingOcr;

        // Now set the primary contact on Opportunity to that contact
        opp.Primary_Contact__c = c.Id;

        // Call your handler with oldmap = null to simulate insert/first-time change
        apexpractice29NOV1.oppContaactrole(
            new List<Opportunity>{ opp },
            null
        );

        // Re-query the OCR and assert it was promoted to primary and role updated
        OpportunityContactRole ocrAfter = [
            SELECT Id, OpportunityId, ContactId, IsPrimary, Role
            FROM OpportunityContactRole
            WHERE Id = :existingOcr.Id
            LIMIT 1
        ];

        System.assertEquals(true, ocrAfter.IsPrimary, 'Existing OCR should be marked primary');
        System.assertEquals('Decision Maker', ocrAfter.Role, 'Role must be updated to Decision Maker');
    }
}