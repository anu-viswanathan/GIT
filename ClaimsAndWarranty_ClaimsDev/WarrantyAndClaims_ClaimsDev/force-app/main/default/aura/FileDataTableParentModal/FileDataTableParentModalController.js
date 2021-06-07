/**
 * @author: Sinan Bunni
 * @date: 2019-07-04
 */
({

    doInit : function(component, event, helper) {
        helper.setDataTableFileRecords(component);
        helper.getFileDownloadSettings(component);
    },

    sortByTitle : function(component, event, helper) {
        helper.sortBy(component, "Title");
    },

    sortByVersionNumber : function(component, event, helper) {
        helper.sortBy(component, "VersionNumber");
    },

    sortByCreatedByName : function(component, event, helper) {
        helper.sortBy(component, "CreatedByName");
    },

    sortByOwnerName : function(component, event, helper) {
        helper.sortBy(component, "OwnerName");
    },

    sortByContentModifiedDate : function(component, event, helper) {
        helper.sortBy(component, "ContentModifiedDate");
    },

    renderPage: function(component, event, helper) {
        helper.renderPage(component);
    },

    openFile : function(component, event, helper) {
        console.log('inside open file controller');
        helper.openContentDocument(event);
    },
    downloadSelectedFiles : function(component, event, helper) {
        helper.downloadSelectedFiles(component, false);
    },
    
    downloadAllFiles : function(component, event, helper) {
        helper.downloadSelectedFiles(component, true);
    },

    uploadFileFinished : function(component, event, helper) {
        helper.updateFileTypeOnFileUpload(component, event);
    },

    handleUpdateFilesDataTable : function(component, event, helper) {
          let isUploadDataTableFinished = event.getParam('fileUploadFinished');
          if (isUploadDataTableFinished) {
              helper.setDataTableFileRecords(component);
          }
    },
});