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
        
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPCallout());
        String output = SearchLogs.searchLogs('test');
        Test.stopTest();
        
        System.assertEquals('testlogdata', output, 'Output should equal testlogdata');
    }
    
    @IsTest
    private static void testGetAccessToken() {
        Api_User__c apiUser = [SELECT Id, Client_ID__c, Client_Secret__c, Username__c, Password__c
                              FROM Api_User__c LIMIT 1];
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPCallout());        
        String bearer = SearchLogs.getAccessToken(apiUser);
        Test.stopTest();

        System.assertEquals('abcde', bearer, 'Bearer should equal abcde');
    }
    
    @IsTest
    private static void testGetLogData() {
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPCallout());
        String logData = SearchLogs.getLogData('testlogid');
        Test.stopTest();
        
        System.assertEquals('testlogdata', logData, 'Log data should equal');
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
}