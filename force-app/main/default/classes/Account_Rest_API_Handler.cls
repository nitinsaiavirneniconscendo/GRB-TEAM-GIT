/**
 * @description
 * This class handles the business logic for Account CRUD operations invoked via a REST API.
 * It supports operations to create, update, and delete Account records based on JSON input.
 * The input is deserialized into a custom wrapper class `AccountWrapper` which represents minimal
 * Account data (Id, Name, Phone).
 *
 * Methods:
 * - createAccount(String accJson) : Accepts JSON array of account data, inserts records, and returns a status response.
 * - updateAccount(String accJson) : Accepts JSON array with Ids and updated fields, updates records, and returns a response.
 * - deleteAccount(String accJson) : Accepts JSON array with Ids, deletes records, and returns a response.
 *
 * @author Sudheer Kumar
 */


public  class Account_Rest_API_Handler {
    
    public class AccountWrapper{
        public String Name;
        public String accId;
        public String accPhone;


    }

    @AuraEnabled
    public static Map<String,Object> createAccount(String accJson){

        Map<String,Object> jsonResponse  = new Map<String,Object>();
 
        try{
            
        List<AccountWrapper> wrapper = (List<AccountWrapper>) Json.deserialize(accJson, List<AccountWrapper>.class);
        List<Account> acclist = new List<Account>();

         for(AccountWrapper accData : wrapper){
            Account acc = new Account();
            acc.Name = accData.Name;
            // acc.Phone = accData.accPhone;
            acclist.add(acc);
         }
        //RestAPIIntegrationCalloutController.methodCallout(JSON.serialize(acclist));
         //insert acclist;
         List<Database.SaveResult> result = Database.insert(acclist);
          for(Database.SaveResult res : result){
             if(res.isSuccess()){
            jsonResponse.put('Id : ' , res.getId());
            jsonResponse.put('Status', 'Success');
            jsonResponse.put('Message' , 'Successfully Inserted');
             }else{
                for(Database.Error err : res.getErrors()){
                jsonResponse.put('Error Field: ', err.getFields());
                jsonResponse.put('Error Message', err.getMessage());
                jsonResponse.put('Status', 'Error');
             }
            }
            }
        }
         catch(Exception e){
             jsonResponse.put('Status' , 'Error');
             jsonResponse.put('Message' ,'Error'+ e.getMessage());
         }
         return jsonResponse;
        
    }

    public static Map<String,Object> updateAccount(String accJson){

        Map<String,Object> jsonResponse = new Map<String,Object>();

        try{
            List<AccountWrapper> wrapper =(List<AccountWrapper>) Json.deserialize(accJson, List<AccountWrapper>.class);

            List<Account> accList = new List<Account>();

            for(AccountWrapper obj : wrapper){
                Account acc = new Account();
                acc.Id = obj.accId;
                acc.Name = obj.Name;
                acc.Phone = obj.accPhone;
                accList.add(acc);
            
            }
            update accList;
            jsonResponse.put('Status', 'Success');
            jsonResponse.put('Message', 'Record has Successfully Updated');

        }catch(Exception e){
             jsonResponse.put('Status', 'Error');
             jsonResponse.put('Message', e.getMessage());
        }
        return jsonResponse;
    }

    public static Map<String,Object> deleteAccount(String accJson){
        Map<String,Object> jsonresponse = new Map<String,Object>();


        try{
            List<AccountWrapper> wrapper = (List<AccountWrapper>) Json.deserialize(accJson,List<AccountWrapper>.class);

            List<Account> accList = new List<Account>();
            set<Id> setIds = new set<Id>();

            for(AccountWrapper delAcc : wrapper){
                setIds.add(delAcc.accId);
            }
            if(setIds.isEmpty()){
                 jsonresponse.put('Status', 'Error');
                jsonresponse.put('Message', 'No Records Found');
            }else{
                List<Account> accListToDelete = [SELECT Id FROM Account WHERE Id IN :setIds];
                delete accListToDelete;
                jsonresponse.put('Status', 'Success'); 
            }
        }catch(Exception e){
            jsonresponse.put('Status', 'Error');
            jsonresponse.put('Message', e.getMessage());
            
        }
        return  jsonresponse;

    }

  
    }