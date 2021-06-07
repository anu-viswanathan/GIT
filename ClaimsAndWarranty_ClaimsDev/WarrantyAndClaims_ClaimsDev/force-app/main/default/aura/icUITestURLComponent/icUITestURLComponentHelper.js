({
	doInit : function (component, event) {

        var currentURL = window.location.href;
        component.set("v.currentURL", currentURL);

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
		var currentTheme = component.get("v.currentTheme");

		if(currentTheme === "Theme4t") {
                var evt = $A.get("e.force:navigateToComponent");
                evt.setParams({
                    componentDef : "one:flexipage",
                    componentAttributes: {
                        flexiPageDeveloperName: urlMobile
                    }
                });
                evt.fire();

		} else {
			var test = $A.get("e.force:navigateToURL");
			test.setParams({
                "url": urlDesktop
			}).fire();
		}

	},




    navToHome : function (component) {
        console.log('hello3');
        this.doNav(component, "https://lp-iko.cs20.force.com/IKOROOFPROm", "https://lp-iko.cs20.force.com/IKOROOFPRO/s/" );

    },

    navToHomeRelativeURL : function (component) {
        console.log('hello4');
        // this.doNav(component, "/IKOROOFPROm/", "/Home");
        this.doNav(component, "ROOFPRO_Home_Page", "/");


    },

    navToHomeDev2 : function (component) {
        console.log('hello4');
        this.doNav(component, "IKOPRO_Home_TEST", "contractor-home-dev");


    },




    navToProzone : function (component) {
        console.log('hello4');
        this.doNav(component, "IKOPRO_Prozone", "prozone" );

    },

    navToComingSoon : function (component) {
        console.log('hello4');
        this.doNav(component, "UnderConstruction", "coming-soon" );

    },

    navToMyToolbox : function (component) {
        console.log('hello4');
        this.doNav(component, "IKOPRO_My_Toolbox", "My_Toolbox" );

    },
    navToTestAppPage : function (component) {
        console.log('hello4');
        this.doNav(component, "icTestAppPage", "icTestAppPage" );

    },



})