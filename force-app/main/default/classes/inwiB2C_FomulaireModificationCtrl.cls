public with sharing class inwiB2C_FomulaireModificationCtrl{
    public String idOrder{ get; set; }

    public String numeroLigne{ get; set; }

    public String offre_commerciale{ get; set; }

    public String dateCreation{ get; set; }

    public String fromos{ get; set; }

    public String description{ get; set; }

    public String motif{ get; set; }

    //
    Map<String, Object> ipInput = new Map<String, Object>();
    public Map<String, Object> ipOutput{ get; set; }

    Map<String, Object> ipOptions = new Map<String, Object>();
    public String keys{ get; set; }

    String orderDate{ get; set; }

    public inwiB2C_FomulaireModificationCtrl(){
        idOrder = Apexpages.currentPage().getParameters().get('orderid');
        fromos = Apexpages.currentPage().getParameters().get('fromos');
        ipInput.put('OrderId', idOrder);

        ipOutput = (Map<String, Object>)(vlocity_cmt.IntegrationProcedureService.runIntegrationService('inwib2c_inwiB2C_getFormulaireDemandeModificationInfos', ipInput, ipOptions));
        for (String item : ipOutput.keySet()){
            keys = keys + item;
        }

        // Get numero ligne
        numeroLigne = '';
        offre_commerciale = '';
        try{
            List<Object> entriesArray = (List<Object>)ipOutput.get('offre');
            for (Object inidividualEntries : entriesArray){
                Map<String, Object> ind = (Map<String, Object>)inidividualEntries;
                if (ind.get('TypeOffe') != null){
                    offre_commerciale = (String) ind.get('TypeOffe');
                }
                if (ind.get('NumLigne') != null){
                    numeroLigne = String.valueOf(ind.get('NumLigne'));
                }
            }
        } catch (Exception e){

        }

        // Date
        dateCreation = '';
        try{
            orderDate = String.valueOf(ipOutput.get('creationDate'));
            dateCreation = orderDate.mid(0, 10);
        } catch (Exception e){

        }

        // Description & Motif
        motif = '';
        description = '';
        try{
            if (fromos == 'suspension'){
                motif = (String) ipOutput.get('motifSuspension');
                description = 'Suspension';
            } else if (fromos == 'option'){
                String actionuser = Apexpages.currentPage().getParameters().get('actionuser');
                String actionnameuser = Apexpages.currentPage().getParameters().get('actionnameuser');
                if (actionuser != null && actionuser != 'null'){
                    motif = (String) actionuser + ' : ' + (String) actionnameuser;
                }
                description = 'Changement Options/Attributs';
            } else if (fromos == 'mdn'){
                description = 'Modification de numéro';
            }

        } catch (Exception e){

        }
    }

}