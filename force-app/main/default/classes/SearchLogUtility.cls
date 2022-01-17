public class SearchLogUtility {

    public static Boolean searchKey(String log, String key) {
        Boolean found = false;
        List<String> searchTokens = key.split(' ');
        for(String token : searchTokens) {
            if(log.containsIgnoreCase(token)) {
                found = true;
            }
        }
        return found;
    }
}