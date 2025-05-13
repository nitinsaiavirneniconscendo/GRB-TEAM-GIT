@RestResource(urlMapping='/externalLeadscreation')
global with sharing class ExternalLeadAPIs {
    
    @HttpPost
    global static ResponseWrapper createLead() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Parse JSON into a Lead object
            Lead newLead = (Lead) JSON.deserialize(req.requestBody.toString(), Lead.class);
            
            // Insert the Lead record
            insert newLead;

            // Success response
            ResponseWrapper response = new ResponseWrapper();
            response.status = 'Success';
            response.message = 'Lead created successfully';
            response.leadId = newLead.Id;
            return response;
            
        } catch (Exception e) {
            // Handle errors
            ResponseWrapper response = new ResponseWrapper();
            response.status = 'Error';
            response.message = e.getMessage();
            return response;
        }
    }
    
    // Response Wrapper Class
    global class ResponseWrapper {
        public String status;
        public String message;
        public String leadId;
    }
}