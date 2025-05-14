public class BitCoinPrices {
    public static void fetchBitcoinR() {
        String url ='https://api.coindesk.com/v1/bpi/currentprice.json';
        
        HttpRequest req =new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeOut(1000);
        
        Http http= new Http();
         HttpResponse res = http.send(req);
        
         if (res.getStatusCode() == 200) {
            
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Map<String, Object> bpi = (Map<String, Object>) responseData.get('bpi');
            Map<String, Object> usd = (Map<String, Object>) bpi.get('USD');
            Decimal price = (Decimal) usd.get('rate_float');
            String currencyCode = (String) usd.get('code'); 

            // Store the price in the custom object (Bitcoin_Price__c)
            Bitcoin_Price__c bitcoinRecord = new Bitcoin_Price__c();
            bitcoinRecord.Price__c = price;
              bitcoinRecord.Currency_Code__c = currencyCode; 

            // Insert the record into the database
            insert bitcoinRecord;

            System.debug('Bitcoin Price Inserted: ' + price + ' ' + currencyCode);
        } else {
            System.debug('Failed to fetch Bitcoin price, Status Code: ' + res.getStatusCode());
        }
    }

}