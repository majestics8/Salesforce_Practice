//Restrict Delete on Account If It Has Open Opportunities
//Write a trigger that prevents deleting an Account if:
//It has Opportunities that are not Closed
//Display an error on before delete

public class apexpractice21NOV3{
    public static void restrictaccdelete(List<Account> acclist){
        set<Id> accid=new set<Id>();
        for(Account accnt:acclist){
            accid.add(accnt.Id);
        }
        set<Id> acntid=new set<id>();
        for(Opportunity opp:[select Id,AccountId from Opportunity where AccountId In:accid And StageName!='Closed Won'And StageName!='Closed Lost']){
            acntid.add(opp.AccountId);
        }
        if(acntid.isEmpty()){
            return;
        }
        
        for(Account acc:acclist){
            if(acntid.contains(acc.Id)){
                acc.addError('We cannot delete this Account it has Active Opportunities');
            }
        }
    }
}