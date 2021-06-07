/**
 * Created by Yves Asselin on 2018-08-20.
 */
({
    doInit : function(component, event) {
        var today = new Date();
    // console.log("Hello" + today.getFullYear());
        component.set('v.thisYear', today.getFullYear());
    }
})