({
    toggleCheckboxDisclaimer : function(component, event) {

        var elem = document.getElementsByClassName('checkboxDisclaimerBEFORE')[0];
        if(event.getParam('value') == 'StatusMatchOptionCheckbox'){
            // Checkbox checked: remove first disclaimer and switch to second disclaimer
            elem.style.display = 'none';
            // Enable radio button 2 and 3
//            component.find("highertierchoices").set("v.disabled", false);
            component.find("secondchoice").set("v.disabled", false);
            component.find("thirdchoice").set("v.disabled", false);
            component.set("v.canNext", false);
            // Disable radio button 1
            component.find("firstchoice").set("v.disabled", true);
            component.find("firstchoice").set("v.value", false);
            // Actual second disclaimer content being displayed
            document.getElementsByClassName('checkboxDisclaimerAFTER')[0].style.display = 'block';            
            //Manually flag             
            component.set("v.isStatusMatch", true);
        }else{
            // Show again old disclaimer
            elem.style.display = 'block';
            // Disable radio 2 and 3
//            component.find("highertierchoices").set("v.disabled", true);
            component.find("secondchoice").set("v.disabled", true);
            component.find("thirdchoice").set("v.disabled", true);
            // Enable radio 1
            component.find("firstchoice").set("v.disabled", false);
            // Remove second disclaimer
            document.getElementsByClassName('checkboxDisclaimerAFTER')[0].style.display = 'none';
            // IN CASE radio button 2 or 3 had been checked, uncheck them and disable Next again
            component.set("v.canNext", false);
//            component.find("highertierchoices").set("v.value", false);
            component.find("secondchoice").set("v.value", false);
            component.find("thirdchoice").set("v.value", false);
            //Manually flag             
            component.set("v.isStatusMatch", false);
        }
        

    },
    firstChoiceTrigger : function(component, event){

            //component.find("checkboxTrigger").set("v.disabled", true);
            component.set('v.tierChoice', event.getParam('value'));
            component.set("v.canNext", true);

    },
    higherTierChoiceTrigger : function(component, event){
        
        component.set('v.tierChoice', event.getParam('value'));
        component.set("v.canNext", true);

    }
})