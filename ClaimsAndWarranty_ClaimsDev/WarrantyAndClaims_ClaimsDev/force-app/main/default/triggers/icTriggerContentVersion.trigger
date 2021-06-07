/**
 * Created by incloud on 2020-05-21.
 */

trigger icTriggerContentVersion on ContentVersion (after insert) {
    icHandlerContentVersion.IClass handler = (icHandlerContentVersion.IClass) icObjectFactory.GetSingletonInstance('icHandlerContentVersion');

    if(Trigger.isInsert && Trigger.isAfter){
        handler.onAfterInsert(Trigger.new);
    }
    
    /**
     * ClaimsV2-931
     * By Anil Mannem (Incloud) on 27-07-2020
     * Adding error message to prevent Sales User to update file name after Submitting a Case
     */
    // if(Trigger.isBefore && Trigger.isUpdate) {
    //     handler.onBeforeUpdate(Trigger.new);
    // }
}