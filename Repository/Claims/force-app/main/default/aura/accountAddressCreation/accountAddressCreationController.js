({
    doInit : function(component, event, helper) {        
        var action = component.get("c.getExpressToken");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.license",response.getReturnValue());
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
    clearAddress : function(component, event, helper) {
        component.set("v.street", "");
        component.set("v.city", "");
        component.set("v.state", "");
        component.set("v.postalCode", "");
    },
    saveAddress : function(component, event, helper) {
        var action = component.get("c.updateRecord");
        var inputMap = {};
        
        if (component.get("v.streetObjField") != "") inputMap[component.get("v.streetObjField")] = component.get("v.street");
        if (component.get("v.cityObjField") != "") inputMap[component.get("v.cityObjField")] = component.get("v.city");
        if (component.get("v.stateObjField") != "") inputMap[component.get("v.stateObjField")] = component.get("v.state");
        if (component.get("v.postalCodeObjField") != "") inputMap[component.get("v.postalCodeObjField")] = component.get("v.postalCode");
        if (component.get("v.countryObjField") != "") inputMap[component.get("v.countryObjField")] = component.get("v.country");
        
        action.setParams({ recordId : component.get("v.recordId"), fieldMap: JSON.stringify(inputMap) });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                component.set("v.street", "");
                component.set("v.city", "");
                component.set("v.state", "");
                component.set("v.postalCode", "");
            } else if (state === "INCOMPLETE") {
                console.log("Listware: Incomplete action");
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    console.log(errors);
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                        alert("Error message: " + errors[0].message)
                    }
                    if (errors[0] && errors[0].pageErrors[0]) {
                        alert("Error message: " + errors[0].pageErrors[0].statusCode);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    scriptsLoaded: function(component, event, helper) {
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
        
        var tempRef = jq$(component.find("countryField").getElement()).find(".slds-input").autocomplete({
            source: countryISOMap,
            delay: 0,
            select: function( event, ui ) { event.stopPropagation(); }
        });
        
        if (tempRef.data('ui-autocomplete') != null) tempRef.data('ui-autocomplete')._renderItem = function( ul, item ) {
            var srchTerm = jq$.trim(this.term).split(/\s+/).join ('|');
            var strNewLabel = item.label;
            regexp = new RegExp ('(' + srchTerm + ')', "ig");
            var strNewLabel = strNewLabel.replace(regexp,"<span style='font-weight:bold;'>$1</span>");
            return jq$( "<li></li>" )
            .data( "ui-autocomplete-item", item )
            .append( "<a>" + strNewLabel + "</a>" )
            .appendTo( ul )
            ;
        };
        
        tempRef = jq$(component.find("streetField").getElement()).find(".slds-input").autocomplete({
            showHeader: true, 
            minLength: eeMinLookup,
            delay: 1,                                                                                                                 
            source: function(request, response) {
                var license = component.get("v.license");
                var searchTerm = jq$(component.find("streetField").getElement()).find(".slds-input").val();
                var urlParams = {
                    format: 'json',
                    id: license,
                    FF: searchTerm,
                    country: jq$(component.find("countryField").getElement()).find(".slds-input").val(),
                    maxrecords: 10
                };
                helper.getJSON(component, jq$.param(urlParams), function (data) {     
                    var suites = [];
                    var results = jq$.map(data.Results, function( item ) {
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
                        results.push(suites[i]);
                    }
    
                    results = results.sort(function(a,b) {
                        return helper.getEditDistance(a.deliveryAddress.toUpperCase(),request.term.toUpperCase()) - helper.getEditDistance(b.deliveryAddress.toUpperCase(),request.term.toUpperCase());
                    });
                    
                    response(results);
                });
            },
            select: function(evt, ui) {
                component.set("v.street", ui.item.deliveryAddress);
                component.set("v.city", ui.item.locality);
                component.set("v.state", ui.item.administrativeArea);
                component.set("v.postalCode", ui.item.postalCode);
            }
        });

        if (tempRef.data('ui-autocomplete') != null) tempRef.data('ui-autocomplete')._renderItem = function( ul, item ) {
                var srchTerm = jq$.trim(this.term).split(/\s+/).join ('|');
                var strNewLabel = item.label;
                regexp = new RegExp ('(' + srchTerm + ')', "ig");
            	var strNewLabel = strNewLabel.replace(regexp,"<span style='font-weight:bold;'>$1</span>");
                return jq$( "<li></li>" )
                .data( "ui-autocomplete-item", item )
                .append( "<a style='font-size:15px;'>" + strNewLabel + "</a>" )
                .appendTo( ul );
            }
        ;
        
        jq$(component.find("streetField").getElement()).find(".slds-input").autocomplete('search', '');
    }
})