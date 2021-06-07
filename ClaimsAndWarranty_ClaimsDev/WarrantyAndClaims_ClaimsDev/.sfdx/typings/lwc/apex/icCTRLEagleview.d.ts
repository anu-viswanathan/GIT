declare module "@salesforce/apex/icCTRLEagleview.isCustomerSubscribed" {
  export default function isCustomerSubscribed(): Promise<any>;
}
declare module "@salesforce/apex/icCTRLEagleview.isCommunity" {
  export default function isCommunity(param: {sPageURL: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLEagleview.getAvailableProducts" {
  export default function getAvailableProducts(): Promise<any>;
}
declare module "@salesforce/apex/icCTRLEagleview.placeOrder" {
  export default function placeOrder(param: {strOrder: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLEagleview.createOrder" {
  export default function createOrder(param: {orderDetailsJSON: any, opportunityId: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLEagleview.setOrderIds" {
  export default function setOrderIds(param: {sfOrderId: any, jsonOrderInfo: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLEagleview.cancelOrder" {
  export default function cancelOrder(param: {recordId: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLEagleview.subscribe" {
  export default function subscribe(param: {eagleviewUsername: any, eagleviewPassword: any}): Promise<any>;
}
