global class InwiB2C_Invoices_Doc_Controller {

        
        public String DateTransaction {get;set;}
        public object  CIN {get; set;}
        public object Nom {get;set;}
        public object Prenom {get;set;}
        public object Quartier {get;set;}
        public object Ville {get;set;}
        public object Pays {get;set;}
        public object CodePointDeVente {get;set;}
        public object CodeAgent {get;set;}
        public object BillingAccount {get;set;}
    	public object ModeDePaiement{get;set;}
        public object TotalAmount{get;set;}
        public object FraisTimbre{get;set;}
        public object NumTransaction{get;set;}
        public object NumeroDeRecu{get;set;}
        public object FirstNameAgent{get;set;}
        public object LastNameAgent{get;set;}
        public List<Map<String, Object>> data{ get; set; }
        public String keys{ get; set; }
        
    
    
    public InwiB2C_Invoices_Doc_Controller() {
   
              Map<String, Object> root = (Map<String, Object>)JSON.deserializeUntyped(Apexpages.currentPage().getParameters().get('input'));
              system.debug('root'+root);
        List<Map<String, Object>> invoices = new List<Map<String, Object>>();
              for (Object instance : (List<Object>)root.get('data')){
                      invoices.add((Map<String, Object>)instance);
                    }
               data = invoices;
        
        for (String Invoice : invoices[0].keySet()){
            keys = keys + Invoice;
        
        System.debug('keys'+keys);
   }
            date dayString = date.today();
            DateTransaction = dayString.format();
            CIN= root.get('CIN');
            Nom= root.get('Nom');
            Prenom=root.get('Prenom');
            CodePointDeVente = root.get('CodePointDeVente');
            CodeAgent = root.get('CodeAgent'); 
            BillingAccount = root.get('BillingAccount'); 
            ModeDePaiement = root.get('ModeDePaiement'); 
            TotalAmount = root.get('TotalAmount'); 
            FraisTimbre = root.get('FraisTimbre');
            NumTransaction = root.get('NumTransaction');
            NumeroDeRecu = root.get('NumeroDeRecu');  
            FirstNameAgent = root.get('FirstNameAgent'); 
            LastNameAgent = root.get('LastNameAgent'); 
        }
}