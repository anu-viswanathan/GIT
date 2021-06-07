/**
 * Created by Francois Poirier on 2018-06-19.
 */
({
    doInit : function (component, event, helper) {
        helper.doInit(component, event);
    },

    doChangePropertyType : function (component, event, helper) {
        helper.doChangePropertyType(component, event);
    },
    
    handleProductChange : function (component, event, helper) {
        helper.handleProductChange(component, event);        
    },

    handleDeliveryProductChange : function (component, event, helper) {
        helper.handleDeliveryProductChange(component, event);                
    },

    handleSendOrderClick : function (component, event, helper) {
        helper.sendOrder(component, event);
    },

    handleBackToOrderClick : function (component, event, helper) {
        helper.handleBackToOrderClick(component, event);
    },

    handleBackToOpportunityClick : function (component, event, helper) {
        helper.handleBackToOpportunityClick(component, event);
    },

    handleResetOrderClick : function (component, event, helper) {
        helper.handleResetOrderClick(component, event);
    }
})