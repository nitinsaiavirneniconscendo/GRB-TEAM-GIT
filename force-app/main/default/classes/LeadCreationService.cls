@RestResource(urlMapping='/CreateLead/*')
global without sharing class LeadCreationService {
    public class LeadWrapper {
        public String LastName;
        public String Company;
        public String FirstName;
        public String Email;
        public String Phone;
        public String LeadSource;
    }
@HttpPost
    global static String createLead() {
        String jsonBody = RestContext.request.requestBody.toString();
        LeadWrapper leadData = (LeadWrapper) JSON.deserialize(jsonBody, LeadWrapper.class);
if(String.isBlank(leadData.LastName) || String.isBlank(leadData.Company)) {
            RestContext.response.statusCode = 400;
            return 'Missing required fields: LastName and Company are required.';
        }
Lead newLead = new Lead();
        newLead.LastName = leadData.LastName;
        newLead.Company = leadData.Company;
        if(leadData.FirstName != null) newLead.FirstName = leadData.FirstName;
        if(leadData.Email != null) newLead.Email = leadData.Email;
        if(leadData.Phone != null) newLead.Phone = leadData.Phone;
        if(leadData.LeadSource != null) newLead.LeadSource = leadData.LeadSource;
try {
            insert newLead;
        } catch(Exception e) {
            RestContext.response.statusCode = 500;
            return 'Error creating Lead: ' + e.getMessage();
        }
RestContext.response.statusCode = 201;
        return 'Lead created successfully with Id: ' + newLead.Id;
    }
}