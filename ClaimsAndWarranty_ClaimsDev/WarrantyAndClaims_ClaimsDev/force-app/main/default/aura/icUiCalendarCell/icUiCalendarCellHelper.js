/**
 * Created by Francois Poirier on 2019-03-28.
 */
({
    doInit : function (component, event) {

        var dayDateStr = component.get("v.dayDate");
        var dayDateArray = dayDateStr.split('/');
        var events = component.get("v.events");
        var dayDate = new Date(dayDateArray[0], dayDateArray[1], dayDateArray[2]);

        var today = new Date();
        //console.log('dayDateDateStr ===> ' + dayDateStr);
        //console.log('dayDate ===> ' + dayDate);

        var dayNumber = dayDate.getDate();
        var monthNumber = dayDate.getMonth();
        var yearNumber = dayDate.getFullYear();
        /*var dayOfWeek = dayDate.getDay();*/
        //var isWeekend = false;

        component.set("v.dayNumber", dayNumber);
        component.set("v.monthNumber", monthNumber);
        component.set("v.yearNumber", yearNumber);

        /*if(dayOfWeek == 0 || dayOfWeek == 6){
            isWeekend = true;
        }
        else {
            isWeekend = false;
        }
*/
        //component.set("v.isWeekend", isWeekend);
        if(dayNumber == today.getDate() && monthNumber == today.getMonth() && yearNumber == today.getFullYear()){
            /*console.log('we are today!!!');*/
            var myCells = component.find("calCell");
            myCells.forEach(function (myCell) {
                $A.util.addClass(myCell, "today");
            });

        }
        else {
            var myCells = component.find("calCell");
            myCells.forEach(function (myCell) {
                $A.util.removeClass(myCell, "today");

            });

        }

        var dateKey = yearNumber.toString() + (monthNumber+1).toString() + dayNumber.toString();
        console.log('dateKey ===> ' + dateKey);

        var myCells = component.find("calCell");



        if(events[dateKey]){
            var todayEvents = events[dateKey];
            /*var majorEvents = events['major'];
            todayEvents.concat(majorEvents);*/
            console.log('todayEvents ===>' + JSON.stringify(todayEvents));
            component.set("v.todayEvents", todayEvents);
            var myCells = component.find("calCell");
            myCells.forEach(function (myCell) {
                $A.util.addClass(myCell, "hasEvents");
            });
        }
        else{
            component.set("v.todayEvents", []);
            var myCells = component.find("calCell");
            myCells.forEach(function (myCell) {
                $A.util.removeClass(myCell, "hasEvents");
                /*if(isWeekend) {
                    $A.util.addClass(myCell, "weekend");
                }
                else {
                    $A.util.addClass(myCell, 'weekday');
                }
*/
            });
        }

        var myCells = component.find("calCell");
        myCells.forEach(function(myCell) {
            $A.util.removeClass(myCell, "isClicked");
        });

    },

    dayClick : function (component, event) {

        component.set('v.resetClick', true);
        var todayEvents = component.get("v.todayEvents");
        var allEvents = component.get("v.events");
        var majorEvents = allEvents["major"];
        console.log('major events ===> '+ JSON.stringify( majorEvents));

        var myCells = component.find("calCell");
        myCells.forEach(function (myCell) {
            $A.util.removeClass(myCell, "hasEvents");
            $A.util.removeClass(myCell, 'weekday');
            $A.util.removeClass(myCell, 'weekend');
            $A.util.addClass(myCell, "isClicked");
        });

        var eventsToDisplay = todayEvents.concat(majorEvents);
        console.log('events to display ====> ' + JSON.stringify(eventsToDisplay));
        component.set("v.eventsToDisplay", eventsToDisplay);
        component.set("v.resetClick", false);

    },

    resetClick :function (component, event) {


        var resetClick = component.get("v.resetClick");
        var isWeekend = component.get("v.isWeekend");

        if(resetClick) {
            var yearNumber = component.get("v.yearNumber");
            var monthNumber = component.get("v.monthNumber");
            var dayNumber = component.get("v.dayNumber");

            var dateKey = yearNumber.toString() + (monthNumber+1).toString() + dayNumber.toString();
            var events = component.get("v.events");
            if(events[dateKey]){
                component.set("v.todayEvents", events[dateKey]);
                myCells = component.find("calCell");
                myCells.forEach(function (myCell) {

                    $A.util.addClass(myCell, "hasEvents");
                });
            }
            else {
                var myCells = component.find("calCell");
                myCells.forEach(function (myCell) {
                    if(isWeekend) {
                        $A.util.addClass(myCell, "weekend");
                    }
                    else {
                        $A.util.addClass(myCell, 'weekday');
                    }

                });
            }


            var myCells = component.find("calCell");
            myCells.forEach(function (myCell) {
                $A.util.removeClass(myCell, "isClicked");
            });
        }

    }
})