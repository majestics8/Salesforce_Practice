public class apexpractice25NOV1 {
    public static void checkoppforamt(List<Opportunity> opplist){
        if(opplist.isEmpty()) return;
        set<Id> accid=new set<Id>();
        for(Opportunity opp:opplist){
            if(opp.AccountId !=null){
                accid.add(opp.AccountId);
            }
        }
        
        Map<Id,Decimal> amtmap=new Map<Id,Decimal>();
        
        for(AggregateResult arr:[select AccountId accids,sum(Amount) amt from Opportunity where AccountId In:accid AND Amount>10000 AND StageName='Closed Won' Group By AccountId]){
            amtmap.put((Id)arr.get('accids'),(Decimal)arr.get('amt'));
        }
        
        List<Account> accnts=new List<Account>();
        for(Id ids:accid){
            decimal amount=amtmap.containskey(ids)?amtmap.get(ids):0;
            accnts.add(New Account(Id=ids,Total_High_Value_Closed_Won_Amount__c=amount));
        }
        
        if(!accnts.isEmpty()){
            update accnts;
        }
    }
}