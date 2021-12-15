@IsTest
global class MockHTTPCallout implements HttpCalloutMock {
    private static String currentOrgSite = URL.getSalesforceBaseUrl().toExternalForm();
    private static String API_PATH = '/services/data/v52.0/sobjects/ApexLog/';
    
    global HTTPResponse respond(HTTPRequest req) {
        if(req.getEndpoint().endsWith('token')) {
            HTTPResponse res = new HTTPResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"access_token":"abcde"}');
            res.setStatusCode(200);
            return res;    
        } else if(req.getEndpoint().endsWith('Body')) {
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