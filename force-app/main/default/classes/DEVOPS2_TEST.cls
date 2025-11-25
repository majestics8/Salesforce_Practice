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
    @isTest
    public static void test2(){
        List<Opportunity> opp=new List<Opportunity>();
        opp.add(new Opportunity(Name='Opp1', StageName='Closed Won', Amount=1000000, CloseDate=Date.today()));
        insert opp;
    }
    
    
}