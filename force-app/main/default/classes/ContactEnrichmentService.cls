public class ContactEnrichmentService {
    public static void enrichContactR(Id contactId) {
        System.debug('=== Starting enrichContact method ===');
        System.debug('Input contactId: ' + contactId);
        
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://jsonplaceholder.typicode.com/users/1');
            System.debug('Set endpoint: ' + req.getEndpoint());

            req.setMethod('GET');
            System.debug('HTTP method set: ' + req.getMethod());

            Http http = new Http();
            System.debug('Http instance created');

            HttpResponse res = http.send(req);
            System.debug('Callout sent. Status code: ' + res.getStatusCode());
            System.debug('Raw response body: ' + res.getBody());

            if (res.getStatusCode() == 200) {
                System.debug('Callout succeeded. Status 200 OK.');

                Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                System.debug('Deserialized response: ' + data);

                Map<String, Object> company = (Map<String, Object>) data.get('company');
                System.debug('Company map extracted: ' + company);

                String companyName = (String) company.get('name');
                System.debug('Company name: ' + companyName);

                Contact c = [SELECT Id, Description FROM Contact WHERE Id = :contactId LIMIT 1];
                System.debug('Fetched contact: ' + c);

                c.Description = 'Company: ' + companyName;
                System.debug('Updated contact description: ' + c.Description);

                update c;
                System.debug('Contact updated successfully.' +c);
            } else {
                System.debug('Callout failed with status code: ' + res.getStatusCode());
            }
        } catch (Exception ex) {
            System.debug('Exception in enrichment: ' + ex.getMessage());
        }

        
    }
}