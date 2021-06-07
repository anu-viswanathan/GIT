/**
 * Created by Francois Poirier on 2019-03-28.
 */
({
    doInit : function (component, event, helper) {

        helper.doInit(component, event);

    },

    movePrevious : function (component, event, helper) {

        console.log('move previous');
        helper.movePrevious(component, event);

    },

    moveNext : function (component, event, helper) {

        console.log('move next');
        helper.moveNext(component, event);

    },

    dateChange : function (component, event, helper) {

        helper.loadMonthData(component, event);
    },

    handleViewModeChange : function (component, event, helper) {

        helper.changeViewMode(component, event);

    }

})