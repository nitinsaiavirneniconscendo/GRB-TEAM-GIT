global class AccountSoapService1 {
webService static Account getAccountById(Id accountId) {
        Account acc = [select Name, Phone, Industry from account where Id =:accountId];
        return acc;
    }
}