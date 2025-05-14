@RestResource(urlMapping='/DeleterelatedfromAccount/')
global class Contactdeletionservice {
    @httpdelete
    global static string relatedcontact(){
        Map<String,String> inputparams = RestContext.request.params;
        List<Contact> conlst = [select id, firstname, lastname, Account.Name from Contact where Account.Name =: inputparams.get('Name')];
        Delete conlst;
        return 'contact deleted';
        
    }
    

}