trigger Lead on Lead (before update) {
    if(Trigger.isBefore && Trigger.isUpdate){
        ApexPractice5DEC.Leadstatuscheck(trigger.new, trigger.oldmap);
    }
}