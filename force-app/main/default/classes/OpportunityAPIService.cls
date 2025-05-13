public with sharing class OpportunityAPIService {
    
    @future(callout=true)
    public static void sendOpportunityData(String opportunityId, String name, Decimal amount, String stageName, Date closeDate) {
        try {
            // Define API Endpoint
            String apiUrl = 'https://webhook.site/17cd609b-a354-4e7e-b9f1-f4087903b972';

            // Prepare HTTP Request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            // Create JSON Payload
            Map<String, Object> data = new Map<String, Object>();
            data.put('opportunityId', opportunityId);
            data.put('name', name);
            data.put('amount', amount);
            data.put('stageName', stageName);
            data.put('closeDate', closeDate);

            String jsonBody = JSON.serialize(data);
            request.setBody(jsonBody);

            // Send API Request
            HttpResponse response = http.send(request);

            System.debug('API Response: ' + response.getBody());
        } catch (Exception e) {
            System.debug('Error sending Opportunity data: ' + e.getMessage());
        }
    }
}