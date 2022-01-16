@IsTest(isParallel=true)
public class SearchLogsTest {
    
    @TestSetup
    private static void setup() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = UserInfo.getUserName();
        apiUser.Password__c = 'abcdef';
        insert apiUser;
    }

    @IsTest
    private static void testSearchLogs() {
        SearchLogs.searchLogDAOService = new MockSearchLogDAO();
        //SearchLogs.calloutService = new MockCalloutService();
        
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPCallout());
        String output = SearchLogs.searchLogs('test');
        Test.stopTest();
        
        System.assertEquals('testlogdata', output, 'Output should equal testlogdata');
    }
    
    @IsTest
    private static void testHasApiUser() {
        Api_User__c apiUser = [SELECT Id, Client_ID__c, Client_Secret__c, Username__c, Password__c
                              FROM Api_User__c LIMIT 1];
        
        System.assert(SearchLogs.hasApiUser(), 'Should return true');
    }
    
    @IsTest
    private static void testApiUserRegister() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = 'testuser@user.com';
        apiUser.Password__c = 'abcdef';
        
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPCallout());
        SearchLogs.apiUserRegister(apiUser);
        Test.stopTest();
        
        Api_User__c apiUserResult = [SELECT Id, Client_ID__c, Client_Secret__c, Username__c, Password__c
                              		FROM Api_User__c
                              		WHERE Username__c = 'testuser@user.com' LIMIT 1];
        System.assert(apiUserResult != null, 'Api User should be successfully inserted');
    }
    
    @IsTest
    private static void testDeleteApiUser() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = 'testuser@user.com';
        apiUser.Password__c = 'abcdef';
        insert apiUser;
        
        Test.startTest();
        SearchLogs.deleteApiUser(apiUser);
        Test.stopTest();
        
        List<Api_User__c> apiUserResults = [SELECT Id, Client_ID__c, Client_Secret__c, Username__c, Password__c
                                    FROM Api_User__c
                                    WHERE Username__c = 'testuser@user.com' LIMIT 1];
        System.assert(apiUserResults.size() == 0, 'Api user should be successfully deleted');
    }
    
    @IsTest
    private static void testDeleteApiUserException() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'def';
        apiUser.Username__c = 'testuser@user.com';
        apiUser.Password__c = 'abcdef';
        
        Test.startTest();
        Boolean hasException = false;
        try {
            SearchLogs.deleteApiUser(apiUser);
        } catch(Exception ex) {
            hasException = true;
        }
        Test.stopTest();
        
        System.assert(hasException, 'Exception should be thrown.');
    }
    
    public class MockSearchLogDAO extends MockSearchLogDAOService {
        public override List<ApexLog> getLogs() {
            List<ApexLog> logs = new List<ApexLog>();
            Id logId = TestUtility.getFakeId(ApexLog.SObjectType);
            ApexLog testLog = (ApexLog) JSON.deserialize(
                '{"Id":"'+logId+'"}', 
                ApexLog.class);
            logs.add(testLog);
            return logs;
        }
    }
    
    // May not be required as MockHttpCallout does the handle Http Callouts
    public class MockCalloutService extends MockHttpCalloutService {
        public override String getAccessToken(Api_User__c apiUser) {
            return 'abcde';
        }
        public override String getLogData(String logId, String bearer) {
            return 'testlogdata';
        }
    }
}