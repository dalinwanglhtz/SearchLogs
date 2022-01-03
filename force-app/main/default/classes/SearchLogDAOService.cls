public interface SearchLogDAOService {
	List<ApexLog> getLogs();
    Api_User__c getApiUserByUsername(String userName);
}