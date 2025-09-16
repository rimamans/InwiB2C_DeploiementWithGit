import { LightningElement, wire, track } from 'lwc';
import getManagedUsers from '@salesforce/apex/inwiCGC_UserHierarchyController.getManagedUsers';
import getSubordinateSalesValues from '@salesforce/apex/inwiCGC_UserHierarchyController.getSubordinateSalesValues';
import getSubordinateObjectives from '@salesforce/apex/inwiCGC_UserHierarchyController.getSubordinateObjectives';
import getDemandesDeVisite from '@salesforce/apex/inwiCGC_UserHierarchyController.getDemandesDeVisite';
import getObjectivesForUserRows from '@salesforce/apex/inwiCGC_UserHierarchyController.getObjectivesForUserRows';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';

export default class InwiCGC_DemandeVisitStats extends LightningElement {
    @track userData = [];
    @track columns = [
        { label: '', type: 'button', typeAttributes: { label: 'Show', name: 'show', variant: 'brand' }},
        { label: 'User', fieldName: 'Name' },
        { label: 'Nombre de carte SIM Vendu', fieldName: 'SIMVendu', type: 'number', cellAttributes: { style: 'font-weight: bold;' }},
        { label: 'Objectif de carte SIM Vendu', fieldName: 'objectifSIMVendu', type: 'text' },
        { label: 'Pourcentage Réalisé (SIM)', fieldName: 'percentageDoneSIM', type: 'text', cellAttributes: { style: 'font-weight: lighter; font-style: italic;' } },
        { label: 'Nombre de carte SIM Dealer Vendu', fieldName: 'SIMDealerVendu', type: 'number', cellAttributes: { style: 'font-weight: bold;' }},
        { label: 'Objectif de carte SIM Dealer Vendu', fieldName: 'objectifSIMDealerVendu', type: 'text' },
        { label: 'Pourcentage Réalisé (SIM Dealer)', fieldName: 'percentageDoneSIMDealer', type: 'text', cellAttributes: { style: 'font-weight: lighter; font-style: italic;' } },
        { label: 'Nombre de SC Vendu', fieldName: 'SCVendu', type: 'number', cellAttributes: { style: 'font-weight: bold;' }},
        { label: 'Objectif de SC Vendu', fieldName: 'objectifSCVendu', type: 'text' },
        { label: 'Pourcentage Réalisé (SC)', fieldName: 'percentageDoneSC', type: 'text', cellAttributes: { style: 'font-weight: lighter; font-style: italic;' } }
    ];
    
    

    expandedRows = new Set();
    @track demandeDeVisiteOptions = [];
    @track selectedDemandeDeVisite = '';

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
                objectifSIMVendu: '',
                objectifSIMDealerVendu: '',
                objectifSCVendu: '',
                expanded: false
            };
            this.userData = [currentUser];
            this.loadDemandesDeVisite();

            this.fetchObjectivesForTopLevelUser(currentUser);
            this.fetchSubordinateSalesValues(currentUser.Id, currentUser);
        } else if (error) {
            console.error('Error fetching current user:', error);
        }
    }

    fetchObjectivesForTopLevelUser(currentUser) {
        const demandeDeVisiteId = this.selectedDemandeDeVisite || null;

        getSubordinateObjectives({ userId: currentUser.Id, demandeDeVisiteId })
            .then(objectivesResult => {
                this.assignObjectivesValues(objectivesResult, currentUser, true);
                this.calculatePercentageForRow(currentUser);
                this.userData = [...this.userData];
            })
            .catch(error => {
                console.error('Error fetching objectives for top-level user:', error);
            });
    }

    calculatePercentageForRow(row) {
        row.percentageDoneSIM = this.calculatePercentage(row.SIMVendu, row.objectifSIMVendu);
        row.percentageDoneSIMDealer = this.calculatePercentage(row.SIMDealerVendu, row.objectifSIMDealerVendu);
        row.percentageDoneSC = this.calculatePercentage(row.SCVendu, row.objectifSCVendu);
    }

    calculatePercentage(sales, objectif) {
        if (!objectif || objectif <= 0) return '';
        return ((sales / objectif) * 100).toFixed(2) + '%';
    }

    handleRowAction(event) {
        const row = event.detail.row;
        const userId = row.Id;

        if (row.expanded) {
            this.collapseRow(userId);
            row.expanded = false;
        } else {
            row.expanded = true;
            this.fetchSubordinateData(userId, row);

            const userIds = [userId];
            const parentDemandeId = this.selectedDemandeDeVisite;

            getObjectivesForUserRows({ userIds: userIds, parentDemandeId: parentDemandeId })
                .then(objectivesMap => {
                    if (objectivesMap[userId]) {
                        const objectives = objectivesMap[userId];
                        row.objectifSIMVendu = objectives.objectifSIM || '';
                        row.objectifSIMDealerVendu = objectives.objectifSIMDealer || '';
                        row.objectifSCVendu = objectives.objectifSC || '';
                    }
                    this.calculatePercentageForRow(row);
                    this.userData = [...this.userData];
                })
                .catch(error => {
                    console.error('Error fetching objectives for row:', error);
                });
        }

        this.userData = [...this.userData];
    }

    fetchSubordinateData(userId, parentRow) {
        if (this.expandedRows.has(userId)) {
            return;
        }

        getManagedUsers({ currentUserId: userId })
            .then(result => {
                if (result.length > 0) {
                    const formattedData = result.map(user => ({
                        Id: user.Id,
                        Name: user.Name,
                        ParentId: parentRow.Id,
                        level: parentRow.level + 1,
                        SIMVendu: 0,
                        SIMDealerVendu: 0,
                        SCVendu: 0,
                        objectifSIMVendu: '',
                        objectifSIMDealerVendu: '',
                        objectifSCVendu: '',
                        expanded: false
                    }));

                    this.insertRowsUnderParent(parentRow.Id, formattedData);

                    const userIds = formattedData.map(row => row.Id);
                    const parentDemandeId = this.selectedDemandeDeVisite;

                    getObjectivesForUserRows({ userIds: userIds, parentDemandeId: parentDemandeId })
                        .then(objectivesMap => {
                            formattedData.forEach(row => {
                                if (objectivesMap[row.Id]) {
                                    const objectives = objectivesMap[row.Id];
                                    row.objectifSIMVendu = objectives.objectifSIM || '';
                                    row.objectifSIMDealerVendu = objectives.objectifSIMDealer || '';
                                    row.objectifSCVendu = objectives.objectifSC || '';
                                }
                                this.calculatePercentageForRow(row);
                            });
                            this.userData = [...this.userData];
                        })
                        .catch(error => {
                            console.error('Error fetching objectives for subordinate rows:', error);
                        });

                    formattedData.forEach(row => {
                        this.fetchSubordinateSalesValues(row.Id, row);
                    });

                    this.expandedRows.add(userId);
                } else {
                    console.log('No managed users found for userId:', userId);
                }
            })
            .catch(error => {
                console.error('Error fetching managed users:', error);
            });
    }

    fetchSubordinateSalesValues(userId, row) {
        const demandeDeVisiteId = this.selectedDemandeDeVisite || null;

        getSubordinateSalesValues({ userId: userId, demandeDeVisiteId })
            .then(salesResult => {
                this.assignSalesValues(salesResult, row);
            })
            .catch(error => {
                console.error('Error fetching subordinate sales values:', error);
            });
    }

    assignSalesValues(result, row) {
        row.SIMVendu = result.SIMVendu || 0;
        row.SIMDealerVendu = result.SIMDealerVendu || 0;
        row.SCVendu = result.SCVendu || 0;

        const subordinateSalesValues = result.SubordinateSalesValues || {};
        this.userData = this.userData.map(user => {
            if (subordinateSalesValues[user.Id]) {
                const sales = subordinateSalesValues[user.Id];
                user.SIMVendu = sales.SIMVendu || 0;
                user.SIMDealerVendu = sales.SIMDealerVendu || 0;
                user.SCVendu = sales.SCVendu || 0;
                this.calculatePercentageForRow(user);
            }
            return user;
        });

        this.calculatePercentageForRow(row);
        this.userData = [...this.userData];
    }

    assignObjectivesValues(result, row, isTopLevel = false) {
        this.userData = this.userData.map(user => {
            if (user.Id === row.Id && (isTopLevel || result.OwnerId === row.Id)) {
                user.objectifSIMVendu = result.ObjectifSIM || '';
                user.objectifSIMDealerVendu = result.ObjectifSIMDealer || '';
                user.objectifSCVendu = result.ObjectifSC || '';
                this.calculatePercentageForRow(user);
            }
            return user;
        });

        const subordinateObjectives = result.SubordinateObjectives || {};
        this.userData = this.userData.map(user => {
            if (subordinateObjectives[user.Id] && user.Id !== row.Id) {
                const objectives = subordinateObjectives[user.Id];
                user.objectifSIMVendu = objectives.objectifSIM || '';
                user.objectifSIMDealerVendu = objectives.objectifSIMDealer || '';
                user.objectifSCVendu = objectives.objectifSC || '';
                this.calculatePercentageForRow(user);
            }
            return user;
        });

        this.userData = [...this.userData];
    }

    insertRowsUnderParent(parentId, newRows) {
        const parentIndex = this.userData.findIndex(user => user.Id === parentId);
        if (parentIndex !== -1) {
            this.userData.splice(parentIndex + 1, 0, ...newRows);
            this.userData = [...this.userData];
        }
    }

    collapseRow(userId) {
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

    loadDemandesDeVisite() {
        getDemandesDeVisite()
            .then(result => {
                this.demandeDeVisiteOptions = result.map(demande => ({
                    label: `${demande.Name} (${demande.OwnerName})`,
                    value: demande.Id
                }));
            })
            .catch(error => {
                console.error('Error fetching Demande de Visites:', error);
            });
    }

    handleDemandeDeVisiteChange(event) {
        this.selectedDemandeDeVisite = event.detail.value;

        this.userData.forEach(user => {
            user.SIMVendu = 0;
            user.SIMDealerVendu = 0;
            user.SCVendu = 0;
            user.objectifSIMVendu = '';
            user.objectifSIMDealerVendu = '';
            user.objectifSCVendu = '';
            user.expanded = false;
        });

        this.expandedRows.clear();
        this.userData = [this.userData[0]];

        this.fetchObjectivesForTopLevelUser(this.userData[0]);
        this.fetchSubordinateSalesValues(this.userData[0].Id, this.userData[0]);
        this.userData = [...this.userData];
    }
}