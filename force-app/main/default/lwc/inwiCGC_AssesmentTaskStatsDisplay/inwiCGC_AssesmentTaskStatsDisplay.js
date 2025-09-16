import { LightningElement, wire, api, track } from 'lwc';
import getManagedUsers from '@salesforce/apex/inwiCGC_UserManagerController.getManagedUsers';
import getSubordinateIdsAndAssessments from '@salesforce/apex/inwiCGC_UserManagerController.getSubordinateIdsAndAssessments';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';

export default class InwiCGC_AssessmentTaskStatsDisplay extends LightningElement {
    @api recordpage_display;
    @track userData = [];
    @track columns = [
        { label: '', type: 'button', typeAttributes: { label: 'Show', name: 'show', variant: 'brand' }},
        { label: 'User', fieldName: 'Name' },
        { label: 'Nombre de carte SIM Vendu', fieldName: 'SIMVendu', type: 'number' },
        { label: 'Nombre de carte SIM Dealer Vendu', fieldName: 'SIMDealerVendu', type: 'number' },
        { label: 'Nombre de SC Vendu', fieldName: 'SCVendu', type: 'number' }
    ];

    expandedRows = new Set();

    @wire(getRecord, { recordId: USER_ID, fields: [NAME_FIELD] })
    wiredUser({ error, data }) {
        if (data) {
            const currentUser = {
                Id: USER_ID,
                Name: data.fields.Name.value,
                ParentId: null,
                level: 0,
                SIMVendu: 0,
                SIMDealerVendu: 0,
                SCVendu: 0,
                expanded: false
            };
            this.userData = [currentUser];
            this.fetchSubordinateDataAndAssessments(currentUser.Id, currentUser);
        } else if (error) {
            console.error('Error fetching current user:', error);
        }
    }

    handleRowAction(event) {
        const row = event.detail.row;
        console.log('Button clicked for row:', row);
    
        const userId = row.Id;
        console.log('Fetching data for userId:', userId);
    
        if (row.expanded) {
            this.collapseRow(userId);
            row.expanded = false;
        } else {
            this.fetchSubordinateData(userId, row);
            row.expanded = true;
        }
    
        this.userData = [...this.userData];
    }
    

    fetchSubordinateData(userId, parentRow) {
        getManagedUsers({ currentUserId: userId })
            .then(result => {
                if (result.length > 0) {
                    console.log('Managed users fetched:', result);
                    const formattedData = result.map(user => ({
                        Id: user.Id,
                        Name: user.Name,
                        ParentId: parentRow.Id,
                        level: parentRow.level + 1,
                        SIMVendu: 0,
                        SIMDealerVendu: 0,
                        SCVendu: 0,
                        expanded: false
                    }));

                    this.insertRowsUnderParent(parentRow.Id, formattedData);

                    formattedData.forEach(row => {
                        this.fetchSubordinateDataAndAssessments(row.Id, row);
                    });
                } else {
                    console.log('No managed users found for userId:', userId);
                }
            })
            .catch(error => {
                console.error('Error fetching managed users:', error);
            });
    }

    fetchSubordinateDataAndAssessments(userId, row) {
        getSubordinateIdsAndAssessments({ userId: userId })
            .then(result => {
                console.log('Subordinates and assessment values fetched:', result);

                row.SIMVendu = result.SIMVendu;
                row.SIMDealerVendu = result.SIMDealerVendu;
                row.SCVendu = result.SCVendu;

                this.userData = [...this.userData];
            })
            .catch(error => {
                console.error('Error fetching subordinates and assessments:', error);
            });
    }

    insertRowsUnderParent(parentId, newRows) {
        const parentIndex = this.userData.findIndex(user => user.Id === parentId);
        if (parentIndex !== -1) {
            this.userData.splice(parentIndex + 1, 0, ...newRows);
            this.userData = [...this.userData];
            console.log('Updated userData:', this.userData);
        }
    }

    collapseRow(userId) {
        console.log('Collapsing row for userId:', userId);
        this.userData = this.userData.filter(user => !this.isDescendant(user, userId));
        this.expandedRows.delete(userId);
        this.userData = [...this.userData];
    }

    isDescendant(user, parentId) {
        let currentParentId = user.ParentId;
        while (currentParentId) {
            if (currentParentId === parentId) {
                return true;
            }
            const parentUser = this.userData.find(u => u.Id === currentParentId);
            currentParentId = parentUser ? parentUser.ParentId : null;
        }
        return false;
    }
}