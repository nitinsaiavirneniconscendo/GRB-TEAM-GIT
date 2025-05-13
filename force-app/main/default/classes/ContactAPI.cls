@RestResource(urlMapping='/createContact/')
global with sharing class ContactAPI {
    
    @HttpPost
    global static String createContact(String firstName, String lastName, String email, String phone) {
        System.debug('===== API Call Received: createContact =====');
        System.debug('Received Parameters - FirstName: ' + firstName + ', LastName: ' + lastName + ', Email: ' + email + ', Phone: ' + phone);

        try {
            // Validate required fields
            if (String.isEmpty(firstName) || String.isEmpty(lastName) || String.isEmpty(email)) {
                System.debug('ERROR: Missing required fields.');
                throw new CustomException('Missing required fields: First Name, Last Name, or Email.');
            }

            // Check if Contact with the same email already exists
            System.debug('Checking if Contact with Email (' + email + ') already exists...');
            Contact existingContact;
            try {
                existingContact = [SELECT Id FROM Contact WHERE Email = :email LIMIT 1];
                System.debug('Existing Contact Found: ' + existingContact.Id);
            } catch (Exception e) {
                System.debug('No existing Contact found. Proceeding to create new Contact.');
            }

            if (existingContact != null) {
                System.debug('Contact with this email already exists. Returning error response.');
                return JSON.serialize(new ResponseWrapper(false, 'Contact with this email already exists.'));
            }

            // Create new Contact record
            System.debug('Creating new Contact record...');
            Contact newContact = new Contact(
                FirstName = firstName,
                LastName = lastName,
                Email = email,
                Phone = phone
            );
            insert newContact;
            System.debug('Contact created successfully with Id: ' + newContact.Id);

            return JSON.serialize(new ResponseWrapper(true, 'Contact created successfully with Id: ' + newContact.Id));

        } catch (Exception e) {
            System.debug('ERROR: Exception occurred - ' + e.getMessage());
            return JSON.serialize(new ResponseWrapper(false, 'Error: ' + e.getMessage()));
        }
    }

    // Helper class for API response format
    global class ResponseWrapper {
        public Boolean success;
        public String message;
        
        public ResponseWrapper(Boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
    
    // Custom Exception for validation errors
    public class CustomException extends Exception {}
}