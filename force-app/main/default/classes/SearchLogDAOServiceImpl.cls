public class SearchLogDAOServiceImpl implements SearchLogDAOService {
    public List<ApexLog> getLogs() {
        return [SELECT Id FROM ApexLog]; 
    }
}