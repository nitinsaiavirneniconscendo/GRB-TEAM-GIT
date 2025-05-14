public class LeadCreationRequest {
    
    public static void createLead(String FirstName, String LastName, string Company, string Status, string Phone, string Email) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
    	request.setEndpoint('callout:sf_name_card/services/apexrest/LeadCreationSFtoSF');
    	request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody('{"FirstName": "' + FirstName + '", "LastName": "' + LastName + '", "Company": "' + Company + '", "Status": "' + Status + '", "Phone": "' + Phone + '", "Email": "' + Email + '"}');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            System.debug('Lead created: ' + response.getBody());
        } else {
            System.debug('Error: ' + response.getStatus() + ' - ' + response.getBody());
        }
    }
}