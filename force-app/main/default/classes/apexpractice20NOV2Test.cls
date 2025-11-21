@isTest
public class apexpractice20NOV2Test {
 /*   @testSetup
    public static void testdata(){
        Account acc=new Account(Name='Account',AccountNumber='12345678');
        insert acc;
		
        List<Invoice__c> inv=new List<Invoice__c>();
        inv.add(new Invoice__c(Account__c=acc,Amount__c=1000,Status__c'Paid'));
        inv.add(new Invoice__c(Account__c=acc,Amount__c=1000,Status__c'Paid'));
        inv.add(new Invoice__c(Account__c=acc,Amount__c=1000,Status__c'Paid'));
        inv.add(new Invoice__c(Account__c=acc,Amount__c=1000,Status__c'Paid'));
    }
    @isTest
   // public static */
   // 
   // ------------------------------
    // Common Test Data
    // ------------------------------
    @testSetup
    static void setupData() {

        // Create Accounts
        Account a1 = new Account(Name = 'Acc1');
        Account a2 = new Account(Name = 'Acc2');
        insert new List<Account>{a1, a2};

        // Create Invoices (Paid + Unpaid)
        List<Invoice__c> invList = new List<Invoice__c>{
            new Invoice__c(Account__c = a1.Id, Amount__c = 100, Status__c = 'Paid'),
            new Invoice__c(Account__c = a1.Id, Amount__c = 200, Status__c = 'Paid'),
            new Invoice__c(Account__c = a1.Id, Amount__c = 50,  Status__c = 'Unpaid'),

            new Invoice__c(Account__c = a2.Id, Amount__c = 300, Status__c = 'Paid'),
            new Invoice__c(Account__c = a2.Id, Amount__c = 100, Status__c = 'Unpaid')
        };
        insert invList;
    }

    // ------------------------------
    // Test Insert Rollup
    // ------------------------------
    @isTest
    static void testInsertRollup() {

        Account a1 = [SELECT Id, Total_Paid_Invoice__c FROM Account WHERE Name = 'Acc1' LIMIT 1];

        // A1 Paid invoices: 100 + 200 = 300
        System.assertEquals(300, a1.Total_Paid_Invoice__c, 'Insert rollup incorrect');
    }

    // ------------------------------
    // Test Update Rollup (Unpaid -> Paid)
    // ------------------------------
    @isTest
    static void testUpdateRollup() {

        // Make the unpaid invoice Paid
        Invoice__c inv = [SELECT Id, Status__c, Amount__c FROM Invoice__c WHERE Amount__c = 50 LIMIT 1];
        inv.Status__c = 'Paid';

        Test.startTest();
        update inv;
        Test.stopTest();

        Account a1 = [SELECT Total_Paid_Invoice__c FROM Account WHERE Name = 'Acc1' LIMIT 1];

        // Expected: 100 + 200 + 50 = 350
        System.assertEquals(350, a1.Total_Paid_Invoice__c, 'Update rollup failed');
    }

    // ------------------------------
    // Test Delete Rollup (Paid invoice deleted)
    // ------------------------------
    @isTest
    static void testDeleteRollup() {

        // Delete one paid invoice (100)
        Invoice__c inv = [SELECT Id FROM Invoice__c WHERE Amount__c = 100 LIMIT 1];

        Test.startTest();
        delete inv;
        Test.stopTest();

        Account a1 = [SELECT Total_Paid_Invoice__c FROM Account WHERE Name = 'Acc1' LIMIT 1];

        // Remaining Paid: 200
        System.assertEquals(200, a1.Total_Paid_Invoice__c, 'Delete rollup failed');
    }

    // ------------------------------
    // Test Undelete Rollup
    // ------------------------------
    @isTest
    static void testUndeleteRollup() {

        // Delete a paid invoice
        Invoice__c inv = [SELECT Id FROM Invoice__c WHERE Amount__c = 200 LIMIT 1];
        delete inv;

        Test.startTest();
        undelete inv;
        Test.stopTest();

        Account a1 = [SELECT Total_Paid_Invoice__c FROM Account WHERE Name = 'Acc1' LIMIT 1];

        // Expected Paid: 100 + 200 = 300
        System.assertEquals(300, a1.Total_Paid_Invoice__c, 'Undelete rollup failed');
    }
    
}