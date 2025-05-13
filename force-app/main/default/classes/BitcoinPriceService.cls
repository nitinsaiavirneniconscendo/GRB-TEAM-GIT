public class BitcoinPriceService {
    private static final String API_KEY = '613e59181a6f24e216cf196299b1b402f61130d10407ca66e999a12448bb0445';

    public void fetchAndStoreBitcoinPrice() {
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint('https://data-api.cryptocompare.com/index/cc/v1/latest/tick?market=ccix&instruments=BTC-USD&api_key=' + API_KEY);
        
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
      
            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            
            Map<String, Object> data = (Map<String, Object>)response.get('Data');
            
            Map<String, Object> btcData = (Map<String, Object>)data.get('BTC-USD');
            
            Decimal price = (Decimal)btcData.get('VALUE');  // The Bitcoin price
            Long timestamp = (Long)btcData.get('VALUE_LAST_UPDATE_TS');  // The timestamp of the last price update
            
            Bitcoin_Price__c bitcoinPrice = new Bitcoin_Price__c();
            
            bitcoinPrice.Name = 'BTC-USD Price';
            
            bitcoinPrice.Price__c = price;
            
            bitcoinPrice.Timestamp__c = String.valueOf(timestamp);
            

            
            try {
                insert bitcoinPrice;
                System.debug('Successfully inserted Bitcoin price record');
            } catch (DmlException e) {
                System.debug('Error inserting Bitcoin price record: ' + e.getMessage());
            }
        } else {
            System.debug('Error fetching data from CryptoCompare: ' + res.getStatus());
        }
    }
}