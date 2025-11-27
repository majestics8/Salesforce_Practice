@isTest
public class Account_importancetest {

    @isTest
    static void testCheckImportance() {
        
        List<Account> accList = new List<Account>();
        accList.add(new Account(Name='Acc1', AnnualRevenue=2000000, AccountNumber='11111111'));
        accList.add(new Account(Name='Acc2', AnnualRevenue=150000, AccountNumber='22222222'));
        accList.add(new Account(Name='Acc3', AnnualRevenue=50000, AccountNumber='33333333'));

        
        Account_importancecheck.checkimp(accList);
        System.assertEquals('Hot', accList[0].Rating, 'Acc1 should be Hot');
        System.assertEquals('Warm', accList[1].Rating, 'Acc2 should be Warm');
        System.assertEquals('Cold', accList[2].Rating, 'Acc3 should be Cold');
    }

}