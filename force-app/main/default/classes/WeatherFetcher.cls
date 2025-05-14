public class WeatherFetcher {
    public static void fetchWeatherDataR() {
        String city = 'London';
        String apiKey = '016ac5bd07d0d89c455ba25a19f77c30'; 
        String url = 'https://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=' + apiKey;

        // Create an HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setTimeout(2000); 

        
        Http http = new Http();
        HttpResponse res = http.send(req);

        
       if (res.getStatusCode() == 200) {
            // Parse the JSON response
            Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());

            // Extract weather data from the response
            Map<String, Object> main = (Map<String, Object>) responseData.get('main');
            Decimal temperature = (Decimal) main.get('temp');
          
            
            // Create or update a custom object to store the weather data
            upsertWeatherData(city, temperature);
        } else {
            System.debug('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
        }
    }

    // Method to upsert (create or update) WeatherData records in Salesforce
    private static void upsertWeatherData(String city, Decimal temperature) {
        // Check if the record already exists for the city
        List<WeatherData__c> weatherDataList = [SELECT Id FROM WeatherData__c WHERE City__c = :city LIMIT 1];

        if (weatherDataList.isEmpty()) {
            // If the record doesn't exist, create a new record
            WeatherData__c newWeatherData = new WeatherData__c();
            newWeatherData.City__c = city;
            newWeatherData.Temperature__c = temperature;
            newWeatherData.Last_Updated__c = System.now();
            insert newWeatherData;
        } else {
            // If the record exists, update it
            WeatherData__c existingWeatherData = weatherDataList[0];
            existingWeatherData.Temperature__c = temperature;
            existingWeatherData.Last_Updated__c = System.now();
            update existingWeatherData;
        }
    }
}