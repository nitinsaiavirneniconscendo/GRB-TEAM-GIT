/**
 * @description
 * This Apex controller class integrates with the Spotify API via RapidAPI.
 * It provides methods to search for songs, albums, and artists, retrieve track preview details,
 * and proxy audio file responses to avoid Content Security Policy (CSP) issues in Salesforce.
 *
 * @author
 * Sudheer Kumar
 *
 * @methods
 *  - searchSpotify(String query): Searches Spotify content (multi-type) using the search term.
 *  - getTrackPreview(String trackId): Retrieves detailed information for a specific track using its ID.
 *  - getTrackPreviewProxy(String previewUrl): Acts as a proxy to fetch the track preview audio as a Blob to bypass CSP limitations.
 */

public class SpotifyController {
    
    public static string RAPIDAPI_KEY = 'b728e647aemsh0d6e293a3cc35cap178befjsnc22841e207a1'; 
    public static string RAPIDAPI_HOST = 'spotify23.p.rapidapi.com';
    public static string TRACK_URL = 'https://spotify23.p.rapidapi.com/tracks/?ids=';

    @AuraEnabled(cacheable = true)
    public static string searchSpotify(string query) { 
        if (string.isEmpty(query)) {
            System.debug('Search Query is Empty'); 
            return null;
        }

        try {
            String SEARCH_URL = 'https://spotify23.p.rapidapi.com/search/?q=';
            Http http = new Http();
            HttpRequest request = new HttpRequest();            
            String encodedQuery = EncodingUtil.urlEncode(query, 'UTF-8');
            String endpointUrl = SEARCH_URL + encodedQuery + '&type=multi&limit=10';
            request.setTimeout(20000);
            request.setEndpoint(endpointUrl);
            request.setMethod('GET');
            request.setHeader('X-RapidAPI-Key', RAPIDAPI_KEY);
            request.setHeader('X-RapidAPI-Host', RAPIDAPI_HOST);
            request.setHeader('Content-Type', 'application/json');
            
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                return response.getBody(); 
            } else {
                System.debug('Spotify API Error: ' + response.getStatus() + ' - ' + response.getBody());
                return null;
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }
    
    @AuraEnabled
    public static string getTrackPreview(string trackId) {
        if (string.isEmpty(trackId)) {
            System.debug('Track ID is Empty');
            return null;
        }

        try {
            Http http = new Http();
            HttpRequest request = new HttpRequest();            
            String endpointUrl = TRACK_URL + trackId;
            request.setTimeout(20000);
            request.setEndpoint(endpointUrl);
            request.setMethod('GET');
            request.setHeader('X-RapidAPI-Key', RAPIDAPI_KEY);
            request.setHeader('X-RapidAPI-Host', RAPIDAPI_HOST);
            request.setHeader('Content-Type', 'application/json');
            
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                return response.getBody(); 
            } else {
                System.debug('Spotify Track API Error: ' + response.getStatus() + ' - ' + response.getBody());
                return null;
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            return null;
        }
    }
    @AuraEnabled(cacheable=true)
    public static Blob getTrackPreviewProxy(String previewUrl) {
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(previewUrl);
        request.setMethod('GET');
        
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            return response.getBodyAsBlob();
        } else {
            throw new AuraHandledException('Failed to fetch audio: ' + response.getStatus());
        }
    }
}