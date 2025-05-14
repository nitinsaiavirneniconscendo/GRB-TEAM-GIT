trigger OpportunityEventTrigger on OpportunityCreatedEvent__e (after insert) {
    List<String> oppIds = new List<String>();

    System.debug('### Trigger executed, number of events: ' + Trigger.new.size());

    for (OpportunityCreatedEvent__e event : Trigger.new) {
        if (event.OpportunityId__c != null) {
            oppIds.add(event.OpportunityId__c);
            System.debug('### Added Opportunity ID: ' + event.OpportunityId__c);
        } else {
            System.debug('### No Opportunity ID for event: ' + event);
        }
    }

    System.debug('### Collected Opportunity IDs: ' + oppIds);

    if (!oppIds.isEmpty()) {
        System.debug('### Calling OpportunityEventHandler.sendToExternalAPI with ' + oppIds.size() + ' Opportunity IDs');
        OpportunityEventHandler.sendToExternalAPI(oppIds);
    } else {
        System.debug('### No valid Opportunity IDs to process.');
    }
}