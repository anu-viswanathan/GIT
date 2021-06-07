/**
 * Created by Yves Asselin on 2018-08-13.
 */
({
	doNav : function(component,event,secId) {		
		var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            "componentDef": "one:flexipage",
            "componentAttributes": {
                     "flexiPageDeveloperName": 'Lead_Lists',
            }
        });
    	evt.fire();    
	}
})