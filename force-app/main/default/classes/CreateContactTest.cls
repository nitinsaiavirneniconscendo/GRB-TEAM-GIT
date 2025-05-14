@isTest
public class CreateContactTest {
    @isTest static void testCreateContactR() {
        String payload = '{"LastName": "Test User", "Email": "test@example.com"}';
        Test.startTest();
        String response = CreateContact.createContact(payload);
        Test.stopTest();
        System.assert(response.contains('Contact created'));
    }

}