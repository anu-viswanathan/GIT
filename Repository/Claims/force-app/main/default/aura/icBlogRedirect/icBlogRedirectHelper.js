/**
 * Created by Anil Mannem on 16-Aug-2020
 */
({

    doInit : function (component, event) {
        var fullLangCode = component.get("v.fullLanguageCode");
		var langCode = fullLangCode.substring(0, 2);
        var recordId = component.get("v.recordId");
        var action = component.get("c.getSummitBlogAuthDetails");
        
        //go fetch Url Information 
        const queryString = window.location.search;
        const urlParams = new URLSearchParams(queryString);
        let blogArticle = null;
        if (urlParams.has("article"))
        {
            blogArticle = urlParams.get("article");

        }
        
        action.setParams({ recordId : recordId });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                var blogURL = $A.get("$Label.c.icTheSummitBlogURL");
                if (blogURL.indexOf('{0}') != -1) {
                    blogURL = blogURL.replace('{0}', langCode);
                }
                if (blogURL.indexOf('{1}') != -1) {
                    blogURL = blogURL.replace('{1}', responseValue.accountId);
                }
                if (blogURL.indexOf('{2}') != -1) {
                    blogURL = blogURL.replace('{2}', responseValue.sessionId);
                }
                console.log(blogArticle !== null);
                if (blogURL.indexOf('{3}') != -1 && blogArticle !== null ) {
                    blogURL = blogURL.replace('{3}', blogArticle);
                }
                else if (blogURL.indexOf('{3}') != -1) {
                    blogURL = blogURL.replace('{3}', "");
                }
                console.log( blogURL);
                window.open(blogURL, '_top');
            }
        });
        $A.enqueueAction(action);
    }
})