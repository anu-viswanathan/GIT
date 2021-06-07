({
    doInit : function (component, event) {

        var recordId = component.get("v.recordId");

        var action = component.get("c.isCustomerSubscribed");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.isCustomerSubscribed", responseValue);
            }
            else {
                console.log('erreur : ' + JSON.stringify(response));
            }
        });

        $A.enqueueAction(action);

        var sPageURL = decodeURIComponent(window.location);

        console.log('PAGE URLSSS ' + sPageURL);

        var checSite = component.get("c.isCommunity");
        checSite.setParams({sPageURL : sPageURL});
        checSite.setCallback(this, function(response){
            var check = response.getState();
            if (check === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.isInCommunity", responseValue);
            }
            else {
                console.log('erreur : ' + JSON.stringify(response));
            }
        })

        $A.enqueueAction(checSite);
    },

    doCreateOrder : function (component, event) {
        var recordId = component.get("v.recordId");
        var communityFlag = component.get("v.isInCommunity");

        if (communityFlag == true){
            $A.get("e.force:navigateToURL").setParams({
                "url": "/eagleview?recordId=" + recordId
            }).fire()
        }else{
            console.log('IN SF');
            $A.get("e.force:navigateToComponent").setParams({
                componentDef: "c:icMedEagleViewOrderForm",
                componentAttributes : {recordId : recordId}
            }).fire();
        }
    },

    doSubscribe : function (component, event) {
        var recordId = component.get("v.recordId");
        var communityFlag = component.get("v.isInCommunity");

        if (communityFlag == true){
            console.log('IN COMMUNITY');
            $A.get("e.force:navigateToURL").setParams({
                "url": "/eagleviewsubscribe?recordId=" + recordId
            }).fire();
        }else{
            console.log('IN SF');
            $A.get("e.force:navigateToComponent").setParams({
                componentDef: "c:icMedEagleViewSubscribeForm",
                componentAttributes : {recordId : recordId}
            }).fire();
        }
    }
})