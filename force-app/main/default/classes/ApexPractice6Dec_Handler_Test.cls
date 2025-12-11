@isTest
private class ApexPractice6Dec_Handler_Test {

    @isTest static void testStatuscheckMultipleScenarios() {

        Case c1 = new Case(Subject = 'Dummy case 1');
        insert c1;

        Case_Task__c t1 = new Case_Task__c(Case__c = c1.Id, Status__c = 'In Progress', Priority__c='Medium');
        Case_Task__c t3 = new Case_Task__c(Case__c = c1.Id, Status__c = 'In Progress', Priority__c='High');
        Case_Task__c t2 = new Case_Task__c(Case__c = c1.Id, Status__c = 'In Progress', Priority__c='Medium');
    
        insert new List<Case_Task__c>{t1,t2,t3};

        // Reload cases and assert expected statuses
        c1 = [SELECT Id, Status FROM Case WHERE Id = :c1.Id];
        
        System.assertEquals('Escalated', c1.Status);
        
        Case_Task__c existingt1=[select Status__c from Case_Task__c where Id= :t1.Id];
        existingt1.Status__c='Blocked';
        update existingt1;
        c1 = [SELECT Id, Status FROM Case WHERE Id = :c1.Id];
        System.assertEquals('On Hold', c1.Status);
        
        list<Case_Task__c> cts=new List<Case_Task__c>();
        for(Case_Task__c c:[select Id,Status__c from Case_Task__c where Case__c =:c1.Id]){
            cts.add(new Case_Task__c(Id=c.Id,Status__c='Completed'));
        }
        update cts;
        
        c1 = [SELECT Id, Status FROM Case WHERE Id = :c1.Id];
        System.assertEquals('Resolved', c1.Status);
        
        Case c2 = new Case(Subject = 'Dummy case 2');
        insert c2;
        
        Case_Task__c existingt2=[select Case__c from Case_Task__c where Id= :t1.Id];
        existingt2.Case__c=c2.Id;
        update existingt2;
        
       // Case c3 = [SELECT Id, Status FROM Case WHERE Id = :c2.Id];
      // System.assertEquals('Resolved', c3.Status);
    }
}