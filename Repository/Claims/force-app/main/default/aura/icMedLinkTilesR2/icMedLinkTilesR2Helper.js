({

    doInit : function (component, event) {
        var action = component.get("c.getCurrentTheme");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();

                component.set("v.currentTheme", responseValue);
            }
        });

        $A.enqueueAction(action);
    },

   

    doNav : function (component, urlMobile, urlDesktop) {
        var currentDevice =  $A.get("$Browser");
        // alert(JSON.stringify(currentDevice));
        var currentTheme = component.get("v.currentTheme");

        // alert(currentTheme);
        var currentURL = window.location.href;


        // alert('currentTheme : ' + currentTheme);
        // alert('currentURL : ' + currentURL);
        // alert('destination : ' + urlDesktop);

        if(currentTheme === "Theme4t" && !currentURL.includes('bridge.app')) {

            // alert('testing url click mobile BROWSER');
            window.open(urlDesktop,'_top');

        } else if(currentTheme === "Theme4t" && currentURL.includes('bridge.app') ) {

            // alert('testing url click mobile app');
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "one:flexipage",
                componentAttributes: {
                    flexiPageDeveloperName: urlMobile
                }
            });
            evt.fire();
        } else {
            // alert('testing url click browser');
            window.open(urlDesktop,'_top');

        }
        // } else if (currentTheme == "THE SECOND THEME YOU WANT HERE") {

    },
    // doNav : function(component,event,secId) {
    //     var evt = $A.get("e.force:navigateToComponent");
    //     evt.setParams({
    //         "componentDef": "one:flexipage",
    //         "componentAttributes": {
    //             "flexiPageDeveloperName": 'Lead_Lists',
    //         }
    //     });
    //     evt.fire();
    // },


    navToMyDashboard : function (component) {
        // alert('testing url click 1');
        this.doNav(component, "IKOPRO_My_Benefits_Dashboard", "ikopro-benefits-dashboards-web" );

    },
    navToMyLeads : function (component) {
        // this.doNav(component, "/00Q/e", "lead/Lead/00B3B000001EjsGUAS" );
        // this.doNav(component, "lead/Lead/00B3B000001EjsGUAS", "lead/Lead/00B3B000001EjsGUAS" );
        // this.doNav(component, "Lead/list?filterName=00B3B000001EjsGUAS", "lead/Lead/00B3B000001EjsGUAS" );
        this.doNav(component, "IKOROOFPRO_Lead_ListView", "lead/Lead/00B3B000001EjsGUAS" );

    },
    navToMyRewards : function (component) {
        this.doNav(component, "Benefits_Overview", "ikopro-benefits-overview" );

    },
    navToIkoUniversity : function (component) {
        this.doNav(component, "IKOROOFPRO_University", "my-learning" );
        // this.doNav(component, "IKOROOFPRO_University", "my-learning" );

    },
    navToProzone : function (component) {
        this.doNav(component, "IKOPRO_Prozone", "prozone" );

    },
    navToForum : function (component) {
        this.doNav(component, "IKOPRO_Forum", "ikoroofpro-forum" );

    }



})