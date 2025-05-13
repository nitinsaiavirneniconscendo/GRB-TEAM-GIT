public class CalloutExample {
    public static String getMessage() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.example.com/ping');
        req.setMethod('GET');

        Http http = new Http();
        HttpResponse res = http.send(req);

        return res.getBody();
    }
}
