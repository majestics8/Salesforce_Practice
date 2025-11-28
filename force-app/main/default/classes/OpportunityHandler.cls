public class OpportunityHandler {
    public static void handleopportunity(List<Opportunity> newopp, List<Opportunity> oldopp,Map<Id,Opportunity> oppoldmap){
        if(Trigger.isInsert || Trigger.isUpdate || Trigger.isUnDelete){
            apexpractice21NOV1.rollupamount(newopp,oppoldmap);
        }
        if(Trigger.isUpdate || Trigger.isDelete){
            apexpractice21NOV1.rollupamount(oldopp,null);
        }
    }
}