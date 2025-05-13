trigger OpportunityTrigger on Opportunity (after insert, after update) {
    // Initialize a list to hold OpportunityCreatedEvent__e events
    List<OpportunityCreatedEvent__e> events = new List<OpportunityCreatedEvent__e>();

    // Debug log to track trigger execution and number of Opportunities
    System.debug('### Trigger executed, number of Opportunities: ' + Trigger.new.size());

    // Loop through each Opportunity in Trigger.new (insert and update)
    for (Opportunity opp : Trigger.new) {
        // Create a new Platform Event for each Opportunity
        OpportunityCreatedEvent__e event = new OpportunityCreatedEvent__e(
            OpportunityId__c = opp.Id,
            Name__c = opp.Name,
            Amount__c = opp.Amount,
            StageName__c = opp.StageName
        );

        // Add event to the list
        events.add(event);

        // Debug log to show details of each created event
        System.debug('### Created Event: ' + event.OpportunityId__c + ', ' + event.Name__c + ', ' + event.Amount__c + ', ' + event.StageName__c);
    }

    // Debug log to show if any events are ready to be published
    if (!events.isEmpty()) {
        System.debug('### Publishing ' + events.size() + ' events to the EventBus');
        // Publish the events
        EventBus.publish(events);
    } else {
        System.debug('### No events to publish.');
    }
}