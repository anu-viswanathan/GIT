({
  doInit : function(component,event,secId) {

    var yearNumber =  new Date().getFullYear();

    component.set("v.yearNumber", yearNumber);


    var action = component.get("c.getQuickShotInfo");
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var responseValue = response.getReturnValue();
        console.log('response value quick shot ===> ' + JSON.stringify(responseValue));
        component.set("v.info", responseValue);
      } else {
        console.log('erreur : ' + JSON.stringify(response));
      }
    });

    $A.enqueueAction(action);
  },

  helperFun : function(component,event,secId) {
    var acc = component.find(secId);
    for(var cmp in acc) {
      $A.util.toggleClass(acc[cmp], 'slds-show');
      $A.util.toggleClass(acc[cmp], 'slds-hide');
    }
  },
})