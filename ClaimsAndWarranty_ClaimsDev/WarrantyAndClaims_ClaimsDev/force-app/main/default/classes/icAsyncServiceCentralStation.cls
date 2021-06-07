public with sharing class icAsyncServiceCentralStation {

    static icLogicConfig.IClass logicConfig = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');


    static API_Configuration__mdt csConfigAccountSync {
        get {
            if(csConfigAccountSync == null) {
                csConfigAccountSync = logicConfig.getAPIConfigByName('CS_Account_Sync');
            }
            return csConfigAccountSync;
        }
        set;
    }

    static API_Configuration__mdt csConfigGetToken {
        get {
            if(csConfigGetToken == null) {
                csConfigGetToken = logicConfig.getAPIConfigByName('CS_Get_Access_Token');
            }
            return csConfigGetToken;
        }
        set;
    }


    //@future (callout=true)
    public Static Boolean syncAccount(String accountId, String payload){
        Boolean syncSuccessful = true;

        List<IMT_Invoice_Log__c> errors = new List<IMT_Invoice_Log__c>();
        String token = getToken();
        String authorizationHeader;
        system.debug('payload ====> ' + payload);
        HttpRequest req = new HttpRequest();

        try {
            String resourceEndpoint = csConfigAccountSync.Endpoint__c;
            if (csConfigAccountSync.Source_Id__c != 'production') {
                resourceEndpoint += '?TOKEN=' + token;

                String username = csConfigAccountSync.Username__c;
                String password = csConfigAccountSync.Password__c;

                Blob headerValue = Blob.valueOf(username + ':' + password);
                authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            } else {
                authorizationHeader = 'Bearer ' + token;
            }
            
            req.setEndpoint(resourceEndpoint);
            req.setHeader('Authorization', authorizationHeader);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(payload);
            Http http = new Http();

            HttpResponse response = http.send(req);

            system.debug('response ===> ' + response);
            system.debug('response.body ===> ' + response.getBody());

            if (response.getStatusCode() != 200) {
                errors.add(icServiceErrorHandler.GenerateError('icAsyncServiceCentralStation', 'syncAccount', response.getBody(), JSON.serialize(response.getStatus()), payload));
            }
        }
        catch (Exception ex){
            errors.add(icServiceErrorHandler.GenerateError('icAsyncServiceCentralStation', 'syncAccount', ex.getStackTraceString(), ex.getMessage(), payload));
        }

        if(errors.size()>0) {
            icServiceErrorHandler.LogErrors(errors);
            icServiceErrorHandler.sendErrorsByEmail(errors);
            syncSuccessful = false;
        }

        return syncSuccessful;
    }

    private Static String getToken(){

        List<IMT_Invoice_Log__c> errors = new List<IMT_Invoice_Log__c>();
        String token;
        String payload;
        String authorizationHeader;
        HttpRequest req = new HttpRequest();
        String resourceEndpoint = csConfigGetToken.Endpoint__c;
        req.setEndpoint(resourceEndpoint);

        try {
            if (csConfigAccountSync.Source_Id__c != 'production') {
                system.debug('*** not in production ***');
                String username = csConfigAccountSync.Username__c;
                String password = csConfigAccountSync.Password__c;
                system.debug('username ===> ' + username);
                system.debug('password ===> ' + password);
                Blob headerValue = Blob.valueOf(username + ':' + password);
                authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                req.setHeader('Authorization', authorizationHeader);
            }

            payload = '{"client_id":"' + csConfigGetToken.Client_Id__c + '","client_secret":"' + csConfigGetToken.Client_Secret__c +
                    '","username":"' + csConfigGetToken.Username__c + '","password":"' + csConfigGetToken.Password__c + csConfigGetToken.Token__c + '"}';

            req.setMethod('POST');
            req.setBody(payload);

            Http http = new Http();
            HttpResponse response = http.send(req);

            system.debug('response ===> ' + response);
            system.debug('response.body ===> ' + response.getBody());

            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                responsebody = responseBody.replaceAll('\uFEFF', '');

                icDtoGetTokenResponse dtoResponse = new icDtoGetTokenResponse();
                dtoResponse = (icDtoGetTokenResponse) JSON.deserialize(responseBody, icDtoGetTokenResponse.class);

                token = dtoResponse.token;

                System.debug('token  ====> ' + token);
            } else {
                errors.add(icServiceErrorHandler.GenerateError('icAsyncServiceCentralStation', 'getToken', response.getBody(), JSON.serialize(response.getStatus()), payload));
            }
        }
        catch (Exception ex){
            errors.add(icServiceErrorHandler.GenerateError('icAsyncServiceCentralStation', 'getToken', ex.getStackTraceString(), ex.getMessage(), payload));
        }

        if(errors.size()>0) {
            icServiceErrorHandler.LogErrors(errors);
            icServiceErrorHandler.sendErrorsByEmail(errors);
        }
        return token;

    }

}