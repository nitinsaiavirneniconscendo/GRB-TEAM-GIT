@RestResource(urlMapping='/lead/create')
global without sharing class LeadRestAPI {
    @HttpPost
    global static String createLead(String firstName, String lastName, String email) {
        Lead newLead = new Lead(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            Company = 'Test Company'  // Required field
        );
        insert newLead;
        return 'Lead Created Successfully!';
    }
}