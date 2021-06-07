/**
 * @author: Sinan Bunni
 * @date: 2019-07-24
 */
({
    doInit : function(component, event, helper) {
        var currentData = component.get("v.currentData");
		
        Object.keys(currentData).forEach(function (item) {
            currentData[item].ikoFileType = 'APPF'; 
            
        });
        
        component.set("v.currentData",currentData );       
        
        helper.manipulateFileNames(component);
        helper.loadFileTypeOptions(component);
    },

    handleSubmit : function(component, event, helper) {
        var currentData = component.get("v.currentData");
        helper.updateFiles(component, event, helper);
        helper.handleFileUpdateFireEvent(component);
        helper.closeModalHelper(component);

        var fileIds = [];
        for(var idx in currentData){
            fileIds.push(currentData[idx].documentId);
        }

        $A.get('e.lightning:openFiles').fire({
            recordIds: fileIds,
            selectedRecordId: fileIds[0]
        });
    },
    
    closeModal: function(component, event, helper) {
        helper.closeModalHelper(component);
    },

    updateFile : function(component, event, helper) {
        //component.set("v.selectedFileType", optionValue);
        helper.updateFileHelper(component, event, helper);
    },

});