/**
 * Created by Anil Mannem (Incloud) on 08-June-2020
 * Ticket ClaimsV2-118
 * Added batch class to process the records without product lookup
 */

global class icBatchTapeCode implements Database.Batchable<sObject>, Database.Stateful  {

    icLogicProduct.IClass logicProduct = (icLogicProduct.IClass) icObjectFactory.GetSingletonInstance('icLogicProduct');

    private Integer totalTapeCodes = 0;
    private Integer totalTapeCodesProcessed = 0;
    private Integer totalTapeCodesFailed = 0;
    private Date processFromDate;

    public icBatchTapeCode() {
        processFromDate = Date.Today();
    }
    public icBatchTapeCode(Date givenDate) {
        processFromDate = givenDate;
    }
    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id, Name, Product__c, Product_Code_Value__c, Product_Description__c, CreatedDate FROM Tape_Code__c WHERE Product__c = null AND CreatedDate >= :processFromDate');
    }

    global void execute(Database.BatchableContext context, List<Tape_Code__c> tapeCodeList) {
		totalTapeCodes += tapeCodeList.size();
        Set<String> setProductCodes = new Set<String>();
        for(Tape_Code__c thisTC : tapeCodeList) {
            if (String.isNotBlank(thisTC.Product_Code_Value__c)) {
                setProductCodes.add(thisTC.Product_Code_Value__c);
            }
        }
        if (!setProductCodes.isEmpty()) {
            List<Product2> activeProductsList = logicProduct.getActiveProductsByProductCode(setProductCodes);
            Map<String, List<Product2>> productMap = logicProduct.getMapProductsByProductCode(activeProductsList);

            List<Tape_Code__c> updateTapeCode = new List<Tape_Code__c>();
            for (Tape_Code__c thisTC : tapeCodeList) {
                if (productMap.containsKey(thisTC.Product_Code_Value__c)) {
                    if (productMap.get(thisTC.Product_Code_Value__c).size() == 1) {
                        thisTC.Product__c = productMap.get(thisTC.Product_Code_Value__c)[0].Id;
                        totalTapeCodesProcessed++;
                        if( String.isNotBlank(thisTC.Product_Description__c)) {
                            if(thisTC.Product_Description__c.contains(System.Label.TapeCode_Multiple_Products)) {
                                thisTC.Product_Description__c = thisTC.Product_Description__c.replaceAll(System.Label.TapeCode_Multiple_Products +'\n','');
                            } else if(thisTC.Product_Description__c.contains(System.Label.TapeCode_No_Products)) {
                                thisTC.Product_Description__c = thisTC.Product_Description__c.replaceAll(System.Label.TapeCode_No_Products +'\n','');
                            }
                            thisTC.Product_Description__c += '\nRecord Updated from Batch Job on :'+ icUtilDatetime.getLocalDateTime(Datetime.now());
                       } else {
                           thisTC.Product_Description__c = 'Record Updated from Batch Job on :'+ icUtilDatetime.getLocalDateTime(Datetime.now());
                       }
                    } else if (productMap.get(thisTC.Product_Code_Value__c).size() > 1) {
                        totalTapeCodesFailed++;
                    }
                } else {
                    totalTapeCodesFailed++;
                }
                updateTapeCode.add(thisTC);
            }
            update updateTapeCode;
        }
	}

    global void finish(Database.BatchableContext context) {
       String emailBodyHTML = 'Tape Code Batch Process ran and completed at : ' + icUtilDatetime.getLocalDateTime(Datetime.now()) + '<br>';
       emailBodyHTML += '<br> Total Tapecodes : ' + totalTapeCodes + '<br>';
       emailBodyHTML += '<br> Total Tapecodes Processed : ' + totalTapeCodesProcessed + '<br>';
        emailBodyHTML += '<br> Total Tapecodes failed : ' + totalTapeCodesFailed + '<br>';

        Messaging.SingleEmailMessage emailOut = new Messaging.SingleEmailMessage(); 

        emailOut.setSubject('Tape Code Batch Process Results');
        emailOut.setSenderDisplayName('TapeCode BatchJob');
        emailOut.setToAddresses(new String[] {'WCMS_GOLIVE@IKO.com'});
        emailOut.setHTMLBody(emailBodyHTML);        

        Messaging.sendEmail(new List<Messaging.Email>{emailOut});
    }
}