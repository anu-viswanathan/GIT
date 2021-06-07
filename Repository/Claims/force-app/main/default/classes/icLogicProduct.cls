/**
 * Created by Anil Mannem (Incloud) on 19-May-2020
 */
public class icLogicProduct implements icIClass {

    public Object GetInstance() {
        return new Impl();
    }

    public Interface IClass {
        List<Product2> getActiveProductsByProductCode(Set<String> productCodeValueSet);
        Map<String, List<Product2>> getMapProductsByProductCode(List<Product2> activeProductsList);
        Map<Id, Product2> getProductUnitOfMeasure(List<OpportunityLineItem> opportunityLineItemList);
    }

    public class Impl implements IClass {

        icRepoProduct.IClass repo = (icRepoProduct.IClass) icObjectFactory.GetSingletonInstance('icRepoProduct');

        /**
         * Ticket ClaimsV2-118
         * Added logic to MapActiveProducts
         * By Anil Mannem (Incloud) on 19-May-2020
         */
        public List<Product2> getActiveProductsByProductCode(Set<String> productCodeValueSet) {
            return repo.getActiveProductsByProductCode(productCodeValueSet);
        }

        public Map<String, List<Product2>> getMapProductsByProductCode(List<Product2> activeProductsList) {
            Map<String, List<Product2>> productMap = new Map<String, List<Product2>>();
            for(Product2 thisProduct: activeProductsList) {
                if (productMap.containsKey(thisProduct.ProductCode)) {
                    productMap.get(thisProduct.ProductCode).add(thisProduct);
    
                } else {
                    productMap.put(thisProduct.ProductCode, new List<Product2>{thisProduct});
                }
            }
            return productMap;
        }
        
        /**
         * By Anil Mannem (Incloud)
         * IKO-359
         */
        public Map<Id, Product2> getProductUnitOfMeasure(List<OpportunityLineItem> opportunityLineItemList){
            List<Id> productIdList = new List<Id>();
            for(OpportunityLineItem thisOpportunityLineItem : opportunityLineItemList){
                productIdList.add(thisOpportunityLineItem.Product2Id);
            }
            List<Product2> productList = repo.getProductUnitOfMeasure(productIdList);
            Map<Id, Product2> productMap = new Map<Id, Product2>();
            for(Product2 thisProduct : productList){
                productMap.put(thisProduct.Id, thisProduct);
            }
            return productMap;
        }


    }
}