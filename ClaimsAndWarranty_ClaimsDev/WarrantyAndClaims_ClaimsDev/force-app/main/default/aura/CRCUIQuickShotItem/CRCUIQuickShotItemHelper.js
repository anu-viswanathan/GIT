/**
 * Created by Dongliang Zhang on 2019-10-31.
 */

({
  formatValue : function (component, event) {

    var value = component.get("v.value");
    if(value) {
      var formattedValue = this.numberWithCommas(value);
      var isRoundUp = component.get("v.isRoundUp");
      if(isRoundUp == false){
        formattedValue = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
      }
      component.set("v.formattedValue", formattedValue);
      //console.log('############ ' + component.get('v.formattedValue'));
    }else{
      component.set("v.formattedValue", "0");
    }
  },

  numberWithCommas: function (value) {
    var getValueDec = Math.abs(value) - Math.floor(value);
    var returnValue = value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");

    if (getValueDec < 0.5 && getValueDec > 0){
      returnValue = Math.floor(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    if(getValueDec >= 0.5 && getValueDec < 1){
      returnValue = Math.round(value).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    }

    return returnValue;
    // return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }
});