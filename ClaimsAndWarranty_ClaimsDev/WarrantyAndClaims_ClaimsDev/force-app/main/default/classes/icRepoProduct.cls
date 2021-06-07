/**
 * Created by Anil Mannem (Incloud) on 20-May-2020
 */
public class icRepoProduct implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
        List<Product2> getActiveProductsByProductCode(Set<String> productCodeSet);
        List<Product2> getProductUnitOfMeasure(List<Id> productIdList);
	}

	public class Impl implements IClass {
		/** Ticket ClaimsV2-118
		 *  Added Repo to query ActiveProducts
		 *  By Anil Mannem (Incloud) on 20-May-2020
		 */
		public List<Product2> getActiveProductsByProductCode(Set<String> productCodeSet) {
			return [SELECT Id
							,Name
							,ProductCode
					FROM	Product2
					WHERE	IsActive=true
					AND		ProductCode IN: productCodeSet];
        }
        /**
         * By Anil Mannem (Incloud)
         * IKO-359
         */
        public List<Product2> getProductUnitOfMeasure(List<Id> productIdList){
            return [SELECT  Id,
                            Unit_of_Measure__c
                    FROM Product2
                    WHERE Id =: productIdList];
        }
	}
}