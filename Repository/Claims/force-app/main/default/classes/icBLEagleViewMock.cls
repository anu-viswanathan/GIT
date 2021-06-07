/**
 * Created by Andrea Pissinis on 2018-09-13.
 */
@isTest
public with sharing class icBLEagleViewMock implements icBLEagleView.IClass{

    public List<icDTOEagleViewProduct> getAvailableProducts() {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getAvailableProducts');
        return (List<icDTOEagleViewProduct>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getAvailableProducts');
    }

    public icDTOGenericResult grantUserOrderDelegation(String username, String password) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'grantUserOrderDelegation');
        params.put('username', username);
        params.put('password', password);
        return (icDTOGenericResult) icTestMockUtilities.Tracer.GetReturnValue(this, 'grantUserOrderDelegation');
    }

    public icDTOEagleViewPlaceOrderResponse placeOrder(String strOrder, String contractorUsernme) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'placeOrder');
        params.put('strOrder', strOrder);
        params.put('contractorUsernme', contractorUsernme);
        return (icDTOEagleViewPlaceOrderResponse) icTestMockUtilities.Tracer.GetReturnValue(this, 'placeOrder');
    }

    public String getDownloadLink(String reportId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getDownloadLink');
        params.put('reportId', reportId);
        return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'getDownloadLink');
    }

    public String cancelOrder(String reportId) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'cancelOrder');
        params.put('reportId', reportId);
        return (String) icTestMockUtilities.Tracer.GetReturnValue(this, 'cancelOrder');
    }
}