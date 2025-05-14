@RestResource(urlMapping = '/createcontact')
global class ContactRestAPI {
    @HttpPost
    global static ResponseWrapper createcontact(String firstname, String lastname, String email, String phone){
        ResponseWrapper response = new ResponseWrapper();
        try{
            Contact con = new Contact(
                FirstName = firstname,
                LastName = lastname,
                Email = email,
                Phone = phone
            );
            insert con;
            
            response.status = 'Success';
            response.message = 'Contat created successful';
            response.contactId = con.Id;
        }catch(Exception e){
            response.status = 'Error';
            response.message = e.getmessage();
        }
        return response;
        
    }
    global class ResponseWrapper{
        public string status;
        public string message;
        public string contactid;
    }

}