public with sharing class ContactHelper {

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts() {
        if (!Schema.sObjectType.Contact.isAccessible()) {
            throw new AuraHandledException('You do not have permission to view Contact records.');
        }

        // Safe SOQL query after permission check
        return [
            SELECT Id, FirstName, LastName
            FROM Contact
            LIMIT 10
        ];
    }
}
