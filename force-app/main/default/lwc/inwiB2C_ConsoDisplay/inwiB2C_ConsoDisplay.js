import { LightningElement, api, track } from "lwc";
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin";
import template from "./inwiB2C_ConsoDisplay.html";
//import xlsx from "@salesforce/resourceUrl/inwiB2C_xlsx";
import { loadStyle, loadScript } from "lightning/platformResourceLoader";

export default class InwiB2C_ConsoDisplay extends OmniscriptBaseMixin(
  LightningElement
) {
  @api recordsString;
  @api consoType;

  @track defaultSortDirection = "asc";
  @track sortDirection = "asc";
  @track sortedBy;
  update = false;
  @track data = [];
  _totals = {
    totalDuration: 0,
    totalAmount: 0.0,
    totalGPRSVolume: 0,
  };

  get totals() {
    let totals = {
      totalDuration: 0,
      totalAmount: 0.0,
      totalGPRSVolume: 0,
    };

    if (this.data) {
      this.data.forEach((r, i) => {
        // 719 AAR 09/02/2021 BEGIN
        if (typeof r.M_TYPE_CONSO !== "undefined") {
          // 719 AAR 09/02/2021 BEGIN

          // 683 AAR 02/02/2021 BEGIN
          if (
            r.M_TYPE_CONSO.localeCompare("SMS_IC") != 0 &&
            r.M_TYPE_CONSO.localeCompare("SMS_OC") != 0
          )
            // 683 AAR 02/02/2021 BEGIN
            totals.totalDuration += parseInt(r.DURATION);

          // 719 AAR 09/02/2021 BEGIN
        }
        // 719 AAR 09/02/2021 BEGIN

        totals.totalAmount += parseFloat(r.M_AMOUNT_CON);
        totals.totalGPRSVolume += parseFloat(r.GPRS_VOLUME);
      });
    }

    totals.totalDuration = new Date(totals.totalDuration * 1000)
      .toISOString()
      .substr(11, 8);
    totals.totalGPRSVolume = this.formatBytes(totals.totalGPRSVolume);

    return totals;
  }

  @track showCard = false;

  @track
  columnsAll = [
    {
      fieldName: "M_LINE_ID",
      label: "Téléphone",
      hideDefaultActions: true,
      initialWidth: 120,
    },
    {
      fieldName: "M_START_DATE",
      label: "Date",
      hideDefaultActions: true,
      initialWidth: 180,
      type: "date",
      typeAttributes: {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit",
      },
    },
    {
      fieldName: "duraction2",
      label: "Durée",
      hideDefaultActions: true,
      initialWidth: 100,
    },
    {
      fieldName: "M_AMOUNT_CON",
      label: "Montant",
      sortable: true,
      type: "currency",
      typeAttributes: { currencyCode: "MAD" },
    },
    {
      fieldName: "GPRS_VOLUME2",
      label: "Volume",
      hideDefaultActions: true,
      initialWidth: 100,
    },
    {
      fieldName: "M_CALL_TYPE",
      label: "Type",
      hideDefaultActions: true,
      initialWidth: 60,
    },
    {
      fieldName: "CALL_DIRECTION",
      label: "Direction",
      hideDefaultActions: true,
      initialWidth: 80,
    },
    {
      fieldName: "FNFFLAG",
      label: "F&F",
      hideDefaultActions: true,
      initialWidth: 80,
    },
    {
      fieldName: "mainBal",
      label: "Balance Principale",
      hideDefaultActions: true,
      initialWidth: 150,
    },
    { fieldName: "M_SERVICE_NAME", label: "Service", hideDefaultActions: true },
    {
      label: "Balances",
      type: "button",
      initialWidth: 120,
      typeAttributes: {
        label: "Balances",
        name: "balanceDetails",
        title: "Cliquer ici pour le détail des balances",
      },
    },
  ];
  get columns() {
    console.log("this.consoType," + this.consoType);

    if (this.consoType == "DATA_ROAM") {
      console.log("this.consoType," + this.consoType);

      return [
        {
          fieldName: "M_START_DATE",
          label: "Date",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "M_END_DATE",
          label: "Date Fin",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "M_AMOUNT_CON",
          label: "Montant",
          sortable: true,

          hideDefaultActions: true,
          initialWidth: 120,
          type: "currency",
          typeAttributes: { currencyCode: "MAD" },
        },
        {
          fieldName: "M_CALL_TYPE",
          label: "Type",
          hideDefaultActions: true,
          initialWidth: 60,
        },
        {
          fieldName: "GPRS_VOLUME2",
          label: "Volume",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "mainBal",
          label: "Balance Principale",
          hideDefaultActions: true,
          initialWidth: 150,
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
        },
      ];
    } else if (this.consoType == "SMS_ROAM") {
      console.log("this.consoType," + this.consoType);

      return [
        {
          fieldName: "M_LINE_ID",
          label: "Téléphone",
          hideDefaultActions: true,
          initialWidth: 120,
        },
        {
          fieldName: "M_START_DATE",
          label: "Date Début",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "M_END_DATE",
          label: "Date Fin",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "CALLING_COUNTRYCODE",
          label: "Code Pays Source",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "CALLED_COUNTRYCODE",
          label: "Code Pays Destinataire",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "M_AMOUNT_CON",
          sortable: true,

          label: "Montant",
          hideDefaultActions: true,
          initialWidth: 120,
          type: "currency",
          typeAttributes: { currencyCode: "MAD" },
        },
        {
          fieldName: "M_CALL_TYPE",
          label: "Type",
          hideDefaultActions: true,
          initialWidth: 60,
        },
        {
          fieldName: "mainBal",
          label: "Balance Principale",
          hideDefaultActions: true,
          initialWidth: 150,
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
        },
      ];
    } else if (this.consoType == "VOIX_ROAM") {
      console.log("this.consoType," + this.consoType);

      return [
        {
          fieldName: "M_LINE_ID",
          label: "Téléphone",
          hideDefaultActions: true,
          initialWidth: 120,
        },
        {
          fieldName: "M_START_DATE",
          label: "Date",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "M_END_DATE",
          label: "Date Fin",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "duraction2",
          label: "Durée",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "BILLED_DURATION2",
          label: "Durée Facturée",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "M_AMOUNT_CON",
          label: "Montant",
          sortable: true,

          hideDefaultActions: true,
          initialWidth: 120,
          type: "currency",
          typeAttributes: { currencyCode: "MAD" },
        },
        {
          fieldName: "M_CALL_TYPE",
          label: "Type",
          hideDefaultActions: true,
          initialWidth: 60,
        },
        {
          fieldName: "CALLING_COUNTRYCODE",
          label: "Code Pays Source",
          hideDefaultActions: true,
          initialWidth: 150,
        },
        {
          fieldName: "CALLED_COUNTRYCODE",
          label: "Code Pays Destinataire",
          hideDefaultActions: true,
          initialWidth: 150,
        },
        {
          fieldName: "mainBal",
          label: "Balance Principale",
          hideDefaultActions: true,
          initialWidth: 150,
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
        },
      ];
    } else if (this.consoType == "ALL_DATA") {
      //B-0815 DLE 16/02/2021 begin
      console.log("this.consoType," + this.consoType);

      return [
        {
          fieldName: "M_LINE_ID",
          label: "Téléphone",
          hideDefaultActions: true,
          initialWidth: 120,
        },
        {
          fieldName: "M_AMOUNT_CON",
          label: "Montant",
          sortable: true,

          hideDefaultActions: true,
          initialWidth: 120,
          type: "currency",
          typeAttributes: { currencyCode: "MAD" },
        },
        {
          fieldName: "M_START_DATE",
          label: "Date",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "M_END_DATE",
          label: "Date Fin",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "GPRS_VOLUME2",
          label: "Volume",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "duraction2",
          label: "Durée",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "M_SERVICE_NAME",
          label: "Service",
          hideDefaultActions: true,
        },
        {
          fieldName: "mainBal",
          label: "Balance Principale",
          hideDefaultActions: true,
          initialWidth: 150,
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
        },
      ];
    } else if (this.consoType == "ALL_SMS") {
      return [
        {
          fieldName: "M_LINE_ID",
          label: "Téléphone",
          hideDefaultActions: true,
          initialWidth: 120,
        },
        {
          fieldName: "M_START_DATE",
          label: "Date",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
          },
        },
        {
          fieldName: "duraction2",
          label: "Durée",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "M_AMOUNT_CON",
          label: "Montant",
          sortable: true,

          hideDefaultActions: true,
          initialWidth: 120,
          type: "currency",
          typeAttributes: { currencyCode: "MAD" },
        },
        {
          fieldName: "M_CALL_TYPE",
          label: "Type",
          hideDefaultActions: true,
          initialWidth: 60,
        },
        {
          fieldName: "GPRS_VOLUME2",
          label: "Volume",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "CALL_DIRECTION",
          label: "Direction",
          hideDefaultActions: true,
          initialWidth: 80,
        },
        {
          fieldName: "FNFFLAG",
          label: "F&F",
          hideDefaultActions: true,
          initialWidth: 80,
        },
        {
          fieldName: "mainBal",
          label: "Balance Principale",
          hideDefaultActions: true,
          initialWidth: 150,
        },
        {
          fieldName: "M_SERVICE_NAME",
          label: "Service",
          hideDefaultActions: true,
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
        },
      ];
    } else if (this.consoType == "ALL_VOIX") {
      return [
        {
          fieldName: "M_LINE_ID",
          label: "Téléphone",
          hideDefaultActions: true,
          initialWidth: 120,
        },
        {
          fieldName: "M_START_DATE",
          label: "Date",
          hideDefaultActions: true,
          initialWidth: 180,
          type: "date",
          typeAttributes: {
            year: "numeric",
            month: "2-digit",
            day: "2-digit",
            hour: "2-digit",
            minute: "2-digit",
            second: "2-digit",
            sortable: true,
          },
        },
        {
          fieldName: "duraction2",
          label: "Durée",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "M_AMOUNT_CON",
          label: "Montant",
          sortable: true,

          hideDefaultActions: true,
          initialWidth: 120,
          type: "currency",
          typeAttributes: { currencyCode: "MAD" },
        },
        {
          fieldName: "GPRS_VOLUME2",
          label: "Volume",
          hideDefaultActions: true,
          initialWidth: 100,
        },
        {
          fieldName: "CALL_DIRECTION",
          label: "Direction",
          hideDefaultActions: true,
          initialWidth: 80,
        },
        {
          fieldName: "FNFFLAG",
          label: "F&F",
          hideDefaultActions: true,
          initialWidth: 80,
        },
        {
          fieldName: "mainBal",
          label: "Balance Principale",
          hideDefaultActions: true,
          initialWidth: 150,
        },
        {
          fieldName: "M_SERVICE_NAME",
          label: "Service",
          hideDefaultActions: true,
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
        },
      ];
    } else {
      //B-0815 DLE 16/02/2021 end
      return this.columnsAll;
    }
  }

  @track targetObject;
  @track draftValues = [];

  @track listBalData = [];
  @track
  listBalColumns = [
    {
      fieldName: "balLabel",
      label: "Nom de la balance",
      hideDefaultActions: true,
    },
    //B-0776 DLE 09/02/2021 BEGIN
    // {fieldName: 'balAmount', label: 'Montant', hideDefaultActions: true, type: 'currency', typeAttributes: { currencyCode: 'MAD' }},
    { fieldName: "balAmount", label: "Montant", hideDefaultActions: true },
    //B-0776 DLE 09/02/2021 END
  ];

  @track openBalanceDetail = false;
  openmodal() {
    this.openBalanceDetail = true;
  }
  closeModal() {
    this.openBalanceDetail = false;
  }

  handleBlur(evt) {
    this.omniUpdateDataJson(evt.target.value);
  }

  @track
  listBalRcapolumns = [
    { fieldName: "balId", label: "Id de la balance", hideDefaultActions: true },
    {
      fieldName: "balLabel",
      label: "Nom de la balance",
      hideDefaultActions: true,
    },
    {
      fieldName: "balCount",
      label: "Nombre d'utilisation",
      hideDefaultActions: true,
    },
    //B-0946 DLE 08/03/2021 BEGIN
    //{fieldName: 'balAmount', label: 'Montant', hideDefaultActions: true, type: 'currency', typeAttributes: { currencyCode: 'MAD' }},
    { fieldName: "balAmount", label: "Montant", hideDefaultActions: true },
    //B-0946 DLE 08/03/2021 END
  ];

  @api balanceList;

  @track openBalanceRecap = false;
  openmodalRecap() {
    this.openBalanceRecap = true;
  }
  closeModalRecap() {
    this.openBalanceRecap = false;
  }

  displayRecapBalance() {
    this.openmodalRecap();
  }

  get balanceListString() {
    return JSON.stringify(this.balanceList);
  }

  render() {
    //console.log(this.omniJsonData);
    return template;
  }

  get records2() {
    //let saveState = this.omniGetSaveState();

    //console.log(this.recordsString);

    let records = JSON.parse(this.recordsString);

    console.log("in records2 --------------", this.update);
    try {
      if (records && !this.update) {
        //console.log(records);
        if (Array.isArray(records)) {
          this.totalDuration = 0;
          this.totalAmount = 0.0;
          this.totalGPRSVolume = 0;
          records.forEach((r, i) => {
            r.Id = i;
            if (r.M_LISTEBAL.length > 0 && r.M_LISTEBAL[0].balLabel) {
              r.mainBal = r.M_LISTEBAL[0].balLabel;
            }
            // 719 AAR 09/02/2021 BEGIN
            if (typeof r.M_TYPE_CONSO !== "undefined") {
              // 719 AAR 09/02/2021 BEGIN

              // 683 AAR 02/02/2021 BEGIN
              if (
                r.M_TYPE_CONSO.localeCompare("SMS_IC") != 0 &&
                r.M_TYPE_CONSO.localeCompare("SMS_OC") != 0
              ) {
                // 683 AAR 02/02/2021 END
                console.log("is In the If");
                if (r.DURATION) {
                  r.duraction2 = new Date(r.DURATION * 1000)
                    .toISOString()
                    .substr(11, 8);
                }

                if (r.BILLED_DURATION) {
                  r.BILLED_DURATION2 = new Date(r.BILLED_DURATION * 1000)
                    .toISOString()
                    .substr(11, 8);
                }
                // 683 AAR 02/02/2021 BEGIN
              }
              // 683 AAR 02/02/2021 END

              // 719 AAR 09/02/2021 BEGIN
            }
            // 719 AAR 09/02/2021 END

            if (r.GPRS_VOLUME) {
              r.GPRS_VOLUME2 = this.formatBytes(parseFloat(r.GPRS_VOLUME));
            }
          });
          //console.log(records);

          this.showCard = true;
          this.data = records;
          this.update = false;
          return records;
        } else {
          let A = [];
          records.Id = 0;
          records.mainBal = records.M_LISTEBAL[0].balLabel;
          A.push(records);
          this.showCard = true;
          this.data = A;
          this.update = false;
          return A;
        }
      } else {
        this.update = false;
        return records;
      }
    } catch (error) {
      console.error(error);
    }
  }

  handleRowAction(event) {
    const action = event.detail.action;
    const row = event.detail.row;

    this.listBalData = row.M_LISTEBAL;

    this.openmodal();
  }

  formatBytes(bytes, decimals = 2) {
    if (bytes === 0) return "0 B";

    const k = 1000;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + " " + sizes[i];
  }

  connectedCallback() {
    //loadScript(this, leaflet + '/resource/inwiB2C_xlsx/leaflet.js')

    //loadResource (this, '/resource/inwiB2C_xlsx');

    Promise.all([loadScript(this, "/resource/inwiB2C_xlsx")]).then(() => {
      console.log("script loaded");
    });
  }

  downloadXls() {
    const XLSX = window.XLSX;

    /*
        ws: worksheet object
        C: 0-based index of the column you want to change, C = 1 means column "B"
        Z: number format string
        */
    function sheet_set_column_format(ws, C, Z) {
      var range = XLSX.utils.decode_range(ws["!ref"]);
      /* this loop starts on the second row, as it assumes the first row is a header */
      for (var R = range.s.r + 1; R <= range.e.r; ++R) {
        var cell = ws[XLSX.utils.encode_cell({ r: R, c: C })];
        if (!cell) continue;
        cell.t = Z;
      }
    }

    console.log("in download XML");

    console.log(XLSX);

    var objectRecords = this.records2;

    if (this.consoType == "ALL_DATA") {
      objectRecords = objectRecords.map(rec => ({
        Telephone: rec.M_LINE_ID,
        Date: rec.M_START_DATE,
        Duree: rec.duraction2,
        Montant: rec.M_AMOUNT_CON.toLocaleString("fr-FR"),
        Volume: rec.GPRS_VOLUME2,
        // TypeAppel: rec.M_CALL_TYPE,
        Direction: rec.CALL_DIRECTION,

        //FnF: rec.FNFFLAG,
        BalancePrincipale: rec.mainBal,
        NomService: rec.M_SERVICE_NAME,
      }));
    } else if (this.consoType == "ALL_VOIX") {
      objectRecords = objectRecords.map(rec => ({
        Telephone: rec.M_LINE_ID,
        Date: rec.M_START_DATE,
        Duree: rec.duraction2,
        Montant: rec.M_AMOUNT_CON.toLocaleString("fr-FR"),
        Volume: rec.GPRS_VOLUME2,
        Direction: rec.CALL_DIRECTION,
        FnF: rec.FNFFLAG,
        BalancePrincipale: rec.mainBal,
        NomService: rec.M_SERVICE_NAME,
      }));
    } else {
      objectRecords = objectRecords.map(rec => ({
        Telephone: rec.M_LINE_ID,
        Date: rec.M_START_DATE,
        Duree: rec.duraction2,
        Montant: rec.M_AMOUNT_CON.toLocaleString("fr-FR"),
        Volume: rec.GPRS_VOLUME2,
        TypeAppel: rec.M_CALL_TYPE,
        Direction: rec.CALL_DIRECTION,
        FnF: rec.FNFFLAG,
        BalancePrincipale: rec.mainBal,
        NomService: rec.M_SERVICE_NAME,
      }));
    }

    console.log(objectRecords);
    try {
      var ws = XLSX.utils.json_to_sheet(objectRecords);

      sheet_set_column_format(ws, 3, "n");

      console.log(ws);

      var wb = XLSX.utils.book_new();

      XLSX.utils.book_append_sheet(wb, ws, "Balances");

      console.log(wb);

      XLSX.writeFile(wb, "Balances.xlsx");
    } catch (error) {
      console.log(error);
    }
  }

  handleSortAccountData(event) {
    this.update = true;
    this.sortedBy = event.detail.fieldName;
    this.sortDirection = event.detail.sortDirection;
    this.sortAccountData(event.detail.fieldName, event.detail.sortDirection);
  }

  sortAccountData(fieldname, direction) {
    let parseData = JSON.parse(JSON.stringify(this.data));
    let keyValue = a => {
      return a[fieldname];
    };

    let isReverse = direction === "asc" ? 1 : -1;
    console.log("parseData", fieldname, direction, isReverse, parseData);

    parseData.sort((x, y) => {
      x = keyValue(x) ? keyValue(x) : "";
      y = keyValue(y) ? keyValue(y) : "";

      return isReverse * ((x > y) - (y > x));
    });

    this.data = parseData;
  }
}