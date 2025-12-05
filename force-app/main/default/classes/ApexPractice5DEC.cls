public class ApexPractice5DEC {
    public static void Leadstatuscheck(List<Lead> ldlist,Map<Id,Lead> oldmap){
        set<Id> ldid=new set<Id>();
        Id pfid=[select Id from Profile where Name='Analytics Cloud Integration User' Limit 1].Id;
        User uu=[select Id from User where ProfileId = :pfid Limit 1];
        for(Lead newll:ldlist){
            Lead oldll=oldmap.get(newll.Id);
            if(newll.status=='Working - Contacted' && oldll.status=='Open - Not Contacted'){
				newll.ownerId=uu.Id;
            }
            if(newll.status=='Closed - Converted'){
                ldid.add(newll.Id);
            }
        }
        if(ldid.isEmpty()) return;
        set<Id> opentask=new set<Id>();
        for(Task tt:[select WhoId from Task Where Status!='Not Started' And Status!='Completed' And WhoId In:ldid]){
            opentask.add(tt.WhoId);
        }
        
        for(Lead ld:ldlist){
            if(opentask.contains(ld.Id)){
                ld.AddError('The Lead Cannot Be Updated');
            }
        }
    }
}//code end