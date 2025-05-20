@RestResource(urlMapping='/externalLead')
global with sharing class ExternalLeadAPI {
    // POST method to create a new Lead
    @HttpPost
    global static ResponseWrapper createLead() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Parse the incoming JSON body
            Lead newLead = (Lead) JSON.deserialize(req.requestBody.toString(), Lead.class);
            
            // Insert the Lead record
            insert newLead;
            
            // Return success response
            ResponseWrapper response = new ResponseWrapper();
            response.status = 'Success';
            response.message = 'Lead created successfully';
            response.leadId = newLead.Id;
            return response;
            
        } catch (Exception e) {
            // Handle errors and return failure response
            ResponseWrapper response = new ResponseWrapper();
            response.status = 'Error';
            response.message = e.getMessage();
            return response;
        }
    }
    
    // Response format
    global class ResponseWrapper {
        public String status;
        public String message;
        public String leadId;
    }
}