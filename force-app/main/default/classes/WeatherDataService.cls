public class WeatherDataService {
    @future(callout=true)
    public static void sendWeatherData(String recordId, String location, Decimal temperature, Decimal humidity, String description, Datetime lastUpdated) {
        try {
            // Define API Endpoint (Replace with actual URL)
            String apiUrl = 'https://webhook.site/17cd609b-a354-4e7e-b9f1-f4087903b972';

            // Prepare HTTP Request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');

            // Create JSON Payload
            Map<String, Object> data = new Map<String, Object>();
            data.put('recordId', recordId);
            data.put('location', location);
            data.put('temperature', temperature);
            data.put('humidity', humidity);
            data.put('description', description);
            data.put('lastUpdated', lastUpdated);

            String jsonBody = JSON.serialize(data);
            request.setBody(jsonBody);

            // Send API Request
            HttpResponse response = http.send(request);
            System.debug('API Response: ' + response.getBody());

        } catch (Exception e) {
            System.debug('Error sending Weather data: ' + e.getMessage());
        }
    }
}