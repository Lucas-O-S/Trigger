public with sharing class AssociatedLocationTriggerHelper {
   public static void handleInsertAccountTeamMember(List<AssociatedLocation__c> newList){

        Set <Id> userIds = new Set<Id>();
        Set <Id> accountIds = new Set<Id>();
        
        for (AssociatedLocation__c iAssociatedLocation : newList){
            userIds.add(iAssociatedLocation.User__c);
            accountIds.add(iAssociatedLocation.Account__c);
        }

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
        Set<Id> userIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
        for (AssociatedLocation__c iAssociatedLocation : oldList) {
            if (iAssociatedLocation.User__c != null && iAssociatedLocation.Account__c != null) {
                userIds.add(iAssociatedLocation.User__c);
                accountIds.add(iAssociatedLocation.Account__c);
            }
        }

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
}