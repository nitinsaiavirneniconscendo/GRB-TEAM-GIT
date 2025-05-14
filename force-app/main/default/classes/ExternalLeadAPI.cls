@RestResource(urlMapping='/externalLead')
global with sharing class ExternalLeadAPI {
    // POST method to create a new Lead
    @HttpPost
    global static ResponseWrapper createLead() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        ResponseWrapper response = new ResponseWrapper();
        try {
            // Parse the incoming JSON body
            Lead newLead = (Lead) JSON.deserialize(req.requestBody.toString(), Lead.class);
            
            // Validate Last Name (Mandatory field)
            if (String.isEmpty(newLead.LastName)) {
                throw new CustomException('Last Name is required.');
            }

            // Insert the Lead record
            insert newLead;

            // Set success response
            response.status = 'Success';
            response.message = 'Lead created successfully';
            response.leadId = newLead.Id;

            // Set HTTP status code to 200
            res.statusCode = 200;
        } catch (CustomException e) {
            response.status = 'Error';
            response.message = e.getMessage();
            res.statusCode = 400; // Bad Request
        } catch (Exception e) {
            response.status = 'Error';
            response.message = 'An unexpected error occurred: ' + e.getMessage();
            res.statusCode = 500; // Internal Server Error
        }
        return response;
    }

    // Custom Exception Class
    global class CustomException extends Exception {}

    // Response format
    global class ResponseWrapper {
        public String status;
        public String message;
        public String leadId;
    }
}