public class CoinDeskAPIIntegration {

    private static final String API_URL = 'https://api.coindesk.com/v1/bpi/currentprice/BTC.json'; // CoinDesk API URL
    
    // Top-level response class
    public class CoinDeskAPIResponse {
        public BPI bpi;
    }

    // Top-level class for BPI
    public class BPI {
        public Currence USD;
    }

    // Top-level class for Currency
    public class Currence {
        public String code;
        public String rate;
        public String description;
    }

    public static String getBitcoinPrice() {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(API_URL);
            req.setMethod('GET');
            req.setHeader('Content-Type', 'application/json');
            
            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                // Parse the response if successful
                CoinDeskAPIResponse response = (CoinDeskAPIResponse)JSON.deserialize(res.getBody(), CoinDeskAPIResponse.class);
                return 'Bitcoin Price (USD): ' + response.bpi.USD.rate;
            } else {
                // Handle non-200 responses from the API
                throw new CoinDeskAPIException('Error from CoinDesk API: ' + res.getStatusCode() + ' - ' + res.getStatus());
            }
        } catch (Exception e) {
            // Catch any other errors (network, parsing, etc.)
            throw new CoinDeskAPIException('Failed to fetch Bitcoin price: ' + e.getMessage());
        }
    }
}