@RestResource(urlMapping='/LeadCreationSFtoSF/*')
global class LeadOutBoundIntegration {

    @HttpPost
    global static Lead createLead(String FirstName, String LastName, String Company, String Status, String Phone, String Email) {
        Lead lead = new Lead(FirstName = FirstName, LastName = LastName, Company = Company, Status = status, Phone = phone, Email = email, Label_email__c = true);
        insert lead;
        return lead; 
    }
 
}