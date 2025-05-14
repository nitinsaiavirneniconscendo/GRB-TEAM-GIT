public with sharing class bitcoinPriceController {
    @AuraEnabled
    public static Map<String, Object> bitcoinPriceController1() {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://api.api-ninjas.com/v1/commodityprice?name=platinum');
            request.setHeader('X-Api-Key','xkD4QTks33Y/Myqbo/VnIg==nbwELqIHG3VCYEhH');
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                System.debug('Parsed Result: ' + result);
                return result;
            } else {
                throw new CalloutException('Error: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            throw new CalloutException('Error: ' + e.getMessage());
        }
        
    }
}