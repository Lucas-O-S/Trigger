public with sharing class AssociatedLocationTriggerHelper {

    private static Set <Id> userIds = new Set<Id>();
    private static Set <Id> accountIds = new Set<Id>();   
    
    public static void handleInsertAccountTeamMember(List<AssociatedLocation__c> newList){
        
        setIds(newList);
        List<AssociatedLocation__c> teamMemberList = [
            select Id, Account__c, User__c
            from AssociatedLocation__c
            where Account__c in : accountIds
            and User__c in : userIds
        ];

        Set<String> pairVerify = new Set<String>();
        for (AssociatedLocation__c iAssociatedLocation : teamMemberList){
            pairVerify.add(iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c);
        }

            List<AccountTeamMember> toInsert = new List<AccountTeamMember>();
            for (AssociatedLocation__c iAssociatedLocation : newList){
                String temp = iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c;

                if(pairVerify.contains(temp)){
                    AccountTeamMember accountTeamMember = new AccountTeamMember( 
                        AccountId = iAssociatedLocation.Account__c,
                        UserId = iAssociatedLocation.User__c
                    );
                    toInsert.add(accountTeamMember);
            
                }

            }
            insert toInsert;


   }

    public static void handleDeleteTeamMenber(List<AssociatedLocation__c> oldList) {
        setIds(oldList);

        List<AccountTeamMember> teamMemberList = [
            select Id, AccountId, UserId
            from AccountTeamMember
            where AccountId in :accountIds
            and UserId in :userIds
        ];

        List<AssociatedLocation__c> stillAssociatedLocations = [
            select Account__c, User__c
            from AssociatedLocation__c
            where Account__c in :accountIds
            and User__c in :userIds
        ];

        Set<String> existingPairs = new Set<String>();
        for (AssociatedLocation__c iAssociatedLocation : stillAssociatedLocations) {
            existingPairs.add(iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c);
        }

        List<AccountTeamMember> toDelete = new List<AccountTeamMember>();
        for (AccountTeamMember iAccountTeamMember : teamMemberList) {
            String pairKey = iAccountTeamMember.AccountId + '-' + iAccountTeamMember.UserId;
            if (!existingPairs.contains(pairKey)) {
                toDelete.add(iAccountTeamMember);
            }
        }

        if (!toDelete.isEmpty()) {
            delete toDelete;
        }
    }

    public static void handleUpdateTeamMenber(List<AssociatedLocation__c> oldList, List<AssociatedLocation__c> newList){
        
        updateUserFlux(oldList, newList);



    }

    public static void updateUserFlux(List<AssociatedLocation__c> oldList, List<AssociatedLocation__c> newList){
        List<AccountTeamMember> toInsert = new List<AccountTeamMember>();
        for(Integer i = 0; i < oldList.size(); i++){

            AssociatedLocation__c oldListNow = oldList[i];
            AssociatedLocation__c newListNow = newList[i];

            if(newListNow.User__c != oldListNow.User__c){
                toInsert.add(new AccountTeamMember( 
                    UserId = newListNow.User__c,
                    AccountId = newListNow.Account__c
                ));

            }

        }

        setIds(oldList);

        //Verifica os que ainda existem
        List<AssociatedLocation__c> stillAssociatedLocations = [
            select Account__c, User__c
            from AssociatedLocation__c
            where Account__c in :accountIds
            and User__c in : userIds
        ];

        //lista para colocar os LAs associados aqueles ATM que serao deletados
        List<AssociatedLocation__c> prepareDelete = new List<AssociatedLocation__c>();

        //Pares de chaves daqueles que ainda estao na tabela
        Set<String> pairVerify = new Set<String>();
        for (AssociatedLocation__c iAssociatedLocation : stillAssociatedLocations){
            pairVerify.add(iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c);
        }
        

        //verifica aquelas combinacoes qeu ainda nao existem 
        for(AssociatedLocation__c iAssociatedLocation : oldList){
            String temp = iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c;
            if(!pairVerify.contains(temp) ){
                prepareDelete.add(iAssociatedLocation);
            }
        }

        setIds(prepareDelete);

        //Busca aqueles que devem ser deletados
        List<AccountTeamMember> ToDelete = [
            select id
            from AccountTeamMember
            where UserId in :userIds
            and AccountId in :accountIds
        ];
        insert toInsert;
        delete ToDelete;
    }

    public static void updateAccountFlux(List<AssociatedLocation__c> oldList, List<AssociatedLocation__c> newList) {
        //Verifica se há 
        List<AccountTeamMember> toVerifyUser = new List<AccountTeamMember>();
        
        //Loop para verificar se houve alterações no account
        for(Integer i = 0; i < oldList.size(); i++){

            AssociatedLocation__c oldListNow = oldList[i];
            AssociatedLocation__c newListNow = newList[i];

            if(newListNow.Account__c != oldListNow.Account__c){
                toVerifyUser.add(new AccountTeamMember( 
                    UserId = newListNow.User__c,
                    AccountId = newListNow.Account__c
                ));
            }
        }

        //Da set nos ids para buscar
        setIds(oldList);

        //Verifica os que ainda existem relacionados aos registros modificados
        List<AssociatedLocation__c> stillAssociatedLocations = [
            select Account__c, User__c
            from AssociatedLocation__c
            where Account__c in :accountIds
            and User__c in : userIds
        ];

        //Pares de chaves daqueles que ainda estao na tabela
        Set<String> pairVerify = new Set<String>();
        for (AssociatedLocation__c iAssociatedLocation : stillAssociatedLocations){
            pairVerify.add(iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c);
        }

        //cria uma lista para verificar os usuarios que nao possuem mais LA para criar uma nova atm para eles na nova Account
        List<AssociatedLocation__c> prepareToMove = new List<AssociatedLocation__c>();

        for(AssociatedLocation__c iAssociatedLocation : oldList){
            String temp = iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c;
            if(!pairVerify.contains(temp) ){
                prepareToMove.add(iAssociatedLocation);
            }
        }

        setIds(prepareToMove);
        List<AccountTeamMember> toDelete = [
            select id
            from AccountTeamMember
            where AccountId in :accountIds
            and UserId in : userIds
        ];

        delete toDelete;
        insert toVerifyUser;
        //tenho que pegar as chaves para verificar se em toVerifyUser há ATM em outras LAS

    }

    //Pega todos os ids de user e account de uma lista do tipo AssociatedLocation__c
    private static void setIds(List<AssociatedLocation__c> listAL){
        clearIds();
        for (AssociatedLocation__c iAssociatedLocation : listAL) {
            if (iAssociatedLocation.User__c != null && iAssociatedLocation.Account__c != null) {
                userIds.add(iAssociatedLocation.User__c);
                accountIds.add(iAssociatedLocation.Account__c);
            }
        }



    }
    

    private static void clearIds(){
        userIds.clear();
        accountIds.clear();
    }

}