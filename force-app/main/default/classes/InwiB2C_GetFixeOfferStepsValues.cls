global with sharing class InwiB2C_GetFixeOfferStepsValues implements vlocity_cmt.VlocityOpenInterface2 {

    // MGEN3660 ILA 20/03/25 Start
    //  set display order
    public static final Map<String, Map<String, List<String>>> ORDER_MAP = new Map<String, Map<String, List<String>>>{
        'LastMile' => new Map<String, List<String>>{
            'FTTH' => new List<String>{'1', '4', '2', '3'},
            'ADSL' => new List<String>{'1', '2', '3', '4'}
        },
        'Rollback' => new Map<String, List<String>>{
            'FTTH' => new List<String>{'1', '4', '2', '3','5'},
            'ADSL' => new List<String>{'1', '2', '3', '4','5'}
        },
        'default' => new Map<String, List<String>>{
            'FTTH' => new List<String>{'1', '2', '3'},
            'ADSL' => new List<String>{'1', '2', '3', '4'},
            // M-Dj B-25479 24/04/25 ajouter l'order des step pour les smo porta 100% digitale begin
            'Prepaye' => new List<String>{'1', '2', '3', '4'},
            'Postpaye' => new List<String>{'1', '2', '3', '4'},
            'Cameleon' => new List<String>{'1', '2', '3', '4'}
            // M-Dj B-25479 24/04/25 ajouter l'order des step pour les smo porta 100% digitale begin
        }
    };
        // MGEN3660 ILA 20/03/25 End
    global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
         Boolean result = true;    
        try{
            if(methodName.equals('getSteps')){
                getSteps(input, output, options);                                                      
            }     
        } catch(Exception e){             
            result = false;        
        }     
        return result;            
   }
   
    public static void getSteps(Map<String, Object> inputs,Map<String,Object> output, Map<String,Object> options){
		Map<String, Object> input = (Map<String, Object>)inputs.get('steps');
        String orderId=inputs.get('orderId').toString();
        //get Parent Steps from response
        List<Map<String, Object>> ListParentTmp = new List<Map<String, Object>>();
        for (Object instance : (List<Object>)input.get('changeEvents')){
            Map<String,object> changeEvents=(Map<String, Object>)instance;
            Map<String,object> changeEvent=(Map<String, Object>)changeEvents.get('changeEvent');
            if(changeEvent.get('workfLowStep').toString().contains('EVENT_'))
            	ListParentTmp.add((Map<String, Object>)changeEvents.get('changeEvent')); 
        }

        //get offer type
        List<Object> parentsteps = new List<Object>();
        OrderItem parentItem = [SELECT id,vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c,Order.inwiB2C_Canal__c FROM OrderItem WHERE orderId =:orderId AND vlocity_cmt__ParentItemId__c = null ORDER BY createdDate asc LIMIT 1];
        String offerType=parentItem.vlocity_cmt__Product2Id__r.vlocity_cmt__Type__c;


        // MGEN3660 ILA 20/03/25 Start
        // get type de parcours
        string typeParcours=null;
        if(input.get('orderType').toString() =='LASTMILE')
            typeParcours='LastMile';
        else if(input.get('orderType').toString() =='Rollback FTTH vers IDAR' || input.get('orderType').toString() =='Rollback FTTH vers ADSL' || input.get('orderType').toString() =='Rollback ADSL vers IDAR')
            typeParcours='Rollback';

        //get display order 
        List<String> orderedEvents = getOrder(typeParcours, offerType);
        //get parentSteps
        List<InwiB2C_Fixe_Order_step__c> stepsTmp= [select InwiB2C_Code_Step__c, InwiB2C_Step__c,InwiB2C_statut__c, InwiB2C_hasVariable__c, InwiB2C_hasCondition__c, InwiB2C_variableName__c,InwiB2C_Operator__c ,InwiB2C_Conditon__c from InwiB2C_Fixe_Order_step__c where InwiB2C_Type_offre__c =:offerType and InwiB2C_Parent_step__c=null and InwiB2C_Type_de_Parcours__c =: typeParcours];
        // Crée un Map associant chaque code d'événement à son libellé
        Map<String, InwiB2C_Fixe_Order_step__c> codeToLibelleMap = new Map<String, InwiB2C_Fixe_Order_step__c>();
        for (InwiB2C_Fixe_Order_step__c event : stepsTmp) {
            codeToLibelleMap.put(event.InwiB2C_Code_Step__c, event);
        }
        //ordonner la liste selon l'order d'affichage definit dans ORDER_MAP
        List<InwiB2C_Fixe_Order_step__c> steps = new List<InwiB2C_Fixe_Order_step__c>();
        for (String eventCode : orderedEvents) {
            if (codeToLibelleMap.containsKey(eventCode)) {
                steps.add(codeToLibelleMap.get(eventCode));
            }
        }
        //get active parent

        //put all received codes in array
        List<String> receivedEvents=new List<String>();
        for(object iter : ListParentTmp){
            Map<String, Object> step = (Map<String, Object>)iter;
            receivedEvents.add(step.get('workfLowStep').toString().right(1));
        }
        Integer activeParentIndex = -1;
        Map<String, Object> activeParent;
        for (Integer i = 0; i < receivedEvents.size(); i++) {
            String eventCode = receivedEvents[i];
            Integer eventPriority = orderedEvents.indexOf(eventCode);
            // chercher le plus grand index dans eventOrder
            if (eventPriority > activeParentIndex) {
                activeParentIndex = eventPriority;
            }
        }
        String activeParentCode=orderedEvents[activeParentIndex];
        string activeParentEvent='EVENT_'+activeParentCode;
        for(object iter : ListParentTmp){
            Map<String, Object> step = (Map<String, Object>)iter;
            if(step.get('workfLowStep').toString() == activeParentEvent){
                activeParent=step;
                break;
            }
        }
        
        /*
        // LastMile 16/01/25 ILA Start 
        //Recuperer les etapes non lastMile qui seront affichés dans tous les cas
        List<String> stepsNotLACode=new List<String>();
        List<InwiB2C_Fixe_Order_step__c> stepsNotLA = [select InwiB2C_Code_Step__c, InwiB2C_Step__c,InwiB2C_statut__c, InwiB2C_hasVariable__c, InwiB2C_hasCondition__c, InwiB2C_variableName__c,InwiB2C_Operator__c ,InwiB2C_Conditon__c from InwiB2C_Fixe_Order_step__c where InwiB2C_Type_offre__c =:offerType and InwiB2C_Parent_step__c=null and InwiB2C_Type_de_Parcours__c = null  order by InwiB2C_Code_Step__c asc];
        //recuperer les codes des etapes non last mile
        for(InwiB2C_Fixe_Order_step__c tmp : stepsNotLA)
            stepsNotLACode.add(tmp.InwiB2C_Code_Step__c);
        
           
        // Recuperer les etapes de lastMile et les ajouter au debut de la liste des parents
        List<String> stepsLACode=new List<String>();
        List<InwiB2C_Fixe_Order_step__c> steps= new List<InwiB2C_Fixe_Order_step__c> ();
        if(input.get('orderType').toString() =='LASTMILE'){
            steps = [select InwiB2C_Code_Step__c, InwiB2C_Step__c,InwiB2C_statut__c, InwiB2C_hasVariable__c, InwiB2C_hasCondition__c, InwiB2C_variableName__c,InwiB2C_Operator__c ,InwiB2C_Conditon__c from InwiB2C_Fixe_Order_step__c where InwiB2C_Type_offre__c =:offerType and InwiB2C_Parent_step__c=null and InwiB2C_Type_de_Parcours__c = 'LastMile'  order by InwiB2C_Code_Step__c asc];
            //recuperer les codes des etapes last mile
            for(InwiB2C_Fixe_Order_step__c tmp : steps)
                stepsLACode.add(tmp.InwiB2C_Code_Step__c);
            //les etapes lastMile doivent etre affichées au debut
            steps.addAll(stepsNotLA);
        }
        else{
            steps=stepsNotLA;
        }
        
         // Rollback 16/01/25 ILA Start 
        //Recuperer les etapes rollback et les ajouter a la fin de liste des parents s il s'agit une migration intertechnologies
        if(input.get('orderType').toString() =='Rollback FTTH vers IDAR' || input.get('orderType').toString() =='Rollback FTTH vers ADSL' || input.get('orderType').toString() =='Rollback ADSL vers IDAR'){
            List<InwiB2C_Fixe_Order_step__c> stepsRollBack = [select InwiB2C_Code_Step__c, InwiB2C_Step__c,InwiB2C_statut__c, InwiB2C_hasVariable__c, InwiB2C_hasCondition__c, InwiB2C_variableName__c,InwiB2C_Operator__c ,InwiB2C_Conditon__c from InwiB2C_Fixe_Order_step__c where InwiB2C_Type_offre__c =:offerType and InwiB2C_Parent_step__c=null and InwiB2C_Type_de_Parcours__c = 'Rollback' order by InwiB2C_Code_Step__c asc];
            steps.addAll(stepsRollBack);
        }
         // Rollback 16/01/25 ILA End 


         //get active parent code
        Map<String, Object> activeParent;
        String activeParentCode;
		List<String> receveidSteps=new List<String>();
		//put all received codes in array
        for(object iter : ListParentTmp){
            Map<String, Object> step = (Map<String, Object>)iter;
            receveidSteps.add(step.get('workfLowStep').toString().right(1));
        }
        if(input.get('orderType').toString()=='LASTMILE'){
             List<String> receveidStepsTmp=new List<String> ();
            if(existsIn(receveidSteps,stepsNotLACode)){
                for(String iter : receveidSteps){
                    if(stepsNotLACode.indexOf(iter) != -1)
			            receveidStepsTmp.add(iter);          
                }
                receveidSteps=receveidStepsTmp;
            }
 		receveidSteps.sort(); 
		activeParentCode = receveidSteps[receveidSteps.size()-1];
        }
        else{
            receveidSteps.sort(); 
	        activeParentCode = receveidSteps[receveidSteps.size()-1];
        }

        //get the active parent
        string activeParentEvent='EVENT_'+activeParentCode;
        for(object iter : ListParentTmp){
            Map<String, Object> step = (Map<String, Object>)iter;
            if(step.get('workfLowStep').toString() == activeParentEvent){
                activeParent=step;
                break;
            }
        }
        // LastMile 16/01/25 ILA End 
        */
        

        //Recuperer les sub steps du parent active
        //ajouter la condition sur type de parcours
        List<InwiB2C_Fixe_Order_step__c> parentSubSteps = [select InwiB2C_Code_Step__c,InwiB2C_Parent_step__c, InwiB2C_Step__c,InwiB2C_statut__c, InwiB2C_hasVariable__c, InwiB2C_hasCondition__c, InwiB2C_variableName__c,InwiB2C_Operator__c ,InwiB2C_Conditon__c from InwiB2C_Fixe_Order_step__c where InwiB2C_Type_offre__c =:offerType and InwiB2C_Parent_step__c=:activeParentCode and InwiB2C_Type_de_Parcours__c =: typeParcours order by InwiB2C_Code_Step__c asc];

        //get final step code
        /*
        // LastMile 16/01/25 ILA Start 
        //String finalStepCode = steps.get(steps.size() - 1).InwiB2C_Code_Step__c;
        String finalStepCode = stepsNotLA.get(stepsNotLA.size() - 1).InwiB2C_Code_Step__c;
        // LastMile 16/01/25 ILA End 
        */

        String finalStepCode=orderedEvents[orderedEvents.size() - 1];

        // MGEN3660 ILA 20/03/25 End
        
        //get last degroupage request
        string degId;
        string degName;
        if(offerType == 'ADSL'){
            List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandeDeg = [select id,name from INWIB2C_DEMANDE_DEGROUPAGE__c where InwiB2C_Order__c =:orderId order by createdDate desc limit 1];
            if (demandeDeg.size() > 0){
                degId=demandeDeg[0].id;
                degName=demandeDeg[0].name;
            }
        }
        
        for(InwiB2C_Fixe_Order_step__c iter : steps){
            //get parent steps
            Map<String,Object> parentTmp = new Map<String,Object>();
            parentTmp.put('name',iter.InwiB2C_Step__c);
            parentTmp.put('code',iter.InwiB2C_Code_Step__c);
            //get date of event from api response
            for(object eventApi : ListParentTmp){
                Map<String, Object> iterparent = (Map<String, Object>)eventApi;
                String codeTmp = iterparent.get('workfLowStep').toString().right(1);
                if(codeTmp==iter.InwiB2C_Code_Step__c)
                    parentTmp.put('date',iterparent.get('eventOccursTime'));    
            }
                
            //current step
            if(iter.InwiB2C_Code_Step__c == activeParentCode){
                if(activeParentCode == finalStepCode)
                    parentTmp.put('statut','Complete');
                else
                parentTmp.put('statut','Active');
                //get subSteps
                List<object> subSteps=(List<Object>)activeParent.get('subEvents');
                //no subSteps
                 //B-19750 19/09/24 ILA Start//
                //if(subSteps == null ||( subSteps != null && subSteps.size()==0)){
                if(subSteps == null ||( subSteps != null && subSteps.size()==0) || activeParentCode == finalStepCode){
                //B-19750 19/09/24 ILA END//
                    parentTmp.put('showSubSteps','false');
                    // get label to display
                    if(iter.InwiB2C_hasCondition__c == true){
                        InwiB2C_DynamicCondition op=new InwiB2C_EqualDynamicCondition();
                        List<String> lstString = iter.InwiB2C_statut__c.split(',');
                        if((Boolean)op.evaluate(input.get(iter.InwiB2C_variableName__c), iter.InwiB2C_Conditon__c))
                            parentTmp.put('name',iter.InwiB2C_Step__c+' : '+lstString[0]);
                        else
                            parentTmp.put('name',iter.InwiB2C_Step__c+' : '+lstString[1]);
                        
                    }
                    else if(iter.InwiB2C_hasVariable__c == true){
                        List<String> variablesName=iter.InwiB2C_variableName__c.split(',');
                        List<String> statutList=iter.InwiB2C_statut__c.split(',');
                        for(String a : statutList)
                            system.debug(a);
                        String statut = statutList[0];
                        Integer i=0;
                        for(Integer j=1;j<statutList.size();j++){
                            if(statutList[j] != '{X}')
                                statut = statut +' '+ statutList[j];
                            else{
                                statut = statut +' '+input.get(variablesName[i]);
                                i++;
                            }
                        } 
                        parentTmp.put('name',statut);
                    }
                    else{
                        parentTmp.put('name',iter.InwiB2C_statut__c);
                    }
                  
                } 
                //parent with subSteps
                else{
                    parentTmp.put('showSubSteps','true');
                    List<Object> substepsFinal = new List<Object>();
                    for(object subStep: subSteps){ 
                        Map <String,Object> subEvents=(Map <String,Object>)subStep;
                        Map <String,Object> subEvent=(Map <String,Object>)subEvents.get('subEvent');
                        //get subStepCode
                        String subStepCode=subEvent.get('workflowStep').toString().right(2);
                        for(InwiB2C_Fixe_Order_step__c iterSub:parentSubSteps){
                            Map<String,Object> subStepTmp = new Map<String,String>();
                            if(iterSub.InwiB2C_Code_Step__c == subStepCode){
                                subStepTmp.put('code',iterSub.InwiB2C_Code_Step__c);
                                subStepTmp.put('statut','Complete');
                                subStepTmp.put('date',subEvent.get('eventOccursTime'));
                                //get label
                                if(iterSub.InwiB2C_hasCondition__c == true){
                                    InwiB2C_DynamicCondition op=new InwiB2C_EqualDynamicCondition();
                                    List<String> lstString = iterSub.InwiB2C_statut__c.split(',');
                                    if((Boolean)op.evaluate(input.get(iterSub.InwiB2C_variableName__c), iterSub.InwiB2C_Conditon__c))
                                        subStepTmp.put('name',iterSub.InwiB2C_Step__c+' : '+lstString[0]);
                                    else
                                        subStepTmp.put('name',iterSub.InwiB2C_Step__c+' : '+lstString[1]);
                                }
                                else if(iterSub.InwiB2C_hasVariable__c == true){
                                    List<String> variablesName=iterSub.InwiB2C_variableName__c.split(',');
                                    List<String> statutList=iterSub.InwiB2C_statut__c.split(',');
                                    for(String a : statutList)
                                        system.debug(a);
                                    String statut = statutList[0];
                                    Integer i=0;
                                    for(Integer j=1;j<statutList.size();j++){
                                        if(statutList[j] != '{X}')
                                            statut = statut +' '+ statutList[j];
                                        else{
                                            statut = statut +' '+input.get(variablesName[i]);
                                            i++;
                                        }
                                    } 
                                    subStepTmp.put('name',statut);
                    }
                    else{
                        subStepTmp.put('name',iterSub.InwiB2C_statut__c);
                    }   
                                substepsFinal.add(subStepTmp);   
                                break;
                            }   
                        }  
                    }
                    parentTmp.put('subSteps',substepsFinal);  
                }     
            }

             // MGEN3660 ILA 20/03/25 Start
            // LastMile 16/01/25 ILA Start 
            else{
                //recuperer l'index en cours
                integer indexEvent = getEventIndex(typeParcours, offerType, iter.InwiB2C_Code_Step__c);
                //finished step
                if(indexEvent < activeParentIndex){
                    parentTmp.put('showSubSteps','false');
                    parentTmp.put('statut','Complete');
                }
                //futur step 	
                else{
                    parentTmp.put('showSubSteps','false');
                    parentTmp.put('statut','NotActive');
                }

            }
            /*
            else{
                if(input.get('orderType').toString()=='LASTMILE'){
                    //si l'étape active est une étape lastMile
                    if(stepsLACode.contains(activeParentCode)){
                        //si l'iterateur est sur une etape lastMile
                        if(stepsLACode.contains(iter.InwiB2C_Code_Step__c)){
                            if(iter.InwiB2C_Code_Step__c < activeParentCode){
                                parentTmp.put('showSubSteps','false');
                                parentTmp.put('statut','Complete');
                            }
                            else{
                                parentTmp.put('showSubSteps','false');
                                parentTmp.put('statut','NotActive');
                            }

                        }
                        else{
                            //toutes les etapes non lastmile seront pas actives
                            parentTmp.put('showSubSteps','false');
                            parentTmp.put('statut','NotActive');
                        }
                    }
                    else{
                        //les etapes last mile seront completed
                        if(stepsLACode.contains(iter.InwiB2C_Code_Step__c)){
                            parentTmp.put('showSubSteps','false');
                            parentTmp.put('statut','Complete');
                        }
                        else{
                            if(iter.InwiB2C_Code_Step__c < activeParentCode){
                                parentTmp.put('showSubSteps','false');
                                parentTmp.put('statut','Complete');
                            }	
                            else{
                                parentTmp.put('showSubSteps','false');
                                parentTmp.put('statut','NotActive');
                            } 

                    }

                }

                }
                else{
                    //finished step
                    if(iter.InwiB2C_Code_Step__c < activeParentCode){
                        parentTmp.put('showSubSteps','false');
                        parentTmp.put('statut','Complete');
                    }
                    //futur step 	
                    else{
                        parentTmp.put('showSubSteps','false');
                        parentTmp.put('statut','NotActive');
                    }
                }
            }
            //LastMile 16/01/25 ILA End 
            */
             // MGEN3660 ILA 20/03/25 End
        parentsteps.add(parentTmp); 
    }

    //REG3--ne pas afficher event 1 et 2 pour adsl et event 1 pour ftth pour PDV
    if(parentItem.Order.inwiB2C_Canal__c =='Point de vente'){
        for (Integer i = (parentsteps.size()-1) ; i>= 0 ; i--){
			Map<String,object> changeEvents=(Map<String, Object>)parentsteps[i];
            if(offerType=='ADSL'){
                if(changeEvents.get('code')=='1' || changeEvents.get('code')=='2')
                    parentsteps.remove(i);
            }
            else{
                if(changeEvents.get('code')=='1')
                    parentsteps.remove(i);
            }
        }
    }  
        output.put('steps',parentsteps);
        output.put('typeOffer',offerType);
        output.put('demandeDegId',degId);
        output.put('demandeDegName',degname);
}

    // MGEN3660 ILA 20/03/25 Start 
    /*
    // LastMile 16/01/25 ILA Start 
    public static boolean existsIn(List<String> toSearch, List<String> values)
    {
        for (String i : values)
        {
            for (String j : toSearch)
            {
                if (j == i)
                {
                    return true;
                }
            }
        }
        return false;
    }
    //  LastMile 16/01/25 ILA End 
    */
    //recuperer l'order des event
    public static List<String> getOrder(String parcours, String typeOffre) {
        // Utiliser la valeur par défaut si parcours est null
        String parcoursFinal = (parcours != null) ? parcours : 'default';
        if (ORDER_MAP.containsKey(parcoursFinal) && ORDER_MAP.get(parcoursFinal).containsKey(typeOffre)) {
            return ORDER_MAP.get(parcoursFinal).get(typeOffre);
        }
        return new List<String>(); // Retourne une liste vide si la combinaison n'existe pas
    }
    //recuperer l'index de l'event dans la map d'affichage
    public static Integer getEventIndex(String parcours, String typeOffre, String eventName) {
        String parcoursFinal = (parcours != null) ? parcours : 'default';
        if (ORDER_MAP.containsKey(parcoursFinal)) {
            Map<String, List<String>> typeMap = ORDER_MAP.get(parcoursFinal);  
            if (typeMap.containsKey(typeOffre)) {
                List<String> events = typeMap.get(typeOffre);
                
                return events.indexOf(eventName); 
            }
        }
        return -1; 
    }
    // MGEN3660 ILA 20/03/25 End
}