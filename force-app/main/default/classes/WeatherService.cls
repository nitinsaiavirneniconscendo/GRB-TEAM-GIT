/*public class WeatherService {
    
    private static final String API_KEY = 'a2e9305c81f54e719f3102207253101';
    private static final String CITY = 'New York'; // Change to your desired city
    private static final String API_URL = 'http://api.weatherapi.com/v1/current.json?key=' + API_KEY + '&q=New%20York&aqi=no';
    //http://api.weatherapi.com/v1/current.json?key=YOUR_API_KEY&q=New%20York&aqi=no
    
    @future(callout=true)
    public static void fetchWeatherData() {
        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(API_URL);
            request.setMethod('GET');
            
            HttpResponse response = http.send(request);
            System.debug('Response: ' + response.getBody());
            
            if (response.getStatusCode() == 200) {
                // Parse JSON response
                Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                Map<String, Object> main = (Map<String, Object>) responseData.get('main');
                List<Object> weatherArray = (List<Object>) responseData.get('weather');
                Map<String, Object> weatherInfo = (Map<String, Object>) weatherArray[0];
                system.debug('weatherInfo ==========>'+weatherInfo);
                // Extract data
                Decimal temperature = (Decimal) main.get('temp');
                Decimal humidity = (Decimal) main.get('humidity');
                String weatherDesc = (String) weatherInfo.get('description');
                Datetime timestamp = Datetime.now();
                
                // Store in Custom Object
                Weather_Report__c weatherRecord = new Weather_Report__c();
                weatherRecord.City__c = CITY;
                weatherRecord.Temperature__c = temperature;
                weatherRecord.Humidity__c = humidity;
                weatherRecord.Weather_Description__c = weatherDesc;
                weatherRecord.Timestamp__c = timestamp;
                
                insert weatherRecord;
                System.debug('Weather data saved: ' + weatherRecord);
            } else {
                System.debug('Failed to fetch weather data. Status Code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error fetching weather data: ' + e.getMessage());
        }
    }*/
public class WeatherService {

    private static final String API_KEY = 'a2e9305c81f54e719f3102207253101'; // Your WeatherAPI key
    private static final String API_URL = 'http://api.weatherapi.com/v1/current.json';

    @future(callout=true)
    public static void fetchWeatherData(String city) {
        try {
            // Construct the API URL dynamically based on the city
            String apiUrlWithCity = API_URL + '?key=' + API_KEY + '&q=' + EncodingUtil.urlEncode(city, 'UTF-8') + '&aqi=no';

            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrlWithCity);
            request.setMethod('GET');

            HttpResponse response = http.send(request);
            System.debug('Response: ' + response.getBody());

            if (response.getStatusCode() == 200) {
                // Parse JSON response
                Map<String, Object> responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                // Check if 'current' exists before accessing it
                if (responseData != null && responseData.containsKey('current')) {
                    Map<String, Object> currentWeather = (Map<String, Object>) responseData.get('current');
                    
                    // Check if 'condition' exists before accessing it
                    if (currentWeather.containsKey('condition')) {
                        Map<String, Object> condition = (Map<String, Object>) currentWeather.get('condition');
                        
                        // Extract data with null checks
                        Decimal temperature = (currentWeather.containsKey('temp_c')) ? (Decimal) currentWeather.get('temp_c') : null;
                        Decimal feelsLike = (currentWeather.containsKey('feelslike_c')) ? (Decimal) currentWeather.get('feelslike_c') : null;
                        String weatherDesc = (condition.containsKey('text')) ? (String) condition.get('text') : 'No description available';
                        Integer humidity = (currentWeather.containsKey('humidity')) ? (Integer) currentWeather.get('humidity') : null;
                        Decimal windSpeed = (currentWeather.containsKey('wind_kph')) ? (Decimal) currentWeather.get('wind_kph') : null;
                        Decimal pressure = (currentWeather.containsKey('pressure_mb')) ? (Decimal) currentWeather.get('pressure_mb') : null;
                        Datetime timestamp = Datetime.now();
                        
                        // Store in Custom Object
                        Weather_Report__c weatherRecord = new Weather_Report__c();
                        weatherRecord.City__c = city;
                        weatherRecord.Temperature__c = temperature;
                        weatherRecord.Feels_Like__c = feelsLike;
                        weatherRecord.Weather_Description__c = weatherDesc;
                        weatherRecord.Humidity__c = humidity;
                        weatherRecord.Wind_Speed__c = windSpeed;
                        weatherRecord.Pressure__c = pressure;
                        weatherRecord.Timestamp__c = timestamp;

                        insert weatherRecord;
                        System.debug('Weather data saved: ' + weatherRecord);
                    } else {
                        System.debug('No weather condition data found.');
                    }
                } else {
                    System.debug('No current weather data found.');
                }
            } else {
                System.debug('Failed to fetch weather data. Status Code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error fetching weather data: ' + e.getMessage());
        }
    }
}