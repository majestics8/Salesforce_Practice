@IsTest
public class apexpractice21NOV1_Test {

    @IsTest
    static void testRollupAmount() {

        // ---------- SETUP DATA ----------
        Account acc1 = new Account(Name = 'Test Acc 1');
        Account acc2 = new Account(Name = 'Test Acc 2');
        insert new List<Account>{ acc1, acc2 };

        // opp1 - Closed Won (should count)
        Opportunity opp1 = new Opportunity(
            Name = 'Opp 1',
            Amount = 10000,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = acc1.Id
        );

        // opp2 - Not Closed Won (should NOT count initially)
        Opportunity opp2 = new Opportunity(
            Name = 'Opp 2',
            Amount = 15000,
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            AccountId = acc1.Id
        );

        // opp3 - Closed Won for acc2 (should count)
        Opportunity opp3 = new Opportunity(
            Name = 'Opp 3',
            Amount = 5000,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            AccountId = acc2.Id
        );

        insert new List<Opportunity>{ opp1, opp2, opp3 };


        // ---------- SCENARIO 1: Insertion should roll-up ----------
        Test.startTest();
        apexpractice21NOV1.rollupamount(
            new List<Opportunity>{ opp1, opp2, opp3 },
            null
        );
        Test.stopTest();

        // Validate acc1 → only opp1 counted (10000)
        acc1 = [SELECT Total_Closed_Won_Amount__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(10000, acc1.Total_Closed_Won_Amount__c,
            'Only opp1 should count for acc1');

        // Validate acc2 → opp3 counted (5000)
        acc2 = [SELECT Total_Closed_Won_Amount__c FROM Account WHERE Id = :acc2.Id];
        System.assertEquals(5000, acc2.Total_Closed_Won_Amount__c,
            'Opp3 should be counted for acc2');



        // ---------- SCENARIO 2: Update opp2 → Closed Won ----------
        Opportunity opp2Old = opp2.clone(false, true, true);
        opp2.StageName = 'Closed Won';
        opp2.Amount = 20000;
        update opp2;

        Test.startTest();
        apexpractice21NOV1.rollupamount(
            new List<Opportunity>{ opp2 },
            new Map<Id, Opportunity>{ opp2Old.Id => opp2Old }
        );
        Test.stopTest();

        // Now acc1 should have opp1 + opp2 = 10000 + 20000 = 30000
        acc1 = [SELECT Total_Closed_Won_Amount__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(30000, acc1.Total_Closed_Won_Amount__c,
            'opp2 turned Closed Won, so total should be 30000');



        // ---------- SCENARIO 3: Update opp1 Closed Won → Prospecting (should NOT reduce total) ----------
        Opportunity opp1Old = opp1.clone(false, true, true);
        opp1.StageName = 'Prospecting';
        update opp1;

        Test.startTest();
        apexpractice21NOV1.rollupamount(
            new List<Opportunity>{ opp1 },
            new Map<Id, Opportunity>{ opp1Old.Id => opp1Old }
        );
        Test.stopTest();

        // Total should STILL be 30000 (opp2 only) because method ignores non-Closed Won updates
        acc1 = [SELECT Total_Closed_Won_Amount__c FROM Account WHERE Id = :acc1.Id];
        System.assertEquals(30000, acc1.Total_Closed_Won_Amount__c,
            'Changing Closed Won → non Closed Won should not re-rollup');

    }
}