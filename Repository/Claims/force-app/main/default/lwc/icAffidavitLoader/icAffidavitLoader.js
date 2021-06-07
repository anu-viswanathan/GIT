import { LightningElement } from "lwc";
import RESOURCES from "@salesforce/resourceUrl/icAffidavit";
import { loadScript, loadStyle } from "lightning/platformResourceLoader";

export default class IcAffidavitLoader extends LightningElement {
  connectedCallback() {
    try {
        loadScript(this, RESOURCES + "/script.js")
        .then()
        .catch(error => console.log("Error " + error.body.message));
    } catch (error) {
      console.log(error);
    }
  }
}