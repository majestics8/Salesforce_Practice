public class InvoiceHandler {
    public static void invoicecheck(List<Invoice__c> newinvlist,List<Invoice__c> oldinvlist){
     if(Trigger.isAfter && (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete)){
        apexpractice20NOV2.invoicerollup(newinvlist);
    }
    if(Trigger.isAfter && (Trigger.isUpdate || Trigger.isDelete)){
        apexpractice20NOV2.invoicerollup(oldinvlist);
    }
    }
}