public class CoinDeckoAPI {
    public static void getBitcoinPriceR() {
        String url = 'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd,eur,gbp';
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        Http http = new Http();
        HttpResponse res = http.send(req);
        // Check if the request was successful (status code 200)
        if (res.getStatusCode() == 200) {
            // Parse the JSON response
            Map<String, Object> data = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            // Extract the Bitcoin prices in different currencies
            Map<String, Object> bitcoinData = (Map<String, Object>) data.get('bitcoin');
            Decimal btcPriceUsd = (Decimal) bitcoinData.get('usd');
            Decimal btcPriceEur = (Decimal) bitcoinData.get('eur');
            Decimal btcPriceGbp = (Decimal) bitcoinData.get('gbp');
            // Debug log to check the results
            System.debug('Bitcoin Price in USD: ' + btcPriceUsd);
            System.debug('Bitcoin Price in EUR: ' + btcPriceEur);
            System.debug('Bitcoin Price in GBP: ' + btcPriceGbp);
           Bitcoin_Price__c btcPrice = new Bitcoin_Price__c();
            btcPrice.Name = 'Bitcoin at'+btcPriceUsd;
            btcPrice.Price__c = btcPriceEur;
insert btcPrice;            
            // Here you can use the values for further processing or store them in a custom object.
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
    }
}