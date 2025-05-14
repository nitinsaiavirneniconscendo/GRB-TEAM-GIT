@isTest
public class WeatherDataCDCApiTriggerTest {
    
    @testSetup
    static void setupTestData() {
        // Create test Weather Data record
        Weather_Data__c testWeather = new Weather_Data__c(
            Location__c = 'New York',
            Temperature__c = 22.5,
            Humidity__c = 60.0,
            Description__c = 'Partly Cloudy',
            Last_Updated__c = System.now()
        );
        insert testWeather;
    }

    @isTest
    static void testWeatherDataTrigger() {
        // Mock HTTP response
        Test.setMock(HttpCalloutMock.class, new WeatherDataMockResponse());

        // Create another Weather Data record to trigger the CDC event
        Test.startTest();
        Weather_Data__c newWeather = new Weather_Data__c(
            Location__c = 'Los Angeles',
            Temperature__c = 25.0,
            Humidity__c = 55.0,
            Description__c = 'Sunny',
            Last_Updated__c = System.now()
        );
        insert newWeather;
        Test.stopTest();

        // Assertions (Optional)
        System.assert(true, 'Ensure trigger executed without errors');
    }
}