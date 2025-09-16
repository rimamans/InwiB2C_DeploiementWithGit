import { LightningElement, track, api, wire } from 'lwc';
import getRoleHierarchy from '@salesforce/apex/inwiCGC_DemandeDeVisiteRoleController.getRoleHierarchy';
import createDemandesVisite from '@salesforce/apex/inwiCGC_DemandeDeVisiteRoleController.createDemandesVisite';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class InwiCGC_AssignDemandeDeVisite extends LightningElement {

  test = [
    {
      id: 1,
      label: 'Node 1',
      isChecked: false,
      input1: '',
      input2: '',
      children: [
        {
          id: 2,
          label: 'Node 1.1',
          isChecked: true,
          input1: '',
          input2: '',
          children: [
            {
              id: 4,
              label: 'Node 1.1.1',
              isChecked: false,
              input1: '',
              input2: '',
              children: []
            }
          ]
        },
        {
          id: 3,
          label: 'Node 1.2',
          isChecked: false,
          input1: '',
          input2: '',
          children: []
        }
      ]
    }
  ];

  @track testupdate

  @api recordId;
  recordData;
  ownerRole;
  @track isLoading = false;
  @track saveMessage = '';
  @track internalData;
  @track errorMessages;
  @track internalTreeData;
  @track isAssignerDisabled = false;
  selectedRole = [];
  @track isDisabled = false;

  

  @wire(getRoleHierarchy, { recordId: '$recordId' })
  wiredHierarchyData({ error, data }) {
    if (data) {
      
      console.log('data',data)
      const parsedData = JSON.parse(data);
      console.log('parsedData ', parsedData)
      console.log('desc', parsedData.descendantRoles)
      console.log('ownerRole', parsedData.ownerRole)
      console.log('tree', parsedData.treeRoles)
      this.internalData = parsedData?.descendantRoles || []
      this.ownerRole = parsedData?.ownerRole
      this.internalTreeData = this.calculateDepth(JSON.parse(JSON.stringify(parsedData?.treeRoles?.children || [])), 2);

    } else if (error) {
      console.error('Error fetching role hierarchy data:', error);
    }}

  /* handleInputChange(event) {
    console.log(event.detail)
    const inputType = event.target.type;
    const inputName = event.target.name;
    const nodeId = event.target.dataset.index;
    const value = inputType == 'checkbox' ? event.target.checked : event.target.value
    console.log(inputType, inputName, nodeId, value)

    const updatedData = this.updateNode(JSON.parse(JSON.stringify(this.internalData)), nodeId, inputName, value);
    console.log(updatedData)
    this.internalData = updatedData;
    console.log('updatedtree', JSON.stringify(this.internalData))
  } */


  /* updateNode(nodes, nodeId, field, value) {
    return nodes.map(node =>  node.id === nodeId ?  { ...node, [field]: value } : node);
  } */

  updateNode(nodes, nodeId, field, value) {
    return nodes.map(node => {
      if (node.id == nodeId) {
        console.log('node', { ...node, [field]: value })
        return { ...node, [field]: value };
      } else if (node.children && node.children.length > 0) {
        return { ...node, children: this.updateNode(node.children, nodeId, field, value) };
      }
      return node;
    });
  }

  clearInputs() {
    this.internalTreeData = this.internalTreeData.map(node => ({
      ...node,
      Objectif: '',
      Descriptif: ''
    }));
  }


  handleSaveClick() {
    this.isDisabled= true;
    console.log('test1')
  
    if (!this.isRoleSelected(this.internalTreeData))  {
      // Show error message
      this.dispatchEvent(
        new ShowToastEvent({
          title: 'Error',
          message: 'Au moins un rôle doit être sélectionné.',
          variant: 'error'
        })
      );
      return;
    }
    //this.isLoading = true
    
    console.log(this.selectedRole)
    this.getCheckedNodes(this.internalTreeData)
    console.log(this.selectedRole)
    console.log(typeof JSON.stringify(this.selectedRole))
    createDemandesVisite({ selectedRolesJson: JSON.stringify(this.selectedRole), recordId: this.recordId  })
      .then(result => {
        // Handle success
        console.log('Roles processed successfully 2:', result);
        

        // this.isLoading = false
        // this.saveMessage = result?.response === true ? 'Demandes de visite assignées avec succès.' : '' ;
        this.errorMessages = result?.message || [];
        this.isDisabled = false

        if(result?.message) {
          this.dispatchEvent(
            new ShowToastEvent({
                title: 'Erreur lors de l\'assignation de la demande de visite.',
                message: result.message,
                variant: 'error'
            })
          );
        }

        if (result?.response === true) {
          this.dispatchEvent(
              new ShowToastEvent({
                  title: 'Success',
                  message: 'Demandes de visite assignées avec succès.',
                  variant: 'success'
              })
          );
          this.clearInputs();
          setTimeout(() => {
            window.location.reload();
          }, 1500);
        }
       
      })
      .catch(error => {
        // Handle error
        // this.isLoading = false
        // this.saveMessage = 'Erreur lors de l\'assignation des Demandes de visite.';
        // console.error('Error processing roles:', error);
        this.isLoading = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'Erreur lors de l\'assignation des Demandes de visite.',
                    variant: 'error'
                })
            );
        console.error('Error processing roles:', error);
        this.isDisabled = false
      });
  }


  handleNodeUpdateEvent(event){
   let  { type, name, id , value } = event.detail

    console.log(type, name, id, value)
    const updatedTreeData = this.updateNode(JSON.parse(JSON.stringify(this.internalTreeData)), id, name, value);
   // console.log(updatedTreeData)
    this.internalTreeData = updatedTreeData;
    //console.log('updatedtree', JSON.stringify(this.internalTreeData))
  }


  calculateDepth(nodes, depth) {

    return nodes.map(node => {
      return {
        ...node,
        depth: depth,
        children: node.children ? this.calculateDepth(node.children, depth + 1) : []
      };
    });
  }


  updateNode(nodes, nodeId, field, value) {
    return nodes.map(node => {
        if (node.id == nodeId) {
            return { ...node, [field]: value };
        } else if (node.children && node.children.length > 0) {
            return { ...node, children: this.updateNode(node.children, nodeId, field, value) };
        }
        return node;
    });
  }

  getCheckedNodes(nodes = []) {
      nodes.forEach((element) => {
          if (element.isChecked) {
              this.selectedRole.push({
                  id: element.id,
                  Objectif: element.Objectif,
                  Descriptif: element.Descriptif,
                  Objectif_SIM: element.Objectif_SIM,
                  Objectif_SIM_Dealer: element.Objectif_SIM_Dealer,
                  Objectif_SC: element.Objectif_SC,
                  isChecked: element.isChecked
              });
          }
          if (element.children) {
              this.getCheckedNodes(element.children);
          }
      });
  }

  isRoleSelected(nodes) {
    return nodes.some(node => node?.isChecked || this.isRoleSelected(node.children));
  }

}