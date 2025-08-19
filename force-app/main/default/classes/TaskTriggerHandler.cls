public with sharing class TaskTriggerHandler  implements TriggerHandler{

    public void beforeInsert(List<Task> Tasks) {

        Set<Id> relacionados = new Set<Id>();
        for(Task t : Tasks){
            if(t.WhatId != null && t.WhatId.getSObjectType() == Case.sObjectType){
                relacionados.add(t.WhatId);
            }

        }

        List<Task> Repetidos = [
                select Id, WhatId
                from Task
                where WhatId in :relacionados
                and Status not in ('completed', 'Deferred')
            ];

        if(Repetidos.size() > 0){
            for(Task t : Tasks){
                for(Task r : Repetidos){
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

