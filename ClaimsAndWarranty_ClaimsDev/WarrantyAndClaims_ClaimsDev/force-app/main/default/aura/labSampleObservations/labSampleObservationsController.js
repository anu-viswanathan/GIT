({

    handleSaveRecord: function(component, event, helper) {
    	helper.saveRecord(component, false);
    },

    handleSaveRecordAndClose: function(component, event, helper) {
        helper.saveRecord(component, true);
    }


})