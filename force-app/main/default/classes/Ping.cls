@RestResource(urlMapping='/ping')
global with sharing class Ping {

    @HttpGet
    global static void ping() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = 
            Blob.valueOf('{"message": "Server is alive ✅"}');
    }

    @HttpPost
    global static void pingPost() {
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = 
            Blob.valueOf('{"message": "POST received ✅"}');
    }
}
