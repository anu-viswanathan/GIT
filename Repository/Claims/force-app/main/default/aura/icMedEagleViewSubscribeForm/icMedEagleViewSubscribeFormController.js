({
    handleSubscribeClick : function (component, event, helper) {
        console.log("in handle subscribe click in controller front end");
        helper.handleSubscribeClick(component, event);
    },

    handleBackToOpportunityClick : function (component, event, helper) {
        helper.handleBackToOpportunityClick(component, event);
    },
    test : function (component, event, helper) {

        alert('test is working');
        
    }
})