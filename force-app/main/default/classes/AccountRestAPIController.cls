@RestResource(urlMapping='/accountCrud')
global class AccountRestAPIController {

   @HttpPost
   global static void doPost(){ 
    RestRequest req = RestContext.request;
    RestResponse res = RestContext.response;

    Map<String,Object> jsonResponse = Account_Rest_API_Handler.createAccount(req.requestBody.toString());
        res.statusCode=200;
        res.responseBody = Blob.valueOf(JSON.serialize(jsonResponse));
        res.addHeader('Content-Type', 'application/json');
        // return res;
        

    }

    @HttpPatch
    global static void doPatch(){
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String,Object> jsonResponse = Account_Rest_API_Handler.updateAccount(req.requestBody.toString());
         res.statusCode = 200;
         res.responseBody = Blob.valueOf(JSON.serialize(jsonResponse));
         res.addHeader('Content-Type', 'application/json');
    }

    @HttpDelete
    global static void doDelete(){
        

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        Map<String,Object> jsonResponse = Account_Rest_API_Handler.deleteAccount(req.requestBody.toString());
        res.statusCode = 200;
        res.responseBody = Blob.valueOf(JSON.serialize(jsonResponse));
        res.addHeader('Content-Type', 'application/json');
    }

}