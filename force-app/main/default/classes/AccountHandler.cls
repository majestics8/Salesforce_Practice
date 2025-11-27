public class AccountHandler {
    public static void HandleAccount(List<Account> acclist){
        if(Trigger.isAfter && Trigger.isInsert){
            apexpractice20Nov.checkforsubstype(acclist);
        }
    }
}