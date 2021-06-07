import {LightningElement, api, wire, track} from 'lwc';
import serachAccs from '@salesforce/apex/CaseCustomerServiceSearchAccount.retriveAccs';
import updateCase from '@salesforce/apex/CaseCustomerServiceSearchAccount.updateCase';
import {updateRecord} from 'lightning/uiRecordApi'
import {ShowToastEvent} from 'lightning/platformShowToastEvent'

// datatable columns
const columns = [{
        label: 'Name',
        fieldName: 'Name',
        type: 'text'
    },
    {
        label: 'Type',
        fieldName: 'Type',
        type: 'text'
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        type: 'text'
    },
    {
        label: 'Customer Type',
        fieldName: 'Customer_Type__c',
        type: 'text '
    }
];
export default class CustomSearchInCase extends LightningElement {
    @track searchData;
    @track columns = columns;
    @track errorMsg = '';
    strSearchAccName = '';
    @api recordId;
    @wire(updateCase, {
        recordId: '$recordId'
    }) conList;

    handleAccountName(event) {
        this.strSearchAccName = event.detail.value;
    }

    handleSearch() {
        if (!this.strSearchAccName) {
            this.errorMsg = 'Please enter account name to search.';
            this.searchData = undefined;

            return;
        } else {
            this.errorMsg = undefined;

        }

        serachAccs({
                strAccName: this.strSearchAccName
            })
            .then(result => {
                this.searchData = result;
            })

            .catch(error => {
                this.searchData = undefined;
                window.console.log('error =====> ' + JSON.stringify(error));
                if (error) {
                    this.errorMsg = error.body.message;
                }
            })
    }


    updateRecord() {
        if (this.template.querySelector("lightning-datatable")) {
            var selectedAccount =
                this.template.querySelector("lightning-datatable").getSelectedRows();
            if (selectedAccount[0]) {
                updateCase({
                        accountId: selectedAccount[0].Id,
                        caseId: this.recordId
                    })

                    .then(result => {
                        updateRecord({
                            fields: {
                                Id: this.recordId
                            }
                        });
                        const event = new ShowToastEvent({
                            title: 'Account is associated to Case',
                            message: 'The selected Account is associated to the Case record.',
                            variant: 'success',
                        });

                        this.dispatchEvent(event);
                    })
                    .catch(error => {
                        alert('Error, please check with administrator' + JSON.stringify(error));
                    })
            } else {
                const event = new ShowToastEvent({
                    title: 'Account is not selected',
                    message: 'Please select a account to proceed.',
                    variant: 'error',
                });
                this.dispatchEvent(event);
            }
        } else {
            const event = new ShowToastEvent({
                title: 'No Account found',
                message: 'Find an account to proceed.',
                variant: 'error',
            });
            this.dispatchEvent(event);
        }
    }
}