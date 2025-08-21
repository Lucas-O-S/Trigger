public with sharing class AssociatedLocationTriggerHandler extends TriggerHandler {
    protected override void beforeInsert() {

        List<AssociatedLocation> newList = (List<AssociatedLocation>) Trigger.new;


        Set <Id> userIds = new Set<Id>();
        Set<Id> accountIds = new Set<Id>();
        
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

        try{
            List<AccountTeamMember> toInsert = new List<AccountTeamMember>();
            for (AssociatedLocation iAssociatedLocation : newList){
                String temp = iAssociatedLocation.Account__c + '-' + iAssociatedLocation.User__c;

                if(pairVerify.contains(temp)){
                    iAssociatedLocation.addError('Jà existe este usuario nesta empresa');
            
                }
                else{
                    AccountTeamMember accountTeamMember = new AccountTeamMember( 
                        AccountId = iAssociatedLocation.Account__c,
                        UserId = iAssociatedLocation.User__c
                    );
                    toInsert.add(accountTeamMember);
                }
            }
            insert toInsert;
        }
        catch(Exception e){
            //TODO: handle exception
        }


    }

     protected override afterInsert(List<SObject> newList){

    }
    public void beforeUpdate(){

    }
    public void afterUpdate(List<SObject> newList, List<SObject> oldList){

    }
    public void beforeDelete(List<SObject> oldList){

    }
    public void afterDelete(List<SObject> oldList){

    }
}