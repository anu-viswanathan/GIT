({
    doInit : function(component, event) {
        var today = new Date();

        component.set('v.thisYear', today.getFullYear());
    },

    // logout : function(component, event, helper) {
    //         	window.location.replace("https://lp-iko.cs20.force.com/IKOROOFPRO/s/login/");
    //     window.location.replace("https://lp-iko.cs20.force.com/IKOROOFPRO/s/servlet/networks/switch?startURL=%2Fsecur%2Flogout.jsp");
    // }

    logout : function(component, event, helper) {
        window.location.replace("https://lp-iko.cs20.force.com/servlet/networks/switch?startURL=%2Fsecur%2Flogout.jsp");
    }

})