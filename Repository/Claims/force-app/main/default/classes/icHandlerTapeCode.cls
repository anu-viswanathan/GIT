/**
 * Created by Anil Mannem (Incloud) on 19-May-2020
 */
public class icHandlerTapeCode implements icIClass {

	public Object GetInstance() {
		return new Impl();
	}

	public Interface IClass {
		void onBeforeInsert(List<Tape_Code__c> newTapeCodes);
    }

	public class Impl implements IClass {

        icLogicProduct.IClass logicProduct = (icLogicProduct.IClass) icObjectFactory.GetSingletonInstance('icLogicProduct');

        /**
         * Ticket ClaimsV2-118
         * Added logic to find and Map available Products with given Product Code
         * By Anil Mannem (Incloud) on 19-May-2020
         */
        public void onBeforeInsert(List<Tape_Code__c> newTapeCodes) {
            updateTapeCodeProduct(newTapeCodes);
        } // end of onBeforeInsert method

        private void updateTapeCodeProduct(List<Tape_Code__c> tapeCodeList) {
            
            Set<String> setProductCodes = new Set<String>();
            for(Tape_Code__c thisTC : tapeCodeList) {
                // If Tape Code Number is blank from DataLoader, insert as No Entry
                if (String.isBlank(thisTC.Name)) {
                    thisTC.Name = 'No Entry';
                }
                if (String.isNotBlank(thisTC.Product_Code_Value__c)) {
                    thisTC.Product_Code_Value__c = thisTC.Product_Code_Value__c.replaceAll('\'','');
                    setProductCodes.add(thisTC.Product_Code_Value__c);
                }
            }
            if (!setProductCodes.isEmpty()) {
                List<Product2> activeProductsList = logicProduct.getActiveProductsByProductCode(setProductCodes);
                Map<String, List<Product2>> productMap = logicProduct.getMapProductsByProductCode(activeProductsList);

                for (Tape_Code__c thisTC : tapeCodeList) {
                    if (productMap.containsKey(thisTC.Product_Code_Value__c)) {
                        if (productMap.get(thisTC.Product_Code_Value__c).size() == 1) {
                            thisTC.Product__c = productMap.get(thisTC.Product_Code_Value__c)[0].Id;
                            thisTC.Product_Description__c = 'Product Code: '+thisTC.Product_Code_Value__c+'\n'+
                                							'Product Name: '+thisTC.Product_Description__c+'\n'+
                                							'Product Color: '+thisTC.Product_Color_Value__c;
                        } else if (productMap.get(thisTC.Product_Code_Value__c).size() > 1) {
                            thisTC.Product_Description__c = System.Label.TapeCode_Multiple_Products +'\n'+
                                							'Product Code: '+thisTC.Product_Code_Value__c+'\n'+
                                							'Product Name: '+thisTC.Product_Description__c+'\n'+
                                							'Product Color: '+thisTC.Product_Color_Value__c;
                        }
                    } else {
                	        thisTc.Product_Description__c = System.Label.TapeCode_No_Products +'\n'+
                                							'Product Code: '+thisTC.Product_Code_Value__c+'\n'+
                                							'Product Name: '+thisTC.Product_Description__c+'\n'+
                                							'Product Color: '+thisTC.Product_Color_Value__c;
                    }
                }
            }
        } //end of updateTapeCodeProduct method
    }
}