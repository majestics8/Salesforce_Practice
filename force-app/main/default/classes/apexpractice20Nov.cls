public class apexpractice20Nov {
    public static void checkforsubstype(List<Account> acclist){
        if(acclist.isEmpty()) return;
        
        List<Subscription__c> subs=new List<Subscription__c>();
        for(Account acc:acclist){
            if(acc.Type_of_Subscription__c=='Annual'){
                subs.add(new Subscription__c(Name='Hotstar',Type__c='Annual',IsActive__c=True));
                subs.add(new Subscription__c(Name='Spotify',Type__c='Annual',IsActive__c=True));
                subs.add(new Subscription__c(Name='AmazonPrime',Type__c='Annual',IsActive__c=True));
            }
            else if(acc.Type_of_Subscription__c=='Monthly'){
                subs.add(new Subscription__c(Name='SonyLiv',Type__c='Monthly',IsActive__c=True));
                subs.add(new Subscription__c(Name='Ganna',Type__c='Monthly',IsActive__c=True));
            }
            else{
                subs.add(new Subscription__c(Name='Anynomous',Type__c=null,IsActive__c=False));
            }
        }
        
        if(!subs.isEmpty()){
            insert subs;
        }
    }
}