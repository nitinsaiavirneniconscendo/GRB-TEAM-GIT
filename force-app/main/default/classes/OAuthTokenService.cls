public class OAuthTokenService {
    public static String getAccessToken() {
        // Replace with your actual credentials
        String clientId = '3MVG9PwZx9R6_Urdf1ecHkSyuxlZAayZaBwh1DSWuP6PSQTgTR7OeZjPx2HlRjFktjsv_cU6GLo_9caa37ElI';
        String clientSecret = 'B9588BE56792F1E61894DCE3C5498E90AFD7C967FE23DAC8842F0E3B6E81F2A4';
        String username = 'saikasukurthi79@abc.com';
        String password = 'Sravani24' + 'S8gVY79BFwt7ZP8QfNM7WIWQN';  // Append your Security Token
        String authUrl = 'https://login.salesforce.com/services/oauth2/token';

        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(authUrl);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

            // Prepare request body
            String body = 'grant_type=password' + 
                          '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8') +
                          '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8') +
                          '&username=' + EncodingUtil.urlEncode(username, 'UTF-8') +
                          '&password=' + EncodingUtil.urlEncode(password, 'UTF-8');

            req.setBody(body);

            Http http = new Http();
            HTTPResponse res = http.send(req);

            // Debugging logs
            System.debug('Response Status: ' + res.getStatusCode());
            System.debug('Response Body: ' + res.getBody());

            if (res.getStatusCode() == 200) {
                // Parse response and extract access token
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                String accessToken = (String) responseMap.get('access_token');
                System.debug('Access Token: ' + accessToken);
                return accessToken;
            } else {
                System.debug('Error: ' + res.getBody());
                return null;
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }
}