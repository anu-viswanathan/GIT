trigger RelatedProductTrigger on Related_Product__c (before insert, before update, before delete,
														after insert, after update, after delete, after undelete) {

	if(System.Trigger.isBefore) 
		RelatedProductService.blockCreatedUpdateDelete(System.Trigger.IsDelete ? System.Trigger.old : System.Trigger.new);


	if(System.Trigger.IsDelete && System.Trigger.isBefore) {
		RelatedProductService.blockRecordDeletion(System.Trigger.old);
	}

	if(System.Trigger.isAfter &&(System.Trigger.isInsert || System.Trigger.isUpdate)){

		RelatedProductService.calculateTotalCostOfSettlementItemsOnRelatedCase(System.Trigger.new);
	}

	if(System.Trigger.isAfter && System.Trigger.isDelete){
		RelatedProductService.calculateTotalCostOfSettlementItemsOnRelatedCase(System.Trigger.old);
	}

}