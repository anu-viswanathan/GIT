({
    // borrowed from here: http://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#JavaScript
    /*
      Copyright (c) 2011 Andrei Mackenzie
    
      Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
    
      The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
    
      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    */
    getEditDistance : function(a, b) {
        if (a.length === 0) return b.length;
        if (b.length === 0) return a.length;
        
        var matrix = [];
        
        var i;
        for (i = 0; i <= b.length; i++) {
            matrix[i] = [i];
        }
        
        var j;
        for (j = 0; j <= a.length; j++) {
            matrix[0][j] = j;
        }
        
        for (i = 1; i <= b.length; i++) {
            for (j = 1; j <= a.length; j++) {
                if (b.charAt(i-1) == a.charAt(j-1)) {
                    matrix[i][j] = matrix[i-1][j-1];
                } else {
                    matrix[i][j] = Math.min(matrix[i-1][j-1] + 1,
                                            Math.min(matrix[i][j-1] + 1,
                                                     matrix[i-1][j] + 1));
                }
            }
        }
        
        return matrix[b.length][a.length];
    },

    showToast : function(message, title, variant) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "variant" : variant
        });
        toastEvent.fire();
    },

    getJSON : function(component, req, callback) {
        var action = component.get("c.getResponseWrapper");
        action.setParams({ request : 'GlobalExpressFreeForm?' + req });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                callback(JSON.parse(response.getReturnValue()));
            } else if (state === "INCOMPLETE") {
                console.log("Listware: Incomplete action");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    clearContactOwnerInfo : function(component){
        component.set("v.contactSalutation", "");
        component.set("v.contactFirstName", "");
        component.set("v.contactLastName", "");
    },

    getSectors : function(component) {
        var action = component.get("c.getPicklistOptions");
        action.setParams({
            "objectName" : "Case",
            "fieldName": "Sector__c"
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set('v.sectorOptions', a.getReturnValue());
                this.getBrands(component);
            } else if (state === "ERROR") {
                var errors = a.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    getBrands : function(component) {
        var action = component.get("c.getPicklistOptions");
        action.setParams({
            "objectName" : "Case",
            "fieldName": "Brand__c"
        });

        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set('v.brandOptions', a.getReturnValue());
                this.getInitializedCase(component);
                //this.getStates(component);
            } else if (state === "ERROR") {
                var errors = a.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    getRecordTypes : function(component) {
        var action = component.get("c.getRecordTypePicklistValues");
        action.setCallback(this, function(a) {
            var state = a.getState();
            if (state === "SUCCESS") {
                component.set('v.recordTypeOptions', a.getReturnValue());
                this.getSectors(component);
            } else if (state === "ERROR") {
                var errors = a.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    getInitializedCase : function(component) {
        var action = component.get('c.initClaimCaseDraft');

        action.setCallback(this, function(a) {
            var state = a.getState();
            
            if (state === "SUCCESS") {
                component.set('v.record', a.getReturnValue());
                component.set('v.record.Brand__c', component.get('v.brandOptions')[0].value);

                if(component.get('v.record.Sector__c') == 'US') {
                    component.set('v.country', 'United States');
                    component.set('v.record.Brand__c', component.get('v.brandOptions')[1].value);
                    this.onchangeHandler(component);
                }

                if (component.get('v.record.Sector__c') == 'Blair') {
                    component.set('v.country', 'United States');
                    this.onchangeHandler(component);
                    component.set('v.record.Brand__c', component.get('v.brandOptions')[3].value);
                } else if (component.get('v.record.Sector__c') == 'Hyload') {
                    component.set('v.country', 'United States');
                    this.onchangeHandler(component);
                    component.set('v.record.Brand__c', component.get('v.brandOptions')[4].value);
                }

                this.toggleOriginElements(component);
            } else if (state === "ERROR") {
                var errors = a.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },
    
    clearNonDistributorFields: function(component){
        component.set("v.street", "");
        component.set("v.city", "");
        component.set("v.state", "");
        component.set("v.postalCode", "");
    },

    toggleOriginElements : function(component) {
        var distributorDiv = component.find('distributor-lookup');
        var addressDiv = component.find('address-fields');

        if(component.get('v.record.Origin') == 'Distributor') {
            $A.util.addClass(addressDiv, 'slds-hide');
            $A.util.removeClass(distributorDiv, 'slds-hide');
            component.set('v.showNonDistributorFields', false);
            this.clearNonDistributorFields(component);

        } else {
            $A.util.removeClass(addressDiv, 'slds-hide');
            $A.util.addClass(distributorDiv, 'slds-hide');
            component.set('v.showNonDistributorFields', true);
        }
    },

    initHandler : function(component) {
            var action = component.get("c.getDependentPicklist");
            action.setParams({
                objectName : "Account",
                parentField : component.get("v.parentFieldAPI"),
                childField : component.get("v.childFieldAPI")
            });

            action.setCallback(this, function(response){
                var status = response.getState();

                if(status === "SUCCESS"){
                    var returnValues = response.getReturnValue();
                    var pickListResponse = returnValues['picklistWrapper'];
                    var contactSalutations = returnValues['salutations'];
                    var pickListMap = JSON.parse(pickListResponse.picklistMap);
                    //save response
                    component.set("v.pickListMap",  pickListMap);
                    var parentkeys = []; // for store all map keys
                    var parentField = []; // for store parent picklist value to set on lightning:select.

                    // Iterate over map and store the key
                    for (var pickKey in pickListMap) {
                        parentkeys.push(pickKey);
                        /* CLAIMS V2 - 1033 - Adding the country code to the list to dynamically map the code to the country selected in the UI */
                        parentField.push({label : pickKey , value : pickListMap[pickKey].countryCode});
                    }

                    var salutationsToShow = [];
                      // Iterate over map and store the key
                    for (var index in contactSalutations) {
                        var salutation = contactSalutations[index];
                        salutationsToShow.push({label: salutation.Label, value : salutation.DeveloperName})
                    }
                    // set the parent picklist
                     /* CLAIMS V2 - 1033 - Sorting the countries in alphabetical order */
                    component.set("v.parentList", parentField.sort((a,b) => (a.label > b.label) ? 1 : ((b.label > a.label) ? -1 : 0)));
                    component.set('v.contactSalutations', salutationsToShow);
                    this.onchangeHandler(component);
                }
            });

            $A.enqueueAction(action);

        },

        onchangeHandler : function(component) {
            if (!$A.util.isEmpty(component.find("countryField"))) {
                let controllerValue = component.find("countryField").get("v.value"); // We can also use event.getSource().get("v.value")
                let pickListMap = component.get("v.pickListMap");
                //get child picklist value
                var childValues = pickListMap[controllerValue];
                var childValueList = [];
                for (var i = 0; i < childValues.states.length; i++) {
                    childValueList.push(childValues.states[i]);
                }
                // set the child list
                component.set("v.childList", childValueList);
            }
        },

        stateSymbolToStateNameMap : function(component, stateSymbol) {
            /* CLAIMS V2 - 1033 - Mapping the country code to the country name */
            let childList = component.get("v.childList");
            let selectedStateRecord;
            let selectedValue = '';
            if(childList != null && childList != undefined){
                selectedStateRecord = childList.find(record => record.value.toLowerCase() === stateSymbol.toLowerCase()); 
                if(selectedStateRecord != null && selectedStateRecord != undefined)
                    selectedValue = selectedStateRecord.label;
            }
            component.set("v.state", selectedValue);
        },

        stateNameToStateSymbolMap : function(component, stateName) {
            /* CLAIMS V2 - 1033 - Mapping the country name to the country code */
            let childList = component.get("v.childList");
            let selectedStateRecord;
            let selectedValue = '';
            if(childList != null && childList != undefined){
                selectedStateRecord =childList.find(record => record.label.toLowerCase() === stateName.toLowerCase()); 
                if(selectedStateRecord != null && selectedStateRecord != undefined)
                    selectedValue = selectedStateRecord.value;
            }
            component.set("v.state", selectedValue);
        },

})