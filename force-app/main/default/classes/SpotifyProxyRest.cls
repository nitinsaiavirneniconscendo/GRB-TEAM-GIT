/**
 * @description
 * This Apex REST resource class serves as a proxy endpoint (`/services/apexrest/spotifyproxy/`) 
 * to fetch and deliver audio previews from external Spotify URL.
 * It helps bypass Salesforce’s Content Security Policy (CSP) restrictions by streaming 
 *
 * @author
 * Sudheer Kumar
 *
 * @methods
 *  - getAudioFile(): Retrieves audio content from the provided `url` parameter and returns it in the response body.
 */

@RestResource(urlMapping='/spotifyproxy/*')
global  class SpotifyProxyRest {
    @HttpGet
    global static void getAudioFile() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
        
        String previewUrl = req.params.get('url');
        system.debug('Preview url : ' + previewUrl);
        
        if (String.isBlank(previewUrl)) {
            res.statusCode = 400;
            res.responseBody = Blob.valueOf('Missing URL parameter');
            return;
        }
        
        try {
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(previewUrl);
            request.setMethod('GET');
            request.setTimeout(20000); 
            
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
               
                res.addHeader('Content-Type', 'audio/mpeg');
                res.addHeader('Cache-Control', 'public, max-age=86400'); 
                res.responseBody = response.getBodyAsBlob();
            } else {
                res.statusCode = response.getStatusCode();
                res.responseBody = Blob.valueOf('Error fetching audio: ' + response.getStatus());
            }
        } catch (Exception e) {
            res.statusCode = 500;
            res.responseBody = Blob.valueOf('Error: ' + e.getMessage());
        }
    }
}