public virtual class MockHttpCalloutService implements HttpCalloutService {
    public virtual String getAccessToken(Api_User__c apiUser) {
        return ''; 
    }
    public virtual String getLogData(String logId, String bearer) {
        return '';
    }
}