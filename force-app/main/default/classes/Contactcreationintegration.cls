public class Contactcreationintegration {
    private static final String NAMED_CREDENTIAL = 'callout:conatctcreation';
    
    @future(callout=true)
    public static void fetchandcreatecontact(){
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
                Userwrapper user = (Userwrapper) JSON.deserialize(res.getBody(), Userwrapper.class);  
                
                Contact con = new Contact(
                    FirstName = user.name.split(' ')[0],  
                    LastName = user.name.split(' ').size() > 1 ? user.name.split(' ')[1] : 'User', 
                    Email = user.email,
                    HomePhone = user.phone 
                );

                System.debug('Contact to Insert: ' + con); 
                
                insert con;
                System.debug('Contact Inserted Successfully: ' + con.Id); 
                
            } else {
                System.debug('API Call Failed. Status Code: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
        }
    }

    public class Userwrapper {
        public String name;
        public String email;
        public String phone;
    }
}