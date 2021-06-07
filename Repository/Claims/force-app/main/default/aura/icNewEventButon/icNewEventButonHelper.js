/**
 * Created by Francois Poirier on 2018-10-04.
 */
({
    newEvent : function (component, event) {

        var evt = $A.get("e.force:createRecord");

        console.log('evt ===> ' + JSON.stringify(evt));

        evt.setParams(
            {
                "entityApiName": "Event"
            }
        );

        evt.fire();
    }
})