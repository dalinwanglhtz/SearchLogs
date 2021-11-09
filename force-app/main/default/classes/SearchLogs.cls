public class SearchLogs {
    private static String currentOrgSite = 'https://australiacom-dev-ed.my.salesforce.com';
    private static String apiString = '/services/data/v52.0/sobjects/ApexLog/';
    private static String bearer;
    
    public static Boolean getDebugLogs(String searchStr) {
        // 1. Create connected app
        // 2. Remote site setting for endpoint registration
        getAccessToken();
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+bearer);
        request.setEndpoint(currentOrgSite+apiString+'07L5g00000AMyZoEAL/Body');
        
        
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        System.debug('Response is right here: '+response.getStatusCode());
        
        if(response.getStatusCode() == 200) {
            System.debug('Results is right here: '+response.getBody());
            String logBody = response.getBody();
            return logBody.containsIgnoreCase(searchStr);
        } else {
            return false;
        }
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
            System.debug('Access token is: '+accessToken); // will return SESSION_ID_REMOVED by Salesforce for security purposes
            bearer = accessToken;
        }
    }
    
    private static List<ApexLog> getLogIds() {
        return [SELECT Id FROM ApexLog];
    }
}