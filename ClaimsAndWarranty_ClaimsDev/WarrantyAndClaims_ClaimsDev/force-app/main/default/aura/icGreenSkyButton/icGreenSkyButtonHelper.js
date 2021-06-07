/**
 * Created by Francois Poirier on 2018-09-14.
 */
({
    newApplication : function (component, event) {

        var externalLink = $A.get("$Label.c.icGreenSky_Merchant_application_URL");
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": externalLink
        });
        eUrl.fire();
    }


})