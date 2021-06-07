/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icHTTPCalloutServiceErrMock implements HttpCalloutMock{

    public HttpResponse respond(HttpRequest param1) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Message":"The request is invalid.","ModelState":{"grantUserOrderDelegationModel.UserName":["The UserName field is required.","The UserName field is not a valid e-mail address."],"grantUserOrderDelegationModel.Password":["The Password field is required."]}}');
        res.setStatusCode(401);
        return res;
    }
}