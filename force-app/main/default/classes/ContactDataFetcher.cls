public with sharing class ContactDataFetcher {
    
    public static void fetchAndUpdateContact(Id contactId) {
        try {
            // Define the endpoint
            String apiUrl = 'https://jsonplaceholder.typicode.com/users/1';

            // Create HTTP request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');

            // Send the request
            HttpResponse response = http.send(request);

            // Process the response
            if (response.getStatusCode() == 200) {
                // Parse JSON response
                Map<String, Object> userData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                // Extract fields
                String name = (String) userData.get('name');
                String email = (String) userData.get('email');

                // Update Contact
                Contact con = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :contactId LIMIT 1];
                if (name != null) {
                    List<String> nameParts = name.split(' ', 2);
                    con.FirstName = nameParts.size() > 1 ? nameParts[0] : 'Unknown';
                    con.LastName = nameParts.size() > 1 ? nameParts[1] : 'Unknown';
                }
                if (email != null) {
                    con.Email = email;
                }

                update con;
                System.debug('Contact updated successfully!');
            } else {
                System.debug('API Callout Failed: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Error in API Callout: ' + e.getMessage());
        }
    }
}
//ContactDataFetcher.fetchAndUpdateContact('CONTACT_ID');