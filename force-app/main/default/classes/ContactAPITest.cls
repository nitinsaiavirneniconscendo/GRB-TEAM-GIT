@isTest
private class ContactAPITest {
    @isTest static void testCreateContact() {
        Test.startTest();
        String result = ContactAPI.createContact('Test', 'User', 'testuser@example.com');
        Test.stopTest();

        System.assert(result.contains('Contact created successfully'));
    }
}