public with sharing class icServiceCentralStation implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		String getShortUrl(String contractorId, String queueId);
		Boolean syncAccount(String accountId, String payload);
	}

	public class Impl implements IClass {

		icLogicConfig.IClass logicConfig = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');

		private API_Configuration__mdt csConfigHTTPServer {
			get {
				if(csConfigHTTPServer == null) {
					csConfigHTTPServer = logicConfig.getAPIConfigByName('CS_HTTP_Server');
				}
				return csConfigHTTPServer;
			}
			set;
		}

		private API_Configuration__mdt csConfigGetToken {
			get {
				if(csConfigGetToken == null) {
					csConfigGetToken = logicConfig.getAPIConfigByName('CS_Get_Access_Token');
				}
				return csConfigGetToken;
			}
			set;
		}

		private API_Configuration__mdt csConfigAccountSync {
			get {
				if(csConfigAccountSync == null) {
					csConfigAccountSync = logicConfig.getAPIConfigByName('CS_Account_Sync');
				}
				return csConfigAccountSync;
			}
			set;
		}
		
		private API_Configuration__mdt csConfigShortUrl {
			get {
				if(csConfigShortUrl == null) {
                    csConfigShortUrl = logicConfig.getAPIConfigByName('CS_Short_URL');
				}
				return csConfigShortUrl;
			}
			set;
		}

		private String csToken {
			get {
				if(csToken == null) {
                    csToken = getToken();
				}
				return csToken;
			}
			set;
		}

		private String getToken(){
			String token;
			String payload;

			try {		
				
				HttpRequest req = new HttpRequest();
				req.setMethod('POST');
				req.setEndpoint(csConfigGetToken.Endpoint__c);

				//CHECK IF WE SET THE AUTH HEADER
				if (csConfigHTTPServer.Source_Id__c != 'production') {
					system.debug('*** not in production ***');
					Blob headerValue = Blob.valueOf(csConfigHTTPServer.Username__c + ':' + csConfigHTTPServer.Password__c);
					String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
					req.setHeader('Authorization', authorizationHeader);
				}
	
				//SET PAYLOAD
				payload = '{"client_id":"' + csConfigGetToken.Client_Id__c + 
						'","client_secret":"' + csConfigGetToken.Client_Secret__c +
						'","username":"' + csConfigGetToken.Username__c + 
						'","password":"' + csConfigGetToken.Password__c + csConfigGetToken.Token__c + '"}';
				req.setBody(payload);
	
				system.debug('req ===> ' + req);

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
					icServiceErrorHandler.StoreError('get token', 'icServiceCentralStation', 'getToken', response.getBody(), JSON.serialize(response.getStatus()), payload);
				}
			}
			catch (Exception ex){
				icServiceErrorHandler.StoreError('get token' ,'icServiceCentralStation', 'getToken', ex.getStackTraceString(), ex.getMessage(), payload);
			}
	
			icServiceErrorHandler.CommitErrors('get token', true);
			
			return token;	
		}

        public String getShortUrl(String contractorId, String queueId) {
			String shortURL;

			try {
				HttpRequest req = new HttpRequest();

				String resourceEndpoint = csConfigShortUrl.Endpoint__c + '/?contractor_id=' + contractorId + '&partner_queue_id=' + queueId + '&secpw=' + csToken;
				String authorizationHeader;
				
				//CHECK IF WE SET THE AUTH HEADER
				if (csConfigHTTPServer.Source_Id__c != 'production') {
					Blob headerValue = Blob.valueOf(csConfigHTTPServer.Username__c + ':' + csConfigHTTPServer.Password__c);
					authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
				} else {
					authorizationHeader = 'Bearer ' + csToken;
				}

				req.setEndpoint(resourceEndpoint);
				req.setHeader('Authorization', authorizationHeader);
				req.setMethod('GET');

				system.debug('req ===> ' + req);

				Http http = new Http();
				HttpResponse response = http.send(req);

				system.debug('response ===> ' + response);
				system.debug('response.body ===> ' + response.getBody());

				//65279 / 0xfeff
				String responseBody = response.getBody().trim().replace('\uFEFF', '');
				system.debug('responseBody ===> ' + responseBody);
				
				Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
				shortURL = String.valueOf(responseMap.get('message'));

				System.debug('shortURL : ' + shortURL);
			}
			catch (Exception ex){
				icServiceErrorHandler.StoreError('getShortUrl','icServiceCentralStation', 'getShortUrl', ex.getStackTraceString(), ex.getMessage(), '');				
			}

			icServiceErrorHandler.CommitErrors('getShortUrl', true);

			return shortURL;
		}
	
		public Boolean syncAccount(String accountId, String payload){
			Boolean syncSuccessful = true;
			
			try {
				HttpRequest req = new HttpRequest();
				
				String resourceEndpoint = csConfigAccountSync.Endpoint__c + '?TOKEN=' + csToken;
				String authorizationHeader;

				//CHECK IF WE SET THE AUTH HEADER
				if (csConfigHTTPServer.Source_Id__c != 'production') {
					Blob headerValue = Blob.valueOf(csConfigHTTPServer.Username__c + ':' + csConfigHTTPServer.Password__c);
					authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);					
				} else {
					authorizationHeader = 'Bearer ' + csToken;
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
					icServiceErrorHandler.StoreError('Sync Account', 'icServiceCentralStation', 'syncAccount', response.getBody(), JSON.serialize(response.getStatus()), payload);
					syncSuccessful = false;
				}
			}
			catch (Exception ex){
				icServiceErrorHandler.StoreError('Sync Account', 'icServiceCentralStation', 'syncAccount', ex.getStackTraceString(), ex.getMessage(), payload);
				syncSuccessful = false;
			}

			icServiceErrorHandler.CommitErrors('Sync Account', true);

			return syncSuccessful;
		}
	}

    @future (callout=true)
    private static void testOut(){

    }
}