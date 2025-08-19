public with sharing class TaskTriggerHandler  implements TriggerHandler{

    public void beforeInsert(List<Task> Tasks) {

        Set<Id> related = new Set<Id>();
        for(Task t : Tasks){
            if(t.WhatId != null && t.WhatId.getSObjectType() == Case.sObjectType){
                related.add(t.WhatId);
            }

        }

        List<Task> repeteds = [
                select Id, WhatId
                from Task
                where WhatId in :related
                and Status  in ('Not Started', 'In Progress', 'Waiting')
            ];

        if(repeteds.size() > 0){
            for(Task t : Tasks){
                for(Task r : repeteds){
                    if( t.WhatId == r.WhatId ){
                        t.addError('Já existe uma tarefa relacionada a este registro');
                    }
                }
            }

        }

    }

    public void beforeUpdate(List<SObject> newList, List<SObject> oldList) {
      
    }

    public void afterUpdate(List<SObject> newList, List<SObject> oldList) {
        // lógica para after update
    }

    public void beforeDelete(List<SObject> oldList) {
        // lógica para before delete
    }

    public void afterDelete(List<SObject> oldList) {
        // lógica para after delete
    }

    public void afterInsert(List<SObject> newList) {
        // lógica para after insert
    }
}

