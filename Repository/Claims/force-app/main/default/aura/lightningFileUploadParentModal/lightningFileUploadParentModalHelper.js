/**
 * @author: Sinan Bunni
 * @date: 2019-07-04
 */
({
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
                component.set("v.maxPage", Math.floor((result.length + 9) / 10));
                this.sortBy(component, "Title");
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

        $A.createComponent('c:lightningFileUploadChildModal', {
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
        this.renderPage(component);
    },

    /**
     * Render the current Files data in the Data Table
     */
    renderPage : function(component) {
        let records = component.get('v.data'),
        pageNumber = component.get('v.pageNumber'),
        pageRecords = records.slice((pageNumber - 1) * 10, pageNumber * 10);

        component.set('v.currentData', pageRecords);
    },

})