public class WeatherDataScheduler implements Schedulable {
     public void executeR(SchedulableContext context) {
        WeatherFetcher.fetchWeatherData();
    }

}