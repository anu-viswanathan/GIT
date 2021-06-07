import { LightningElement, api, wire} from 'lwc';
import getAllCons from '@salesforce/apex/CaseCustomerServiceFindSimilarContacts.fetchContactList';
import updateCase from '@salesforce/apex/CaseCustomerServiceFindSimilarContacts.updateContactInCase';
import {updateRecord} from 'lightning/uiRecordApi'
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

// datatable columns
const COLS = [{
      label: 'First Name',
      fieldName: 'FirstName',
      type: 'text'
  },
  {
      label: 'LastName',
      fieldName: 'LastName',
      type: 'text'
  },
  {
      label: 'Email',
      fieldName: 'Email',
      type: 'text'
  },
  {
    label: 'Account',
    fieldName: 'AccountName__c',
    type: 'text'
 },
 {
    label: 'Account Address',
    fieldName: 'Account_Address__c',
    type: 'text'
 }
 
];

export default class SimilarContactsInCase extends LightningElement {
  @api recordId;
  cols = COLS;
  @wire(getAllCons, {
      recordId: '$recordId'
  }) conList;

  updateRecord() {
      // alert('Selected contact -')
      var selectedContact =
          this.template.querySelector("lightning-datatable").getSelectedRows();
      //   alert('Selected contact -'+ selectedContact[0])
      if (selectedContact[0]) {
          updateCase({
                  contactId: selectedContact[0].Id,
                  caseId: this.recordId
              })

              .then(result => {

                  updateRecord({
                      fields: {
                          Id: this.recordId
                      }
                  });

                  const event = new ShowToastEvent({
                      title: 'Contact is associated to Case',
                      message: 'The selected Contact is associated to the Case record.',
                      variant: 'success',
                  });
                  this.dispatchEvent(event);

              })
              .catch(error => {
                  alert('Error, please check with administrator' + JSON.stringify(error));
              })
      } else {
          const event = new ShowToastEvent({
              title: 'Contact is not selected',
              message: 'Please select a contact record to proceed.',
              variant: 'error',
          });
          this.dispatchEvent(event);
      }
  }
}