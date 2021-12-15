@IsTest
global class MockHTTPCallout implements HttpCalloutMock {
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