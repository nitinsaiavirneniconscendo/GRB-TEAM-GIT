@RestResource(URLMapping='/AccountsUpdateServices/*')
Global class AccountRecordsManagerService 
{
	@HttpPut
    Global static string UpdateAccountRecords(string accIndustry)
    {
        if(accIndustry != null && accIndustry != '')
        {
            List<Account> lstAccounts = [Select id, name, industry, rating, annualrevenue
                                        			from Account 
                                        				Where industry =: accIndustry];
            
            if(! lstAccounts.isEmpty())
            {
                for(Account acc : lstAccounts)
                {
                    Switch ON accIndustry
                    {
                     	When 'Banking'   
                        {
                            acc.Rating = 'Hot';
                            acc.Annualrevenue = 7900000;
                        }
                        When 'Finance'
                        {
                            acc.Rating = 'Warm';
                            acc.Annualrevenue = 5700000;
                        }
                        When 'Insurance'
                        {
                            acc.Rating = 'Hot';
                            acc.Annualrevenue = 8400000;
                        }
                        When 'Education'
                        {
                            acc.Rating = 'Cold';
                            acc.Annualrevenue = 4100000;
                        }
                        When 'Consulting'
                        {
                            acc.Rating = 'Warm';
                            acc.Annualrevenue = 5000000;
                        }
                    }
                }
                
                Update lstAccounts;
                return 'Records Updated.';
            }
            else
                return 'No Matching Records Found.';
        }
        else
        {
            return 'Please provide the Industry Name.';
        }
    }
}