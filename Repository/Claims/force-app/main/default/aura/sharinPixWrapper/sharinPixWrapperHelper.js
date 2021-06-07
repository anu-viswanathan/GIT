({

    /**
     * View all the existing files associated with the object name and record Id
     * provided by the component
     */
    assignPermissionId : function(component) {

        let objectName = component.get("v.sObjectName");

        if (objectName === 'Case') {
            this.getPermissionId(component, component.get("v.recordId"), objectName);
        } else if (objectName === 'Lab_Sample__c') {
            this.getLabSampleCaseId(component); // retrieve the CaseId associated with the Lab Sample
            this.getPermissionId(component, component.get("v.recordId"), objectName);
        }
    },

    getPermissionId : function(component, recordId, objectName) {
        var action = component.get("c.getSharinPixPermissions");

        action.setParams({ 
            "recordId": recordId,
            "objectName" : objectName
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                if (objectName === 'Case') {
                    component.set('v.permissionId', a.getReturnValue());
                    component.set('v.albumId', component.get('v.recordId'));
                }

                if (objectName === 'Lab_Sample__c') {
                    component.set('v.permissionId', a.getReturnValue());
                }

                component.set('v.showSharinPix', true);
            } else if (state === "ERROR") {
                var errors = a.getError();
                console.error(errors);
            }
        });

        $A.enqueueAction(action);        
    },

    getLabSampleCaseId : function(component) {
        var action = component.get("c.getCaseIdByLabSampleId");

        action.setParams({
            "labSampleId" : component.get('v.recordId')
        });

        action.setCallback(this, function(result) {
            var state = result.getState();
            if (state === 'SUCCESS') {
                component.set('v.albumId', result.getReturnValue());
            } else if (state === 'ERROR') {
                var errors = result.getError();
                console.log(errors);
            }
        });

        $A.enqueueAction(action);
    }
})