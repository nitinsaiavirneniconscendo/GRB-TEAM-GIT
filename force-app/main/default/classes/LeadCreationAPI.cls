@RestResource(urlMapping='/createLead/*')
global with sharing class LeadCreationAPI {
 
    @HttpPost
    global static String createLeadR(String firstName, String lastName, String company, String email, String phone) {
        try {
            // Check if required parameters are provided
            if (String.isBlank(firstName) || String.isBlank(lastName) || String.isBlank(company)) {
                return 'Error: First Name, Last Name, and Company are required.';
            }
            // Create a new Lead record
            Lead newLead = new Lead(
                FirstName = firstName,
                LastName = lastName,
                Company = company,
                Email = email,
                Phone = phone
            );
            // Insert the Lead
            insert newLead;
 
            // Return success message with Lead Id
            return 'Lead created successfully. Lead ID: ' + newLead.Id;
        } catch (Exception e) {
            // Return the error message
            return 'Error: ' + e.getMessage();
        }
    }
}