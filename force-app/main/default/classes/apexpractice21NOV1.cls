// Write a trigger and handler that updates Account.Total_Closed_Won_Amount__c with the sum of Amount of all Closed-Won Opportunities.
public class apexpractice21NOV1{
    public static void rollupamount(List<Opportunity> opplist,map<Id,Opportunity> oldoppmap){
       List<Id>accid=new List<Id>();
        for(Opportunity opp:opplist){
            if(opp.AccountId!=null && opp.StageName=='Closed Won'&& (oldoppmap == null || oldoppmap.get(opp.Id).StageName!=opp.StageName)){
                accid.add(opp.AccountId);
            }
        }
        
        List<Account> acc=new List<Account>();
        for(AggregateResult arr:[select AccountId accids, Sum(Amount) totalamt from Opportunity where AccountId In:accid And StageName='Closed Won' Group By AccountId]){
            decimal amount=(Decimal)arr.get('totalamt')!=null?(Decimal)arr.get('totalamt'):0;
            acc.add(new Account(Id=(Id)arr.get('accids'),Total_Closed_Won_Amount__c=amount));
        }
        if(!acc.isEmpty()){
            update acc;
        }
        
    }
}