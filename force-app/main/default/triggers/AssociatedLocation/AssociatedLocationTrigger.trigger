Trigger AssociatedLocationTrigger on AssociatedLocation(before insert , after insert, before update, after update, before delete, after delete, after undelete ){
    AssociatedLocationTriggerHandler handler = new AssociatedLocationTriggerHandler();
    handler.run();
}