@RestResource(urlMapping='/createContact/')
global with sharing class ContactAPI {
    
    @HttpPost
    global static String createContact(String firstName, String lastName, String email) {
        try {
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email
            );
            insert newContact;
            return 'Contact created successfully with ID: ' + newContact.Id;
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}