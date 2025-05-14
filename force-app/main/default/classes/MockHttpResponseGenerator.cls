@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respondR(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{"company": {"name": "MockCompany Inc."}}');
        return res;
    }
}