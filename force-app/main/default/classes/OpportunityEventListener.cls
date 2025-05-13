public with sharing class OpportunityEventListener {
    @AuraEnabled
    public static void handleEvents(List<OpportunityEvent__e> events) {
        for (OpportunityEvent__e event : events) {
            System.enqueueJob(new OpportunityEventProcessor(event));
        }
    }
}