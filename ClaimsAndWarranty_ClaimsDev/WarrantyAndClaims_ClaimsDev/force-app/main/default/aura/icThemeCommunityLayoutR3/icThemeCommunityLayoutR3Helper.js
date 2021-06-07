/**
 * Created by yvesasselin on 2018-08-31.
 */
({
    doInit : function(component, event) {
        var today = new Date();

        component.set('v.thisYear', today.getFullYear());
    }
})