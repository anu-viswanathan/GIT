/**
 * Created by Francois Poirier on 2019-03-25.
 */
({
    goToPDF : function(component, event, helper){

        console.log("in gotoPDF");
        var recordId = component.get('v.recordId');
        var invoiceId = recordId ? recordId : component.get('v.accountPaymentId');
        var action = component.get("c.getBaseURL");
        var currentURL = "";
        console.log("invoice ID ====> " + invoiceId);

        action.setCallback(this, function (response) {
            var state = response.getState();
            console.log('in callback');
            if(state === "SUCCESS"){



                currentURL = response.getReturnValue();
                if(invoiceId) {
                    var vfURL = currentURL + '/apex/icPaymentInvoicePDF?id=' + invoiceId;
                    window.open(vfURL, '_blank');
                    //console.log('vfURL ====> ' + vfURL);
                }
                else {
                    alert('Invoice Id not found');
                }

            }
            else{
                console.log('Error: ' + JSON.stringify(response));
            }


        });

        $A.enqueueAction(action);
    }
})