@RestResource(urlMapping='/getDatafromAccount/')
global class OutBondIntegration {
    @httpget
    global static List<Account> getAccountData(){
        List<Account> accList = [Select id,Name from Account];
        return accList;
    }
}