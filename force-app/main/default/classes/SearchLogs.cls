public class SearchLogs {
    private static String currentOrgSite = 'https://australiacom-dev-ed.my.salesforce.com';
    private static String apiString = '/services/data/v52.0/sobjects/ApexLog/';
    private static String bearer;
    
    public static void searchLogs(String searchStr) {
        // 1. Create connected app
        // 2. Remote site setting for endpoint registration
        getAccessToken();
        String allLogString = '';
        List<ApexLog> allLogs = getLogs();
        for (ApexLog al : allLogs) {
            allLogString += getLogData(al.Id, searchStr);
        }
        System.debug('All logs **********************: '+allLogString);
        System.debug('All logs End ***********************');
    }
    
    private static void getAccessToken() {
        // 1. Create connected app
        // 2. Remote site setting for endpoint registration
        String username = 'dalewang@australia.com';
        String password = 'Digital2!gtg9GraDOYfxh8NWgQopiUoq';
        String grantType = 'password';
        String clientId = '3MVG9fe4g9fhX0E6c6x1mh38Y0cCjHMAOVouYb30AgFT0jaXBSpHhfxzedxCJ3Y.NzrY4rDmKz1K2eVdAp4WE';
        String clientSecret = 'C913B844D2C744D8D4FFE666D873FFB902847CC7CF69A09E653E55CAED0572E0';
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');        
        request.setBody('grant_type=password' + 
                    '&client_id=' + clientId + 
                    '&client_secret=' + clientSecret + 
                    '&username=' + username + 
                    '&password=' + password);
        
        httpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200) {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            String accessToken = (String)resultMap.get('access_token');
            System.debug('Access token is: '+accessToken); // will return SESSION_ID_REMOVED as session is removed by Salesforce for security purposes
            bearer = accessToken;
        }
    }
    
    private static String getLogData(String logId, String searchStr) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+bearer);
        request.setEndpoint(currentOrgSite+apiString+logId+'/Body');
        
        
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        
        String logBody = '';
        if(response.getStatusCode() == 200) {
            logBody = response.getBody();
        }
        
        
        return logBody.contains(searchStr) ? logBody : '';
    } 
    
    private static List<ApexLog> getLogs() {
        return [SELECT Id FROM ApexLog];
    }
}