public class ContactEnrichmentSchedulerR implements Schedulable {
    public void execute(SchedulableContext sc) {
        List<Contact> contacts = [SELECT Id, Description FROM Contact LIMIT 10];
        
        for (Contact c : contacts) {
            if (String.isBlank(c.Description)) {
                try {
                    ContactEnrichmentService.enrichContact(c.Id); // ✅ this should match your actual service class name
                } catch (Exception e) {
                    System.debug('Failed to enrich contact ' + c.Id + ': ' + e.getMessage());
                }
            }
        }
    }
}