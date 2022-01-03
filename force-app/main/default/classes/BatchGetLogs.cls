public class BatchGetLogs implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
    public List<String> allLogStrings; // To obtain results, this class should implement Database.Stateful
    public String query = 'SELECT Id, LogUserId, StartTime, LogLength FROM ApexLog WHERE LogLength < 12000000 ORDER BY StartTime DESC';
    private String searchStr;
    private String bearer;
    
    public static SearchLogDAOService searchLogDAOService {
        get {
            if(searchLogDAOService == null) {
                searchLogDAOService = new SearchLogDAOServiceImpl();
            }
            return searchLogDAOService;
        }
        set {
            searchLogDAOService = value;
        }
    }
    
    public static HttpCalloutService calloutService {
        get {
            if (calloutService == null) {
                calloutService = new HttpCalloutServiceImpl();
            }
            return calloutService;
        }
        set {
            calloutService = value;
        }
    }
    
    public BatchGetLogs(String searchStr) {
        Api_User__c registeredApiUser = searchLogDAOService.getApiUserByUsername(UserInfo.getUserName());
        if(registeredApiUser == null) return;
        bearer = calloutService.getAccessToken(registeredApiUser);
        allLogStrings = new List<String>();
        this.searchStr = searchStr;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<ApexLog> records) {
        for (ApexLog al : records) {
            String someData = calloutService.getLogData(al.Id, bearer);
            if(someData.containsIgnoreCase(searchStr) && !someData.contains('selfsearch')) {
            	allLogStrings.add(someData);   
            }
        }
        System.debug('selfsearch');
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