@RestResource(urlMapping='/externalcontact/*')
global with sharing class CreateContact {
    @HttpPost
    global static String createContactR() {
        try {
            // Read the raw JSON body
            String jsonBody = RestContext.request.requestBody.toString();

            // Deserialize into a Contact object
            Contact newCon = (Contact) JSON.deserialize(jsonBody, Contact.class);
            insert newCon;

            return 'Contact created: ' + newCon.Id;
        } catch (Exception e) {
            throw new CalloutException('Error: ' + e.getMessage());
        }
    }
}