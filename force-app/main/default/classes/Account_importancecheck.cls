public class Account_importancecheck {
    public static void checkimp(List<Account> acclist){
        for(Account acc:acclist){
        if(acc.AnnualRevenue > 200000){
			acc.rating='Hot';
        }
        else if(acc.AnnualRevenue >100000){
            acc.Rating='Warm';
        }
        else{
            acc.Rating='Cold';
            // dont know what to do
            // ha ha
        }
        }
    }
}