public class AccountHandler123 {
	 public static void updateAccountRating(List<Account> accList) {
        for (Account acc : accList) {
            if (acc.AnnualRevenue != null && acc.AnnualRevenue > 5000001) {
                acc.Rating = 'Warm';
            } else if (acc.AnnualRevenue != null && acc.AnnualRevenue > 5000000) {
                acc.Rating = 'Hot';
            } else {
                acc.Rating = 'Cold';
            }
        }
    }
}