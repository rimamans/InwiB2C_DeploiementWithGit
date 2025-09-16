global with sharing class InwiB2C_ElligMigCycleFact implements vlocity_cmt.VlocityOpenInterface2 {
        global static boolean invokeMethod(String methodName, Map<String,Object> input, Map<String,Object> output, Map<String,Object> options) {        
         Boolean result = true;    
        try{
            
            if(methodName.equals('Elligible')){
                Elligible(input, output, options);                                                      
            }     
        } catch(Exception e){
                       
            result = false;
                    
        }     
        return result;            
   }
    public static void Elligible(Map<String, Object> deserialized,Map<String,Object> output, Map<String,Object> options){
        system.debug('start');
        String idcommmande = (String)deserialized.get('idcommmande');
		String cycleFac = (String)deserialized.get('cycleFac');
        system.debug('idcommmande '+idcommmande);
        system.debug('cycleFac '+cycleFac);
		Integer cycle = Integer.ValueOf(cycleFac);
		Integer month;
		Integer year;
		Integer day;
		Date debutCycle;
		Date finCycle;
		Date migrationDate;
		Boolean elligMig;

		//get Today
		DateTime td = System.now();
		Integer tdDay=td.day();
		Integer tdMonth=td.month();
		Integer tdYear=td.year();

		//get Migration order date
		List<Order> commandeMigration =  [Select id,CreatedDate from Order where Id=:idcommmande];
		For(Order item : commandeMigration){
		if(item.CreatedDate != null){ 
    		month = item.CreatedDate.month();
 			year= item.CreatedDate.year();
    		day = item.CreatedDate.day();
        }
        }
		migrationDate = date.newinstance(year, month, day);

		//set cycle facturation
		if(cycle == 1){
            debutCycle = date.newInstance(tdYear, tdMonth, 1);
     		finCycle =date.newInstance(tdyear, tdMonth+1, 1);
        }
		else{
            debutCycle = date.newInstance(tdYear, tdMonth-1, 18);
     		finCycle =date.newInstance(tdyear, tdMonth, 18);
        }

        //compare
		if (migrationDate < finCycle && migrationDate > debutCycle)
        {
            elligMig = false;}
		else 
        {
            elligMig = true;}
        output.put('elligibleMigCyc',elligMig);
    }

}