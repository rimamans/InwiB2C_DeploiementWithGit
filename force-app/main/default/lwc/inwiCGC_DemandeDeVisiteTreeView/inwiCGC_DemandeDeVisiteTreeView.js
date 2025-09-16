import { LightningElement , api } from 'lwc';

export default class InwiCGC_DemandeDeVisiteTreeView extends LightningElement {

  @api apidata
  @api isRecursive = false

  connectedCallback(){

  }

  handleInputChange(event) {
    console.log(event.detail)
    const inputType = event.target.type;
    const inputName = event.target.name;
    const nodeId = event.target.dataset.index;
    const value = inputType === 'checkbox' ? event.target.checked : event.target.value;
    console.log(inputType, inputName, nodeId, value)

    const inputChangeEvent = new CustomEvent('inputchange', { detail: { type: inputType, name: inputName, id: nodeId, value: value } });
    this.dispatchEvent(inputChangeEvent);
  }

  handleNodeUpdateEvent(event) {
    let { type, name, id, value } = event.detail;

    console.log(type, name, id, value)
    const inputChangeEvent = new CustomEvent('inputchange', { detail: { type: type, name: name, id: id, value: value } });
    this.dispatchEvent(inputChangeEvent);
  }
}