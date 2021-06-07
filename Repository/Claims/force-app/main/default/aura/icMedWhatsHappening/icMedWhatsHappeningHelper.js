({
    doInit : function(component, event) {
        var helper = this;

        var action = component.get("c.getWhatsHappening");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                var content = responseValue.content;
                component.set("v.listWhatsHappening", content);
                component.set("v.currentTheme", responseValue.theme);

                var displayWhatsHappening = [];

                var listCap = 3;

                var currentURL = window.location.href;
                if(currentURL.includes('bridge.app')) {
                    listCap = 3;
                }

                if(content == null || content == undefined) {
                    listCap = 1;
                } else {
                    if(listCap > content.length) {
                        listCap = content.length
                    }
                }

                for(var i = 0; i < listCap; i++) {
                    displayWhatsHappening.push(content[i]);
                }

                component.set("v.displayCardCount", listCap);
                component.set("v.displayWhatsHappening", displayWhatsHappening);

                helper.setPosAbs(component, displayWhatsHappening);
            }
        });

        $A.enqueueAction(action);

        this.doAutoRotate(component, event);
    },

    setPosAbs : function(component, listCards) {
        var absCard = 0;
        var greaterDescLength = 0;
        var greaterTitleLength = 0;
         for(var i = 0; i < listCards.length; i++) {
            if(listCards[i].description.length > greaterDescLength) {
                greaterDescLength = listCards[i].description.length;
                greaterTitleLength = listCards[i].title.length;
                absCard = i;
            } else {
                if(listCards[i].description.length == greaterDescLength && listCards[i].title.length > greaterTitleLength) {
                    greaterDescLength = listCards[i].description.length;
                    greaterTitleLength = listCards[i].title.length;
                    absCard = i;
                }
            }
         }

        component.set("v.absCard", absCard);
    },

    doAutoRotate : function(component, event) {
        var helper = this;

        var carouselInterval = window.setInterval(
           $A.getCallback( function() {
                var carouselPage = component.get("v.carouselPage");
                carouselPage++;
                component.set("v.carouselPage", carouselPage);
                helper.adjustDisplayedCards(component, event, carouselPage);
            })
            ,5000
        );

        component.set("v.carouselInterval", carouselInterval);
    },

    doNext : function(component, event) {
        var carouselInterval = component.get("v.carouselInterval");
        window.clearInterval(carouselInterval);

        var carouselPage = component.get("v.carouselPage");
        carouselPage++;
        component.set("v.carouselPage", carouselPage);
        this.adjustDisplayedCards(component, event, carouselPage);
    },

    doPrev : function(component, event) {
        var carouselInterval = component.get("v.carouselInterval");
        window.clearInterval(carouselInterval);

        var carouselPage = component.get("v.carouselPage");
        carouselPage--;
        component.set("v.carouselPage", carouselPage);
        this.adjustDisplayedCards(component, event, carouselPage);
    },

    adjustDisplayedCards : function(component, event, carouselPage) {
        var listWhatsHappening = component.get("v.listWhatsHappening");
        var displayWhatsHappening = [];

        if(listWhatsHappening != null && listWhatsHappening != undefined) {
            var listCap = component.get("v.displayCardCount");
            var addedCards = 0;
            for(var i = carouselPage; i < carouselPage + listCap; i++) {
                var listIndex = i;
                if(listIndex > (listWhatsHappening.length - 1)) {
                    listIndex = i - listWhatsHappening.length;
                }
                if(listIndex < 0) {
                    listIndex = listWhatsHappening.length + i;
                }
                displayWhatsHappening.push(listWhatsHappening[listIndex]);
            }
            component.set("v.displayWhatsHappening", displayWhatsHappening);

            if(carouselPage >= listWhatsHappening.length) {
                component.set("v.carouselPage", 0);
            }

            if(carouselPage < 0) {
                component.set("v.carouselPage", (listWhatsHappening.length - 1));
            }

            this.setPosAbs(component, displayWhatsHappening);
        }
    }
})