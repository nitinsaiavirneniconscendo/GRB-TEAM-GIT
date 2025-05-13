/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 05-09-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
@RestResource(urlMapping='/bitcoinprice')
global class BitcoinPriceService {
    
    private static final String API_URL = 'https://api.coindesk.com/v1/bpi/currentprice.json';
    
    @HttpPost
    global static void fetchBitcoinPrice() {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(API_URL);
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            System.debug('Response: ' + response.getBody());

            if (response.getStatusCode() == 200) {
                Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> bpi = (Map<String, Object>) responseData.get('bpi');
                Map<String, Object> usd = (Map<String, Object>) bpi.get('USD');
                
                Decimal price = (Decimal) usd.get('rate_float'); 
                String currence = String.valueOf(usd.get('code')); 
                Datetime timestamp = Datetime.now();
                
                Bitcoin_Price__c btcPrice = new Bitcoin_Price__c();
                btcPrice.Price__c = price; 
                btcPrice.Currency__c = currence; 
                btcPrice.Timestamp__c = timestamp;
                
                insert btcPrice;
                System.debug('Bitcoin price saved: ' + btcPrice);

                RestResponse res = RestContext.response;
                res.statusCode = 201;
                res.responseBody = Blob.valueOf('{"success": "Bitcoin price saved", "price": ' + price + '}');
            } else {
                RestContext.response.statusCode = 500;
                RestContext.response.responseBody = Blob.valueOf('{"error": "Failed to fetch data"}');
            }
        } catch (Exception e) {
            RestContext.response.statusCode = 500;
            RestContext.response.responseBody = Blob.valueOf('{"error": "' + e.getMessage() + '"}');
        }
        // test update
        // ok
        // code change
    }
}