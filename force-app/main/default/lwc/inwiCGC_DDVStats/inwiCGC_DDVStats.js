import { LightningElement, track } from 'lwc';
import getDemandesDeVisiteWithManagersAndSales from '@salesforce/apex/inwiCGC_DDVSController.getDemandesDeVisiteWithManagersAndSales';
import getTotalSalesByDemande from '@salesforce/apex/inwiCGC_DDVSController.getTotalSalesByDemande';
import getVisitOwnerManagers from '@salesforce/apex/inwiCGC_DDVSController.getVisitOwnerManagers';
import getCurrentUserRole from '@salesforce/apex/inwiCGC_DDVSController.getCurrentUserRole';
import SheetJS from '@salesforce/resourceUrl/SheetJS';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader'; 

export default class InwiCGC_DDVStats extends LightningElement {
    @track data = [];
    @track columns = [];
    @track startDate = null;
    @track endDate = null;
    xlsxjs;

    allColumns = [
        {
            label: 'Demande de Visite',
            fieldName: 'DemandeUrl',
            type: 'url',
            typeAttributes: { label: { fieldName: 'DemandeName' }, target: '_blank' },
        },
        { label: 'Date début', fieldName: 'PlannedStartTime', type: 'date' },
        { label: 'Date fin', fieldName: 'PlannedEndTime', type: 'date' },
        {
            label: 'Visite',
            fieldName: 'VisitUrl',
            type: 'url',
            typeAttributes: { label: { fieldName: 'VisitName' }, target: '_blank' },
        },
        { label: 'Date execution', fieldName: 'PlannedVisitStartTime', type: 'date' },
        { label: 'Région', fieldName: 'Region', type: 'text' },
        { label: 'Route', fieldName: 'Route', type: 'text' },
        { label: 'Circuit', fieldName: 'Circuit', type: 'text' },
        { label: 'Demande de visite Owner', fieldName: 'DDVOwner', type: 'text' },
        { label: 'Canal VI', fieldName: 'CanalVI', type: 'text' },
        { label: 'Manager VI', fieldName: 'ManagerVI', type: 'text' },
        { label: 'Operation VI', fieldName: 'OperationVI', type: 'text' },
        { label: 'MR', fieldName: 'MR', type: 'text' },
        { label: 'RVR', fieldName: 'RVR', type: 'text' },
        { label: 'Objectif SIM', fieldName: 'ObjectifSIM', type: 'number' },
        { label: '% Réalisé SIM', fieldName: 'PercentageSIM', type: 'text' },
        { label: 'Objectif SIM Dealer', fieldName: 'ObjectifSIMDealer', type: 'number' },
        { label: '% Réalisé SIM Dealer', fieldName: 'PercentageSIMDealer', type: 'text' },
        { label: 'Objectif SC', fieldName: 'ObjectifSC', type: 'number' },
        { label: '% Réalisé SC', fieldName: 'PercentageSC', type: 'text' },
        { label: 'Acteur Marché', fieldName: 'ActeurMarche', type: 'text' },
        { label: 'Visit Owner', fieldName: 'VisitorName', type: 'text' },
        { label: 'SIM Vendu', fieldName: 'SIMVendu', type: 'number', cellAttributes: { class: 'bold-text' }},
        { label: 'SIM Dealer Vendu', fieldName: 'SIMDealerVendu', type: 'number', cellAttributes: { class: 'bold-text' } },
        { label: 'SC Vendu', fieldName: 'SCVendu', type: 'number', cellAttributes: { class: 'bold-text' } },
        ];

    async connectedCallback() {
        await this.fetchUserRoleAndData();
        await loadScript(this, SheetJS);
        this.xlsxjs = window.XLSX;
        this.version = this.xlsxjs.version;
        console.log('version: '+this.version);      
    }

    async fetchUserRoleAndData() {
        try {
            const userRole = await getCurrentUserRole();
            console.log('User Role:', userRole);

            if (['Canal VI', 'Opération VI', 'Manager VI'].includes(userRole)) {
                this.columns = this.allColumns; 
            } else {
                this.columns = this.allColumns.filter((col) => 
                    !['Canal VI', 'Manager VI', 'Operation VI'].includes(col.label)
                );
            }

            this.fetchData();
        } catch (error) {
            console.error('Error fetching user role:', error);
        }
    }

    async fetchData() {
        try {
            const demandes = await getDemandesDeVisiteWithManagersAndSales();
            const demandeIds = demandes.map((d) => d.DemandeId);
            const ownerIds = demandes.map((d) => d.VisitorId);
            const salesTotals = await getTotalSalesByDemande({ demandeDeVisiteIds: demandeIds });
            const managers = await getVisitOwnerManagers({ visitorIds: ownerIds });
            console.log('owners:', ownerIds);
    
            this.fullData = demandes.map((demande) => {
                const totals = salesTotals[demande.DemandeId] || { TotalSIMVendu: 0, TotalSIMDealerVendu: 0, TotalSCVendu: 0 };
                const hierarchy = managers[demande.VisitorId] || {};
                console.log('hierarchy:', hierarchy);
    
                return {
                    DemandeUrl: `/lightning/r/inwiCGC_DemandeDeVisite__c/${demande.DemandeId}/view`,
                    DemandeName: demande.DemandeName,
                    PlannedStartTime: demande.PlannedStartTime,
                    PlannedEndTime: demande.PlannedEndTime,
                    VisitUrl: `/lightning/r/Visit/${demande.VisitId}/view`,
                    VisitName: demande.VisitName,
                    PlannedVisitStartTime: demande.PlannedVisitStartTime,
                    Region: demande.Region,
                    Route: demande.Route,
                    Circuit: demande.Circuit,
                    DDVOwner: demande.DDVOwner,
                    ActeurMarche: demande.ActeurMarche,
                    VisitorName: demande.VisitorName,
                    CanalVI: hierarchy.CanalVI || '',
                    ManagerVI: hierarchy.ManagerVI || '',
                    OperationVI: hierarchy.OperationVI || '',
                    MR: hierarchy.MR || '',
                    RVR: hierarchy.RVR || '',
                    SIMVendu: totals.TotalSIMVendu,
                    SIMDealerVendu: totals.TotalSIMDealerVendu,
                    SCVendu: totals.TotalSCVendu,
                    ObjectifSIM: demande.ObjectifSIM || 0,
                    ObjectifSIMDealer: demande.ObjectifSIMDealer || 0,
                    ObjectifSC: demande.ObjectifSC || 0,
                    PercentageSIM: this.calculatePercentage(totals.TotalSIMVendu, demande.ObjectifSIM),
                    PercentageSIMDealer: this.calculatePercentage(totals.TotalSIMDealerVendu, demande.ObjectifSIMDealer),
                    PercentageSC: this.calculatePercentage(totals.TotalSCVendu, demande.ObjectifSC),
                };
            });
    
            this.data = [...this.fullData];
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    }
    

    calculatePercentage(value, objectif) {
        if (!objectif || objectif === 0) {
            return '0%';
        }
        const percentage = ((value / objectif) * 100).toFixed(2);
        return `${percentage}%`;
    }

    exportToExcel() {
        console.log('Export File button clicked.');
    
        if (!this.data || this.data.length === 0) {
            console.error('No data available to export.');
            return;
        }
    
        try {
            const worksheetData = this.data.map((row) => {
                const formattedRow = {};
                this.columns.forEach((col) => {
                    let value = row[col.fieldName];
                    
                    if (col.fieldName === 'DemandeUrl') {
                        value = value ? value.split('/').slice(-2, -1)[0] : '';
                    } else if (col.fieldName === 'VisitUrl') {
                        value = value ? value.split('/').slice(-2, -1)[0] : '';
                    }
    
                    formattedRow[col.label] = value || '';
                });
                return formattedRow;
            });
    
            const workbook = window.XLSX.utils.book_new();
            const worksheet = window.XLSX.utils.json_to_sheet(worksheetData);
            window.XLSX.utils.book_append_sheet(workbook, worksheet, 'ExportedData');
    
            const excelBuffer = window.XLSX.write(workbook, { bookType: 'xlsx', type: 'array' });
            const blob = new Blob([excelBuffer], { type: 'application/octet-stream' });
    
            const link = document.createElement('a');
            link.href = URL.createObjectURL(blob);
            link.download = 'DemandesDeVisiteStats.xlsx';
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
    
            URL.revokeObjectURL(link.href);
    
            console.log('Export successful.');
        } catch (error) {
            console.error('Error exporting:', error);
        }
    }
    
    
    
    
    
    
    handleStartDateChange(event) {
        this.startDate = event.target.value;
        this.applyDateFilter();
    }
    
    handleEndDateChange(event) {
        this.endDate = event.target.value;
        this.applyDateFilter();
    }
    
    applyDateFilter() {
        const filteredData = this.fullData.filter((record) => {
            const visitDate = new Date(record.PlannedVisitStartTime);
            const startDate = this.startDate ? new Date(this.startDate) : null;
            const endDate = this.endDate ? new Date(this.endDate) : null;
    
            return (
                (!startDate || visitDate >= startDate) &&
                (!endDate || visitDate <= endDate)
            );
        });
        this.data = filteredData;
    }
    

}