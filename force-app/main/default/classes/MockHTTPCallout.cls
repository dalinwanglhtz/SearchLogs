@IsTest
global class MockHTTPCallout implements HttpCalloutMock {
    private static String currentOrgSite = URL.getSalesforceBaseUrl().toExternalForm();
    private static String API_PATH = '/services/data/v52.0/sobjects/ApexLog/';
    
    global HTTPResponse respond(HTTPRequest req) {
        if(req.getEndpoint().endsWith('token')) {
            String oauthEndPoint = 'https://login.salesforce.com/services/oauth2/token';
            //System.assertEquals(oauthEndPoint, req.getEndpoint(), 'Request endpoint should be '+oauthEndPoint);
            //System.assertEquals('POST', req.getMethod(), 'Request method should be POST');
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"abcde"}');
            res.setStatusCode(200);
            return res;    
        } else if(req.getEndpoint().endsWith('Body')) {
            String url = currentOrgSite+API_PATH+'testlogid'+'/Body';
            //System.assertEquals(url, req.getEndpoint(), 'Request endpoint should be '+url);
            //System.assertEquals('GET', req.getMethod(), 'Request method should be GET');
            
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('testlogdata');
            res.setStatusCode(200);
            return res;
        } else {
            System.assert(false, 'Unexpected endpoint: '+req.getEndpoint());
            return null;
        }
    }
}