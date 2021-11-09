public class SearchLogs {
    private static String currentOrgSite = 'https://australiacom-dev-ed.my.salesforce.com';
    private static String apiString = '/services/data/v52.0/sobjects/ApexLog/';
    private static String bearer = '00D5g000005IwVi!AQEAQHreEKZSxxrZA56DM2kCkPv2ivGkbN5yxbZx99KvBfT2yMq7wt52gDBny5o_1iqsccoeGCe2mkv3EX8cG2tIO0fCnNw5';
    
    public static Boolean getDebugLogs(String searchStr) {
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
    
    private static List<ApexLog> getLogIds() {
        return [SELECT Id FROM ApexLog];
    }
}