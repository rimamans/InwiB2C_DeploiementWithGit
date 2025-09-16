import { LightningElement , api , track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import template from './inwiB2C_Historique_PromoF_F.html';

export default class InwiB2C_Historique_PromoF_F extends OmniscriptBaseMixin(LightningElement) {

  stockeceddata = [];
  pickListvalues = [];
  pickListvalues2 = [];
  pickListvalues3 = [];
  ballist = [];
  _records;


  @api
  get records() {
    console.log("_records ", this._records)
    let t = JSON.parse(JSON.stringify(this._records));
    console.log("t", t)
    let temp = Object.values(this._records)

    if (this._records.length != 0 && this.stockeceddata.length == 0) {

      this.stockeceddata = JSON.parse(JSON.stringify(temp));
      this.pickListvalues = this.stockeceddata.map(element => {
        let v1 = {
          "value": element.M_AMOUNT_CON,
          "label": element.M_AMOUNT_CON
        }
        return v1;
      })

      let allElement = {
        "value": 'all',
        "label": 'Tout'
      }


      this.pickListvalues.unshift(allElement)

      this.pickListvalues = this.pickListvalues.filter((thing, index, self) =>
        index === self.findIndex((t) => (
          t.value === thing.value && t.label === thing.label
        ))
      )

      console.log("stockdata ", this.stockeceddata);

      //return this.stockeceddata
    }



    if (temp.length != 0)

      return temp;
  }

  set records(value) {
    this._records = { ...value };
  }


  @track columns = [
    { fieldName: 'M_MOTIF_RECH_LIBELLE', label: 'Libellé ', hideDefaultActions: true, initialWidth: 180 },
    { fieldName: 'M_AMOUNT_CON', label: 'Prix', hideDefaultActions: true, initialWidth: 120, type: 'currency', typeAttributes: { currencyCode: 'MAD' } },
    {
      fieldName: 'M_TRANSAC_DATE', label: 'Date/heure de transaction', hideDefaultActions: true, initialWidth: 180, type: 'date', typeAttributes: {
        day: 'numeric',
        month: 'short',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour24: true
      }
    },

    {
      label: "Balances",
      type: "button",
      initialWidth: 120,
      typeAttributes: {
        label: "Balances",
        name: "balanceDetails",
        title: "Cliquer ici pour le détail des balances",
      },
    }
  ];




  @track targetObject;
  @track draftValues = [];


  updateSearch(event) {
    console.log('event.target.value :' + event.target.value)


    let regex = new RegExp(event.target.value, 'gi')
    this.records = this.stockeceddata.filter(
      row => regex.test(row.M_AMOUNT_CON)
    );
    this.records = (event.target.value == '' || event.target.value == 'all') ? this.stockeceddata : this.records;

  }



  @track openBalanceDetail = false;
  openmodal(event) {
    this.openBalanceDetail = true;
    const row = event.detail.row;
    console.log("row" + row);

    this.ballist = row.listbal;
    console.log("this.ballist" + this.ballist);

  }
  closeModal() {
    this.openBalanceDetail = false;
  }

  displayRecapBalance() {
    const actionName = 'balance';

    this.openmodalRecap();
  }
  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;

    this.listBalData = row.M_LISTEBAL;

    this.openmodal();
  }

  @track listbal = [];
  @track
  listBalColumns = [
    {
      fieldName: "name",
      label: "Nom de la balance",
      hideDefaultActions: true,
    },
    { fieldName: "value", label: "Montant", hideDefaultActions: true },
  ];

  render() {

    return template;
  }
}