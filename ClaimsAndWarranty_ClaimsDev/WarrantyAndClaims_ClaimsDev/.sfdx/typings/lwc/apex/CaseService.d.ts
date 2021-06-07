declare module "@salesforce/apex/CaseService.createClaimDraft" {
  export default function createClaimDraft(param: {street: any, fieldMap: any, c: any, contactSalutation: any, contactFirstName: any, contactLastName: any, contactOfInterest: any, addressVerified: any}): Promise<any>;
}
declare module "@salesforce/apex/CaseService.initClaimCaseDraft" {
  export default function initClaimCaseDraft(): Promise<any>;
}
declare module "@salesforce/apex/CaseService.getPicklistOptions" {
  export default function getPicklistOptions(param: {objectName: any, fieldName: any}): Promise<any>;
}
declare module "@salesforce/apex/CaseService.getRecordTypePicklistValues" {
  export default function getRecordTypePicklistValues(): Promise<any>;
}
declare module "@salesforce/apex/CaseService.getDependentPicklist" {
  export default function getDependentPicklist(param: {objectName: any, parentField: any, childField: any}): Promise<any>;
}
