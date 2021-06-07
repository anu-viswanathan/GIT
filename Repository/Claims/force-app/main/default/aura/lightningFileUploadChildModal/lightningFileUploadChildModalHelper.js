/**
 * @author: Sinan Bunni
 * @date: 2019-07-26
 */
({
    /**
     * close the modal by destorying the dynamic component
     */
    closeModalHelper : function(component) {
        component.destroy();
    },

    /**
     * load the IKO File Types from the the Custom Metadata Type: IKOFileType__mdt
     */
    loadFileTypeOptions : function(component) {

        var action = component.get("c.getListOfFileTypes");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                let result = response.getReturnValue();
                let optionsMap = [];
                for (var key in result) {
                    optionsMap.push({ key : key, value : result[key] });
                }
                component.set('v.fileOptions', optionsMap);
            } else if (state === 'ERROR') {
                let errors = response.getError();
                if (errors) {
                    console.error("JS method: loadFileTypeOptions Error Message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);

    },

    /**
     * Update the File Title to contain the IKO File Type selected by the user
     */
    updateFileHelper : function(component, event, helper) {

        var optionValue = event.getSource().get('v.value');
        var file_id = event.getSource().get('v.name');

        let action = component.get("c.updateFiles");
        action.setParams({
            "documentId" : file_id,
            "recordId" : component.get("v.recordId"),
            "ikoFileType" : optionValue,
            "objectName" : component.get("v.objectName")
        });

        action.setCallback(this,function(response){
            var state = response.getState();
            if(state=='SUCCESS') {

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "message": "The file(s) have been updated successfully."
                });
                toastEvent.fire();

            } else if (state === 'ERROR') {
                let errors = response.getError();
                if (errors) {
                    console.error("JS method: updateFileHelper Error Message: " + errors[0].message);
                }
            }

         });
         $A.enqueueAction(action);

    },

    /**
     * Indication to the Parent Lightning Component when the Child Component finish processing
     * and updating the uploaded (new) Files by the user
     * @event updateFilesDataTableEvent.evt
     */
    handleFileUpdateFireEvent : function(component) {
        var fileUploadFinishedEvent = component.getEvent('fileUploadFinished');
        fileUploadFinishedEvent.setParam('fileUploadFinished', true);
        fileUploadFinishedEvent.fire();
    },

});