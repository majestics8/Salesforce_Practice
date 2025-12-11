public class ApexPractice6Dec_Handler {
    public static void process(List<Case_Task__c> clist,List<Case_Task__c> oldclist,Map<Id,Case_Task__c> oldmap,Boolean isInsert){
        set<Id> caseids=new set<Id>();
        if(clist != null){
            for(Case_Task__c c:clist){
                if(c.Case__c!=null){
                    caseids.add(c.Case__c);
                    system.debug('case is udpdated');
                }
            }
        }
        
        if(oldclist!=null){
            for(Case_Task__c c:oldclist){
                if(c.Case__c!=null){
                   caseids.add(c.Case__c); 
                   system.debug('old case found');
                }
            }
        }
        
        if(clist != null && oldmap !=null){
            for(Case_Task__c c:clist){
                if(oldmap.containsKey(c.Id) && c.Case__c != oldmap.get(c.Id).Case__c){
                    if(oldmap.get(c.Id).Case__c!=null){
                        caseids.add(oldmap.get(c.Id).Case__c);
                        system.debug('case is changed');
                    }
                }
            }
        }
        
        if(caseids.isEmpty()) return;
        
        set<Id> CasetoNotify=new set<Id>();
        for(Case_Task__c c:clist){
            if(isInsert && c.Case__c!=null && c.Priority__c=='High'){
                CasetoNotify.add(c.Case__c);
                system.debug('High priority');
            }
        }
        
		Map<Id,Integer> totalcasetaskcount=new Map<Id,Integer>();     
        Map<Id,Map<String,Integer>> perStatuscount=new Map<Id,Map<String,Integer>>();
        for(AggregateResult arr:[select Case__c,Status__c,count(Id) total from Case_Task__c where Case__c In:caseids And Status__c != null Group By Case__c,Status__c]){
            Id caseid=(Id)arr.get('Case__c');
            String casestatus=(String)arr.get('Status__c');
            Integer totalcases=(Integer)arr.get('total');
            if(!perStatuscount.containskey(caseid)){
                perStatuscount.put(caseid,new Map<String,Integer>());
            }
            perStatuscount.get(caseid).put(casestatus,totalcases);
            
            totalcasetaskcount.put(caseid,totalcasetaskcount.containsKey(caseid)?totalcasetaskcount.get(caseid)+totalcases:totalcases);
        }
        
            Map<Id,Case> existingcase=new Map<Id,Case>([select Id,Owner.Email From Case where Id In:CasetoNotify]);
        
        List<Case> Updatecase=new List<Case>();
        for(Id cid:caseids){
            
            Map<String,Integer> statuscount=perStatuscount.containskey(cid)?perStatuscount.get(cid):new Map<String,Integer>();
            
            integer Completed=statuscount.get('Completed')!= null ? statuscount.get('Completed') : 0;
            integer Blocked=statuscount.get('Blocked')!= null ? statuscount.get('Blocked') : 0;
            integer InProgress=statuscount.get('In Progress')!= null ? statuscount.get('In Progress') : 0;
            integer totalcases=totalcasetaskcount.containsKey(cid)?totalcasetaskcount.get(cid):0;
            
            if(totalcases>0 && Completed==totalcases){
                Updatecase.add(new Case(Id=cid, Status='Resolved'));
            }
            else if(Blocked>0){
                Updatecase.add(new Case(Id=cid, Status='On Hold'));
            }
            else if(InProgress>=3){
                Updatecase.add(new Case(Id=cid,Status='Escalated'));
            }
        }
        if(!Updatecase.isEmpty()){
            update Updatecase;
        }   
        
        if(!CasetoNotify.isEmpty()){
            List<Messaging.SingleEmailMessage> email=new List<Messaging.SingleEmailMessage>();
            for(Id c:CasetoNotify){
                if(existingcase.containsKey(c) && existingcase.get(c).Owner.Email != null){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    String[] toaddress=new String[] {existingcase.get(c).Owner.Email};
                    mail.setToAddresses(toaddress);
                    mail.setSubject('Alert For High Priority Case Task');
                    mail.setPlainTextBody( 'Hello!'+'\n\n'+'We have Found The Hight Priority Case Task'+ 'Please Resolve the issues beacuse the prority is high'+ 'ThankYou !' );
                    email.add(mail);
                }
            }
            if(!email.isEmpty()){
                Messaging.sendEmail(email);
            }
        }
    }
}
