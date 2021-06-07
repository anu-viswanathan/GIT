({
    doInit : function(component, event, helper) {
        helper.initHandler(component);
        helper.getRecordTypes(component);

        //console.log("doInit() finished");
    },

    onOriginChange : function(component, event, helper) {
        helper.toggleOriginElements(component);
        component.set('v.contactOfInterest', '');
        component.set( 'v.record.Contact_of_Interest__c', null);
    },

    onManualAddressChange : function(component, event, helper) {
        component.set('v.addressVerified', false);
    },
    handleStreetChange : function(component, event, helper) {
        component.set('v.autoCompleteDisplay', true);
        var icShowRelatedAccounts = component.find('icShowRelatedAccounts');
        icShowRelatedAccounts.fetchRelatedAccounts();
    },

    handleStreetBlur : function(component, event, helper){
        var icShowRelatedAccounts = component.find('icShowRelatedAccounts');
        icShowRelatedAccounts.fetchRelatedAccounts();
    },

    onSectorChange : function (component, event, helper){

        var sector = event.getSource().get("v.value");
        console.log('==>' , component.get('v.record'));
        if(sector == 'Decra'){
            //helper.checkAccountAndContact(component);
        }
    },

    handleLookupEvent : function(component, event, helper) {
        // retrieve the value form the Contact search to assign to v.contactName for creating a net new Account
        if(event.getParam('type') == 'Contact') {
            var contactOfInterest         = event.getParam('searchString');
            contactOfInterest             = contactOfInterest.replace('\\', '');

            component.set('v.contactOfInterest', contactOfInterest);
            console.log('contactOfInterest===' + contactOfInterest);
        }
    },

    handleLookupSelect : function(component, event, helper) {
        if(event.getParam('type') == 'Contact')
            component.set('v.contactOfInterest', event.getParam('fieldName'));

        console.log('contactOfInterest===' + component.get('v.contactOfInterest'));
    },

    fillBoxes : function(component, event, helper){

        var selectedItem = event.currentTarget;

        component.set("v.street", selectedItem.dataset.deliveryaddress);
        component.set("v.city", selectedItem.dataset.locality);
        //component.set("v.state", selectedItem.dataset.administrativearea);
        component.set("v.postalCode",selectedItem.dataset.postalcode);
        helper.stateSymbolToStateNameMap(component, selectedItem.dataset.administrativearea);
        component.set("v.addressVerified", true);
        component.set("v.autoCompleteDisplay", false);

        var icShowRelatedAccounts = component.find('icShowRelatedAccounts');
        icShowRelatedAccounts.fetchRelatedAccounts();
    },

    clearAddress : function(component, event, helper) {

        component.set("v.street", "");
        component.set("v.city", "");
        component.set("v.state", "");
        component.set("v.postalCode", "");
        helper.clearContactOwnerInfo(component);
        component.set("v.resetCount", component.get("v.resetCount") + 1);
        component.set("v.addressVerified", false);

        helper.getRecordTypes(component);
        helper.toggleOriginElements(component);
        var icShowRelatedAccounts = component.find('icShowRelatedAccounts');
        icShowRelatedAccounts.clearAccounts();
    },

    saveAddress : function(component, event, helper) {
        component.set('v.Spinner', true);
        component.set("v.createDraftButtonDisplay", true);
        var action = component.get("c.createClaimDraft");
        var inputMap = {};
        var allValid = true;

        if(component.find('requiredField')){
            allValid = component.find('requiredField').reduce(function (validFields,
                inputCmp) {
                inputCmp.showHelpMessageIfInvalid();
                return validFields && inputCmp.get('v.validity').valid;
                }, true);
        }
            
        
        if(!allValid){
            helper.showToast('Please complete all the required fields.');
            component.set('v.Spinner', false);
            component.set("v.createDraftButtonDisplay", false);
            return;
        }
        if (component.get("v.streetObjField") != "") {
            inputMap[component.get("v.streetObjField")] = component.get("v.street");
        } else {
            console.log('streetObjField');
        }

        if (component.get("v.cityObjField") != "") {
            inputMap[component.get("v.cityObjField")] = component.get("v.city");
        }

        if (component.get("v.stateObjField") != "") {
            /* CLAIMS V2 - 1039 - Getting the state code dynamically from the attribute list 'v.childList' using the helper method */
            helper.stateNameToStateSymbolMap(component, component.get('v.state'));
            inputMap[component.get("v.stateObjField")] = component.get('v.state');
        }

        if (component.get("v.postalCodeObjField") != "") {
            inputMap[component.get("v.postalCodeObjField")] = component.get("v.postalCode");
        }

        if (component.get("v.countryObjField") != "") {
            /* CLAIMS V2 - 1033 - Getting the country code dynamically from the list attribut 'v.parentList' */
            let country = component.get("v.country");

            var selectedCountryRecord = component.get("v.parentList").find(record => record.label === country); 

            if(selectedCountryRecord != null && selectedCountryRecord != undefined)
                inputMap[component.get("v.countryObjField")] = selectedCountryRecord.value;
            else
                inputMap[component.get("v.countryObjField")] = '';
        }

        var icShowRelatedAccounts = component.find('icShowRelatedAccounts');
        		icShowRelatedAccounts.clearAccounts();
        action.setParams({
            street : component.get("v.street"),
            fieldMap: JSON.stringify(inputMap),
            c : component.get("v.record") ,
            contactSalutation : component.get("v.contactSalutation"),
            contactFirstName : component.get("v.contactFirstName"),
            contactLastName : component.get("v.contactLastName"),
            contactOfInterest : component.get("v.contactOfInterest"),
            addressVerified : component.get("v.addressVerified")
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //$A.get('e.force:refreshView').fire();
                component.set("v.createDraftButtonDisplay", false);
                component.set('v.Spinner', false);
                component.set("v.street", "");
                component.set("v.city", "");
                component.set("v.state", "");
                component.set("v.contactOfInterest", "");
                component.set("v.postalCode", "");
                helper.clearContactOwnerInfo(component);
                component.set("v.resetCount", component.get("v.resetCount") + 1);
                component.set("v.addressVerified", false);
                helper.getInitializedCase(component);

                var navEvt = $A.get("e.force:navigateToSObject");

                navEvt.setParams({
                  "recordId": response.getReturnValue().Id,
                  "isredirect" : true
                });
                navEvt.fire();

            } else if (state === "INCOMPLETE") {
                component.set("v.createDraftButtonDisplay", false);
                component.set('v.Spinner', false);
                console.log("Listware: Incomplete action");
            } else if (state === "ERROR") {
                var errors = response.getError();
                component.set("v.createDraftButtonDisplay", false);
                component.set('v.Spinner', false);
                if (errors) {
                    console.log(errors);
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        alert("Error message: " + errors[0].message)
                    }
                    component.set("v.contactName", "");
                    helper.clearContactOwnerInfo(component);
                    component.set("v.contactOfInterest", "");
                    component.set("v.resetCount", component.get("v.resetCount") + 1);
                    component.set("v.street", "");
                    component.set("v.city", "");
                    component.set("v.state", "");
                    component.set("v.postalCode", "");
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    scriptsLoaded: function(component, event, helper) {
        //console.log("Scripts loading");
        var jq$ = jQuery.noConflict();
        var countryISOMap = [
            {value: "US", label: "US - United States of America"}, {value: "AF", label: "AF - Afghanistan"}, {value: "AX", label: "AX - Aland Islands"}, {value: "AL", label: "AL - Albania"}, {value: "DZ", label: "DZ - Algeria"}, {value: "AD", label: "AD - Andorra"}, {value: "AO", label: "AO - Angola"},
            {value: "AI", label: "AI - Anguilla"}, {value: "AG", label: "AG - Antigua and Barbuda"}, {value: "AR", label: "AR - Argentina"}, {value: "AM", label: "AM - Armenia"}, {value: "AW", label: "AW - Aruba"}, {value: "AU", label: "AU - Australia"}, {value: "AT", label: "AT - Austria"}, {value: "AZ", label: "AZ - Azerbaijan"},
            {value: "BS", label: "BS - Bahamas"}, {value: "BH", label: "BH - Bahrain"}, {value: "BD", label: "BD - Bangladesh"}, {value: "BB", label: "BB - Barbados"}, {value: "BY", label: "BY - Belarus"}, {value: "BE", label: "BE - Belgium"}, {value: "BZ", label: "BZ - Belize"}, {value: "BJ", label: "BJ - Benin"},
            {value: "BM", label: "BM - Bermuda"}, {value: "BT", label: "BT - Bhutan"}, {value: "BO", label: "BO - Bolivia"}, {value: "BA", label: "BA - Bosnia and Herzegovina"}, {value: "BW", label: "BW - Botswana"}, {value: "BV", label: "BV - Bouvet Island"}, {value: "BR", label: "BR - Brazil"},
            {value: "IO", label: "IO - British Indian Ocean Territory"}, {value: "BN", label: "BN - Brunei Darussalam"}, {value: "BG", label: "BG - Bulgaria"}, {value: "BF", label: "BF - Burkina Faso"}, {value: "BI", label: "BI - Burundi"}, {value: "KH", label: "KH - Cambodia"},
            {value: "CM", label: "CM - Cameroon"}, {value: "CA", label: "CA - Canada"}, {value: "CV", label: "CV - Cape Verde"}, {value: "BQ", label: "BQ - Caribbean Netherlands "}, {value: "KY", label: "KY - Cayman Islands"}, {value: "CF", label: "CF - Central African Republic"},
            {value: "TD", label: "TD - Chad"}, {value: "CL", label: "CL - Chile"}, {value: "CN", label: "CN - China"}, {value: "CX", label: "CX - Christmas Island"}, {value: "CC", label: "CC - Cocos (Keeling) Islands"}, {value: "CO", label: "CO - Colombia"}, {value: "KM", label: "KM - Comoros"},
            {value: "CG", label: "CG - Congo"}, {value: "CD", label: "Congo, Democratic Republic of"}, {value: "CK", label: "CK - Cook Islands"}, {value: "CR", label: "CR - Costa Rica"}, {value: "CI", label: "Cote D'Ivoire"}, {value: "HR", label: "HR - Croatia"},
            {value: "CU", label: "CU - Cuba"}, {value: "CW", label: "CW - Curacao"}, {value: "CY", label: "CY - Cyprus"}, {value: "CZ", label: "CZ - Czech Republic"}, {value: "DK", label: "DK - Denmark"}, {value: "DJ", label: "DJ - Djibouti"}, {value: "DM", label: "DM - Dominica"}, {value: "DO", label: "DO - Dominican Republic"},
            {value: "EC", label: "EC - Ecuador"}, {value: "EG", label: "EG - Egypt"}, {value: "SV", label: "SV - El Salvador"}, {value: "GQ", label: "GQ - Equatorial Guinea"}, {value: "ER", label: "ER - Eritrea"}, {value: "EE", label: "EE - Estonia"}, {value: "ET", label: "ET - Ethiopia"}, {value: "FK", label: "FK - Falkland Islands"},
            {value: "FO", label: "FO - Faroe Islands"}, {value: "FJ", label: "FJ - Fiji"}, {value: "FI", label: "FI - Finland"}, {value: "FR", label: "FR - France"}, {value: "GF", label: "GF - French Guiana"}, {value: "PF", label: "PF - French Polynesia"}, {value: "TF", label: "TF - French Southern Territories"},
            {value: "GA", label: "GA - Gabon"}, {value: "GM", label: "GM - Gambia"}, {value: "GE", label: "GE - Georgia"}, {value: "DE", label: "DE - Germany"}, {value: "GH", label: "GH - Ghana"}, {value: "GI", label: "GI - Gibraltar"}, {value: "GR", label: "GR - Greece"}, {value: "GL", label: "GL - Greenland"}, {value: "GD", label: "GD - Grenada"},
            {value: "GP", label: "GP - Guadeloupe"}, {value: "GT", label: "GT - Guatemala"}, {value: "GG", label: "GG - Guernsey"}, {value: "GN", label: "GN - Guinea"}, {value: "GW", label: "Guinea-Bissau"}, {value: "GY", label: "GY - Guyana"}, {value: "HT", label: "HT - Haiti"},
            {value: "HM", label: "HM - Heard and McDonald Islands"}, {value: "HN", label: "HN - Honduras"}, {value: "HK", label: "HK - Hong Kong"}, {value: "HU", label: "HU - Hungary"}, {value: "IS", label: "IS - Iceland"}, {value: "IN", label: "IN - India"}, {value: "ID", label: "ID - Indonesia"},
            {value: "IR", label: "IR - Iran"}, {value: "IQ", label: "IQ - Iraq"}, {value: "IE", label: "IE - Ireland"}, {value: "IM", label: "IM - Isle of Man"}, {value: "IL", label: "IL - Israel"}, {value: "IT", label: "IT - Italy"}, {value: "JM", label: "JM - Jamaica"}, {value: "JP", label: "JP - Japan"}, {value: "JE", label: "JE - Jersey"},
            {value: "JO", label: "JO - Jordan"}, {value: "KZ", label: "KZ - Kazakhstan"}, {value: "KE", label: "KE - Kenya"}, {value: "KI", label: "KI - Kiribati"}, {value: "KW", label: "KW - Kuwait"}, {value: "KG", label: "KG - Kyrgyzstan"}, {value: "LA", label: "Lao People's Democratic Republic"},
            {value: "LV", label: "LV - Latvia"}, {value: "LB", label: "LB - Lebanon"}, {value: "LS", label: "LS - Lesotho"}, {value: "LR", label: "LR - Liberia"}, {value: "LY", label: "LY - Libya"}, {value: "LI", label: "LI - Liechtenstein"}, {value: "LT", label: "LT - Lithuania"}, {value: "LU", label: "LU - Luxembourg"},
            {value: "MO", label: "MO - Macau"}, {value: "MK", label: "MK - Macedonia"}, {value: "MG", label: "MG - Madagascar"}, {value: "MW", label: "MW - Malawi"}, {value: "MY", label: "MY - Malaysia"}, {value: "MV", label: "MV - Maldives"}, {value: "ML", label: "ML - Mali"}, {value: "MT", label: "MT - Malta"},
            {value: "MQ", label: "MQ - Martinique"}, {value: "MR", label: "MR - Mauritania"}, {value: "MU", label: "MU - Mauritius"}, {value: "YT", label: "YT - Mayotte"}, {value: "MX", label: "MX - Mexico"}, {value: "MD", label: "MD - Moldova"}, {value: "MC", label: "MC - Monaco"}, {value: "MN", label: "MN - Mongolia"},
            {value: "ME", label: "ME - Montenegro"}, {value: "MS", label: "MS - Montserrat"}, {value: "MA", label: "MA - Morocco"}, {value: "MZ", label: "MZ - Mozambique"}, {value: "MM", label: "MM - Myanmar"}, {value: "NA", label: "NA - Namibia"}, {value: "NR", label: "NR - Nauru"}, {value: "NP", label: "NP - Nepal"},
            {value: "NC", label: "NC - New Caledonia"}, {value: "NZ", label: "NZ - New Zealand"}, {value: "NI", label: "NI - Nicaragua"}, {value: "NE", label: "NE - Niger"}, {value: "NG", label: "NG - Nigeria"}, {value: "NU", label: "NU - Niue"}, {value: "NF", label: "NF - Norfolk Island"},
            {value: "KP", label: "KP - North Korea"}, {value: "NO", label: "NO - Norway"}, {value: "OM", label: "OM - Oman"}, {value: "PK", label: "PK - Pakistan"}, {value: "PS", label: "Palestinian Territory, Occupied"}, {value: "PA", label: "PA - Panama"},
            {value: "PG", label: "PG - Papua New Guinea"}, {value: "PY", label: "PY - Paraguay"}, {value: "PE", label: "PE - Peru"}, {value: "PH", label: "PH - Philippines"}, {value: "PN", label: "PN - Pitcairn"}, {value: "PL", label: "PL - Poland"}, {value: "PT", label: "PT - Portugal"},
            {value: "QA", label: "QA - Qatar"}, {value: "RE", label: "RE - Reunion"}, {value: "RO", label: "RO - Romania"}, {value: "RU", label: "RU - Russian Federation"}, {value: "RW", label: "RW - Rwanda"}, {value: "BL", label: "BL - Saint Barthelemy"}, {value: "SH", label: "SH - Saint Helena"},
            {value: "KN", label: "KN - Saint Kitts and Nevis"}, {value: "LC", label: "LC - Saint Lucia"}, {value: "VC", label: "VC - Saint Vincent and the Grenadines"}, {value: "MF", label: "Saint-Martin (France)"}, {value: "SX", label: "Saint-Martin (Pays-Bas)"},
            {value: "WS", label: "WS - Samoa"}, {value: "SM", label: "SM - San Marino"}, {value: "ST", label: "ST - Sao Tome and Principe"}, {value: "SA", label: "SA - Saudi Arabia"}, {value: "SN", label: "SN - Senegal"}, {value: "RS", label: "RS - Serbia"}, {value: "SC", label: "SC - Seychelles"},
            {value: "SL", label: "SL - Sierra Leone"}, {value: "SG", label: "SG - Singapore"}, {value: "SK", label: "SK - Slovakia (Slovak Republic)"}, {value: "SI", label: "SI - Slovenia"}, {value: "SB", label: "SB - Solomon Islands"}, {value: "SO", label: "SO - Somalia"},
            {value: "ZA", label: "ZA - South Africa"}, {value: "GS", label: "South Georgia & S Sandwich Islands"}, {value: "KR", label: "KR - South Korea"}, {value: "SS", label: "SS - South Sudan"}, {value: "ES", label: "ES - Spain"}, {value: "LK", label: "LK - Sri Lanka"},
            {value: "PM", label: "PM - St. Pierre and Miquelon"}, {value: "SD", label: "SD - Sudan"}, {value: "SR", label: "SR - Suriname"}, {value: "SJ", label: "SJ - Svalbard and Jan Mayen Islands"}, {value: "SZ", label: "SZ - Swaziland"}, {value: "SE", label: "SE - Sweden"},
            {value: "CH", label: "CH - Switzerland"}, {value: "SY", label: "SY - Syria"}, {value: "TW", label: "TW - Taiwan"}, {value: "TJ", label: "TJ - Tajikistan"}, {value: "TZ", label: "TZ - Tanzania"}, {value: "TH", label: "TH - Thailand"}, {value: "NL", label: "NL - The Netherlands"},
            {value: "TL", label: "Timor-Leste"}, {value: "TG", label: "TG - Togo"}, {value: "TK", label: "TK - Tokelau"}, {value: "TO", label: "TO - Tonga"}, {value: "TT", label: "TT - Trinidad and Tobago"}, {value: "TN", label: "TN - Tunisia"}, {value: "TR", label: "TR - Turkey"},
            {value: "TM", label: "TM - Turkmenistan"}, {value: "TC", label: "TC - Turks and Caicos Islands"}, {value: "TV", label: "TV - Tuvalu"}, {value: "UG", label: "UG - Uganda"}, {value: "UA", label: "UA - Ukraine"}, {value: "AE", label: "AE - United Arab Emirates"},
            {value: "GB", label: "GB - United Kingdom"}, {value: "UY", label: "UY - Uruguay"}, {value: "UZ", label: "UZ - Uzbekistan"}, {value: "VU", label: "VU - Vanuatu"}, {value: "VA", label: "VA - Vatican"}, {value: "VE", label: "VE - Venezuela"}, {value: "VN", label: "VN - Vietnam"},
            {value: "VG", label: "VG - Virgin Islands (British)"}, {value: "WF", label: "WF - Wallis and Futuna Islands"}, {value: "YE", label: "YE - Yemen"}, {value: "ZM", label: "ZM - Zambia"}, {value: "ZW", label: "ZW - Zimbabwe"}, {value: "PR", label: "PR - Puerto Rico"}
        ];
        var eeMinLookup = component.get("v.minLookup");
        var mixedCasing = component.get("v.mixedCase");

        // BEGIN NEW COMPONENT LOGIC

        // only fire off if our form value is greater then our limit.
        var strLength = 0;
        var strFromComp = component.get('v.street') + '&country=' + component.get('v.country');
        //var license = component.get('v.license');
        var license = 'CqrakORI8hB4J1Nge61nIq**';
        var results = [];

        if (component.get('v.street') != null && component.get('v.country') != null) {
            if (component.get('v.street').length >= eeMinLookup)
                {
                jq$.getJSON(
                    "https://expressentry.melissadata.net/jsonp/GlobalExpressFreeForm?id=" + license + "&format=json&maxrecords=10&ff=" + strFromComp,
                    function(data) {
                        results = data.d.Results;
                        //debug- show our log
                        //console.log('restString: ' + "https://expressentry.melissadata.net/jsonp/GlobalExpressFreeForm?id=" + license + "&format=json&maxrecords=10&ff=" + strFromComp);

                        //debugger;
                        var suites = [];
                        var resultsx = jq$.map(data.d.Results, function( item ) {
                        if (item.Address.SubBuilding != null && item.Address.SubBuilding != "") {
                            var suiteArray = item.Address.SubBuilding.split(",");
                            var secondaryPostalCode = item.Address.PostalCodeSecondary.split(",");
                            for (var i = 0; i < suiteArray.length; i++) {
                                var postalCode = item.Address.PostalCode;
                                if (item.Address.PostalCodePrimary != null && item.Address.PostalCodePrimary != "") {
                                    if (secondaryPostalCode[i] != null && secondaryPostalCode[i] != "") {
                                        postalCode = item.Address.PostalCodePrimary + "-" + secondaryPostalCode[i];
                                    }
                                }
                                var m_completeAddress = item.Address.DeliveryAddress + " " + suiteArray[i] + ", " + item.Address.Locality + ", " + item.Address.AdministrativeArea + ", " + postalCode;
                                if (!mixedCasing) {
                                    m_completeAddress = m_completeAddress.toUpperCase();
                                    //console.log('DEBUG: We mixed case!');

                                    item.Address.DeliveryAddress = (item.Address.DeliveryAddress != null) ? item.Address.DeliveryAddress.toUpperCase() : null;
                                    item.Address.PostalCode = (item.Address.PostalCode != null) ? item.Address.PostalCode.toUpperCase() : null;
                                    item.Address.Locality = (item.Address.Locality != null) ? item.Address.Locality.toUpperCase() : null;
                                    item.Address.AdministrativeArea = (item.Address.AdministrativeArea != null) ? item.Address.AdministrativeArea.toUpperCase() : null;
                                    item.Address.SubAdministrativeArea = (item.Address.SubAdministrativeArea != null) ? item.Address.SubAdministrativeArea.toUpperCase() : null;
                                    item.Address.DoubleDependentLocality = (item.Address.DoubleDependentLocality != null) ? item.Address.DoubleDependentLocality.toUpperCase() : null;
                                    item.Address.DependentLocality = (item.Address.DependentLocality != null) ? item.Address.DependentLocality.toUpperCase() : null;

                                    suites.push({label: m_completeAddress, value: item.Address.DeliveryAddress + " " + suiteArray[i].toUpperCase(),
                                    deliveryAddress: item.Address.DeliveryAddress + " " + suiteArray[i].toUpperCase(), postalCode: postalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                    subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality});
                                } else {
                                    suites.push({label: m_completeAddress, value: item.Address.DeliveryAddress + " " + suiteArray[i],
                                        deliveryAddress: item.Address.DeliveryAddress + " " + suiteArray[i], postalCode: postalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                                        subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality});
                                }
                            }
                        }

                        var m_completeAddress = item.Address.DeliveryAddress + ", " + item.Address.Locality + ", " + item.Address.AdministrativeArea + ", " + item.Address.PostalCode;
                        if (!mixedCasing) {
                            //console.log('DEBUG: We not mixed case!');
                            m_completeAddress = m_completeAddress.toUpperCase();

                            item.Address.DeliveryAddress = (item.Address.DeliveryAddress != null) ? item.Address.DeliveryAddress.toUpperCase() : null;
                            item.Address.PostalCode = (item.Address.PostalCode != null) ? item.Address.PostalCode.toUpperCase() : null;
                            item.Address.Locality = (item.Address.Locality != null) ? item.Address.Locality.toUpperCase() : null;
                            item.Address.AdministrativeArea = (item.Address.AdministrativeArea != null) ? item.Address.AdministrativeArea.toUpperCase() : null;
                            item.Address.SubAdministrativeArea = (item.Address.SubAdministrativeArea != null) ? item.Address.SubAdministrativeArea.toUpperCase() : null;
                            item.Address.DoubleDependentLocality = (item.Address.DoubleDependentLocality != null) ? item.Address.DoubleDependentLocality.toUpperCase() : null;
                            item.Address.DependentLocality = (item.Address.DependentLocality != null) ? item.Address.DependentLocality.toUpperCase() : null;

                            return{label: m_completeAddress, value: item.Address.DeliveryAddress,
                            deliveryAddress: item.Address.DeliveryAddress, postalCode: item.Address.PostalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                            subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality};
                        }

                        return{label: m_completeAddress, value: item.Address.DeliveryAddress,
                            deliveryAddress: item.Address.DeliveryAddress, postalCode: item.Address.PostalCode, locality: item.Address.Locality, administrativeArea: item.Address.AdministrativeArea,
                            subadministrativeArea: item.Address.SubAdministrativeArea, ddlocality: item.Address.DoubleDependentLocality, dlocality: item.Address.DependentLocality};
                    });

                        for (var i = 0; i < suites.length; i++) {
                                resultsx.push(suites[i]);
                        }

                         //debugger
                        // only get the top 15 results relating to the record
                        var resultsMaxxedOut = [];

                        if (component.get('v.maxReturns') != null){
                            resultsMaxxedOut = resultsx.slice(0,component.get('v.maxReturns'));
                        } else {
                            resultsMaxxedOut = resultsx.slice(0,25);
                        }

                        component.set('v.bcPredictions',resultsMaxxedOut);
						
                        /*
                        component.set("v.street", ui.item.deliveryAddress);
                        component.set("v.city", ui.item.locality);
                        helper.stateSymbolToStateNameMap(component, ui.item.administrativeArea);
                        component.set("v.postalCode", ui.item.postalCode);
                        component.set("v.addressVerified", true);
                        */
                    }
                );

             } else {
                component.set('v.bcPredictions',[]);
            }
        }
        // END NEW COMPONENT LOGIC
    },

    parentFieldChange : function(component, event, helper) {
        component.set('v.addressVerified', false);
        helper.onchangeHandler(component);
    },

})