@isTest
public class apexpractice25NOV1_Test {

    @isTest
    static void testHighValueClosedWon() {

        // Create Accounts
        Account acc1 = new Account(Name = 'Acc One');
        Account acc2 = new Account(Name = 'Acc Two');
        insert new List<Account>{acc1, acc2};

        // Create Opportunities
        Opportunity opp1 = new Opportunity( 
            Name = 'Big Deal 1', 
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 15000,
            AccountId = acc1.Id
        );

        Opportunity opp2 = new Opportunity(
            Name = 'Small Deal',
            StageName = 'Closed Won', 
            CloseDate = Date.today(),
            Amount = 5000, // should NOT 
            AccountId = acc1.Id
        );

        Opportunity opp3 = new Opportunity(
            Name = 'Big Deal 2',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 20000,
            AccountId = acc2.Id
        );

        insert new List<Opportunity>{opp1, opp2, opp3};

        // Call your method
        apexpractice25NOV1.checkoppforamt(
            new List<Opportunity>{opp1, opp2, opp3}
        );

        // Query updated Accounts
        acc1 = [SELECT Total_High_Value_Closed_Won_Amount__c FROM Account WHERE Id = :acc1.Id];
        acc2 = [SELECT Total_High_Value_Closed_Won_Amount__c FROM Account WHERE Id = :acc2.Id];

        // Validations
        System.assertEquals(
            15000, 
            acc1.Total_High_Value_Closed_Won_Amount__c,
            'Only opps > 10000 must count'
        );

        System.assertEquals(
            20000, 
            acc2.Total_High_Value_Closed_Won_Amount__c,
            'Amount should match sum of qualifying opportunities'
        );
    }



    @isTest
    static void testNoQualifyingOpportunities() {

        // Create Account
        Account acc = new Account(Name = 'Test No Qualify');
        insert acc;

        // Opportunity NOT matching criteria
        Opportunity opp = new Opportunity(
            Name = 'Low Deal',
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            Amount = 5000,
            AccountId = acc.Id
        );

        insert opp;

        // call apex
        apexpractice25NOV1.checkoppforamt(new List<Opportunity>{opp});

        // Query updated account
        acc = [SELECT Total_High_Value_Closed_Won_Amount__c FROM Account WHERE Id = :acc.Id];

        System.assertEquals(
            0,
            acc.Total_High_Value_Closed_Won_Amount__c,
            'Amount must be 0 when no opportunity qualifies'
        );
    }

}