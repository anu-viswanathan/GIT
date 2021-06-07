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
        var currentData = component.get("v.currentData");
        
        for (var i = 0; i < currentData.length; ++i) {
            if(currentData[i].documentId == file_id ){
                currentData[i].ikoFileType = optionValue;
                console.log(currentData[i]);
                break;
             }
        };
        component.set("v.currentData", currentData);
        
    },

    updateFiles : function(component, event, helper) {

        var currentData = component.get("v.currentData");
        var recordId = component.get("v.recordId");
        var objectName = component.get("v.objectName");
        
        
        let action = component.get("c.updateFilesBulkified");
        action.setParams({
            "fileMetaList" : JSON.stringify(currentData),
            "recordId" : component.get("v.recordId"),
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

    /**
     * Shorten the File Name to the first 50 characters for visualization purposes
     * and add ... at the end of the name to let user aware that file name is not complete
     */
    manipulateFileNames : function(component) {

        let currentFilesList = component.get('v.currentData');
        let modifiedCurrentFilesList = [];

        for (var i = 0; i < currentFilesList.length; i++) {
            let file_name = currentFilesList[i].name;
            if (file_name.length >= 50) {
                modifiedCurrentFilesList.push(new this.File(file_name.substr(0, 51) + '...', currentFilesList[i].documentId, currentFilesList[i].ikoFileType));
            } else {
                modifiedCurrentFilesList.push(new this.File(file_name, currentFilesList[i].documentId, currentFilesList[i].ikoFileType));
            }
        }
        component.set('v.currentData', modifiedCurrentFilesList);
    },

    /**
     * Data structure to define the File parameters
     * name for the file name
     * documentId for the file documentId
     */
    File : function(name, documentId, ikoFileType) {
        this.name = name;
        this.documentId = documentId;
        this.ikoFileType = ikoFileType;
    }

});