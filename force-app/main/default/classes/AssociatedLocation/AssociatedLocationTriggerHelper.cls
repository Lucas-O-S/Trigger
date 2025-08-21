public with sharing class AssociatedLocationTriggerHelper {
   public static void handleInsertAccountTeamMember(List<AssociatedLocation> newList){

        Set <Id> userIds = new Set<Id>();
        Set <Id> accountIds = new Set<Id>();
        
        for (AssociatedLocation iAssociatedLocation : newList){
            userIds.add(iAssociatedLocation.User__c);
            accountIds.add(iAssociatedLocation.Account__c);
        }

        List<AssociatedLocation> teamMemberList = [
            select Id, Account__c, User__c
            from AssociatedLocation
            where Account__c in : accountIds
            and User__c in : userIds
        ];

        Set<String> pairVerify = new Set<String>();
        for (AssociatedLocation al : teamMemberList){
            pairVerify.add(al.Account__c + '-' + al.User__c);
        }

            List<AccountTeamMember> toInsert = new List<AccountTeamMember>();
            for (AssociatedLocation iAssociatedLocation : newList){
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

   public static void handleDeleteTeamMenber(List<AssociatedLocation> oldList){
        Set<Id> userIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        for(AssociatedLocation al : oldList){
            if(al.User__c != null && al.Account__c != null){
                userIds.add(al.User__c);
                accountIds.add(al.Account__c);
            }
        }
        
        List<AccountTeamMember> teamMembersToDelete = [
            SELECT Id
            FROM AccountTeamMember
            WHERE AccountId IN :accountIds
            AND UserId IN :userIds
        ];
        
        if(!teamMembersToDelete.isEmpty()){
            delete teamMembersToDelete;
        }


   }
}