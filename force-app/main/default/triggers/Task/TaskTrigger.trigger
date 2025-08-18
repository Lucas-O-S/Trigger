Trigger TaskTrigger on Task(Before insert){
    TaskTriggerHandler handler = new TaskTriggerHandler();
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.beforeInsert(Trigger.new);
    }

    if (Trigger.isBefore && Trigger.isUpdate) {
        handler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}