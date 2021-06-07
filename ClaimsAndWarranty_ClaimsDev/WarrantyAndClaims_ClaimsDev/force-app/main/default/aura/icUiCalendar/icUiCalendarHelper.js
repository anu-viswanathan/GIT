/**
 * Created by Francois Poirier on 2019-03-28.
 */
({
    doInit : function (component, event) {

        var dayDate = new Date();

        var isNotShowing = "**NotDisplay**";

        component.set("v.dayDate", dayDate);

        component.set("v.isNotShow", isNotShowing);

    },

    getMonthName : function (component, monthNumber) {
        

        var monthNames = [];

        var action = component.get("c.getMonthNamesArray");

        action.setCallback(this, function(response){

            var status = response.getState();
            if (status === 'SUCCESS') {

                var monthNames = response.getReturnValue();
                console.log('monthNames ===> ' + JSON.stringify(monthNames));

                var translatedMonthName = monthNames[monthNumber+1];
                component.set("v.monthName", translatedMonthName);

            }
            else {
                console.log('Error : ' + JSON.stringify(response));
            }
        });

        $A.enqueueAction(action);
    },

    loadMonthData : function(component, event){

        var today = new Date();
        var dayDate = component.get("v.dayDate");
        var numberOfDays = component.get("v.numberOfDays");
        var dayOfWeek = dayDate.getDay();
        var dayNumber = dayDate.getDate();
        var monthNumber = dayDate.getMonth();
        var yearNumber = dayDate.getFullYear();
        var firstMonth = today.getMonth() == monthNumber && today.getFullYear() == yearNumber ? true : false;
        var monthName = this.getMonthName(component, monthNumber);

        component.set("v.yearNumber", yearNumber);
        var firstDayOfMonth = new Date(yearNumber, monthNumber, 1);
        var montNumberBackend = firstDayOfMonth.getMonth() + 1;
        var firstDayOfMonthStr = yearNumber + '-' + montNumberBackend + '-1';
        var firstDayOfMonthDayOfWeek = firstDayOfMonth.getDay();
        var firstDayOfNextMonth = new Date(yearNumber, monthNumber + 1, 1);
        var lastDayOfMonth = new Date(yearNumber, monthNumber+1, 0);
        var lastDayOfMonthStr = yearNumber + '-' + montNumberBackend + '-' + lastDayOfMonth.getDate();
        var lastDayNumber = lastDayOfMonth.getDate();
        var lastDayOfWeek = lastDayOfMonth.getDay();
        var firstDayOfCalendar = new Date(firstDayOfMonth.getFullYear(), firstDayOfMonth.getMonth(), firstDayOfMonth.getDate()-firstDayOfMonthDayOfWeek);
        var firstDayNumber = firstDayOfCalendar.getDate();
        var firstMonthNumber = firstDayOfCalendar.getMonth();
        var firstYearNumber = firstDayOfCalendar.getFullYear();
        var lastDayOfCalendar = new Date(yearNumber, monthNumber, lastDayNumber + 6 - lastDayOfWeek);
        var allCalendarDates = [];
        var allDates = [];

        for(var i=0;i<numberOfDays;i++){
            // var tempDate = new Date();
            // if(lastDayOfWeek > 7){
            //     tempDate = new Date(firstYearNumber, firstMonthNumber, firstDayNumber + i + 1 );
            // }else{
            //     tempDate = new Date(firstYearNumber, firstMonthNumber, firstDayNumber + i - 6 );
            // }

            var tempDate = new Date(firstYearNumber, firstMonthNumber, firstDayNumber + i );
            var tempDateStr = tempDate.getFullYear() + '/' + tempDate.getMonth() + '/' + tempDate.getDate();
            allCalendarDates.push(tempDateStr);
            allDates.push(tempDate);
        }

        console.log('first day of lastDayOfWeek ===>' + lastDayOfWeek);

        console.log('first day of month ===> ' + firstDayOfMonth );
        console.log('first day of month String ===> ' + firstDayOfMonthStr );


        console.log('last day of month ===> ' + lastDayOfMonth);
        console.log('last day of month String ===> ' + lastDayOfMonthStr );

        var action = component.get("c.getEventsByDateRange");
        action.setParams({
            fistDay : firstDayOfMonthStr,
            lastDay : lastDayOfMonthStr
        });
        action.setCallback(this, function(response){

            var status = response.getState();
            if (status === 'SUCCESS'){

                var events = response.getReturnValue();
                console.log('events ===> ' + JSON.stringify(events));
                console.log('current events ===> ' + JSON.stringify(events['currentEvents']));
                component.set("v.events", events);
                var eventsToDisplay = [];
                eventsToDisplay = events['currentEvents'];

                component.set("v.eventsToDisplay", eventsToDisplay);
                component.set("v.dayOfWeek", dayOfWeek);
                component.set("v.dayNumber", dayNumber);
                component.set("v.monthNumber", monthNumber);

                component.set("v.firstDayOfMonth", firstDayOfMonth);
                component.set("v.firstDayOfCalendar", firstDayOfCalendar);
                component.set("v.lastDayOfMonth", lastDayOfMonth);
                component.set("v.lastDayOfCalendar", lastDayOfCalendar);
                component.set("v.firstDayOfNextMonth", firstDayOfNextMonth);
                component.set("v.allCalendarDates", allCalendarDates);
                component.set("v.allDates", allDates);
                component.set("v.firstMonth", firstMonth);
                component.set("v.ready", true);
            }
            else {
                console.log('Error : ' + JSON.stringify(response));
            }

        });

        $A.enqueueAction(action);

        //this.getEvents(component, event);

    },

    movePrevious : function (component, event) {

        var firstDayOfMonth = component.get("v.firstDayOfMonth");
        var firstDayOfPrevious = new Date(firstDayOfMonth.getFullYear(), firstDayOfMonth.getMonth()-1, 1);
        console.log('firstDayOfPrevious ===> ' + firstDayOfPrevious);
        component.set("v.dayDate", firstDayOfPrevious);
    },

    moveNext : function (component, event) {

        var lastDayOfMonth = component.get("v.lastDayOfMonth");
        var firstDayOfNext = new Date(lastDayOfMonth.getFullYear(), lastDayOfMonth.getMonth()+1, 1);
        component.set("v.dayDate", firstDayOfNext);
    },

    getEvents : function (component, event) {
        var firstDayOfCalendar = component.get("v.firstDayOfCalendar");
        var lastDayOfCalendar = component.get("v.lastDayOfCalendar");

        var action = component.get("c.getEventsByDateRange");
        action.setParam({
            startDate : firstDayOfCalendar,
            endDate : lastDayOfCalendar
        });
        action.setCallback(this, function(response){

            var status = response.getState();
            if (status === 'SUCCESS'){

                var events = response.getReturnValue();
                console.log('events ===> ' + JSON.stringify(events));
                component.set("v.events", events);
            }
            else {
                console.log('Error : ' + JSON.stringify(response));
            }

        });

        $A.enqueueAction(action);
    },
    changeViewMode : function (component, event) {

        var viewMode = component.get("v.viewMode");
        var numberOfDays;

        if(viewMode == 'week'){
            numberOfDays = 7;
        }
        if(viewMode == 'month'){
            numberOfDays = 42;
        }

        component.set('v.numberOfDays', numberOfDays);
        this.loadMonthData(component, event);
    }
})