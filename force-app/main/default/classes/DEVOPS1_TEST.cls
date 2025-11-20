@isTest
public class DEVOPS1_TEST {
	@isTest
    public static void test1(){
		List<Account> accnts=new List<Account>();
        accnts.add(new Account(Name='test1',AnnualRevenue=5000001));
        accnts.add(new Account(Name='test2',AnnualRevenue=5000000));
        
       // insert accnts;
        
        DEVOPS_APEX_CLASS1.setpremium(accnts);
        
      //  Account acc=[select IsPremium__c from Account where Name='test1' Limit 1];
      
        System.assertEquals(true, accnts[0].IsPremium__c);
        System.assertEquals(false, accnts[1].IsPremium__c);
    
        
    }
    
    
}