@isTest
public class DEVOPS1_TEST {
	
		@testSetup
        public static void testdata(){
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name='AAccount', AnnualRevenue=6000000, AccountNumber='12345678'));
        accounts.add(new Account(Name='BAccount', AnnualRevenue=4000000, AccountNumber='87654321'));
        accounts.add(new Account(Name='BAccount', AnnualRevenue=5000001, AccountNumber='87654321'));
        insert accounts;

        List<Contact> contacts = new List<Contact>();
        contacts.add(new Contact(FirstName='John', LastName='Doe', AccountId=accounts[0].Id, Level__c='Primary'));
        contacts.add(new Contact(FirstName='Jane', LastName='Doe', AccountId=accounts[1].Id, Level__c='Primary'));
        insert contacts;
        }    
    
       @isTest
       public static void testing(){
        List<Account> accs = [SELECT Id, Name, AnnualRevenue, Rating FROM Account];
       // List<Contact> contacts = [SELECT Id, AccountId FROM Contact];
       //changes are reflected 

        AccountHandler123.updateAccountRating(accs);
		DEVOPS_APEX_CLASS1.setpremium(accs);
        mytestclass.execute();
        mytestclass_Test.execute();
           
           List<Opportunity> opp=new List<Opportunity>();
           insert opp;
           opp.add(new Opportunity(Name='Opp1', StageName='Closed Won', Amount=1000000, CloseDate=Date.today(), AccountId=accs[0].Id));
        	Nov4AssignmentVersion2.createtask(opp);
       }  
    
}