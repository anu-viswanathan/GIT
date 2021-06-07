import { LightningElement, api, track, wire } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import submit from "@salesforce/apex/icAffidavitController.submitAffidavit";
import getContractorInfo from "@salesforce/apex/icAffidavitController.getContractorInfo";
import HEADINGTEXT from "@salesforce/label/c.icAffidavit_Header";
import HEADINGTEXT_COMPLETED from "@salesforce/label/c.icAffidavit_Header_Completed";
import BODYTEXT_P1 from "@salesforce/label/c.icAffidavit_Body_P1";
import BODYTEXT_P2 from "@salesforce/label/c.icAffidavit_Body_P2";
import BODYTEXT_COMPLETED from "@salesforce/label/c.icAffidavit_Body_Completed";
import SWORN from "@salesforce/label/c.icAffidavit_Sworn";
import NAME from "@salesforce/label/c.icAffidavit_Label_Name";
import ESIGNATURE from "@salesforce/label/c.icAffidavit_Label_ESignature";
import TITLE from "@salesforce/label/c.icAffidavit_Label_Title";
import NAME_CONTRACTOR from "@salesforce/label/c.icAffidavit_Label_Name_Contractor";
import CONTRACTOR_ID_NO from "@salesforce/label/c.icAffidavit_Label_Contractor_ID_No";
import BUTTON_SUBMIT from "@salesforce/label/c.icAffidavit_Button_Submit";
import ERR_MESSAGE_ESIGNATURE from "@salesforce/label/c.icAffidavit_ErrMessage_ESignature";
import LINK_MYLEARNING from "@salesforce/label/c.icAffidavit_Link_MyLearning";
import RESOURCES from "@salesforce/resourceUrl/icAffidavit";
export default class IcAffidavit extends NavigationMixin(LightningElement) {
  dateNow = Date.now();

  @track contractor = {
    companyName: "",
    contractorId: "",
    learningPlanName: "",
    isCompletedPlan: ""
  };

  @track isLoadedData = false;

  urlParametr = "aid";

  label = {
    HEADINGTEXT,
    HEADINGTEXT_COMPLETED,
    BODYTEXT_P1,
    BODYTEXT_P2,
    BODYTEXT_COMPLETED,
    SWORN,
    NAME,
    ESIGNATURE,
    TITLE,
    NAME_CONTRACTOR,
    CONTRACTOR_ID_NO,
    BUTTON_SUBMIT
  };

  fieldName = {
    Name: "NAME",
    Esignatue: "ESIGNATURE",
    Title: "TITLE",
    Company: "COMPANY",
    ContractorID: "CONTRACTORID"
  };

  constructor() {
    super();
    let self = this;
    window.onunload = function () {
      if (!self.contractor.isCompletedPlan) {
        window.parent.postMessage({ isOpened: false });
      }
    };
  }
  connectedCallback() {
    let laid = this.getRecordId();
    let self = this;
    this.makeServerCall(
      getContractorInfo,
      {
        LAID: laid
      },
      function (result) {
        self.contractor = result;
        self.isLoadedData = true;
        if (!self.contractor.isCompletedPlan) {
          window.parent.postMessage({
            isOpened: true,
            styles: RESOURCES + "/style.css"
          });
        }
      },
      function (error) {
        console.log(error);
      }
    );
  }

  getRecordId() {
    function getGet(name) {
      var s = window.location.search;
      s = s.match(new RegExp(name + "=([^&=]+)"));
      return s ? s[1] : false;
    }
    return getGet(this.urlParametr);
  }

  makeServerCall(action, params, callback, errorCallback) {
    action(params)
      .then((result) => {
        callback(result);
      })
      .catch((errors) => {
        if (errorCallback) {
          errorCallback(errors);
        } else {
          console.log(errors);
        }
      });
  }

  submitAffidavit() {
    let LMS_Contractor = JSON.parse(JSON.stringify(this.getForm()));
    let laid = this.getRecordId();
    this.navigateToWebPage();
    this.makeServerCall(
      submit,
      {
        LAID: laid,
        LMS_Completion_Name: LMS_Contractor.LMS_Completion_Name__c,
        LMS_Completion_Signature: LMS_Contractor.LMS_Completion_Signature__c,
        LMS_Completion_Title: LMS_Contractor.LMS_Completion_Title__c
      },
      function (result) {},
      function (error) {
        console.log(error);
      }
    );
  }

  handleClick() {
    console.log(this.getRecordId());
    let isValid = this.validationForm();
    if (isValid) {
      this.submitAffidavit();
    }
  }

  validationForm() {
    let form = Array.from(this.template.querySelectorAll("lightning-input"));
    let isValid = true;
    let isValidName = this.validationName();
    form.forEach((input) => {
      if (!input.value) {
        isValid = false;
        input.setCustomValidity("");
      }
      input.reportValidity();
    });
    if (!isValidName) {
      return false;
    }
    return isValid;
  }

  validationName() {
    let inputName = this.template.querySelector(
      "lightning-input[data-field='" + this.fieldName.Name + "']"
    );
    let inputEsignatue = this.template.querySelector(
      "lightning-input[data-field='" + this.fieldName.Esignatue + "']"
    );
    if (inputName.value !== inputEsignatue.value && inputEsignatue.value) {
      inputEsignatue.setCustomValidity(ERR_MESSAGE_ESIGNATURE);
      return false;
    }
    inputEsignatue.setCustomValidity("");
    inputEsignatue.reportValidity();
    return true;
  }
  handleChange(event) {
    event.target.value = event.target.value.replace(/^\s/, "");
  }

  navigateToWebPage() {
    window.parent.postMessage({ isRedirect: true });
  }
  getForm() {
    let LMSuser = {
      LMS_Completion_Name__c: this.template.querySelector(
        "lightning-input[data-field='" + this.fieldName.Name + "']"
      ).value,
      LMS_Completion_Signature__c: this.template.querySelector(
        "lightning-input[data-field='" + this.fieldName.Esignatue + "']"
      ).value,
      LMS_Completion_Title__c: this.template.querySelector(
        "lightning-input[data-field='" + this.fieldName.Title + "']"
      ).value
    };
    return LMSuser;
  }
}