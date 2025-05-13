/*global class WeatherScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        WeatherService.fetchWeatherData();
    }
}*/
global class WeatherScheduler implements Schedulable {

    // The 'execute' method will be called when the scheduled job runs.
    global void execute(SchedulableContext context) {
        // You can pass any city or make it dynamic if needed
        String city = 'New York'; // Change to your desired city

        // Call the fetchWeatherData method
        WeatherService.fetchWeatherData(city);
    }

    // Schedule the job to run every minute
    global static void scheduleWeatherFetch() {
      /*  // Define the frequency at which the job will run (every minute)
        String cronExpression = '0 0/1 * * * ?';  // Run every minute

        // You can change the job name to something meaningful like 'Weather Fetch Job'
        String jobName = 'Weather Fetch Job';

        // Schedule the job
        System.schedule(jobName, cronExpression, new WeatherScheduler());*/
    }
}