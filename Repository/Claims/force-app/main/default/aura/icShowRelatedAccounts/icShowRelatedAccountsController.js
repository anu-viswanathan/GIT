({
    doInit : function (component, event, helper){
        console.log('yes its is working ');
        var recordId = component.get('v.recordId');
        console.log('v.recordId', recordId);
        if(recordId){
            helper.getRelatedAccountsByCaseId(component, recordId);
        }
        
    },

    onSelectAccount : function(component, event, helper) {
        var caseObj = component.get('v.caseObj');
        caseObj.AccountId = event.getSource().get("v.name")
        component.set('v.caseObj', caseObj);

        var relatedAccountsList = component.get('v.relatedAccounts');

        for(var index in  relatedAccountsList){
            var accountDetailsObj = relatedAccountsList[index];

            if(accountDetailsObj.relatedAccountObj.Id == caseObj.AccountId){
                component.set('v.street', accountDetailsObj.relatedAccountObj.BillingStreet);
                component.set('v.state', accountDetailsObj.relatedAccountObj.BillingState);
                component.set('v.postalCode', accountDetailsObj.relatedAccountObj.BillingPostalCode);
                component.set('v.city', accountDetailsObj.relatedAccountObj.BillingCity);
                component.set('v.country', accountDetailsObj.relatedAccountObj.BillingCountry);
                break;
            }
        }
        /*var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
            "url": "/"+ caseObj.AccountId
            });
        urlEvent.fire();*/
    },

    onSelectCase : function(component, event, helper) {
        var caseId = event.currentTarget.getAttribute("name");
       component.set('v.recordId', caseId);
        var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
            "url": "/"+ caseId,
            "isredirect": "true"
            });
        urlEvent.fire();
    },

    fetchAccounts : function(component, event, helper) {
        helper.getAllRelatedAccounts(component);
    },

    clearAccounts : function(component, event, helper) {
        component.set('v.relatedAccounts', []);
    },
})