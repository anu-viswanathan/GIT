/*
 * Author: Enrico Murru (http://enree.co, @enreeco)
 */
({
    
    /*
     * Executes the search server-side action when the c:inputLookupEvt is thrown
     */
    handleInputLookupEvt: function(component, event, helper){
		helper.searchAction(component, event.getParam('searchString')); 
    },
    
    /*
    	Loads the typeahead component after JS libraries are loaded
    */
    initTypeahead : function(component, event, helper){
        //first load the current value of the lookup field and then
        //creates the typeahead component
       
        var $ = jQuery;
        var globalId = component.getGlobalId();
        
        if(!globalId.endsWith('0')){
            $A.get('e.force:refreshView').fire();
        }
        else{
            var inputElement = $('#'+globalId+'_typeahead');
                        
            if( typeof inputElement.typeahead === "undefined") {
                $A.get('e.force:refreshView').fire();
            }
            else{
                helper.loadFirstValue(component);
            }
        }    
    },

    resetNameValue : function(component, event, helper) {
        component.set('v.nameValue', null);

        var globalId = component.getGlobalId();
        //loading libraries sequentially
        var inputElement = jQuery('[id="'+globalId+'_typeahead"]');
        //init the input element
        inputElement.val(component.get("v.nameValue"));

    }
})