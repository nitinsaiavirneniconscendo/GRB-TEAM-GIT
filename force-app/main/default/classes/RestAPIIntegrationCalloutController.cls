/**
 * @description
 * This class handles the outbound HTTP POST callout to an external REST API using a Named Credential.
 * It sends JSON data to the `accountCRUD` endpoint and returns the response body if successful.
 *  
 * @author Sudheer Kumar
 */

public  class RestAPIIntegrationCalloutController {
    @AuraEnabled
    public static String methodCallout(String JsonData) {

        System.debug('Inside methodCallout');
        System.debug('JsonData-' + JsonData);
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:RestCalloutNamedCredential/services/apexrest/accountCRUD');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JsonData);

        try{
            HttpResponse res = http.send(req);
            System.debug('body: '+res.getBody());
            System.debug('status: '+res.getStatusCode()); 
            if(res.getStatusCode() == 200){
                return res.getBody();
            }else{
                throw new CalloutException('Error: ' +res.getStatusCode());
            }
       
        }
        catch (Exception e){
            throw new CalloutException('Callout Failed :' +e.getMessage());
        }

    }
}