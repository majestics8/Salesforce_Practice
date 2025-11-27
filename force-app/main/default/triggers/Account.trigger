trigger Account on Account (After insert) {
    if(Trigger.isInsert){
        AccountHandler.HandleAccount(Trigger.new);
    }
}