//Write a trigger that updates Contact.Completed_Tasks_Count__c every time a Task related to a Contact is:Created, Deleted, Reopened
public class apexpractice21NOV2 {
    public static void taskcheck(List<Task> ttlist,Map<Id,Task> oldtt){
        
        List<Id> ccid=new List<Id>();
        for(Task tt:ttlist){
            if(tt.WhoId != null){
                ccid.add(tt.WhoId);
            }
        }
        List<Contact> cc=new List<Contact>();
        for(AggregateResult arr:[select Count(Id) ttid, WhoId contid from Task Where WhoId In:ccid And Status='Completed' Group By WhoId]){
            Integer countoftask=(Integer)arr.get('ttid')!=null?(Integer)arr.get('ttid'):0;
            cc.add(New Contact(Id=(Id)arr.get('contid'),Completed_Tasks_Count__c=countoftask));
        }
        
        if(!cc.isEmpty()){
            update cc;
        }
    }
}