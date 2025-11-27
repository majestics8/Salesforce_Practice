//Write an Apex class that changes the Rating field of all Accounts where Name starts with “A” to “Hot”.
public class DEVOPS_APEX_CLASS2 {
    public static void preventinsert(List<Account> acclist){
        for(Account acc:acclist){
            if(acc.Name.startswith('A')){
                acc.Rating='Hot';
            }
        }
    }
}