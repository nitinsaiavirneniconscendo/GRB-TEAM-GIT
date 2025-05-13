public class OpportunityEventProcessor implements Queueable, Database.AllowsCallouts {
    private OpportunityEvent__e eventData;

    public OpportunityEventProcessor(OpportunityEvent__e eventData) {
        this.eventData = eventData;
    }

    public void execute(QueueableContext context) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://jsonplaceholder.typicode.com/posts'); // Mock API URL
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');

        // Convert event data to JSON
        String jsonBody = JSON.serialize(new Map<String, Object>{
            'OpportunityId' => eventData.OpportunityId__c,
            'Name' => eventData.Name__c,
            'StageName' => eventData.Stage_Name__c,
            'Amount' => eventData.Amount__c,
            'CloseDate' => eventData.Close_Date__c
        });

        req.setBody(jsonBody);
        Http http = new Http();
        try {
            HttpResponse res = http.send(req);
            System.debug('Response: ' + res.getBody());
        } catch (Exception e) {
            System.debug('Error sending API call: ' + e.getMessage());
        }
    }
}