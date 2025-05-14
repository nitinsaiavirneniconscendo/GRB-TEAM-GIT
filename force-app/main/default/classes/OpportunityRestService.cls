@RestResource(urlMapping='/opportunityoutbound/*')
global with sharing class OpportunityRestService {

    @HttpPost
    global static void receiveOutboundMessage() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        try {
            // Get the request body (Assuming it's sent as JSON)
            String requestBody = req.requestBody.toString();
            System.debug('Received Request: ' + requestBody);
            
            // Parse the JSON (if the outbound message uses JSON format)
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
            String opportunityId = (String) data.get('Id');  // Extract Opportunity ID
            
            if (opportunityId != null) {
                // Fetch the Opportunity record
                Opportunity opp = [SELECT Id, Name, Description FROM Opportunity WHERE Id = :opportunityId LIMIT 1];
                
                // Update a custom field (or Description)
                opp.Description = 'Received Outbound Message at ' + System.now();
                update opp;
                
                // Send a success response
                res.statusCode = 200;
                res.responseBody = Blob.valueOf('{"status": "Success"}');
            } else {
                res.statusCode = 400;
                res.responseBody = Blob.valueOf('{"error": "Missing Opportunity ID"}');
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
    }
}