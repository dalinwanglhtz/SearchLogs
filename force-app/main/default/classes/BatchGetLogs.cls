public class BatchGetLogs implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
	private static String currentOrgSite = URL.getSalesforceBaseUrl().toExternalForm();
    private static String API_PATH = '/services/data/v52.0/sobjects/ApexLog/';
    public List<String> allLogStrings; // To obtain results, this class should implement Database.Stateful
    public String query = 'SELECT Id, LogUserId, StartTime, LogLength FROM ApexLog WHERE LogLength < 12000000 ORDER BY StartTime DESC';
    private String bearer;
    private String searchStr;
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
    
    public BatchGetLogs(String searchStr) {
        Api_User__c registeredApiUser = getApiUser(UserInfo.getUserName());
        if(registeredApiUser == null) return;
        bearer = getAccessToken(registeredApiUser);
        System.debug('Bearer: '+bearer.length());
        allLogStrings = new List<String>();
        this.searchStr = searchStr;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<ApexLog> records) {
        for (ApexLog al : records) {
            String someData = getLogData(al.Id);
            if(someData.containsIgnoreCase(searchStr) && !someData.contains('selfsearch')) {
            	allLogStrings.add(someData);   
            }
        }
        System.debug('selfsearch');
    }
    
    public Api_User__c getApiUser(String userName) {
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
    
    private String getAccessToken(Api_User__c apiUser) {
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
    
    private String getLogData(String logId) {
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
    
    public void finish(Database.BatchableContext bc) {
        sendEmail();
		sendNotification();
    }
    
    private void sendEmail() {
        String output = String.join(allLogStrings, '\n');
        String fileName = 'debug-log-search-output.txt';
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment logFile = new Messaging.EmailFileAttachment();
        logFile.setFileName(fileName);
        logFile.setBody(Blob.valueOf(output));
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{logFile});
        mail.setSubject('Your log search result');
        mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
        mail.setPlainTextBody('Log search completed');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }
    
    private void sendNotification() {
        CustomNotificationType type = [SELECT Id, DeveloperName 
                                       FROM CustomNotificationType
                                       WHERE DeveloperName = 'Debug_Log_Search_Complete'];
        Messaging.CustomNotification notification = new Messaging.CustomNotification();
        notification.setTitle('Debug Log Search Complete');
        notification.setBody('An email with search output as an attachment is sent to your email address: '+UserInfo.getUserEmail());
        notification.setNotificationTypeId(type.Id);
        String pgRef = '{ type: "standard__namedPage",attributes:{pageName: "home",actionName: "view"} }';
        notification.setTargetPageRef(pgRef);
        try {
            notification.send(new Set<String> {UserInfo.getUserId()});
        } catch (Exception ex) {
            System.debug('Problem sending notification: '+ex.getMessage());
        }
    }
    
    private class ApplicationException extends Exception {}
}