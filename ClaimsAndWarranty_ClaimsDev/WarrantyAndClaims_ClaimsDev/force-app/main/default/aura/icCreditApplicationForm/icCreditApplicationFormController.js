({
    doInit : function (component, event, helper) {
        helper.doInit(component, event);
    },
    optinChange : function(component, event, helper) {

        var loanForm  = component.get('v.loanForm');
        console.log('applicant opt in ===> ' + loanForm.applicantMobileOptIn);
    },
    showCoApplicant : function(component, event, helper) {

        var s =component.find('coApplicantFlag').get("v.value");

        if(s == 'Yes'){
            component.set("v.showCoApplicant", true);
            component.set("v.loanForm.coApplicantIndicator", true);
        }else if (s == 'No'){
            component.set("v.showCoApplicant", false);
            component.set("v.loanForm.coApplicantIndicator", false);
        }

	},
    languageToggle : function(component, event, helper){
    var s =component.find('languageChosen').get("v.value");

        component.set("v.loanForm.contractLanguage", s);

    },
    toggleYouAre : function(component, event, helper){
    var s =component.find('youareid').get("v.value");

    component.set("v.loanForm.youAre", s);

    },
    checkState : function(component, event, helper){
        var s =component.find('statechosen').get("v.value");

        if( s == 'WI' ){
            component.set("v.WIstatechosen", true);
        }else {
            component.set("v.WIstatechosen", false);
        }

        component.set("v.loanForm.applicantState", s);


    },
    checkStateCoApplicant: function(component, event, helper){

        var s =component.find('statechosenCO').get("v.value");

        if( s == 'WI' ){
            component.set("v.WIstatechosenCoApplicant", true);
        }else{
            component.set("v.WIstatechosenCoApplicant", false);
        }

        component.set("v.loanForm.coApplicantState", s);

    },
    checkBirthdayApplicant : function(component, event, helper){


        var b =component.find('birthdate').get("v.value");
        var s = component.find('statechosen').get("v.value");

        component.set("v.loanForm.applicantDateOfBirth", b);


        var dateN =  new Date(Date.now());
        var dateApplicant = new Date(b);

        // as per 2018 Q4 update, remove the 19 years old age requirement for Nebraska
        if (s == 'AL' ) { //|| s == 'NE'){

          if (dateN.getFullYear() - dateApplicant.getFullYear() < 19) {

              component.set("v.dateValidationErrorALNE" , true);
          }else{
              component.set("v.dateValidationErrorALNE" , false);
          }

        }else{

            if (dateN.getFullYear() - dateApplicant.getFullYear() < 18) {

                component.set("v.dateValidationError" , true);
            }else{
                component.set("v.dateValidationError" , false);
            }

        }

    },
    checkBirthdayCoApplicant : function(component, event, helper){


        var b =component.find('birthdateCO').get("v.value");
        var s = component.find('statechosenCO').get("v.value");

        component.set("v.loanForm.coApplicantDateOfBirth", b);


        var dateN =  new Date(Date.now());
        var dateApplicant = new Date(b);

        // as per 2018 Q4 update, remove the 19 years old age requirement for Nebraska
        if (s == 'AL' ) { //|| s == 'NE'){

            if (dateN.getFullYear() - dateApplicant.getFullYear() < 19) {

                component.set("v.dateCoValidationErrorALNE" , true);
            }else{
                component.set("v.dateCoValidationErrorALNE" , false);
            }

        }else{

            if (dateN.getFullYear() - dateApplicant.getFullYear() < 18) {

                component.set("v.dateCoValidationError" , true);
            }else{
                component.set("v.dateCoValidationError" , false);
            }

        }

    },
    toggleTypeID : function(component, event, helper){
    var s =component.find('typeofidchosen').get("v.value");

    component.set("v.loanForm.applicantTypeOfID", s);

    },
    toggleStateID : function(component, event, helper){
    var s =component.find('stateonidchosen').get("v.value");

    component.set("v.loanForm.applicantStateOnID", s);

    },
    toggleCOstateID : function(component, event, helper){
    var s =component.find('typeofidchosenCO').get("v.value");

    component.set("v.loanForm.coApplicantTypeOfID", s);

    },
    toggleCOstate : function(component, event, helper){
    var s =component.find('stateonidchosenCO').get("v.value");

    component.set("v.loanForm.coApplicantStateOnID", s);

    },
    toggleMarriedCO : function(component, event, helper){
    var s =component.find('marriedflagCO').get("v.value");

        if(s == 'Yes'){
            component.set("v.loanForm.coApplicantMarried", true);
        }else if (s == 'No'){
            component.set("v.loanForm.coApplicantMarried", false);
        }

    },
    toggleMarried : function(component, event, helper){
    var s =component.find('marriedflag').get("v.value");

        if(s == 'Yes'){
            component.set("v.loanForm.applicantMarried", true);
        }else if (s == 'No'){
            component.set("v.loanForm.applicantMarried", false);
        }


    },
    toggleMarriedToCoApp : function(component, event, helper){
        var s =component.find('marriedToCoAppflag').get("v.value");

        if(s == 'Yes'){
            component.set("v.applicantIsMarriedToCoApplicant", true);
            component.set("v.loanForm.applicantCoApplicantMarried", true);
        }else if (s == 'No'){
            component.set("v.applicantIsMarriedToCoApplicant", false);
            component.set("v.loanForm.applicantCoApplicantMarried", false);
        }


    },
    handleValidation : function(component, event, helper) {

        var fieldsVal = [];

        var coApplicantIndic = component.find('coApplicantFlag');
        fieldsVal.push(coApplicantIndic);

        var language = component.find('languageChosen');
        fieldsVal.push(language);

        /*var program = component.find('program');
        fieldsVal.push(program);

        var channel = component.find('channel');
        fieldsVal.push(channel);

        var promotionCode = component.find('promotionCode');
        fieldsVal.push(promotionCode);

        var referral = component.find('referral');
        fieldsVal.push(referral);
*/
        var firstname = component.find('firstname');
        fieldsVal.push(firstname);

        var lastname = component.find('lastname');
        fieldsVal.push(lastname);

        var streetaddress = component.find('streetaddress');
        fieldsVal.push(streetaddress);

        var city = component.find('city');
        fieldsVal.push(city);

        var statechosen = component.find('statechosen');
        fieldsVal.push(statechosen);

        var zipcode = component.find('zipcode');
        fieldsVal.push(zipcode);

        var cellPhone = component.find('cellphone');
        fieldsVal.push(cellPhone);

        var email = component.find('email');
        fieldsVal.push(email);

        var ssn = component.find('ssn');
        fieldsVal.push(ssn);

        var birthdate = component.find('birthdate');
        fieldsVal.push(birthdate);

        var grossincome = component.find('grossincome');
        fieldsVal.push(grossincome);

        var s = component.find('statechosen').get("v.value");
        if(s == 'WI'){
            var marriedflag = component.find('marriedflag');
            fieldsVal.push(marriedflag);
        }

        var coapp =component.find('coApplicantFlag').get("v.value");
        if(coapp == 'Yes'){

            var firstnameCO = component.find('firstnameCO');
            fieldsVal.push(firstnameCO);

            var lastnameCO = component.find('lastnameCO');
            fieldsVal.push(lastnameCO);

            var streetaddressCO = component.find('streetaddressCO');
            fieldsVal.push(streetaddressCO);

            var cityCO = component.find('cityCO');
            fieldsVal.push(cityCO);

            var statechosenCO = component.find('statechosenCO');
            fieldsVal.push(statechosenCO);

            var zipcodeCO = component.find('zipcodeCO');
            fieldsVal.push(zipcodeCO);

            var cellphoneCO = component.find('cellphoneCO');
            fieldsVal.push(cellphoneCO);

            var emailCO = component.find('emailCO');
            fieldsVal.push(emailCO);

            var ssnCO = component.find('ssnCO');
            fieldsVal.push(ssnCO);

            var birthdateCO = component.find('birthdateCO');
            fieldsVal.push(birthdateCO);

            var grossincomeCO = component.find('grossincomeCO');
            fieldsVal.push(grossincomeCO);

            var sco = component.find('statechosen').get("v.value");
            if(sco == 'WI'){
                var marriedflagCO = component.find('marriedflagCO');
                fieldsVal.push(marriedflagCO);
            }

        }

        var flag;

        var firstError = true;

        for (var cmp in fieldsVal){

            if(fieldsVal[cmp].get('v.validity').valid){
                flag=true;
            }else{
                flag=false;
                fieldsVal[cmp].showHelpMessageIfInvalid();
                if(firstError){
                    fieldsVal[cmp].focus();
                    firstError  = false;
                }
            }
        }

        if(flag==true){
            component.set('v.requiredFieldsFilledIn', true);
            console.log('all fields filled in');
        }else{
            component.set('v.requiredFieldsFilledIn', false);
            console.log('required fields missing');
        }


    },

    handleZipCodeBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        if(loanForm.applicantZipCode) {
            loanForm.applicantZipCode4 = loanForm.applicantZipCode.substr(loanForm.applicantZipCode.length - 4);
            component.set("v.loanForm", loanForm);
            console.log('loanForm ===> ' + JSON.stringify(loanForm));
        }
    },

    handleAddressBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        var streetNumber = '';
        var streetName = '';

        if(loanForm.applicantStreetNumber){
            streetNumber = loanForm.applicantStreetNumber;
        }

        if(loanForm.applicantStreetName){
            streetName = loanForm.applicantStreetName;
        }

        loanForm.applicantStreetAddress = streetNumber + ' ' + streetName;

        component.set("v.loanForm", loanForm);

    },

    handleCoAddressBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        var streetNumber = '';
        var streetName = '';

        if(loanForm.coApplicantStreetNumber){
            streetNumber = loanForm.coApplicantStreetNumber;
        }

        if(loanForm.coApplicantStreetName){
            streetName = loanForm.coApplicantStreetName;
        }

        loanForm.coApplicantStreetAddress = streetNumber + ' ' + streetName;

        component.set("v.loanForm", loanForm);

    },

    handleCoZipCodeBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        if(loanForm.coApplicantZipCode) {
            loanForm.coApplicantZipCode4 = loanForm.coApplicantZipCode.substr(loanForm.coApplicantZipCode.length - 4);
            component.set("v.loanForm", loanForm);
            console.log('loanForm ===> ' + JSON.stringify(loanForm));
        }
    },

    handleAppSpouseAddressBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        var streetNumber = '';
        var streetName = '';

        if(loanForm.applicantSpouseStreetNumber){
            streetNumber = loanForm.applicantSpouseStreetNumber;
        }

        if(loanForm.applicantSpouseStreetName){
            streetName = loanForm.applicantSpouseStreetName;
        }

        loanForm.applicantSpouseStreetAddress = streetNumber + ' ' + streetName;

        component.set("v.loanForm", loanForm);
    },

    handleAppSpouseZipCodeBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        if(loanForm.applicantSpouseZipCode) {
            loanForm.applicantSpouseZipCode4 = loanForm.applicantSpouseZipCode.substr(loanForm.applicantSpouseZipCode.length - 4);
            component.set("v.loanForm", loanForm);
            console.log('loanForm ===> ' + JSON.stringify(loanForm));
        }
    },


    handleCoAppSpouseAddressBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        var streetNumber = '';
        var streetName = '';

        if(loanForm.coApplicantSpouseStreetNumber){
            streetNumber = loanForm.coApplicantSpouseStreetNumber;
        }

        if(loanForm.coApplicantSpouseStreetName){
            streetName = loanForm.coApplicantSpouseStreetName;
        }

        loanForm.coApplicantSpouseStreetAddress = streetNumber + ' ' + streetName;

        component.set("v.loanForm", loanForm);
    },

    handleCoAppSpouseZipCodeBlur : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        if(loanForm.coApplicantSpouseZipCode) {
            loanForm.coApplicantSpouseZipCode4 = loanForm.coApplicantSpouseZipCode.substr(loanForm.coApplicantSpouseZipCode.length - 4);
            component.set("v.loanForm", loanForm);
            console.log('loanForm ===> ' + JSON.stringify(loanForm));
        }
    },

    handleAppAgree : function (component, event, helper) {

        var loanForm = component.get("v.loanForm");
        console.log('loan form 1 ===> ' + JSON.stringify(loanForm));
        component.set("v.loanForm", loanForm);

    },

    OtherAddressAppBlur : function (component, event, helper) {

        var poBox = /^ *((#\d+)|((box|bin)[-. \/\\]?\d+)|(.*p[ \.]? ?(o|0)[-. \/\\]? *-?((box|bin)|b|(#|num)?\d+))|(p(ost)? *(o(ff(ice)?)?)? *((box|bin)|b)? *\d+)|(p *-?\/?(o)? *-?box)|post office box|((box|bin)|b) *(number|num|#)? *\d+|(num|number|#) *\d+)/i;
        var otherAddrCmp = component.find("otheraddress")
        var otherAddrValue = otherAddrCmp.get("v.value");

        if(otherAddrValue) {

            if (otherAddrValue.match(poBox)) {
                otherAddrCmp.setCustomValidity($A.get("$Label.c.icPO_Box_addresses_are_not_allowed"));
                otherAddrCmp.reportValidity();
            }
        }
    },

    otherAddressAppFocus : function (component, event, helper) {

        var otherAddrCmp = component.find("otheraddress");
        otherAddrCmp.setCustomValidity("");
        otherAddrCmp.reportValidity();
    },

    hideHelpText : function(component, event, helper){

        var a = event.getSource();
        var id = a.getLocalId();


        if(id == 'cellphoneIcon'){
            var cellphoneHelpText= alert("By providing your mobile phone number, you authorize any financial institution that makes a GreenSky® loan to you and its agents, contractors, successors, assigns, or service providers to contact you at this mobile number, and any future number that you provide for your cellular telephone or other wireless device, by phone or text message using automated telephone dialing system or artificial or prerecorded voice messages, for any legal purpose, including, but not limited to, servicing a loan. You may revoke your consent at any time by contacting us at 1-866-936-0602 or P.O. Box 24929, Atlanta, GA 30359.");

        }
        if(id == 'emailIcon'){
            var emailHelpText= alert("The email address must belong to the Applicant completing this section. If you provide an email address, we, and/or your merchant/provider, may use it to contact you about our products, services, special offers, and other promotions.");

        }
        if(id == 'grossincomeIcon'){
            var grossincomeHelpText= alert($A.get("$Label.c.icGrossIncomeExample"));
            // var grossincomeHelpText= alert("Examples: Annual salary (before taxes), alimony, child support, investment income, social security, etc. NOTE: Alimony, child support, or separate maintenance payments need not be revealed if you do not wish to have them considered as a basis for repaying the loan. Married Wisconsin Residents: Combine spouse and your income information once.");
        }

    },

    hideHelpTextCO : function(component, event, helper){

        var a = event.getSource();
        var id = a.getLocalId();


        if(id == 'cellphoneCOIcon'){
            var cellphoneHelpTextCO= alert("By providing your mobile phone number, you authorize any financial institution that makes a GreenSky® loan to you and its agents, contractors, successors, assigns, or service providers to contact you at this mobile number, and any future number that you provide for your cellular telephone or other wireless device, by phone or text message using automated telephone dialing system or artificial or prerecorded voice messages, for any legal purpose, including, but not limited to, servicing a loan. You may revoke your consent at any time by contacting us at 1-866-936-0602 or P.O. Box 24929, Atlanta, GA 30359.");

        }
        if(id == 'emailCOIcon'){
            var emailHelpTextCO= alert("The email address must belong to the Co-Applicant completing this section. If you provide an email address, we, and/or your merchant/provider, may use it to contact you about our products, services, special offers, and other promotions.");

        }
        if(id == 'grossincomeCOIcon'){
            var grossincomeHelpTextCO= alert($A.get("$Label.c.icGrossIncomeExample"));
        }

    },


})