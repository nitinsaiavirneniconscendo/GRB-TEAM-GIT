@isTest
private class ContactEnrichmentTest {
    
    @isTest
    static void testEnrichContactR() {
        // Create test contact
        Contact c = new Contact(FirstName = 'Test', LastName = 'User');
        insert c;

        // Set mock callout
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        ContactEnrichmentService.enrichContact(c.Id);
        Test.stopTest();

        Contact updated = [SELECT Description FROM Contact WHERE Id = :c.Id];
        System.assert(updated.Description.contains('MockCompany'));
    }

    @isTest
    static void testScheduledJob() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            contacts.add(new Contact(FirstName='User'+i, LastName='Test'));
        }
        insert contacts;

        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());

        Test.startTest();
        String jobId = System.schedule('Test Job', '0 0 0 1 1 ? 2099', new ContactEnrichmentScheduler());
        Test.stopTest();

        System.assertNotEquals(null, jobId);
    }
}