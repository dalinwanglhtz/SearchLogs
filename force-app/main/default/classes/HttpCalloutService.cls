public interface HttpCalloutService {
	String getAccessToken(Api_User__c apiUser);
    String getLogData(String logId, String bearer);
}