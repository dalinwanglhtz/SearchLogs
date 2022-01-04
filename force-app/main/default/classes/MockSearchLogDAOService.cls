public virtual class MockSearchLogDAOService implements SearchLogDAOService {
    public virtual List<ApexLog> getLogs() {
        return new List<ApexLog>(); 
    }
    public virtual Api_User__c getApiUserByUsername(String userName) {
        return new Api_User__c();
    }
}