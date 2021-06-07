declare module "@salesforce/apex/InputLookupAuraController.getCurrentValue" {
  export default function getCurrentValue(param: {type: any, value: any}): Promise<any>;
}
declare module "@salesforce/apex/InputLookupAuraController.searchSObject" {
  export default function searchSObject(param: {type: any, searchString: any}): Promise<any>;
}
declare module "@salesforce/apex/InputLookupAuraController.searchSObjectFiltered" {
  export default function searchSObjectFiltered(param: {type: any, searchString: any, whereClause: any}): Promise<any>;
}
