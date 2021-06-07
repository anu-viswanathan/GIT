trigger Product_Trigger on Product2 (before insert, before update) {

    // CLAIMSV2-35
    // Copies the Sector multi-picklist to a text field which will
    // contain all values seperated by a Semi-Colon. This can
    // be used to filter product selection by using a CONTAINS filter
    // for Sector.
   
    if(System.Trigger.isBefore && (System.Trigger.isInsert || System.Trigger.isUpdate)){
       for(Product2 p : System.Trigger.new){
            p.Sectors_Text__c = p.Sectors__c;
        }
        ProductService.updateEngFreFullDescriptionforUnitOfMeasure(System.Trigger.new);
        
    }
      
}