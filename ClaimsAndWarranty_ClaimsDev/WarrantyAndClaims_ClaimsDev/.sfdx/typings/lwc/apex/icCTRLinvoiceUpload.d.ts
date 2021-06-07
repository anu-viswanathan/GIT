declare module "@salesforce/apex/icCTRLinvoiceUpload.getRebatePrograms" {
  export default function getRebatePrograms(): Promise<any>;
}
declare module "@salesforce/apex/icCTRLinvoiceUpload.getComponentDetails" {
  export default function getComponentDetails(param: {invoiceId: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLinvoiceUpload.newContractorInvoice" {
  export default function newContractorInvoice(param: {rebateProgram: any, contractorInvoice: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLinvoiceUpload.deleteUploadedFiles" {
  export default function deleteUploadedFiles(param: {fileIds: any, invoiceId: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLinvoiceUpload.deleteContractInvoice" {
  export default function deleteContractInvoice(param: {invoiceId: any}): Promise<any>;
}
declare module "@salesforce/apex/icCTRLinvoiceUpload.saveInvoice" {
  export default function saveInvoice(param: {invoice: any}): Promise<any>;
}
