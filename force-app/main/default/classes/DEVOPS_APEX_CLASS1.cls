public class DEVOPS_APEX_CLASS1 {
    public static void setpremium(List<Account> acclist){
        for(Account acc:acclist){
            if(acc.AnnualRevenue>5000000){
               // acc.IsPremium__c=True;
            }
        }
    }
}