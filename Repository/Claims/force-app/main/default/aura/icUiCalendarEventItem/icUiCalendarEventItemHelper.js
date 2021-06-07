/**
 * Created by Francois Poirier on 2019-06-03.
 */

({

    navToInternal : function (component) {

        var event = component.get("v.event");
        var linkDesktopValue = event.InternalCommunityLink;
        var linkMobileValue = event.InternalMobileLink;

        //var currentDevice =  $A.get("$Browser");
        var currentTheme = component.get("v.currentTheme");
        var currentURL = window.location.href;

        if(!currentURL.includes('bridge.app')) {

            window.open(linkDesktopValue,'_top');

        } else if(currentURL.includes('bridge.app') ) {

            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef : "one:flexipage",
                componentAttributes: {
                    flexiPageDeveloperName: linkMobileValue
                }
            });
            evt.fire();
        }
        // else {
        //     // alert('testing url click browser');
        //     window.open(linkDesktopValue,'_top');
        // }
    },

    navToExternal : function (component) {

        var event = component.get("v.event");
        var externalLink = event.ExternalLink;

        if(!externalLink.startsWith("http://") && !externalLink.startsWith("https://")) {
            externalLink = "http://" + externalLink;
        }

        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": externalLink
        });
        eUrl.fire();
    }

});