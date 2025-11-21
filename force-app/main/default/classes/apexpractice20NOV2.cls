public class apexpractice20NOV2 {
    public static void invoicerollup(List<Invoice__c> invlist){
        if(invlist.isEmpty())return;
        set<Id> accid=new set<Id>();
        for(Invoice__c inv:invlist){
            if(inv.Account__c!=null && inv.Amount__c!=null){
                accid.add(inv.Account__c);
            }
        }
        
        if(accid.isEmpty()) return;
        
        Map<Id,Decimal> rollupamount=new Map<Id,Decimal>();
        for(AggregateResult arr:[select sum(Amount__c) amt, Account__c accid from Invoice__c where Account__c In:accid And Status__c='Paid' Group By Account__c]){
            rollupamount.put((Id)arr.get('accid'),(Decimal)arr.get('amt'));
        }
        
        List<Account> accnts=new List<Account>();
        for(Id acc:accid){
            Decimal paid_invoice=rollupamount.containsKey(acc)?rollupamount.get(acc):0;
            accnts.add(new Account(Id=acc,Total_Paid_Invoice__c=paid_invoice));
        }
        if(!accnts.isEmpty()){
            update accnts;
        }
        
    }
}