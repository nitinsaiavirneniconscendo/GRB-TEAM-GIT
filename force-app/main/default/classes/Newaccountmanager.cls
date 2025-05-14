@RestResource(URLMapping='/accountcreationsevice/')
global class Newaccountmanager {
    @HttpPost
      global static string insertnewaccounts(string accname,string accrating,string accindustry,decimal accrevenue,string accphone,string accfax,string accwebsite,string acctype,string accownership,string accactive)
      {
          Account acc = new Account();
          acc.Name = accname;
          acc.Rating = accrating;
          acc.Industry = accindustry;
          acc.AnnualRevenue = accrevenue;
          acc.Phone = accphone;
          acc.Fax = accfax;
          acc.Website = accwebsite;
          acc.Type = acctype;
          acc.Ownership = accownership;
          
          
          insert acc;
          
          if(acc.Id != null)
          {
              return 'Account inserted';
          }
          else
          {
              return 'something went wrong in account data';
          }
      }
        

}