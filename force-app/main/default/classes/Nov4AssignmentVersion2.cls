public class Nov4AssignmentVersion2 {
public static void createtask(list<Opportunity> opplist){
		set<Id> accid=new set<Id>();  //grab this
        set<Id> oppid=new set<Id>();
        for(Opportunity opp:opplist){
            if(opp.AccountId!=null && opp.StageName=='Closed Won'){
				accid.add(opp.AccountId);
                oppid.add(opp.Id);
            }
        }
        
        Map<Id,Contact> cntmap=new Map<id,Contact>();  //grab this
    	set<Id> contid=new set<Id>();
        //map<Id,Id>ccownermap=new map<Id,Id>();
        for(Contact cc:[select Id, ownerId,AccountId from Contact where AccountId In :accid And Level__c='Primary']){
            cntmap.put(cc.AccountId,cc);
            contid.add(cc.Id);
           // ccownermap.put(cc.Id,cc.OwnerId);
        }
        
       set<String> combiofoppacc=new set<String>();
        for(Task tt:[select WhatId,WhoId from Task where WhatId In:oppid And WhoId In:contid And Subject='Follow up for Opportunity']){
            combiofoppacc.add(tt.WhatId+'-'+tt.WhoId);
        }
        
        List<Task> tt=new List<Task>();
        for(Opportunity opp:opplist){
            Contact currentcontact=cntmap.get(opp.AccountId);
            if(currentcontact==null)continue;
            if(!combiofoppacc.contains(opp.Id+'-'+currentcontact.Id)){
              tt.add(new Task(Subject='Follow up for Opportunity',ActivityDate=date.today().addDays(30),Whatid=opp.Id,WhoId=currentcontact.Id,OwnerId=currentcontact.OwnerId));                
            }
        }
        
        if(!tt.isEmpty()){
            insert tt;
        }
         
    }
}