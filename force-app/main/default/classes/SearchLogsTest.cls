@IsTest(isParallel=true)
public class SearchLogsTest {

    @IsTest
    private static void testSearchLogs() {
        
    }
    
    @IsTest
    private static void testApiUserRegister() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = 'ghi@email.com';
        apiUser.Password__c = 'abcdef';
        
        SearchLogs.apiUserRegister(apiUser);
        
        List<Api_User__c> resultUsers = [SELECT Id FROM Api_User__c WHERE Username__c = 'ghi@email.com'];
        System.assert(resultUsers.size() > 0, 'Should return at least 1 user');
    }
    
    @IsTest
    private static void testGetApiUser() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = 'ghi@email.com';
        apiUser.Password__c = 'abcdef';
        insert apiUser;
        
        System.assert(SearchLogs.getApiUser(), 'Should return true');
    }
}