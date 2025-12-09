trigger Case_Task on Case_Task__c (After insert,After Update) {
    if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate)){
        system.debug('trigger is fired');
        ApexPractice6Dec_Handler.process(Trigger.new, Trigger.old, Trigger.oldmap, Trigger.isInsert);
    }
}