import { LightningElement, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import LINK_MYLEARNING from "@salesforce/label/c.icAffidavit_Link_MyLearning";
export default class IcAffidavitUtil extends NavigationMixin(LightningElement) {
  constructor() {
    super();
    function receiveMessage(event) {
      if (event.data.isRedirect) {
        window.location = 'https://'+ window.location.hostname + LINK_MYLEARNING;
      }
    }
    window.addEventListener("message", receiveMessage, false);
  }
}