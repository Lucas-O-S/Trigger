public interface TriggerHandler {
    void beforeInsert(List<SObject> newList);
    void afterInsert(List<SObject> newList);
    void beforeUpdate(List<SObject> newList, List<SObject> oldList);
    void afterUpdate(List<SObject> newList, List<SObject> oldList);
    void beforeDelete(List<SObject> oldList);
    void afterDelete(List<SObject> oldList);
}