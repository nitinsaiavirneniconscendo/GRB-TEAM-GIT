@isTest
private class ContactUpdaterSchedulerTest {
    
    // Mock HTTP Response Class
    private class MockHttpResponse implements HttpCalloutMock {
        private String responseBody;
        private Integer statusCode;
        
        public MockHttpResponse(String responseBody, Integer statusCode) {
            this.responseBody = responseBody;
            this.statusCode = statusCode;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(statusCode);
            res.setBody(responseBody);
            return res;
        }
    }
    
    @isTest
    static void testUpdateContacts_Success() {
        Test.startTest();
        
        // Insert a Contact that should be updated
        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'User', 
            Email = 'johndoe@example.com', 
            HomePhone = '000-000-0000'
        );
        insert testContact;
        
        System.debug('Inserted Contact: ' + testContact.Id);
        
        // Set Mock Response with a valid user matching the contact
        String mockJson = '[{"name":"John Doe","email":"johndoe@example.com","phone":"123-456-7890"}]';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(mockJson, 200));

        // Call the method
        ContactUpdaterScheduler.updateContactsFromAPI();
        
        Test.stopTest();

        // Fetch updated contact
        Contact updatedContact = [SELECT FirstName, LastName, HomePhone FROM Contact WHERE Id = :testContact.Id];
        
        // Assertions
        System.assertEquals('contact01', updatedContact.FirstName, 'FirstName should be updated');
        System.assertEquals('created', updatedContact.LastName, 'LastName should be updated');
        System.assertEquals('123-456-7890', updatedContact.HomePhone, 'HomePhone should be updated');
    }

    @isTest
    static void testUpdateContacts_NoMatchingEmails() {
        Test.startTest();

        // Insert a Contact that does NOT match the API email
        Contact testContact = new Contact(
            FirstName = 'NoMatch', 
            LastName = 'User', 
            Email = 'nomatch@example.com', 
            HomePhone = '999-999-9999'
        );
        insert testContact;

        // Set Mock Response with a different email
        String mockJson = '[{"name":"John Doe","email":"johndoe@example.com","phone":"123-456-7890"}]';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(mockJson, 200));

        // Call the method
        ContactUpdaterScheduler.updateContactsFromAPI();
        
        Test.stopTest();

        // Fetch contact to ensure it was NOT updated
        Contact unchangedContact = [SELECT FirstName, LastName, HomePhone FROM Contact WHERE Id = :testContact.Id];

        // Assertions
        System.assertEquals('NoMatch', unchangedContact.FirstName, 'FirstName should remain unchanged');
        System.assertEquals('User', unchangedContact.LastName, 'LastName should remain unchanged');
        System.assertEquals('999-999-9999', unchangedContact.HomePhone, 'HomePhone should remain unchanged');
    }

    @isTest
    static void testUpdateContacts_EmptyAPIResponse() {
        Test.startTest();

        // Mock API with an empty response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('[]', 200));

        // Call the method
        ContactUpdaterScheduler.updateContactsFromAPI();
        
        Test.stopTest();

        // Ensure no exception is thrown and debug logs show 'No users found'
    }

    @isTest
    static void testUpdateContacts_APIError() {
        Test.startTest();

        // Mock API with a failure response (e.g., 500 Internal Server Error)
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{"error":"Internal Server Error"}', 500));

        // Call the method
        ContactUpdaterScheduler.updateContactsFromAPI();
        
        Test.stopTest();

        // No assertions needed, just ensuring no exception crashes the execution
    }

    @isTest
    static void testUpdateContacts_InvalidJSON() {
        Test.startTest();

        // Mock API with invalid JSON response
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{invalidJson:true}', 200));

        // Call the method
        ContactUpdaterScheduler.updateContactsFromAPI();
        
        Test.stopTest();

        // Ensure no exception crashes the execution
    }
}