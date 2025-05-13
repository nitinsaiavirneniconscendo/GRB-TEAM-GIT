public class OpportunityChangeTriggerHandler {

    // Method to handle calling the external API
    public static void callExternalAPI(OpportunityEvent__e eventRecord) {
        // Assuming you have your API call logic here
        // Example:
        // 1. Create HttpRequest, set endpoint, method, and headers.
        // 2. Serialize data from the OpportunityEvent__e to the external API.
        // 3. Make the callout.

        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://external.api/endpoint'); // Replace with your actual endpoint
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('OpportunityId', eventRecord.OpportunityId__c);  // Make sure the field names match the event's schema
        payload.put('ChangeType', eventRecord.ChangeType__c);  // Custom text field to store change type
        
        req.setBody(JSON.serialize(payload));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            System.debug('API call successful');
        } else {
            System.debug('Error with API call: ' + res.getStatusCode());
        }
    }
}