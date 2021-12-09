@IsTest
global class MockHTTPLogData implements HTTPCalloutMock {
    private static String currentOrgSite = URL.getSalesforceBaseUrl().toExternalForm();
    private static String API_PATH = '/services/data/v52.0/sobjects/ApexLog/';
    
    global HTTPResponse respond(HTTPRequest req) {
        String url = currentOrgSite+API_PATH+'testlogid'+'/Body';
        System.assertEquals(url, req.getEndpoint(), 'Request endpoint should be '+url);
        System.assertEquals('GET', req.getMethod(), 'Request method should be GET');
        
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('testlogdata');
        res.setStatusCode(200);
        return res;
    }
}