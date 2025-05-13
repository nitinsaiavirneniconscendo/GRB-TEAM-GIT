@isTest
public class MockWeatherHttpResponse implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{"name":"New York","main":{"temp":298.15,"humidity":65},"weather":[{"description":"Clear sky"}]}');
        return res;
    }
}