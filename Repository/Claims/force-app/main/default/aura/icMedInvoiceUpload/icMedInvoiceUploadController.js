/**
 * Created by Francois Poirier on 2019-11-15.
 */
({
    doInit : function(component, event, helper){
        helper.doInit(component, event);
    },

    handleDeleteUploadedFile : function (component, event, helper) {
        helper.onDeleteFile(component, event);
    }, 
 
    onFileUploaded : function(component, event, helper){
        helper.onFileUploaded(component, event);
    },

    onHandleSendClick : function(component, event, helper){
        helper.saveContractorInvoice(component, event);
    }, 

    onHandleValidationJobNumber:function(component, event, helper){
        helper.enableNextButton(component);
        //helper.onHandleInputValidation(component, event);
    },

    onHandleJobDateChange : function(component, event, helper){
        helper.onHandleInputValidation(component, event);
    },
    onHandleChangeProgram: function(component, event, helper){
        helper.onHandleChangeProgram(component, event);
        helper.enableNextButton(component);
    },

    onHandleCancel: function (component, event, helper) {
        helper.onHandleCancel(component, event);

    },

    onToNext : function (component, event, helper){

        helper.createContractorInvoice(component, event);
    }, 

    handleUploadFinished: function (cmp, event, helper) {

          helper.onFileUploaded(cmp, event); 
    }
});