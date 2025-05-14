public with sharing class weatherAPI {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getWeatherData() {
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=1d0618d3643a6702489c692599429de4';
        try {
            // Create and configure HttpRequest
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            req.setTimeout(20000);  // 20 seconds
 
            // Send the HTTP request and capture the response
            Http http = new Http();
            HttpResponse res = http.send(req);
 
            // Check for successful status code
            if (res.getStatusCode() == 200) {
                String responseBody = res.getBody();
                System.debug('Weather Data: ' + responseBody);
                // Deserialize JSON into a Map
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
 
                // Extract relevant weather data
                Map<String, Object> main = (Map<String, Object>) jsonResponse.get('main');
                List<Object> weatherList = (List<Object>) jsonResponse.get('weather');
                Map<String, Object> weatherDetails = (Map<String, Object>) weatherList[0];
                // Prepare result with required fields
                Map<String, Object> result = new Map<String, Object>();
                result.put('location', jsonResponse.get('name'));
                result.put('temperature', main.get('temp'));
                result.put('humidity', main.get('humidity'));
                result.put('description', weatherDetails.get('description'));
 
                System.debug('Parsed Weather Data: ' + result);
                return result;
            } else {
                System.debug('Error: ' + res.getStatusCode() + ' - ' + res.getBody());
                throw new CalloutException('Error: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            throw new CalloutException('Error: ' + e.getMessage());
        }
    }
}