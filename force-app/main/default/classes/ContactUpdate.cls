global class ContactUpdateR implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Contact> contacts = [SELECT Id FROM Contact LIMIT 5];
        for (Contact c : contacts) {
            ContactService.contactServ(c.Id);
        }
    }
}