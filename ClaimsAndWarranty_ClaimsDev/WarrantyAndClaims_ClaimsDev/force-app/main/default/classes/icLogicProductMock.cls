/**
 * Created by Anil Mannem (Incloud) on 21-May-2020
 */
@isTest
public with sharing class icLogicProductMock implements icLogicProduct.IClass {
	/**
	 * Ticket ClaimsV2-118
	 * By Anil Mannem (Incloud) on 21-May-2020
	 */
    public List<Product2> getActiveProductsByProductCode(Set<String> productCodeValueSet) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getActiveProductsByProductCode');
        params.put('productCodeValueSet', productCodeValueSet);
        return (List<Product2>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getActiveProductsByProductCode');
    }
    public Map<String, List<Product2>> getMapProductsByProductCode(List<Product2> activeProductsList) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getMapProductsByProductCode');
        params.put('activeProductsList', activeProductsList);
        return (Map<String, List<Product2>>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getMapProductsByProductCode');
    }

    public Map<Id, Product2> getProductUnitOfMeasure(List<OpportunityLineItem> opportunityLineItemList){
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getProductUnitOfMeasure');
        params.put('opportunityLineItemList', opportunityLineItemList);
        return (Map<Id, Product2>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getProductUnitOfMeasure');
    }


}