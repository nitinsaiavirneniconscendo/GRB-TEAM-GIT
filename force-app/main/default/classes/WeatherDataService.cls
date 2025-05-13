public class WeatherDataService implements Schedulable {
    private static final String API_KEY = '9ab799a4bf3ca0a2f3128c98b714ea51';  // Your OpenWeatherMap API key
    private static final String CITY = 'London';  // You can change this to any city
    
    // Method to fetch weather data from OpenWeatherMap API and update custom object
    public static void fetchAndStoreWeatherData() {
        // Create the HTTP request to get weather data
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.openweathermap.org/data/2.5/weather?q=' + CITY + '&appid=' + API_KEY);
        req.setMethod('GET');
        
        // Create the Http object to send the request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Check if the response is successful
        if (res.getStatusCode() == 200) {
            // Parse the JSON response
            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
            
            // Extract relevant weather data from the response
            Map<String, Object> mainData = (Map<String, Object>)response.get('main');
            Decimal temperature = (Decimal)mainData.get('temp');  // Temperature
            Decimal humidity = (Decimal)mainData.get('humidity');  // Humidity
            Long timestamp = (Long)response.get('dt');  // UNIX timestamp
            
            // Convert UNIX timestamp (milliseconds) to seconds by dividing by 1000
            Long timestampInSeconds = timestamp / 1000;
            
            // Format the UNIX timestamp as a string in Salesforce DateTime format (seconds)
            String timestampStr = String.valueOf(timestampInSeconds);
            
            // Create or update custom object (Weather_Data__c) with the weather info
            Weather_Data__c weatherRecord = new Weather_Data__c();
            weatherRecord.Name = 'Weather Data - ' + CITY;
            weatherRecord.Temperature__c = temperature;
            weatherRecord.Humidity__c = humidity;
            
            try {
                insert weatherRecord;  // Insert the new weather record
                System.debug('Weather data inserted successfully.');
            } catch (DmlException e) {
                System.debug('Error inserting weather data: ' + e.getMessage());
            }
        } else {
            // If the API call fails, log the error status
            System.debug('Error fetching data from OpenWeatherMap: ' + res.getStatus());
        }
    }

    // Implementing the Schedulable interface to schedule the weather data fetching job
    public void execute(SchedulableContext sc) {
        fetchAndStoreWeatherData();
    }
    
    // Method to schedule the job to run daily at a specific time
    public static void scheduleDailyJob() {
        String cronExpression = '0 0 0 * * ?';  // Schedule to run daily at midnight (00:00)
        String jobName = 'DailyWeatherDataFetch';
        
        // Schedule the job
        System.schedule(jobName, cronExpression, new WeatherDataService());
    }
}