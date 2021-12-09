@IsTest(isParallel=true)
public class SearchLogsTest {

    @IsTest
    private static void testSearchLogs() {
        
    }
    
    @IsTest
    private static void testGetAccessToken() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = 'test@test.com';
        apiUser.Password__c = 'abcdef';
        insert apiUser;
        
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPAuthenticate());        
        String bearer = SearchLogs.getAccessToken(apiUser);
        Test.stopTest();

        System.assertEquals('abcde', bearer, 'Bearer should equal abcde');
    }
    
    @IsTest
    private static void testGetLogData() {
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPLogData());
        String logData = SearchLogs.getLogData('testlogid');
        Test.stopTest();
        
        System.assertEquals('testlogdata', logData, 'Log data should equal');
    }
    
    @IsTest
    private static void testHasApiUser() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = UserInfo.getUserName();
        apiUser.Password__c = 'abcdef';
        insert apiUser;
        
        System.assert(SearchLogs.hasApiUser(), 'Should return true');
    }
}