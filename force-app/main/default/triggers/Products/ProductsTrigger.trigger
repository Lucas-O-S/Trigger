Trigger ProductsTrigger on Product2(after insert){
    ProductsTriggerHandler handler = new ProductsTriggerHandler();
    if (Trigger.isAfter && Trigger.isInsert) {
        handler.afterInsert(Trigger.new);
    }

}