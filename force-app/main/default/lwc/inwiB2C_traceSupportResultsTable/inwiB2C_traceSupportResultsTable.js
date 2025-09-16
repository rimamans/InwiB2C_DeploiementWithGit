import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { NavigationMixin } from 'lightning/navigation';
import { OmniscriptActionCommonUtil } from 'vlocity_cmt/omniscriptActionUtils';

export default class InwiB2C_traceSupportResultsTable extends OmniscriptBaseMixin(NavigationMixin(LightningElement)) {
    @api recordpage_display;
    
    @api logincdc;
    @api dateenvoie;
    @api datereception;
    @api province;
    _actionUtilClass;
    // @track loginOptions = [];

    @track provinceVilleOptions = [];
    @track filteredProvinceVilleOptions = [];
    @track searchProvince = '';
    @track showOptions = false;
@track labelProvince;
    codeProvince;
    valueProvince;

    records;
    isLoading = true;

    columns = [
        { label: 'OrderID', fieldName: 'Name' },
        { label: 'Login SF du CDC', fieldName: 'inwiB2C_LoginSFCDC__c' },
        { label: 'Date d’envoi', fieldName: 'inwiB2C_dateEnvoi__c' },
        { label: 'Date de réception', fieldName: 'inwiB2C_dateReception__c' },
        { label: 'Province', fieldName: 'inwiB2C_ProvinceValue__c' },
        { label: 'Code Province', fieldName: 'inwiB2C_ProvinceCode__c' },
        { label: 'Commune', fieldName: 'inwiB2C_CommuneValue__c' },
        { label: 'Code Commune', fieldName: 'inwiB2C_CommuneCode__c' },
        { label: 'Quartier', fieldName: 'inwiB2C_QuartierValue__c' },
        { label: 'Code Quartier', fieldName: 'inwiB2C_QuartierCode__c' },
        { label: 'Voie', fieldName: 'inwiB2C_VoieValue__c' },
        { label: 'Code Voie', fieldName: 'inwiB2C_VoieCode__c' }
    ];


    handleLoginChange(event) {
    this.logincdc = event.detail.value;
    }

    handleDateEnvoiChange(event) {
        this.dateenvoie = event.detail.value.replace(/\//g, ":");     
    }

    handleDateReceptionChange(event) {
        this.datereception = event.detail.value.replace(/\//g, ":"); 
    }

    // handleProvinceChange(event) {
    //     this.province = event.detail.value;
    // }

    handleProvinceSearchChange(event) {
        const inputValue = event.target.value.toLowerCase();

        this.filteredProvinceVilleOptions = inputValue
            ? this.provinceVilleOptions.filter(option =>
                option.label.toLowerCase().includes(inputValue)
            )
            : [];

        this.showOptions = this.filteredProvinceVilleOptions.length > 0;
        this.labelProvince = event.target.value;
    }

    GetProvince() {
        this.showOptions = true;
    }

    handleProvinceSelect(event) {
        const selectedValue = event.currentTarget.dataset.value;
        console.log("Selected value:", selectedValue);
        const selectedOption = this.provinceVilleOptions.find(opt => opt.value === selectedValue);
        console.log("Selected option:", selectedOption);
        

        if (selectedOption) {
            this.labelProvince = selectedOption.label;
            this.searchProvince = selectedOption.label;
            this.codeProvince = selectedOption.value;
            this.valueProvince = selectedOption.label;
            this.province = selectedOption.label;
            this.showOptions = false;
        } else {
            console.warn("No matching option found.");
        }
    }




    connectedCallback() {
        this._actionUtilClass = new OmniscriptActionCommonUtil();

        this.fetchTraceSupportData()
            .then(() => {
                this.loadProvinceVille();
            });
    }


    fetchTraceSupportData() {
        const input = {
            loginCDC: this.logincdc,
            dateEnvoi: this.dateenvoie,
            dateReception: this.datereception,
            province: this.province
        };

        const params = {
            input: JSON.stringify(input),
            sClassName: 'inwiB2C_TraceSupportController',
            sMethodName: 'getFilteredTraceSupport',
            options: '{}',
        };

        this.isLoading = true;

        return this._actionUtilClass.executeAction(params, null, this, null, null)
            .then(response => {
                if (response && response.result && response.result.List) {
                    this.records = response.result.List;
                } else {
                    this.records = [];
                }
            })
            .catch(error => {
                console.error('Error fetching trace support records:', error);
                this.records = [];
            })
            .finally(() => {
                this.isLoading = false;
            });
    }


    // fetchLoginCDCOptions() {
    //     const params = {
    //         input: JSON.stringify({}),
    //         sClassName: 'inwiB2C_TraceSupportController',
    //         sMethodName: 'getUniqueLoginsCDC',
    //         options: '{}',
    //     };

    //     this._actionUtilClass.executeAction(params, null, this, null, null)
    //         .then(response => {
    //             if (response && response.result && response.result.List) {
    //                 console.log('Unique logins returned:', response.result.List);
                    
    //                 this.loginOptions = response.result.List.map(login => ({
    //                     label: login,
    //                     value: login
    //                 }));
    //             } else {
    //                 console.warn('No unique logins returned.');
    //                 this.loginOptions = [];
    //             }
    //         })
    //         .catch(error => {
    //             console.error('Error fetching LoginSFCDC values:', error);
    //         });
    // }

    loadProvinceVille() {
        let params = {
            input: JSON.stringify({
                keyword: "",
                search: "PROVINCES"
            }),
            sClassName: 'IntegrationProcedureService',
            sMethodName: "inwib2c_inwib2c_SearchAdresseIAM",
            options: {}
        };

        this._actionUtilClass.executeAction(params, null, this, null, null)
            .then((response) => {
                console.log("Provinces response:", response);
                if (response?.result?.IPResult?.results) {
                    this.provinceVilleOptions = response.result.IPResult.results.map(provinceVille => ({
                        label: provinceVille.libelle,
                        value: String(provinceVille.code)
                    }));
                    this.filteredProvinceVilleOptions = [...this.provinceVilleOptions];
                   // this.showOptions = this.filteredProvinceVilleOptions.length > 0;
                }
            })
            .catch((error) => {
                console.error("Erreur lors du chargement des provinces:", error);
            });

            
    }



    // handleUserSelection(event) {
    //     const userId = event.detail.value;

    //     if (userId) {
    //         this.getUsernameFromId(userId);
    //     }
    // }

    // getUsernameFromId(userId) {
    //     const params = {
    //         input: JSON.stringify({ userId }),
    //         sClassName: 'inwiB2C_TraceSupportController',
    //         sMethodName: 'getUsernameFromUserId',
    //         options: '{}',
    //     };

    //     this._actionUtilClass.executeAction(params, null, this, null, null)
    //         .then(response => {
    //             if (response && response.result && response.result.username) {
    //                 this.logincdc = response.result.username;
    //             }
    //         })
    //         .catch(error => {
    //             console.error('Error fetching username:', error);
    //         });
    // }


}