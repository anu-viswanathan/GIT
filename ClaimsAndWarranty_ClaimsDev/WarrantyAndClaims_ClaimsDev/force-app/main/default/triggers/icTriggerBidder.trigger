trigger icTriggerBidder on Bidder__c (before insert, before update, after insert) {

    icHandlerBidder.IClass handler = (icHandlerBidder.IClass) icObjectFactory.GetSingletonInstance('icHandlerBidder');
    if (Trigger.isBefore && Trigger.isInsert) {
        handler.onBeforeInsert(Trigger.New);
    }
    if (Trigger.isBefore && Trigger.isUpdate) {
        handler.onBeforeUpdate(Trigger.Old, Trigger.New, Trigger.OldMap);
    }
    if(Trigger.isAfter && Trigger.isInsert){
        handler.onAfterInsert(Trigger.New, Trigger.NewMap);
    }
}