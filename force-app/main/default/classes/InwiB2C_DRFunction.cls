global class InwiB2C_DRFunction implements vlocity_cmt.VlocityOpenInterface{
    global Boolean invokeMethod(String methodName, Map<String, Object> inputs, Map<String, Object> output, Map<String, Object> options)
    {
        if (methodName == 'toLabel')
        {
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', toLabel(arguments));
        }
        /*Boost FTTH ILA 18/05/2024  Start */
        if (methodName == 'eligibileBoostFTTH')
        {
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', eligibileBoostFTTH(arguments));
        }
        /*Boost FTTH ILA 18/05/2024  End */
         if (methodName == 'FormatInputImx'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', FormatInputImx(arguments));
        }
        /*B-15152 21/05/2024 Ila Start*/
         if (methodName == 'elligibleCHT'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', elligibleCHT(arguments));
        }
        /*B-15152 21/05/2024 Ila End*/
        /*Degroupage 05/09/2024 Ila Start*/
        if (methodName == 'WorkDayCounter'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', WorkDayCounter(arguments));
        }
        /*Degroupage 05/09/2024 Ila End*/
        /**Confirmation MES 25/09/2024 Start */
        if (methodName == 'calculWorkingDay'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', calculWorkingDay(arguments));
        }
        if(methodName == 'HoursDiff'){
            List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', HoursDiff(arguments));
        }
        /**Confirmation MES 25/09/2024 End */
        /**B-23489 ILA 25/12/24 start */
        if((methodName == 'AddHours')){
           List<Object> arguments = (List<Object>)inputs.get('arguments');
            output.put('result', AddHours(arguments));
        }
        /**B-23489 ILA 25/12/24 End */
        return true;
    }
    /**B-23489 ILA 25/12/24 start */
    public DateTime AddHours(List<Object> arguments){
            DateTime inputDate =(DateTime)JSON.deserialize('"'+String.valueOf(arguments[0])+'"', DateTime.class);
            Integer hours = Integer.valueOf(String.valueOf(arguments[1]));
            DateTime outputDate =inputDate.addHours(hours);
            return outputDate;
    }
    /**B-23489 ILA 25/12/24 end */
    /**Confirmation MES 25/09/2024 Start */
    public Long HoursDiff(List<Object> arguments){
        DateTime inputDate1 =(DateTime)JSON.deserialize('"'+String.valueOf(arguments[0])+'"', DateTime.class);
        DateTime inputDate2 =(DateTime)JSON.deserialize('"'+String.valueOf(arguments[1])+'"', DateTime.class);
        Long dt1Long = inputDate1.getTime();
        Long dt2Long = inputDate2.getTime();
        Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
        Long hours = minutes / 60;
        return hours;
    }
    public DateTime calculWorkingDay(List<Object> arguments){
        //DateTime inputDate = Date.valueOf(String.valueOf(arguments[0]));
        DateTime inputDate =(DateTime)JSON.deserialize('"'+String.valueOf(arguments[0])+'"', DateTime.class);
        Integer counter = Integer.valueOf(String.valueOf(arguments[1]));
        Integer i=0;
        Set<Date> holidays = new Set<Date>();
        for (InwiB2C_Holidays__c holiday : [SELECT inwib2c_date__c FROM InwiB2C_Holidays__c WHERE inwib2c_date__c >= :inputDate.date()]) {
            holidays.add(holiday.inwib2c_date__c);
        }
        while(i<counter){
            inputDate=inputDate.addDays(1);
            Integer dayOfWeek = Integer.valueOf(inputDate.format('u'));
            if(dayOfWeek != 6 && dayOfWeek != 7 && !holidays.contains(inputDate.date()))
                i++; 
        }
        return inputDate;
    }
    
     /**Confirmation MES 25/09/2024 End */
    /*Degroupage 05/09/2024 Ila Start*/
    public Integer WorkDayCounter(List<Object> arguments){
        date inputDate = Date.valueOf(String.valueOf(arguments[0]));
        return InwiB2C_WorkDaysCounter.countTotalDaysForWorkingDays(inputDate);     
    }
    /*Degroupage 05/09/2024 Ila End*/

    /*B-15152 21/05/2024 Ila Start*/
        public boolean elligibleCHT (List<Object> arguments){
            String nd=String.valueOf(arguments[0]);
            boolean elligible = true;
            List<INWIB2C_DEMANDE_DEGROUPAGE__c> demandes = [select id,InwiB2C_ORDER_DEGROUPAGE_NUM__c,InwiB2C_Statutdegroupage__c  from INWIB2C_DEMANDE_DEGROUPAGE__c where InwiB2C_typeCommande__c='CT' and (InwiB2C_NumeroDesignation__c=: nd or InwiB2C_ndOperateur__c =: nd)];
            map<String,Set<String>> groupedDemandes = new map<String,Set<String>>();
            for (INWIB2C_DEMANDE_DEGROUPAGE__c demande : demandes){
                String Norder = demande.InwiB2C_ORDER_DEGROUPAGE_NUM__c;
                if(!groupedDemandes.containsKey(Norder)){
                    Set<String> listTmp = new Set<String>();
                    for (INWIB2C_DEMANDE_DEGROUPAGE__c demandeiter : demandes){
                        if(demandeiter.InwiB2C_ORDER_DEGROUPAGE_NUM__c == Norder)
                            listTmp.add(demandeiter.InwiB2C_Statutdegroupage__c);
                    }
                    groupedDemandes.put(Norder,listTmp);
                }
            }
            for(string key : groupedDemandes.keySet()){
                if(!groupedDemandes.get(key).contains('REU')){
                    elligible=false;
                    break;
                }   
            }
            return elligible;
        }
        /*B-15152 21/05/2024 Ila End*/
    
    /*Boost FTTH ILA 18/05/2024  Start */
    public boolean eligibileBoostFTTH(List<Object> arguments){
        String subId=String.valueOf(arguments[0]);
        DateTime debutCycle;
        DateTime finCycle;
        decimal price=0;
        //get billing account and offre
        vlocity_cmt__Subscription__c ligne = [Select vlocity_cmt__BillingAccountId__r.InwiB2C_Cycle_de_facturation__c,vlocity_cmt__AccountId__c from vlocity_cmt__Subscription__c  where id=:subId];
        //get offre from asset
        Asset asset = [select id,ProductCode from asset where vlocity_cmt__SubscriptionId__c=:subId ];
        //set cycle dates
        Date todayDate = system.today();
        Integer todayDay = todayDate.day();
        Integer todayMonth = todayDate.month();
        Integer todayYear = todayDate.year();
        if(ligne.Vlocity_cmt__BillingAccountId__r.InwiB2C_Cycle_de_facturation__c == '18'){
            if(todayDay<=17){
        		debutCycle=date.newInstance(todayYear, todayMonth-1, 18);
    			finCycle=date.newInstance(todayYear, todayMonth, 17);
    		}
    		else{
       			debutCycle=date.newInstance(todayYear, todayMonth, 18);
    			finCycle=date.newInstance(todayYear, todayMonth+1, 17);  
    		}
    
		}
        else{
            //get last day of the month
            Integer numberOfDays = Date.daysInMonth(todayDate.year(), todayDate.month());
            debutCycle=date.newInstance(todayYear, todayMonth, 1);
            finCycle=date.newInstance(todayYear, todayMonth, numberOfDays);
		}
        //get plafond
   		List<AggregateResult> historique = [Select sum(InwiB2C_Prix__c) from InwiB2C_Historique_Boost_FTTH__c where InwiB2C_Account__c=: ligne.vlocity_cmt__AccountId__c and InwiB2C_Date_activation__c >=: debutCycle and InwiB2C_Date_activation__c <=:finCycle];
    	if(historique.size() > 0 && (Decimal)historique[0].get('expr0') != null){
        	price = (Decimal)historique[0].get('expr0');
    	}
        //check elligibility
        boolean eligible=false;
		if(asset.ProductCode=='INWIB2C_OFFERING_FTTH20MG_249DH' && price <350)
			eligible = true;  
		if(asset.ProductCode =='INWIB2C_OFFERING_FTTH50MG_349DH' && price <400)
    		eligible = true;
        /**MGEN3770 08/08/25 K-KA Start */
        if(asset.ProductCode =='INWIB2C_OFFERING_FTTH100MG_449DH' && price <450)
    		eligible = true;
        /**MGEN3770 08/08/25 K-KA End */
        return eligible;
    }
    /*Boost FTTH ILA 18/05/2024  End */
    
    public String toLabel(List<Object> arguments){
        String objet = String.valueOf(arguments[0]);
		String champ = String.valueOf(arguments[1]);
        String objetId = String.valueOf(arguments[2]);
        String output = '';
        Try {
		String query = 'Select toLabel('+champ+') From '+objet+' where Id=\''+objetId+'\'';
        List<SObject> records = Database.query(query);
        Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(records[0]));
            output= String.valueof(deserialized.get(champ));
        }catch(Exception e){
            System.debug('Exception Message toLabelClass: '+e.getMessage());
        }
        return output;
        
        
    }
    
    List<Map<String, Object>> FormatInputImx(List<Object> arguments){
        List<Map<String, Object>> output = new List<Map<String, Object>>();

        for (Integer i = 0; i < arguments.size(); i++){
            Map<String, Object> item = new Map<String, Object>();
            String type = String.valueOf(arguments[3]);
            item.put('value', arguments[i] != null && arguments[i] != 'null' ? arguments[i] : '');
            switch  on i{
                when 0{
                    item.put('code', 'DISTRIBUTOR');
                }
                when 1{
                    item.put('code', 'ENGAGEMENT');
                }
                when 2{
                    item.put('code', 'IN_TSRM');
                }
                when 3{
                    item.put('code', 'CONTRACT_TYPE');
                }
                when 4{
                    if(type == 'ADSL')
                    	item.put('code', 'ACCESS_TECHNOLOGY');
                    else
                        break;
                }
                when 5{
                    if(type == 'ADSL')
                    	item.put('code', 'ACTION_AUTH_IMX');
                    else
                        break;
                }
            }
            output.add(item);
        }

        return output;
    }

}