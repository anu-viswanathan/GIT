/**
 * Created by Francois Poirier on 2018-06-19.
 */

 public with sharing class icBLeagleView implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        List<icDTOEagleViewProduct> getAvailableProducts();
        icDTOGenericResult grantUserOrderDelegation(String username, String password);
        icDTOEagleViewPlaceOrderResponse placeOrder(String strOrder, String contractorUsernme);
        String getDownloadLink(String reportId);
        String cancelOrder(String reportId);
    }


    public class Impl implements IClass {

        icLogicConfig.IClass logicConfig = (icLogicConfig.IClass) icObjectFactory.GetSingletonInstance('icLogicConfig');

        private API_Configuration__mdt eagleViewConfig {
            get {
                if(eagleViewConfig == null) {
                    eagleViewConfig = logicConfig.getAPIConfigByName('EagleView');
                }
                return eagleViewConfig;
            }
            set;
        }

        private icDTOEagleViewToken eagleViewToken {
            get {
                if(eagleViewToken == null) {
                    eagleViewToken = getToken();
                }
                return eagleViewToken;
            }
            set;
        }

        private icDTOEagleViewToken getToken(){
            icDTOEagleViewToken evToken;

            if(eagleViewConfig != null) {
                Blob authorizationKey = Blob.valueOf(eagleViewConfig.Source_Id__c + ':' + eagleViewConfig.Client_Secret__c);
                String authorizationValue = EncodingUtil.base64Encode(authorizationKey);
                
                HttpRequest req = new HttpRequest();
                String resourceEndpoint = eagleViewConfig.Endpoint__c + 'Token';
                req.setEndpoint(resourceEndpoint);
                req.setMethod('POST');
                req.setHeader('Authorization', 'Basic ' + authorizationValue);
                req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
                req.setBody('grant_type=password&username=' + eagleViewConfig.Username__c + '&password=' + eagleViewConfig.Password__c);

                Http http = new Http();
                HttpResponse response = http.send(req);

                system.debug('response ===> ' + response);
                system.debug('response.body ===> ' + response.getBody());

                evToken =  (icDTOEagleViewToken) JSON.deserialize(response.getBody(), icDTOEagleViewToken.class);

                system.debug('evToken ===> ' + evToken);
            }

            return evToken;
        }

        public List<icDTOEagleViewProduct> getAvailableProducts() {
            List<icDTOEagleViewProduct> products = new List<icDTOEagleViewProduct>();

            if(eagleViewConfig != null && eagleViewToken != null) {
                HttpRequest req = new HttpRequest();
                String resourceEndpoint = eagleViewConfig.Endpoint__c + 'v2/Product/GetAvailableProducts';
                req.setEndpoint(resourceEndpoint);
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + eagleViewToken.access_token);
                req.setHeader('Content-Type', 'application/x-www-form-urlencoded');

                Http http = new Http();
                HttpResponse response = http.send(req);

                system.debug('response ===> ' + response);
                system.debug('response.body ===> ' + response.getBody());

                products = (List<icDTOEagleViewProduct>) JSON.deserialize(response.getBody(), List<icDTOEagleViewProduct>.class);

                system.debug('products ===> ' + products);
            }            

            return products;
        }

        public icDTOGenericResult grantUserOrderDelegation(String username, String password) {
            icDTOGenericResult returnResult = new icDTOGenericResult();
            returnResult.isSuccess = true;

            if(eagleViewConfig != null && eagleViewToken != null) {
                HttpRequest req = new HttpRequest();
                String resourceEndpoint = eagleViewConfig.Endpoint__c + 'v2/Order/GrantUserOrderDelegation';
                req.setEndpoint(resourceEndpoint);
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer ' + eagleViewToken.access_token);
                req.setHeader('Content-Type', 'application/json');

                req.setBody('{"UserName":"' + username + '", "Password":"' + password + '"}');

                system.debug('req.body ===> ' + req.getBody());

                Http http = new Http();
                HttpResponse response = http.send(req);

                system.debug('response ===> ' + response);
                system.debug('response.body ===> ' + response.getBody());

                if(response.getStatusCode() == 200) {
                    returnResult.message = response.getBody();
                }

                if(response.getStatusCode() == 400 || response.getStatusCode() == 401) {
                    returnResult.isSuccess = false;
                    Map<String, Object> mapResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    Map<String, Object> mapModelState = (Map<String, Object>)mapResult.get('ModelState');
                    
                    String strGrantUserOrderDelegationModelUsername;
                    try { 
                        strGrantUserOrderDelegationModelUsername = String.valueOf(mapModelState.get('grantUserOrderDelegationModel.UserName'));
                    } catch(Exception ex){}
                    
                    String strGrantUserOrderDelegationModelPassword;
                    try { 
                        strGrantUserOrderDelegationModelPassword = String.valueOf(mapModelState.get('grantUserOrderDelegationModel.Password'));
                    } catch(Exception ex){} 
                    
                    returnResult.message = String.valueOf(mapResult.get('Message'));
                    if(strGrantUserOrderDelegationModelUsername != null) {
                        returnResult.message += ' ' + strGrantUserOrderDelegationModelUsername;
                    }
                    if(strGrantUserOrderDelegationModelPassword != null) {
                        returnResult.message += ' ' + strGrantUserOrderDelegationModelPassword;
                    }
                }

                if(response.getStatusCode() == 500) {
                    returnResult.isSuccess = false;
                    Map<String, Object> mapResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    returnResult.message = String.valueOf(mapResult.get('Message'));
                }

                system.debug('returnResult.message ===> ' + returnResult.message);
            }            

            return returnResult;
        }

        public icDTOEagleViewPlaceOrderResponse placeOrder(String strOrder, String contractorUsernme){
            icDTOEagleViewPlaceOrderResponse dtoResponse = new icDTOEagleViewPlaceOrderResponse();

            strOrder = strOrder.replace('##PlaceOrderUser##', contractorUsernme);

            if(eagleViewConfig != null && eagleViewToken != null) {
                HttpRequest req = new HttpRequest();
                String resourceEndpoint = eagleViewConfig.Endpoint__c + 'v2/Order/PlaceOrder';
                req.setEndpoint(resourceEndpoint);
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer ' + eagleViewToken.access_token);
                req.setHeader('Content-Type', 'application/json');

                req.setTimeout(120000);

                req.setBody(strOrder);

                Http http = new Http();
                HttpResponse response = http.send(req);
                system.debug('strOrder ===> ' + strOrder);
                system.debug('response ===> ' + response);
                system.debug('response.body ===> ' + response.getBody());

                if(response.getStatusCode() == 200) {
                    dtoResponse = (icDTOEagleViewPlaceOrderResponse) JSON.deserialize(response.getBody(), icDTOEagleViewPlaceOrderResponse.class);
                    dtoResponse.message = Label.icOrder_was_successfully_placed;
                }
                if(response.getStatusCode() == 400 || response.getStatusCode() == 401) {
                    Map<String, Object> mapResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    dtoResponse.message = String.valueOf(mapResult.get('Message'));
                }

                system.debug('response DTO ===> ' + dtoResponse);
            }

            return dtoResponse;
        }

        public String getDownloadLink(String reportId) {
            String downloadLink = '';

            if(eagleViewConfig != null && eagleViewToken != null) {
                HttpRequest req = new HttpRequest();
                String resourceEndpoint = eagleViewConfig.Endpoint__c + 'v2/Report/GetReport?reportId=' + reportId;
                req.setEndpoint(resourceEndpoint);
                req.setMethod('GET');
                req.setHeader('Authorization', 'Bearer ' + eagleViewToken.access_token);            

                Http http = new Http();
                HttpResponse response = http.send(req);
                system.debug('response ===> ' + response);
                system.debug('response.body ===> ' + response.getBody());

                Map<String, Object> mapResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());

                downloadLink = String.valueOf(mapResult.get('ReportDownloadLink'));

                system.debug('response DTO ===> ' + downloadLink);
            }

            return downloadLink;
        }

        public String cancelOrder(String reportId) {
            String resultMessage = '';

            if(eagleViewConfig != null && eagleViewToken != null) {
                HttpRequest req = new HttpRequest();
                String resourceEndpoint = eagleViewConfig.Endpoint__c + 'v2/Report/CloseReport?reportId=' + reportId;
                req.setEndpoint(resourceEndpoint);
                req.setMethod('POST');
                req.setHeader('Authorization', 'Bearer ' + eagleViewToken.access_token);
                req.setHeader('Content-Length', '0');

                Http http = new Http();
                HttpResponse response = http.send(req);
                system.debug('response ===> ' + response);
                system.debug('response.body ===> ' + response.getBody());

                if(response.getStatusCode() == 200) {
                    resultMessage = response.getBody();
                }
                if(response.getStatusCode() == 500) {
                    Map<String, Object> mapResult = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
                    resultMessage = String.valueOf(mapResult.get('Message'));
                }
            }

            return resultMessage;
        }
    }
}