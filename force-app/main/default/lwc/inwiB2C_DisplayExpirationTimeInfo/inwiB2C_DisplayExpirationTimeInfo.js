/* eslint-disable no-undef */

import { LightningElement, api } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_DisplayExpirationTimeInfo.html";

export default class InwiB2C_DisplayExpirationTimeInfo extends OmniscriptBaseMixin(
  LightningElement
) {
  __records;

  iscameleon;
  @api
  get records() {
    return this.__records;
  }
  dateval;

  set records(value) {
    this.__records = value;
    console.log("value = ", JSON.stringify(this.__records));
  }

  connectedCallback() {}

  get dateValue() {
    if (this.dateval === undefined) {
      this.dateval = new Date().toISOString().substring(0, 16);
    }
    return this.dateval;
  }

  renderedCallback() {
    console.log("callback " + this.__records[0].ListInfo[0].isCameleon);
  }

  get isCameleon() {
    return this.__records[0].ListInfo[0].isCameleon;
  }

  get diff() {
    return this.__records[0].ListInfo[0].ExpirationTime < this.dateValue;
  }
  get ExpirationTime() {
    return this.__records[0].ListInfo[0].ExpirationTime;
  }

  render() {
    return template;
  }
}