@isTest
public class apexpractice20NOVTest {
	@testSetup
    public static void testdata(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='AAccount', Type_of_Subscription__c='Annual', AccountNumber='12345678'));
        accounts.add(new Account(Name='BAccount', Type_of_Subscription__c='Monthly', AccountNumber='87654321'));
        accounts.add(new Account(Name='cAccount', Type_of_Subscription__c=null, AccountNumber='87654321'));
        insert accounts;
    }
    @isTest
    public static void test1(){
        List<Subscription__c> subscrpt1=[select Id from Subscription__c where Type__c='Annual'];
        List<Subscription__c> sub2=[select Id from Subscription__c where Type__c='Monthly'];
        List<Subscription__c> sub3=[select Id from Subscription__c where Type__c=null];
        
        system.assertEquals(3,subscrpt1.size());
        system.assertEquals(sub2.size(),2);
        system.assertEquals(sub3.size(),1);
        
    }
}