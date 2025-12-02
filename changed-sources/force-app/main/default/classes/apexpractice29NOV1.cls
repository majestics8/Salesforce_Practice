public class apexpractice29NOV1 {
    public static void oppContaactrole(List<Opportunity> opplist,Map<Id,Opportunity> oldmap){
        map<Id,Id> oppmap=new map<Id,Id>();
        for(Opportunity opp:opplist){
            if(opp.Primary_Contact__c!=null && (oldmap==null || oldmap.get(opp.Id).Primary_Contact__c!=opp.Primary_Contact__c)){
                oppmap.put(opp.Id,opp.Primary_Contact__c);
                system.debug('code run');
            }
        }
       // Map<Id,OpportunityContactRole> ocr=new Map<Id,OpportunityContactRole>();
        List<OpportunityContactRole> ocrmap1=new List<OpportunityContactRole>();
        Map<Id,OpportunityContactRole> ocrmap2=new Map<Id,OpportunityContactRole>();
        for(OpportunityContactRole oppcr:[select Id,OpportunityId,ContactId,IsPrimary,Role From OpportunityContactRole where OpportunityId In:oppmap.keyset()]){
 
            ocrmap1.add(oppcr);
            
            if(oppmap.get(oppcr.OpportunityId)==oppcr.ContactId){
                ocrmap2.put(oppcr.OpportunityId,oppcr);
            }
        }
        
        List<OpportunityContactRole> ocrupdate=new List<OpportunityContactRole>();
        List<OpportunityContactRole> ocrinsert=new List<OpportunityContactRole>();
        For(Id opp:oppmap.keyset()){
            system.debug('Took enterance');
            if(ocrmap2.containsKey(opp)){
                system.debug(ocrmap2.get(opp));
                if(ocrmap2.get(opp).IsPrimary==false){	
                    ocrupdate.add(new OpportunityContactRole(Id=ocrmap2.get(opp).Id,IsPrimary=true,Role='Decision Maker'));
                }
            }
            else{
                system.debug('creating contact role');
                ocrinsert.add(new OpportunityContactRole(OpportunityId=opp,ContactId=oppmap.get(opp),IsPrimary=true,Role='Decision Maker'));
            }
        }
        
        for(OpportunityContactRole ocr:ocrmap1){
            /*if(!ocrmap2.isEmpty() && ocrmap2.get(ocr.OpportunityId).Id==ocr.Id){
                continue;
            }
            if(ocr.IsPrimary==true){
                ocrupdate.add(new OpportunityContactRole(Id=ocr.Id,IsPrimary=false));
            }*/
            if(ocr.IsPrimary && (ocrmap2.get(ocr.OpportunityId)==null || ocr.Id != ocrmap2.get(ocr.OpportunityId).Id)){
				ocrupdate.add(new OpportunityContactRole(Id=ocr.Id,IsPrimary=false));                
            }
        }
        
        if(!ocrupdate.isEmpty()){
            update ocrupdate;
        }
        if(!ocrinsert.isEmpty()){
            insert ocrinsert;
        }
    }
} //code end