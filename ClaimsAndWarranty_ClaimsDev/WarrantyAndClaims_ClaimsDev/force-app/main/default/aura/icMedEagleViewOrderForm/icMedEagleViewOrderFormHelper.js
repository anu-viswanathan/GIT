/**
 * Created by Francois Poirier on 2018-06-19.
 */
({
    doInit : function (component, event) {

        //component.set("v.displaySpinner", true);
        this.waiting(component);

        var action = component.get("c.getAvailableProducts");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.availableProducts", responseValue);
            }
            else {
                console.log("erreur : " + JSON.stringify(response));
            }
            //component.set("v.displaySpinner", false);
            this.waiting(component);
        });

        $A.enqueueAction(action);

        var sPageURL = decodeURIComponent(window.location);

        console.log("PAGE URLSSS " + sPageURL);

        var checSite = component.get("c.isCommunity");
        checSite.setParams({sPageURL : sPageURL});
        checSite.setCallback(this, function(response){
            var check = response.getState();
            if (check === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.isInCommunity", responseValue);
            }
            else {
                console.log("erreur : " + JSON.stringify(response));
            }
        })

        $A.enqueueAction(checSite);

        this.resetOrder(component);
    },

    doChangePropertyType : function (component, event) {

        //component.set("v.displaySpinner", true);
        this.waiting(component);

        var orderDetails = component.get("v.orderDetails");
        var availableProducts = component.get("v.availableProducts");

        var filteredProducts = [];

        if(availableProducts != null && availableProducts != undefined) {
            for (var i = 0; i < availableProducts.length; i++) {
                var thisProduct = availableProducts[i];
                if(!thisProduct.isTemporarilyUnavailable && thisProduct.TypeOfStructure == orderDetails.propertyType) {
                    filteredProducts.push(thisProduct);
                }
            }
        }

        component.set("v.filteredProducts", filteredProducts);

        //component.set("v.displaySpinner", false);
        this.waiting(component);
    },

    handleProductChange : function (component, event) {

        //component.set("v.displaySpinner", true);
        this.waiting(component);

        var orderDetails = component.get("v.orderDetails");
        var productId = component.get("v.selectedProductId");
        var availableProducts = component.get("v.availableProducts");
        var thisProduct = this.getProductById(availableProducts, productId);

        orderDetails.product = thisProduct;

        component.set("v.deliveryProducts", thisProduct.deliveryProducts);
        component.set("v.optionalProducts", thisProduct.addOnProducts);

        var measurementInstructionTypes = [];
        thisProduct.measurementInstructionTypes.forEach(function (measurementInstructionType) {
            if(measurementInstructionType == 1){
                measurementInstructionTypes.push({"label":$A.get("$Label.c.icPrimary_plus_detached_garage"), "value":1});
            }
            if(measurementInstructionType == 2){
                measurementInstructionTypes.push({"label":$A.get("$Label.c.icPrimary_structure_only"), "value":2});
            }
            if(measurementInstructionType == 3){
                measurementInstructionTypes.push({"label":$A.get("$Label.c.icAll_structures_on_parcel"), "value":3});
            }
            if(measurementInstructionType == 4){
                measurementInstructionTypes.push({"label":$A.get("$Label.c.icCommercial_complex"), "value":4});
            }
            if(measurementInstructionType == 5){
                measurementInstructionTypes.push({"label":$A.get("$Label.c.icOther"), "value":5});
            }
        });
        component.set("v.measurementTypes", measurementInstructionTypes);

        //component.set("v.displaySpinner", false);
        this.waiting(component);
    },

    handleDeliveryProductChange : function (component, event) {

        //component.set("v.displaySpinner", true);
        this.waiting(component);

        var orderDetails = component.get("v.orderDetails");
        var productId = component.get("v.selectedDeliveryProductId");
        var deliveryProducts = component.get("v.deliveryProducts");
        var thisProduct = this.getProductById(deliveryProducts, productId);

        orderDetails.delivery = thisProduct;

        //component.set("v.displaySpinner", false);
        this.waiting(component);
    },    

    getProductById : function (haystack, needdle) {

        console.log("in getProductById");
        var returnProduct;

        haystack.forEach(function (hay) {
            if(hay.productID == needdle){
                returnProduct = hay;
            }
        });

        return returnProduct
    },

    sendOrder : function (component, event) {
        this.waiting(component);

        var recordId = component.get("v.recordId");
        if(recordId == null || recordId == undefined) {
            recordId = decodeURIComponent(window.location.search.substring(1)).split("=")[1];
        }
        
        var orderDetails = component.get("v.orderDetails");

        var allValid = component.find("field").reduce(function (validSoFar, inputCmp) {
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get("v.validity").valid;
        }, true);

        var validateProprtyType = component.find("validateProprtyType");
        if(orderDetails.propertyType == 0) {
            allValid = false;            
        }

        if (allValid) {
            var action = component.get("c.createOrder");
            action.setParams({ orderDetailsJSON : JSON.stringify(orderDetails), opportunityId : recordId });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var responseValue = response.getReturnValue();
                    console.log("create order response ===> " + responseValue);
                    if(responseValue.startsWith("An Exception Occured")) {
                        component.set("v.placeOrderResponse", {message:responseValue});
                        this.waiting(component);
                    } else {
                        this.sendOrderToEV(component, responseValue);
                    }                
                }
                else {
                    console.log("erreur : " + JSON.stringify(response));
                    this.waiting(component);
                }
            });

            $A.enqueueAction(action);            
        } else {
            this.waiting(component);
            component.set("v.resultMessage", $A.get("$Label.c.icPlease_fill_in_all_required_fields_and_try_again"));
        }        
    },

    sendOrderToEV : function (component, refId) {
        var orderDetails = component.get("v.orderDetails");
        
        var myPlaceOrder = {};
        var myOrderReport = {};
        
        var myAddress = {};
        myAddress.Address = orderDetails.streetAddress;
        myAddress.City = orderDetails.city;
        myAddress.State = orderDetails.state;
        myAddress.Zip = orderDetails.postalCode;
        myAddress.Country = orderDetails.country;
        myAddress.AddressType = 1;
        console.log("myADdress ===> " + JSON.stringify(myAddress));
        myOrderReport.ReportAddresses = [];
        myOrderReport.ReportAddresses.push(myAddress);

        myOrderReport.PrimaryProductId = orderDetails.product.productID;
        myOrderReport.DeliveryProductId = orderDetails.delivery.productID;
        myOrderReport.MeasurementInstructionType = orderDetails.measurementType;
        myOrderReport.ChangesInLast4Years = orderDetails.changesInLast4Years;
        myOrderReport.ReferenceId = refId;
        myOrderReport.Comments = orderDetails.specialInstructions;

        myPlaceOrder.OrderReports = [];
        myPlaceOrder.OrderReports.push(myOrderReport);
        myPlaceOrder.PlaceOrderUser = "##PlaceOrderUser##";

        var strOrder = JSON.stringify(myPlaceOrder);
        console.log("strOder in lightning ===> " + strOrder);

        var action = component.get("c.placeOrder");
        action.setParams({ strOrder : strOrder });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                component.set("v.placeOrderResponse", responseValue);
                this.updateOrder(component, refId, responseValue);
                console.log("place order response ===> " + JSON.stringify(responseValue));
            }
            else {
                console.log("erreur : " + JSON.stringify(response));
                this.waiting(component);
            }
        });

        $A.enqueueAction(action);
    },

    updateOrder : function (component, refId, orderInfo) {
        var action = component.get("c.setOrderIds");
        action.setParams({ sfOrderId : refId, jsonOrderInfo : JSON.stringify(orderInfo) });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseValue = response.getReturnValue();
                console.log("update order response ===> " + JSON.stringify(responseValue));
            }
            else {
                console.log("erreur : " + JSON.stringify(response));
            }

            this.waiting(component);
        });

        $A.enqueueAction(action);
    },

    handleBackToOrderClick : function (component, event) {
        this.waiting(component);

        component.set("v.placeOrderResponse", undefined);

        this.waiting(component);
    },

    handleBackToOpportunityClick : function (component, event) {
        var recordId = component.get("v.recordId");
        var communityFlag = component.get("v.isInCommunity");

        if(recordId == null || recordId == undefined) {
            recordId = decodeURIComponent(window.location.search.substring(1)).split("=")[1];
        }

        if (communityFlag == true){
            console.log("IN COMMUNITY");
            $A.get("e.force:navigateToURL").setParams({
                "url": "/opportunity/" + recordId,
                "isredirect" :false
            }).fire();
        }else{
            console.log("IN SF");
            $A.get("e.force:navigateToSObject").setParams({
                "recordId": recordId
            }).fire();
        }
    },

    handleResetOrderClick : function(component, event) {
        this.resetOrder(component);
    },

    resetOrder : function(component) {
        var orderDetails = {
            streetAddress:""
            ,city:""
            ,state:""
            ,postalCode:""
            ,country:""
            ,propertyType:0
            ,product:{}
            ,delivery:{}
            ,propertyType:0
            ,specialInstructions:""
            ,changesInLast4Years:false
        };

        component.set("v.orderDetails", orderDetails);
        component.set("v.selectedProductId", 0);
        component.set("v.selectedDeliveryProductId", 0);
        
        
    },

    waiting : function(component) {
        var spinner = component.find("objSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
    }
})