/**
 * @author: Sinan Bunni
 * @date: 2019-07-04
 */
/* variables required for file download */

({
    getFileDownloadSettings : function(component, settingsType){
        var action = component.get("c.getHierarchySettings");
       
        action.setCallback(this, function(response){
            if(component.isValid() && response !== null && response.getState() == 'SUCCESS'){
                if(response.getState() == 'SUCCESS')
                {
                    var result = response.getReturnValue();
                    component.set("v.download", result.	Download__c);
                    component.set("v.downloadUrl", result.DownloadUrl__c);
                    component.set("v.fileSizeLimit", result.MaxSizeAllowed__c);
                }
                else if (status === "INCOMPLETE") {
                    let errors = response.getError();
                    if (errors) {
                        console.log("JS method: getFileDownloadSettings : No response from server or client is offline." + + errors[0].message);
                    }
                }
                else if (state === 'ERROR') {
                    let errors = response.getError();
                    if (errors) {
                        console.error("JS method: getFileDownloadSettings Error Message: " + errors[0].message);
                    }
                }
            }
        });
    
        $A.enqueueAction(action);
    }, 
    /**
     * View all the existing files associated with the object name and record Id
     * provided by the component
     */
    setDataTableFileRecords : function(component) {

        let objectName = component.get("v.sObjectName");

        if (objectName === 'Case') {
            this.getExistingFileRecordsAssociatedWithObject(component, component.get("v.recordId"), objectName);
        } else if (objectName === 'Lab_Sample__c') {
            //$A.util.addClass(component.find('fileUploadCmp'), 'slds-hide'); // hide the fileUpload component
            this.getExistingFileRecordsAssociatedWithObject(component, component.get("v.recordId"), objectName);
        } else if (objectName === 'Warranty__c') {
            this.getExistingFileRecordsAssociatedWithObject(component, component.get("v.recordId"), objectName);
        }
    },

    /**
     * Retrieve all the existing files associated with the object name and record Id
     */
    getExistingFileRecordsAssociatedWithObject : function(component, recordId, objectName) {

        var action = component.get("c.getFiles");
        action.setParams({
            "recordId" : recordId,
            "objectName" : objectName
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.data", result);
                component.set("v.maxPage", Math.ceil(result.length / 25)); // 25 max number records per page
                component.set("v.sortAsc", true);
        		component.set("v.sortField", "ContentModifiedDate"); //ClaimsV2-689
                this.sortBy(component, "ContentModifiedDate");
            } else if (state === 'ERROR') {
                let errors = response.getError();
                if (errors) {
                    console.error("JS method: uploadFilesToObjectFilesRelatedList Error Message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    /**
     * Create a Lightning Modal component to allow the users to modify the IKO File Type prior to upload
     */
    updateFileTypeOnFileUpload : function(component, event) {
        let uploadedFiles = event.getParam("files"); // current uploaded files by user

        $A.createComponent('c:FileDataTableChildModal', {
            currentData : uploadedFiles,
            recordId : component.get('v.recordId'),
            objectName : component.get('v.sObjectName')
        },
        function(modalComponent, status, errorMessage) {
            if (status === 'SUCCESS') {
                var body = component.find('showChildModal').get('v.body');
                body.push(modalComponent);
                component.find('showChildModal').set('v.body', body);
            } else if (state === 'ERROR') {
                let errors = response.getError();
                if (errors) {
                    console.error("JS method: updateFileTypeOnFileUpload Error Message: " + errors[0].message);
                }
            }
        }
        );

    },

    /**
     * Hyperlink to allow the users to view the File details
     */
    openContentDocument : function(event) {

        let file_id = event.currentTarget.getAttribute('id');

        var navigationEvent = $A.get("e.force:navigateToSObject");
        navigationEvent.setParams({
                "recordId": file_id,
                "slideDevName": "related"
        });

        navigationEvent.fire();
    },
    
    downloadSelectedFiles : function(component, isAllFiles){

        let downloadUrl =  component.get("v.downloadUrl");
        let fileSizeLimit =  component.get("v.fileSizeLimit");

        if(downloadUrl == undefined || downloadUrl == '' || downloadUrl == null)
        {
            this.showToast("Error", "Unable to download files. Please try after sometime or contact your system administrator", "Error", "sticky", 5000);
            return;
        }
               
        let availableCheckboxes = component.find('checkFile');
               
        let checkboxesChecked = '';
        let size = 0;

        if(availableCheckboxes == undefined || availableCheckboxes.length == 0)
        {
            this.showToast("Error", "There are no files to be downloaded", "Error", "sticky", 5000);
            return;
        }
        if(!Array.isArray(availableCheckboxes)){
             
            if (isAllFiles || availableCheckboxes.get("v.checked") == true) {
                checkboxesChecked = availableCheckboxes.get("v.value").ContentDocumentId;
                size = size + availableCheckboxes.get("v.value").ContentSize;
            }
        }
         else
        {
              for (let i = 0; i < availableCheckboxes.length; i++) {
                if (isAllFiles || availableCheckboxes[i].get("v.checked") == true) {
                    let id = availableCheckboxes[i].get("v.value").ContentDocumentId;
                    size = size + availableCheckboxes[i].get("v.value").ContentSize;
                    checkboxesChecked = checkboxesChecked + '/' + id;
                }
            }
        }
        if(checkboxesChecked == undefined || checkboxesChecked.length <=0)
        {
            this.showToast("Error", "Please select files to download", "Error", "sticky", 5000);
            return;
        }
         
        if(size > fileSizeLimit)
        {
            this.showToast("Error", "Selected files size exceed 5MB. Please unselect some files to proceed with download", "Error", "sticky", 5000);
        }
        else
        {
            let urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": downloadUrl+checkboxesChecked
            });
            urlEvent.fire();
            
            this.showToast("Success", "Files will be downloaded shortly", "Success", "sticky", 5000);
            if(!Array.isArray(availableCheckboxes)){
                availableCheckboxes.set("v.checked",false)
            }
            else{
                for (let i = 0; i < availableCheckboxes.length; i++) {
                    availableCheckboxes[i].set("v.checked",false);
                }
            }
        }
     },
    

    /**
     * generic method to sort the data table columns either in ascending or descending order
     */
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.data");

        sortAsc = sortField != field || !sortAsc;

        records.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });

        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.data", records);

        /* Clear the selection */
        let availableCheckboxes = component.find('checkFile');
        if(availableCheckboxes != undefined || availableCheckboxes != null)
        {
            if(!Array.isArray(availableCheckboxes)){
                availableCheckboxes.set("v.checked",false)
            }
            else{
                for (let i = 0; i < availableCheckboxes.length; i++) {
                    availableCheckboxes[i].set("v.checked",false);
                }
            }
        }

        this.renderPage(component);
    },

    /**
     * Render the current Files data in the Data Table
     */
    renderPage : function(component) {
        let records = component.get('v.data'),
        pageNumber = component.get('v.pageNumber'),
        pageRecords = records.slice((pageNumber - 1) * 25, pageNumber * 25);

        component.set('v.currentData', pageRecords);
    },

    showToast : function(title, message, type, mode, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode" : mode,
            "duration" : duration
        });
        toastEvent.fire();
    },
})