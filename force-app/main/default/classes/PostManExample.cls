@RestResource(urlMapping='/contactDataCreationExample/*')
global class PostManExample {
    @HttpPost
    global static String dataCreation() {
        try {
            // Read the request body
            String requestBody = RestContext.request.requestBody.toString();
            // Deserialize JSON into a Contact object
            Contact con = (Contact) JSON.deserialize(requestBody, Contact.class);
            // Ensure LastName is provided (mandatory field)
            if (String.isEmpty(con.LastName)) {
                return 'Error: Last Name is required';
            }
            // Insert contact record
            insert con;
            // Return the Contact ID as response
            return con.Id;
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}