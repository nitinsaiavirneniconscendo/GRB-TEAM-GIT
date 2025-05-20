public class ScheduledApexWeatherJob implements Schedulable {
    public void execute(SchedulableContext context) {
        // Call the WeatherAPI method to get the latest weather data
        try {
            // Call the method from the WeatherAPI class to get the weather data
				Weatherexample.getWeatherData();
        } catch (Exception e) {
            System.debug('Error in scheduled job: ' + e.getMessage());
        }
    }
}