public with sharing class APIHandler {
    @AuraEnabled(cacheable=true)
    public static List<Todo> fetchTodos() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/todos'); 
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json');

        HttpResponse response = http.send(request);
        System.debug('Response Status: ' + response.getStatus());
        System.debug('Response Body: ' + response.getBody());
        if (response.getStatusCode() == 200) {
            // Deserialize JSON response into a List of Todo objects
            List<Todo> todos = (List<Todo>) JSON.deserialize(response.getBody(), List<Todo>.class);
            System.debug('Fetched Todos: ' + todos);
            return todos;
        } else {
            System.debug('Response Status: ' + response.getStatus());
        System.debug('Response Body: ' + response.getBody());
            throw new AuraHandledException('Failed to fetch data: ' + response.getStatus());
        }
    }

    // Inner class representing the Todo object
    public class Todo {
        @AuraEnabled public Integer userId;
        @AuraEnabled public Integer id;
        @AuraEnabled public String title;
        @AuraEnabled public Boolean completed;
    }
}