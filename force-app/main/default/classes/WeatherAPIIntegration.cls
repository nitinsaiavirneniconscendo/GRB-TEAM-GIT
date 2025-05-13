public class WeatherAPIIntegration {
private static final String API_KEY = 'a2e9305c81f54e719f3102207253101'; // Your WeatherAPI key
    private static final String API_URL = 'http://api.weatherapi.com/v1/current.json';

    public static void fetchAndStoreWeatherData(String city) {
        try {
            String response = getWeatherData(city);
            
            if (response != null) {
                // Store data in Salesforce
                storeWeatherData(response, city);
                
                // Notify the mock API
                notifyMockAPI(city);
            }
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }

    // Method to fetch weather data
    private static String getWeatherData(String city) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(API_URL + '?q=' + EncodingUtil.urlEncode(city, 'UTF-8') + '&appid=' + API_KEY + '&units=metric');
            req.setMethod('GET');

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                return res.getBody();
            } else {
                System.debug('Error: API returned ' + res.getStatusCode());
                return null;
            }
        } catch (Exception e) {
            System.debug('Error fetching weather data: ' + e.getMessage());
            return null;
        }
    }

    // Method to store weather data in Salesforce
    private static void storeWeatherData(String response, String city) {
        Map<String, Object> jsonData = (Map<String, Object>) JSON.deserializeUntyped(response);
        
        if (jsonData.containsKey('main') && jsonData.containsKey('weather')) {
            Map<String, Object> main = (Map<String, Object>) jsonData.get('main');
            List<Object> weatherList = (List<Object>) jsonData.get('weather');
            Map<String, Object> weather = (Map<String, Object>) weatherList[0];

            Weather_Report__c weatherRecord = new Weather_Report__c();
            weatherRecord.City__c = city;
            weatherRecord.Temperature__c = (Decimal) main.get('temp');
            weatherRecord.Humidity__c = (Integer) main.get('humidity');
            weatherRecord.Weather_Description__c = (String) weather.get('description');

            insert weatherRecord;
            System.debug('Weather data stored successfully');
        }
    }

    // Method to send confirmation to mock API
    private static void notifyMockAPI(String city) {
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://mockapi.example.com/weatherNotification'); // Replace with actual mock API
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            Map<String, Object> payload = new Map<String, Object>();
            payload.put('city', city);
            payload.put('message', 'Weather data successfully recorded');

            req.setBody(JSON.serialize(payload));

            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() == 200) {
                System.debug('Successfully notified mock API');
            } else {
                System.debug('Error notifying mock API: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error in notifyMockAPI: ' + e.getMessage());
        }
    }
}