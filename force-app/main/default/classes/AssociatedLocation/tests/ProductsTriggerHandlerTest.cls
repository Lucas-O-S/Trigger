@isTest
private class ProductsTriggerHandlerTest {

    @TestSetup
    static void makeData() {
        // Cria usuários de teste
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User' LIMIT 1];
        List<User> users = new List<User>();
        for(Integer i = 1; i <= 2; i++) {
            users.add(new User(
                FirstName = 'Test'+i,
                LastName = 'User',
                Alias = 'tuser'+i,
                Email = 'tuser'+i+'@test.com',
                Username = 'tuser'+i+'_' + System.currentTimeMillis() + '@test.com', // único
                ProfileId = p.Id,
                TimeZoneSidKey = 'America/Sao_Paulo',
                LocaleSidKey = 'pt_BR',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'pt_BR',
                IsActive = true
            ));
        }
        insert users;

        // Cria contas de teste
        List<Account> accounts = new List<Account>{
            new Account(Name='Account A'),
            new Account(Name='Account B')
        };
        insert accounts;

        // Cria AssociatedLocation__c
        List<AssociatedLocation__c> associatedLocations = new List<AssociatedLocation__c>();
        for(User u : users){
            for(Account a : accounts){
                associatedLocations.add(new AssociatedLocation__c(
                    User__c = u.Id,
                    Account__c = a.Id
                ));
            }
        }
        insert associatedLocations;
    }

    
    @isTest
    static void handleInsertAccountTeamMemberTest() {
        List<User> users = [select id from User where name = 'Lucas Oliveira Silva' ];
        List<Account> accounts = [select id from Account];

        List<AssociatedLocation__c> associatedLocations = new List<AssociatedLocation__c>();
        for(User iUser : users){
            for(Account iAccount : accounts){
                associatedLocations.add(new associatedLocation__c(User__c  = iUser.id,Account__c = iAccount.id));
            }
        }
        Test.startTest();
        insert associatedLocations;
        Test.stopTest();

    }

    @isTest
    static void handleDeleteAccountTeamMemberTest() {
        List<AssociatedLocation__c> associatedLocations = [select id from AssociatedLocation__c];

        Test.startTest();
        delete associatedLocations;
        Test.stopTest();

    }

    @isTest
    static void handleUpdateAccountOnlyAccountTeamMemberTest() {
        Account account = new Account( Name =  'Mudanca');
        insert account;
        
        List<AssociatedLocation__c> associatedLocations = [select id from AssociatedLocation__c];
        for(AssociatedLocation__c  iAssociatedLocation : associatedLocations){
            iAssociatedLocation.Account__c = account.Id;
        }

        Test.startTest();
        update associatedLocations;
        Test.stopTest();

    }

    @isTest
    static void handleUpdateAccountOnlyUserTeamMemberTest() {
        List<User> users = [select id from User where name = 'Lucas Oliveira Silva' ];
        
        List<AssociatedLocation__c> associatedLocations = [select id from AssociatedLocation__c];
        for(AssociatedLocation__c  iAssociatedLocation : associatedLocations){
            iAssociatedLocation.User__c = users[0].Id;
        }

        Test.startTest();
        update associatedLocations;
        Test.stopTest();

    }



    
}