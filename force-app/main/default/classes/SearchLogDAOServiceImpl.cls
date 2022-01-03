public class SearchLogDAOServiceImpl implements SearchLogDAOService {
    public List<ApexLog> getLogs() {
        Integer remainingCallouts = Limits.getLimitCallouts() - Limits.getCallouts();
        return [SELECT Id, LogUserId, StartTime FROM ApexLog ORDER BY StartTime DESC LIMIT :remainingCallouts]; 
    }
    
    public Api_User__c getApiUserByUsername(String userName) {
        Api_User__c apiUser;
        try {
        	apiUser = [SELECT Id, Username__c, Password__c, Client_ID__c, Client_Secret__c
                       FROM Api_User__c 
                       WHERE Username__c = :userName LIMIT 1];
            return apiUser;
        } catch(Exception ex) {
            throw new ApplicationException('No Api User found with username: '+userName);
        }
    }
    
    private class ApplicationException extends Exception {}
}