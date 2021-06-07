/**
 * Created by Francois Poirier on 2019-11-20.
 */

({
    doInit : function (component, event, helper) {        
        helper.doInit(component, event);
        
    },
    
    handleDeleteClick : function (component, event, helper) {
        helper.onDeleteFile(component, event); 
    }
});