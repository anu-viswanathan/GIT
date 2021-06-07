/**
 * Created by Anil Mannem (Incloud) on 21-May-2020
 */
@isTest
public with sharing class icRepoProductMock implements icRepoProduct.IClass {
	/**
	 * Ticket ClaimsV2-118
	 * By Anil Mannem (Incloud) on 21-May-2020
	 */
    public List<Product2> getActiveProductsByProductCode(Set<String> productCodeSet) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getActiveProductsByProductCode');
        params.put('productCodeSet', productCodeSet);
        return (List<Product2>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getActiveProductsByProductCode');
    }

    /**
     * IKO-359
     * By Anil Mannem (Incloud) on 30-Sep-2020
     */
    public List<Product2> getProductUnitOfMeasure(List<Id> productIdList) {
        Map<String, object> params = icTestMockUtilities.Tracer.RegisterCall(this, 'getProductUnitOfMeasure');
        params.put('productIdList', productIdList);
        return (List<Product2>) icTestMockUtilities.Tracer.GetReturnValue(this, 'getProductUnitOfMeasure');
    }


}