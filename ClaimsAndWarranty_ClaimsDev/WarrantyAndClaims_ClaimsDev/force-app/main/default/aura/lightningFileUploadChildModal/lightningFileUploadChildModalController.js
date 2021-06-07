/**
 * @author: Sinan Bunni
 * @date: 2019-07-24
 */
({
    doInit : function(component, event, helper) {
        helper.loadFileTypeOptions(component);
    },

    closeModal : function(component, event, helper) {
        helper.closeModalHelper(component);
    },

    updateFile : function(component, event, helper) {
        helper.updateFileHelper(component, event, helper);
        helper.handleFileUpdateFireEvent(component);
    },

});