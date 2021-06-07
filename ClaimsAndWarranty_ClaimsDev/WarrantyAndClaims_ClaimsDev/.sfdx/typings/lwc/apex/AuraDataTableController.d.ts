declare module "@salesforce/apex/AuraDataTableController.getFiles" {
  export default function getFiles(param: {recordId: any, objectName: any}): Promise<any>;
}
declare module "@salesforce/apex/AuraDataTableController.updateFiles" {
  export default function updateFiles(param: {documentId: any, recordId: any, ikoFileType: any, objectName: any}): Promise<any>;
}
declare module "@salesforce/apex/AuraDataTableController.getListOfFileTypes" {
  export default function getListOfFileTypes(): Promise<any>;
}
declare module "@salesforce/apex/AuraDataTableController.getCaseIdByLabSampleId" {
  export default function getCaseIdByLabSampleId(param: {labSampleId: any}): Promise<any>;
}
