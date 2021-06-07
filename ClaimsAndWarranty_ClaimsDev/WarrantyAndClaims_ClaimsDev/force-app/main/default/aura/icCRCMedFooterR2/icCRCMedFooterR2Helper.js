/**
 * Created by yvesasselin on 2018-08-12.
 */
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

        var today = new Date();
        // console.log("Hello" + today.getFullYear());
        component.set('v.thisYear', today.getFullYear());


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
    },

    navToPrivacyPolicy : function (component) {
        this.doNav(component, "IKOROOFPRO_Privacy_Policy", "crcroofpro-privacy-policy");

    },

    navToTermsConditions : function (component) {
        this.doNav(component, "IKOROOFPRO_Terms_Conditions", "crcroofpro-terms-and-conditions");

    },

    navToCookiePolicy : function (component) {
        this.doNav(component, "IKOROOFPRO_Cookie_Policy", "ikoroofpro-cookie-policy");

    },

    navToContactUs : function (component) {
        this.doNav(component, "IKOPRO_Contact_Us", "crcpro-contact-us");

    },

    // navToGlobalSite : function (component) {
    //     this.doNav(component, "https://www.iko.com", "https://www.iko.com");
    //
    // },
    //
    // navToNorthAmericanSite : function (component) {
    //     this.doNav(component, "https://www.iko.com/na/", "https://www.iko.com/na/");
    //
    // },





})