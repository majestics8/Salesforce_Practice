public class AccountHandler123 {
	 public static void updateAccountRating(List<Account> accList) {
        for (Account acc : accList) {
            if (acc.AnnualRevenue != null && acc.AnnualRevenue > 1000000) {
                acc.Rating = 'Warm';
            } else if (acc.AnnualRevenue != null && acc.AnnualRevenue > 500000) {
                acc.Rating = 'Hot';
            } else {
                acc.Rating = 'Cold';
            }
        }
    }
}