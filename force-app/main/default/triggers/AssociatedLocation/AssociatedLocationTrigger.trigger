Trigger AssociatedLocationTrigger on AssociatedLocation(after insert ,after update, after delete ){
    System.debug('AssociatedLocation__c Trigger Start => ' + Trigger.operationType);

    AssociatedLocationTriggerHandler handler = new AssociatedLocationTriggerHandler(
        Trigger.old,
        Trigger.new,
        Trigger.oldMap,
        Trigger.newMap
    );

    if(AssociatedLocationTriggerHandler.IsTriggerEnabled()){
        switch on Trigger.operationType {
            when AFTER_INSERT{
                handler.AfterInsert();
            }
            when AFTER_UPDATE{
                handler.AfterUpdate();
            }
            when AFTER_DELETE{
                handler.AfterDelete();
            }

        }
    }

}