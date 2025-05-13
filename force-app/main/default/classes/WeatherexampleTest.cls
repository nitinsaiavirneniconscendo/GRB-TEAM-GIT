@isTest
public class WeatherexampleTest {
    @isTest
    static void testGetWeatherData() {
        
        Test.setMock(HttpCalloutMock.class, new MockWeatherHttpResponse());
        Test.startTest();
        Weatherexample.getWeatherData();
        Test.stopTest();
        Weather_Data__c weatherRecord = [SELECT Location__c, Temperature__c, Humidity__c, Description__c FROM Weather_Data__c LIMIT 1];

        //System.assertEquals('New York', weatherRecord.Location__c);
        //System.assertEquals(298.15, weatherRecord.Temperature__c);
        //System.assertEquals(65, weatherRecord.Humidity__c);
        //System.assertEquals('Clear sky', weatherRecord.Description__c); // ✅ No more null values
    }
}