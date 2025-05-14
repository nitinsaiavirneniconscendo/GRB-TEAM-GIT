public with sharing class OpportunityApiCallout {
    @InvocableMethod(label='Send Opportunity to API' description='Sends Opportunity details to external API')
    public static void sendOpportunityToAPI(List<Integration_Platform__e> events) {
        for (Integration_Platform__e event : events) {
            // Pass only primitive values to future method
            sendHttpCallout(
                event.Opportunity_Name__c,
                event.opportunity_Id__c
              );
        }
    }
 
    @future(callout=true)
    private static void sendHttpCallout(String opportunityId, String opportunityName) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://eofxxocwcqqc8ep.m.pipedream.net'); // Replace with your actual API URL
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
 
            // Create JSON Body
            Map<String, Object> requestBody = new Map<String, Object>();
            requestBody.put('OpportunityId', opportunityId);
            requestBody.put('OpportunityName', opportunityName);
           
 
            String body = JSON.serialize(requestBody);
            req.setBody(body);
 
            Http http = new Http();
            HTTPResponse res = http.send(req);
            System.debug('API Response: ' + res.getBody());
        } catch (Exception e) {
            System.debug('Error sending API request: ' + e.getMessage());
        }
    }
}