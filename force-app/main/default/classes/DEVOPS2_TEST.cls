@isTest
class DEVOPS2_TEST {
	@isTest
    public static void test1(){
		List<Account> accnts=new List<Account>();
        accnts.add(new Account(Name='Ayush'));
        accnts.add(new Account(Name='test2'));
        
       // insert accnts;
        
        DEVOPS_APEX_CLASS2.preventinsert(accnts);
        
      //  Account acc=[select IsPremium__c from Account where Name='test1' Limit 1];
      
        System.assertEquals('Hot', accnts[0].Rating);
        System.assertEquals(null, accnts[1].Rating);
    
        
    }
    
    
}