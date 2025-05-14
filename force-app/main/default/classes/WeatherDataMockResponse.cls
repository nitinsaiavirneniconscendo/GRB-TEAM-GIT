@isTest
global class WeatherDataMockResponse implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        // Validate the request
        System.assertEquals('POST', req.getMethod(), 'HTTP Method should be POST');
        System.assert(req.getBody().contains('location'), 'JSON body should contain location field');

        // Create mock response
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"status":"success"}');
        return response;
    }
}