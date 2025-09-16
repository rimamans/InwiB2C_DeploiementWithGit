public with sharing class InwiB2C_SimulationFacturation_Controller {
    public String name { get; set; }
    public Date dateActivForfait { get; set; }
    public String nomForfait { get; set; }
    public String detailsForfait { get; set; }
    public Integer frais { get; set; }
    public Date dateDemarrageForfait { get; set; }
    public Date dateLimitPaiement { get; set; }

    public InwiB2C_SimulationFacturation_Controller() {
        String orderId = ApexPages.currentPage().getParameters().get('orderid');

        if (String.isNotBlank(orderId)) {
            fetchOrderData(orderId);
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aucun Order ID fourni.'));
        }

        // Date d’activation et date de démarrage = date actuelle (date de génération du document)
        dateActivForfait = System.today();
        dateDemarrageForfait = System.today();

        // Calcul de la date limite de paiement
        dateLimitPaiement = calculatePaymentDeadline(dateDemarrageForfait);
    }

    public static Date calculatePaymentDeadline(Date startDate) {
        if (startDate == null) {
            return null;
        }

        //CH-Y Ticket B-27099 Begin
        // Date newDate = startDate.addDays(30);
        Date newDate = startDate.addMonths(1);
        //CH-Y Ticket B-27099 End

        // Vérification pour s'assurer que la date existe bien dans le mois (éviter 31 février)
        Integer lastDayOfMonth = Date.daysInMonth(newDate.year(), newDate.month());
        if (newDate.day() > lastDayOfMonth) {
            newDate = Date.newInstance(newDate.year(), newDate.month(), lastDayOfMonth);
        }

        return newDate;
    }

    private void fetchOrderData(String orderId) {
        try {
            Order ord = [
                SELECT Id, 
                       InwiB2C_FMS_Total__c, 
                       InwiB2C_Offre__c, 
                       Account.Name ,
                       InwiB2C_New_Account_Id__r.name,//chb 29/05/2025
                       inwiB2C_TypeDeMigration__c
                FROM Order
                WHERE Id = :orderId
                LIMIT 1
            ];

            if (ord != null) {
                //chb 29/05/2025
                //name = ord.Account.Name;
                name = ord.inwiB2C_TypeDeMigration__c=='InwiB2C_MigrationPrePostAvecIdentification'?ord.InwiB2C_New_Account_Id__r.name: ord.Account.Name;
                nomForfait = ord.InwiB2C_Offre__c + ' ' + ord.InwiB2C_FMS_Total__c + ' DH';
                detailsForfait = ord.InwiB2C_Offre__c;
                frais = Integer.valueOf(ord.InwiB2C_FMS_Total__c);
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Aucune commande trouvée pour cet Order ID.'));
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Erreur lors de la récupération des données : ' + e.getMessage()));
        }
    }
}