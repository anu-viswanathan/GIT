/**
 * Created by Francois Poirier on 2019-11-15.
 */
({
    doInit: function (component, event) {

        var today = new Date();
        var dd = String(today.getDate()).padStart(2, '0');
        var mm = String(today.getMonth() + 1).padStart(2, '0');
        var yyyy = today.getFullYear();

        var getToday = mm + '/' + dd + '/' + yyyy;
        component.set("v.getToday", getToday);
        var recordId = component.get('v.recordId');

        var action = component.get("c.getComponentDetails");
        action.setParams({
            invoiceId: recordId
        });

        action.setCallback(this, function (response) {

            var state = response.getState();
            if (state === "SUCCESS") {

                var returnValues = response.getReturnValue();
                component.set("v.rebatePrograms", returnValues['rebatePrograms']);
                console.log("get rebate programs ++++++: " + returnValues['rebatePrograms']);

                if(returnValues['contractorInvoice']){
                    component.set('v.contractorInvoice',  returnValues['contractorInvoice']);
                    component.set('v.selectedRebateProgram',  returnValues['contractorInvoice'].Rebate_Program_Formula__c);
                    component.set('v.contractorInvoiceId', recordId);
                    component.set('v.files', returnValues['files']);
                    component.set('v.calledFromQuickAction', true);

                    if(returnValues['files']){
                        component.set('v.fileNumber', returnValues['files'].length);

                        if( returnValues['files'].length >= 1){
                            component.set('v.sendBtnIsDisabled',  false);
                        }

                        if(returnValues['files'].length >= 10){
                            component.set('v.uploadDisabled', true);
                        }
                    }
                    
                    //enable second screen
                    var toHide = component.find('firstScreen');
                    var toShow = component.find('secondScreen');
                    $A.util.addClass(toHide,'hiddeContent');
                    $A.util.removeClass(toShow, 'hiddeContent');
                }else{
                    var toShow = component.find('firstScreen');
                    var toHide = component.find('secondScreen');
                    $A.util.addClass(toHide,'hiddeContent');
                    $A.util.removeClass(toShow, 'hiddeContent');
                }
            } else {
                console.log('Error : ' + JSON.stringify(response));
                var toShow = component.find('firstScreen');
                    var toHide = component.find('secondScreen');
                    $A.util.addClass(toHide,'hiddeContent');
                    $A.util.removeClass(toShow, 'hiddeContent');
            }
        });
        $A.enqueueAction(action);
    },

    saveContractorInvoice: function (component, event) {

        var action = component.get("c.saveInvoice");
        var contractorInvoice = component.get("v.contractorInvoice");

        action.setParams({invoice: contractorInvoice});

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.sendBtnIsDisabled', true);
                component.set('v.cancelBtnDisabled', true);
                component.set('v.uploadDisabled', true);

                var getScreenGrey = component.find('secondScreen');
                $A.util.addClass(getScreenGrey, 'getGrey');
                var Success_Title = $A.get("{!$Label.c.icUpload_Success_Title}");
                var Success_Msg = $A.get("{!$Label.c.icUpload_Success_Message}");
                this.showToast (Success_Title, Success_Msg , 'success');
                //window.open('/s/invoice-uploads', '_self');
                document.location.reload(true);
            } else {

                var Error_Title = $A.get("{!Label.c.icUpload_Error_Title}");
                var Error_Msg = $A.get("{!Label.c.icUpload_Error_Message}");
                this.showToast(Error_Title, Error_Msg, 'error');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                console.log('Error : ' + JSON.stringify(respons));
            }
        });

        $A.enqueueAction(action);

    },

    onFileUploaded : function (component, event) {
        try{
            var uploadedFiles = event.getParam("files");
            var numberOfFiles = uploadedFiles.length;
            var attachedFiles = component.get("v.files");
            var maxNumberOfFilesReached = false;
            var maxNumberOfFiles = $A.get('$Label.c.Max_number_uploaded_invoices');
            var totalNumberFilesUploaded = attachedFiles.length;
            var validateInput =  component.get("v.DtoInvoices");
            var fileIds = [];

            if((totalNumberFilesUploaded + numberOfFiles) > maxNumberOfFiles){
                var maximumErrorMsg = component.get("v.maximumErrorMsg");
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: maximumErrorMsg,
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();

                for(let i = 0; i < numberOfFiles  ; i++){
                    fileIds.push(uploadedFiles[i].documentId);
                }
                this.deleteFiles(component, fileIds);
                return;
            } 
            if ( totalNumberFilesUploaded <= maxNumberOfFiles) {

                for(let i = 0; i < numberOfFiles  ; i++){

                    if (totalNumberFilesUploaded >= maxNumberOfFiles) {
                        maxNumberOfFilesReached = true;

                    }
                    if(totalNumberFilesUploaded >= maxNumberOfFiles -1 ){
                        component.set("v.uploadDisabled", true);
                        component.set("v.hasFullFile", true);
                    }

                    var name = uploadedFiles[i].name;  
                    if(this.checkFileType(name) == true  && !maxNumberOfFilesReached){
                        totalNumberFilesUploaded++;
                        attachedFiles.push(uploadedFiles[i]);
                    }

                }

                if(this.validateFields(component, validateInput) == true){
                    component.set("v.sendBtnIsDisabled", false);
                }
            }
            component.set("v.files", attachedFiles);
            component.set("v.fileNumber", attachedFiles.length);
            if(totalNumberFilesUploaded > maxNumberOfFiles){
                component.set("v.disableFileUpload", true);
            }
            var fileOverSize = component.get("v.fileOverSize");
            if(fileOverSize){
                component.set("v.disableFileUpload", false);
            }

            component.set("v.uploadCompleted", true);
            component.set("v.sendBtnIsDisabled", false);

        }catch(excp){
            console.log('Exception came===', excp);
        }

    },
    deleteFiles : function(component, fileIds){
        component.set('v.Spinner', true);
        var action = component.get("c.deleteUploadedFiles");
        var contractorInvoiceId = component.get('v.contractorInvoiceId');
        action.setParams(
            {
                fileIds : fileIds,
                invoiceId    : contractorInvoiceId
            }
        );

        action.setCallback(this, function (response) {

            var state = response.getState();
            if(state === "SUCCESS"){
                component.set("v.hasFullFile", false);
                var newFileLength = component.get('v.files').length;
                component.set('v.fileNumber', newFileLength);
            }
            else {
                console.log('Error : ' + JSON.stringify(response));
                var Error_Title = $A.get("{!$Label.c.Generic_Error_Title}");
                var Error_Msg = $A.get("{!$Label.c.Generic_Error_Message}");
                this.showToast (Error_Title, Error_Msg , 'error');
            }
                component.set('v.Spinner', false);
        });
        $A.enqueueAction(action);
    },

    onDeleteFile : function(component, event) {
        var fileObj = event.getParam("file");
        var documentId = fileObj.documentId;

        if(!documentId){
            documentId = fileObj.DocumentId;
        }
        var fileIds = [];
        fileIds.push(documentId);
        this.deleteFiles(component, fileIds);

    },



    onHandleInputValidation : function(component, event){

        var inputDtoInvoice = component.get("v.DtoInvoices");

        if( this.validateFields(component, inputDtoInvoice) == false ){
            component.set("v.sendBtnIsDisabled", true);
        }else{
            component.set("v.sendBtnIsDisabled", false);
        }
    },

    onHandleChangeProgram : function(component,event){

        var selectedRebateProgram = component.get('v.selectedRebateProgram');
        component.set("v.showRebatProgram", selectedRebateProgram);
    },

    validateFields: function (component, DtoInvoices) {

        var retour = true;
        var attachedFilesSize = component.get("v.files").length;

        if (DtoInvoices.invoiceNumber === undefined ||
            DtoInvoices.invoiceNumber === null ||
            DtoInvoices.invoiceNumber === "" ||  attachedFilesSize == 0) {
            retour = false;
        }

        return retour;
    },

    createContractorInvoice : function (component, event) {

        console.log("in createContractorInvoice");
        var action = component.get("c.newContractorInvoice");
        var selectedRebateProgram = component.get('v.selectedRebateProgram');
        var contractorInvoice = component.get('v.contractorInvoice');

        action.setParams(
            {
                rebateProgram : selectedRebateProgram,
                contractorInvoice    : contractorInvoice
            }
        );

        action.setCallback(this, function (response) {

            var state = response.getState();
            if(state === "SUCCESS"){

                var invoice = response.getReturnValue();
                component.set("v.contractorInvoiceId", invoice.Id);
                component.set("v.contractorInvoice", invoice);

                //enable second screen
                var toHide = component.find('firstScreen');
                var toShow = component.find('secondScreen');
                $A.util.addClass(toHide,'hiddeContent');
                $A.util.removeClass(toShow, 'hiddeContent');
            }
            else {
                var Error_Title = $A.get("{!$Label.c.Generic_Error_Title}");
                var Error_Msg = $A.get("{!$Label.c.Generic_Error_Message}");
                this.showToast (Error_Title, Error_Msg , 'error');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                console.log('Error : ' + JSON.stringify(errors));
                console.log('Error : ' + JSON.stringify(response));
            }

        });
        $A.enqueueAction(action);
    },

    enableNextButton : function (component){
        var selectedRebateProgram = component.get('v.selectedRebateProgram');
        var contractorInvoice = component.get('v.contractorInvoice');

        if(!this.isBlank(selectedRebateProgram) && !this.isBlank(contractorInvoice.Invoice_Number__c)){
            component.set('v.nextBtnIsDisabled', false);
        }else{
            component.set('v.nextBtnIsDisabled', true);
        }
    },

    isBlank : function(value)
    {
        if(value != '' && value != undefined && value != null){
            return false;
        }
        return true;
    },

    showToast : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    checkFileType : function (fileName) {
        var fileType = fileName.substring(fileName.lastIndexOf('.') + 1);
        fileType = fileType.toLowerCase();
        if( fileType == "pdf" || fileType == "png" || fileType == "jpg" || fileType == "JPEG" || fileType == "jpeg") {
            return true;
        }else{
            return false;
        }
    },

    deleteInvoice : function (component){
        var action = component.get("c.deleteContractInvoice");
        var contractorInvoiceId = component.get("v.contractorInvoiceId");

        action.setParams({invoiceId : contractorInvoiceId});

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {

                var calledFromQuickAction = component.get('v.calledFromQuickAction');
                if(calledFromQuickAction){
                    //window.open('/s/invoice-uploads', '_self');
                    var currentURL = window.location.href;
                    if(currentURL.indexOf('CRCROOFPRO') > -1){
                        window.open('/CRCROOFPRO/s/invoice-uploads', '_self');					
                    } else {
                        window.open('/s/invoice-uploads', '_self');
                    }
                }else{

                    component.set('v.selectedRebateProgram', null);
                    var newFiles = component.get("v.newFiles");
                    component.set('v.files', newFiles);
                    var newDtoInvoices = component.get("v.newDtoInvoices");
                    component.set('v.DtoInvoices', newDtoInvoices);
                    var newFileLength = component.get('v.files').length;
                    component.set('v.fileNumber', newFileLength);

                    component.set('v.contractorInvoice', response.getReturnValue());
                    component.set("v.uploadDisabled", false);
                    component.set("v.hasFullFile", false);
                    component.set("v.nextBtnIsDisabled", true);
                    component.set("v.sendBtnIsDisabled", true);
                    var toHideScreen = component.find('secondScreen');
                    var toShowScreen = component.find('firstScreen');
                    $A.util.addClass(toHideScreen,'hiddeContent');
                    $A.util.removeClass(toShowScreen, 'hiddeContent');
                }

            } else {
                var Error_Title = $A.get("{!$Label.c.Generic_Error_Title}");
                var Error_Msg = $A.get("{!$Label.c.Generic_Error_Message}");
                this.showToast (Error_Title, Error_Msg , 'error');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
                console.log('Error : ' + JSON.stringify(response));
            }
        });

        $A.enqueueAction(action);
    },

    onHandleCancel: function(component, event){


        this.deleteInvoice(component);

    }
});