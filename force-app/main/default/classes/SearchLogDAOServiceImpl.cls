public class SearchLogDAOServiceImpl implements SearchLogDAOService {
    public List<ApexLog> getLogs() {
        Integer remainingCallouts = Limits.getLimitCallouts() - Limits.getCallouts();
        return [SELECT Id, LogUserId, StartTime FROM ApexLog ORDER BY StartTime DESC LIMIT :remainingCallouts]; 
    }
}