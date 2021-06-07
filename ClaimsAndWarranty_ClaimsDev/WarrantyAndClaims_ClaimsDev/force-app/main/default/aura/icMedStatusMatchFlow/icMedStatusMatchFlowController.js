({
    toggleCheckboxDisclaimer : function(component, event, helper) {
        helper.toggleCheckboxDisclaimer(component, event);
    },

    // FLOW NAVIGATION PART
    init : function(cmp, event, helper) {
        // Figure out which buttons to display
        var availableActions = cmp.get('v.availableActions');
        for (var i = 0; i < availableActions.length; i++) {
           if (availableActions[i] == "PAUSE") {
              cmp.set("v.canPause", true);
           } else if (availableActions[i] == "BACK") {
              cmp.set("v.canBack", true);
           } else if (availableActions[i] == "NEXT") {
              //cmp.set("v.canNext", true);
           } else if (availableActions[i] == "FINISH") {
              cmp.set("v.canFinish", true);
           }
        }
        
        // Checkbox label and value
        var liststatusmatch = [
         { label: $A.get("$Label.c.icStatusMatchCheckboxLabel"), value: 'StatusMatchOptionCheckbox'}
        ];
        cmp.set('v.liststatusmatch', liststatusmatch);
        
        // Radio Buttons Labels
        var tier1RadioLabel = $A.get("$Label.c.icROOFPROTier1");
            tier1RadioLabel = tier1RadioLabel.replace('{0}', '<b><span style="color:blue">');
            tier1RadioLabel = tier1RadioLabel.replace('{1}', '</span><span style="color:red">');
            tier1RadioLabel = tier1RadioLabel.replace('{2}', '</span></b>');
        cmp.set('v.tier1RadioLabel', tier1RadioLabel);

        var tier2RadioLabel = $A.get("$Label.c.icROOFPROTier2");
            tier2RadioLabel = tier2RadioLabel.replace('{0}', '<b><span style="color:blue">');
            tier2RadioLabel = tier2RadioLabel.replace('{1}', '</span><span style="color:red">');
            tier2RadioLabel = tier2RadioLabel.replace('{2}', '</span></b>');
        cmp.set('v.tier2RadioLabel', tier2RadioLabel);

        var tier3RadioLabel = $A.get("$Label.c.icROOFPROTier3");
            tier3RadioLabel = tier3RadioLabel.replace('{0}', '<b><span style="color:blue">');
            tier3RadioLabel = tier3RadioLabel.replace('{1}', '</span><span style="color:red">');
            tier3RadioLabel = tier3RadioLabel.replace('{2}', '</span></b>');
        tier3RadioLabel = tier3RadioLabel.replace('{3}', '<span style="font-size:11px">');
        tier3RadioLabel = tier3RadioLabel.replace('{4}', '</span>');
        cmp.set('v.tier3RadioLabel', tier3RadioLabel);

        // Radio Buttons Values
        var tier1RadioValue = [
           { label: '', value: 'Tier 1 (0 - 2,499)'}
        ];
        cmp.set('v.tier1RadioValue', tier1RadioValue);
        var tier2RadioValue = [
           { label: '', value: 'Tier 2 (2,500 - 9,999)'}
        ];
        cmp.set('v.tier2RadioValue', tier2RadioValue);
        var tier3RadioValue = [
           { label: '', value: 'Tier 3 (10,000+)'}
        ];
        cmp.set('v.tier3RadioValue', tier3RadioValue);
        
        // Next/Previous buttons labels
        cmp.set('v.nextLabel', $A.get("$Label.c.icNextButton"));
        cmp.set('v.previousLabel', $A.get("$Label.c.icPreviousButton"));
        
        //New static text
        cmp.set('v.statusMatchText', $A.get("$Label.c.ROOFPROStatusMatchText"));
    },
          
     onButtonPressed: function(cmp, event, helper) {
        // Figure out which action was called
        var actionClicked = event.getSource().getLocalId();
        // Fire that action
        var navigate = cmp.get('v.navigateFlow');
        navigate(actionClicked);
     },  
     // END OF FLOW NAVIGATION PART

     firstChoiceTrigger : function(component, event, helper){
        helper.firstChoiceTrigger(component, event, helper);
     },

     higherTierChoiceTrigger : function(component, event, helper){
        helper.higherTierChoiceTrigger(component, event, helper);
     }
})