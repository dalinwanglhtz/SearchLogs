public class HttpCalloutServiceImpl implements HttpCalloutService {
    private static String currentOrgSite = URL.getSalesforceBaseUrl().toExternalForm();
    private static String API_PATH = '/services/data/v52.0/sobjects/ApexLog/';
    
    public static Http http {
        get {
            if(http == null) {
                http = new Http();
            }
            return http;
        }
        set {
            http = value;
        }
    }
    
    public String getAccessToken(Api_User__c apiUser) {
        // 1. Create connected app
        // 2. Remote site setting for endpoint registration
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setEndpoint('https://login.salesforce.com/services/oauth2/token');
        request.setHeader('Content-Type','application/x-www-form-urlencoded');        
        request.setBody('grant_type=password' + 
                    '&client_id=' + apiUser.Client_ID__c + 
                    '&client_secret=' + apiUser.Client_Secret__c + 
                    '&username=' + apiUser.Username__c + 
                    '&password=' + apiUser.Password__c);
        
        httpResponse response = http.send(request);
        
        String accessToken;
        if(response.getStatusCode() == 200) {
            Map<String, Object> resultMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            
            accessToken = (String)resultMap.get('access_token');
            System.debug('Access token is: '+accessToken); // will return SESSION_ID_REMOVED as session is removed by Salesforce for security purposes
        }
        
        return accessToken;
    }
    
    public String getLogData(String logId, String bearer) {
        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer '+bearer);
        request.setEndpoint(currentOrgSite+API_PATH+logId+'/Body');
        
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        
        String logBody = '';
        if(response.getStatusCode() == 200) {
            logBody = response.getBody();
        }
        
        return logBody;
    }
}