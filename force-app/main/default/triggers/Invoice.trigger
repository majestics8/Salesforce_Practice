trigger Invoice on Invoice__c (After insert, After Update, After Delete, After Undelete) {
      InvoiceHandler.invoicecheck(Trigger.new,Trigger.old);
}