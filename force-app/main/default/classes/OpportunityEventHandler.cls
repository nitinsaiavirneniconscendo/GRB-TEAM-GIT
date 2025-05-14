public class OpportunityEventHandler {
    @future(callout=true)
    public static void sendToExternalAPI(List<String> opportunityIds) {
        System.debug('### Executing sendToExternalAPI Future Method ###');
        
        if (opportunityIds == null || !opportunityIds.isEmpty()) {
            System.debug('### No Opportunity IDs received, exiting method. ###');
            return;
        }

        // Update the endpoint to your correct Webhook URL
        String endpoint = 'https://webhook.site/26098579-6f0b-4338-b705-9afc5a9ac82e'; 
        System.debug('### Webhook Endpoint: ' + endpoint);

        // Query Opportunity details
        List<Opportunity> opps = [SELECT Id, Name, Amount, StageName FROM Opportunity WHERE Id IN :opportunityIds];

        if (opps.isEmpty()) {
            System.debug('### No Opportunities found for provided IDs. ###');
            return;
        }

        System.debug('### Found ' + opps.size() + ' Opportunities to process.');

        for (Opportunity opp : opps) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            // Prepare JSON body
            Map<String, Object> payload = new Map<String, Object>{
                'OpportunityId' => opp.Id,
                'Name' => opp.Name,
                'Amount' => opp.Amount,
                'StageName' => opp.StageName
            };
            String jsonBody = JSON.serialize(payload);
            request.setBody(jsonBody);

            System.debug('### Sending HTTP Request: ' + jsonBody);

            try {
                HttpResponse response = http.send(request);
                System.debug('### Response Status: ' + response.getStatus());
                System.debug('### Response Body: ' + response.getBody());
            } catch (Exception e) {
                System.debug('### HTTP Callout Error: ' + e.getMessage());
            }
        }
    }
}