global class WeatherFetchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        WeatherAPIIntegration.fetchAndStoreWeatherData('London');  // Example: Fetch weather data for London
    }
}