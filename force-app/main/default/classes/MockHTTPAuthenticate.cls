@IsTest
global class MockHTTPAuthenticate implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        String oauthEndPoint = 'https://login.salesforce.com/services/oauth2/token';
        System.assertEquals(oauthEndPoint, req.getEndpoint(), 'Request endpoint should be '+oauthEndPoint);
        System.assertEquals('POST', req.getMethod(), 'Request method should be POST');
        
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"access_token":"abcde"}');
        res.setStatusCode(200);
        return res;
    }        
}