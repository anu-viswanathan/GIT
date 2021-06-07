declare module "@salesforce/apex/icCTRLGreenSky.isCustomerSubscribed" {
  export default function isCustomerSubscribed(): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.createGreenSkySubscription" {
  export default function createGreenSkySubscription(param: {gsSubscriptionString: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.merchantValidation" {
  export default function merchantValidation(): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.asyncSubmit" {
  export default function asyncSubmit(param: {merchantValidation: any, payload: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.state" {
  export default function state(param: {gsApplication: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.decision" {
  export default function decision(param: {gsApplication: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.offer" {
  export default function offer(param: {gsApplication: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.create" {
  export default function create(param: {gsOffer: any, gsApplication: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.loanAgreement" {
  export default function loanAgreement(param: {gsApplication: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLGreenSky.email" {
  export default function email(param: {loanAgreement: any, gsApplication: any}): Promise<any>;
}
