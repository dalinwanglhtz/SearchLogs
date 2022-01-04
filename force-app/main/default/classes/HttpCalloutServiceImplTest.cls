@IsTest
public class HttpCalloutServiceImplTest {

    @TestSetup
    static void setup() {
        Api_User__c apiUser = new Api_User__c();
        apiUser.Client_ID__c = 'abc';
        apiUser.Client_Secret__c = 'deg';
        apiUser.Username__c = UserInfo.getUserName();
        apiUser.Password__c = 'cdse';
        insert apiUser;
    }
    
    @IsTest
    private static void testGetAccessToken() {
        HttpCalloutService calloutService = new HttpCalloutServiceImpl();
        Api_User__c apiUser = [SELECT Id, Client_ID__c, Client_Secret__c, Username__c, Password__c
                              FROM Api_User__c LIMIT 1];
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPCallout());        
        String bearer = calloutService.getAccessToken(apiUser);
        Test.stopTest();

        System.assertEquals('abcde', bearer, 'Bearer should equal abcde');
    }
    
    @IsTest
    private static void testGetLogData() {
        HttpCalloutService calloutService = new HttpCalloutServiceImpl();
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new MockHTTPCallout());
        String logData = calloutService.getLogData('testlogid', 'abcde');
        Test.stopTest();
        
        System.assertEquals('testlogdata', logData, 'Log data should equal');
    }
}