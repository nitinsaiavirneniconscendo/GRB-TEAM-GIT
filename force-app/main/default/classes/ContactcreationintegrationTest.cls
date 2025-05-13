@isTest
private class ContactcreationintegrationTest {
    
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
    static void testFetchAndCreateContact_Success() {
        Test.startTest();

        // Mock API response with a valid user
        String mockJson = '{"name":"John Doe","email":"johndoe@example.com","phone":"123-456-7890"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(mockJson, 200));

        // Call the method
        Contactcreationintegration.fetchandcreatecontact();
        
        Test.stopTest();

        // Query the inserted contact
        Contact insertedContact = [SELECT FirstName, LastName, Email, HomePhone FROM Contact WHERE Email = 'johndoe@example.com' LIMIT 1];

        // Assertions
        System.assertEquals('John', insertedContact.FirstName, 'FirstName should be John');
        System.assertEquals('Doe', insertedContact.LastName, 'LastName should be Doe');
        System.assertEquals('johndoe@example.com', insertedContact.Email, 'Email should match');
        System.assertEquals('123-456-7890', insertedContact.HomePhone, 'Phone should match');
    }

    @isTest
    static void testFetchAndCreateContact_NoLastName() {
        Test.startTest();

        // Mock API response with a single-name user
        String mockJson = '{"name":"John","email":"john@example.com","phone":"987-654-3210"}';
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(mockJson, 200));

        // Call the method
        Contactcreationintegration.fetchandcreatecontact();
        
        Test.stopTest();

        // Query the inserted contact
        Contact insertedContact = [SELECT FirstName, LastName FROM Contact WHERE Email = 'john@example.com' LIMIT 1];

        // Assertions
        System.assertEquals('John', insertedContact.FirstName, 'FirstName should be John');
        System.assertEquals('User', insertedContact.LastName, 'LastName should default to User');
    }

    @isTest
    static void testFetchAndCreateContact_APIError() {
        Test.startTest();

        // Mock API failure response (e.g., 500 Internal Server Error)
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{"error":"Internal Server Error"}', 500));

        // Call the method
        Contactcreationintegration.fetchandcreatecontact();
        
        Test.stopTest();

        // Ensure no contacts are inserted
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = 'johndoe@example.com'];
        System.assertEquals(0, contacts.size(), 'No contact should be created if API call fails');
    }

    @isTest
    static void testFetchAndCreateContact_InvalidJSON() {
        Test.startTest();

        // Mock API response with invalid JSON
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse('{invalidJson:true}', 200));

        // Call the method
        Contactcreationintegration.fetchandcreatecontact();
        
        Test.stopTest();

        // Ensure no contacts are inserted
        List<Contact> contacts = [SELECT Id FROM Contact WHERE Email = 'johndoe@example.com'];
        System.assertEquals(0, contacts.size(), 'No contact should be created if API returns invalid JSON');
    }
}