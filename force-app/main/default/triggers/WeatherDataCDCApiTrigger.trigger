trigger WeatherDataCDCApiTrigger on Weather_Data__ChangeEvent (after insert) {
    for(Weather_Data__ChangeEvent evt : Trigger.new){
        String recordId = evt.id;
        String location = evt.Location__c;
        Decimal Temperature = evt.Temperature__c;
        Decimal humidity = evt.Humidity__c;
        String description = evt.Description__c;
        Datetime lastupdated = evt.Last_Updated__c;
        
        String changeType = evt.ChangeEventHeader.getChangeType();
        if(changeType == 'CREATE' || changeType == 'UPDATE'){
            WeatherDataService.sendWeatherData(recordId, location, temperature, humidity, description, lastUpdated);
        }
        
    }
    

}