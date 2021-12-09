public class SearchLogDAOServiceImpl implements SearchLogDAOService {
    public static List<ApexLog> getLogs() {
        return [SELECT Id FROM ApexLog]; 
    }
}