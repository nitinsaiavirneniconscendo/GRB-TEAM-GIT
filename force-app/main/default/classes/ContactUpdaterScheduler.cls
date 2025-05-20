public without sharing class ContactUpdaterScheduler implements Schedulable {
    private static final String NAMED_CREDENTIAL = 'callout:conatctcreation';
    
    public void execute(SchedulableContext sc) {
        updateContactsFromAPI();
    }
    
    @future(callout=true)
    public static void updateContactsFromAPI() {
        try {
            String endpoint = NAMED_CREDENTIAL + '/users/1';
            System.debug('Calling API: ' + endpoint);
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');
            
            HttpResponse res = http.send(req);
            System.debug('API Response: ' + res.getBody());
            
            if (res.getStatusCode() == 200) {
                List<UserWrapper> users;
                
                try {
                    // Try parsing as a List
                    users = (List<UserWrapper>) JSON.deserialize(res.getBody(), List<UserWrapper>.class);
                } catch (Exception e) {
                    // If parsing as a single object, wrap in a list
                    UserWrapper singleUser = (UserWrapper) JSON.deserialize(res.getBody(), UserWrapper.class);
                    users = new List<UserWrapper>{ singleUser };
                }

                System.debug('Parsed Users: ' + users);
                
                if (users.isEmpty()) {
                    System.debug('No users found in API response.');
                    return;
                }

                // Collect and normalize emails
                Set<String> emailIds = new Set<String>();
                for (UserWrapper user : users) {
                    if (user.email != null) {
                        emailIds.add(user.email.trim().toLowerCase());
                    }
                }
                System.debug('Emails from API: ' + emailIds);
                
                if (emailIds.isEmpty()) {
                    System.debug('No valid emails received from API.');
                    return;
                }

                // Fetch existing contacts from Salesforce
                List<Contact> conList = [SELECT Id, LastName, FirstName, Email, HomePhone 
                                         FROM Contact WHERE Email IN :emailIds];
                System.debug('Retrieved Contacts: ' + conList);

                // Map existing contacts by normalized email
                Map<String, Contact> existingConMap = new Map<String, Contact>();
                for (Contact co : conList) {
                    existingConMap.put(co.Email.trim().toLowerCase(), co);
                }

                // Prepare contacts for update
                List<Contact> contactsToUpdate = new List<Contact>();
                for (UserWrapper user : users) {
                    if (existingConMap.containsKey(user.email.trim().toLowerCase())) {
                        Contact con = existingConMap.get(user.email.trim().toLowerCase());
                        con.FirstName = 'contact01';
                        con.LastName = 'created';
                        con.HomePhone = user.phone;
                        contactsToUpdate.add(con);
                    }
                }

                System.debug('Contacts to be updated: ' + contactsToUpdate);

                // Perform update if there are contacts to update
                if (!contactsToUpdate.isEmpty()) {
                    try {
                        update contactsToUpdate;
                        System.debug('Contacts updated successfully.');
                    } catch (DmlException dmlEx) {
                        System.debug('DML Exception: ' + dmlEx.getMessage());
                    }
                } else {
                    System.debug('No contacts to update.');
                }
            } else {
                System.debug('API Call failed with status: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }
    
    public class UserWrapper {
        public String name;
        public String email;
        public String phone;
    }
}