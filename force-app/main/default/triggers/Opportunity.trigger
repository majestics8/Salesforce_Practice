trigger Opportunity on Opportunity (after insert,after update) {
    if(Trigger.isAfter &&(Trigger.isupdate || Trigger.isInsert)){
        Nov4AssignmentVersion2.createtask(trigger.new);
        apexpractice29NOV1.oppContaactrole(trigger.new,trigger.oldmap);
    }
}