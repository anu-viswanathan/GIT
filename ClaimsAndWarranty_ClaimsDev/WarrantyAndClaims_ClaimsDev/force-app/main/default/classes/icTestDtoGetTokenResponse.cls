/**
 * Created by Francois Poirier on 2019-11-14.
 */

@isTest
public with sharing class icTestDtoGetTokenResponse {

    @isTest
    static void testicDtoGetTokenResponse(){

        icDtoGetTokenResponse dto = new icDtoGetTokenResponse();
        dto.status = 200;
        dto.requestMethod = 'POST';
        dto.token = 'f4k3t0k3n';
        dto.errMsg = icTestHelperUtility.generateRandomString(25);
        
    }
}