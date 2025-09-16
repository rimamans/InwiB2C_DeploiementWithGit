//DLE 05/10/2020 begin
public class INWIB2C_CSDisplayCustomerMDNHistoryRep {
	 public CSOperationResultInfo CSOperationResultInfo ;
	 public list<CSDisplayCustomerMDNHistoryInteraction> CSDisplayCustomerMDNHistoryInteraction;
	
	public class CSOperationResultInfo{
		public String isOK;
		public String errorCode;
		public String errorMessage;
		public String uuid;
	}

	public class CSDisplayCustomerMDNHistoryInteraction{
		public String id;
		public String actionStatus;
		public String errorCode;
		public string errorMessage;
		public list<CSCustomerMDNTransaction> CSCustomerMDNTransaction;
		
	}
	
	public class CSCustomerMDNTransaction{
		public string sousType;
		 public list<dataItem> dataItem;
	}
	
	public class dataItem{
		 public String code ;
		 public String value ;
		 public String balance;
	}
	public static INWIB2C_CSDisplayCustomerMDNHistoryRep parse(String json) {
		return (INWIB2C_CSDisplayCustomerMDNHistoryRep) System.JSON.deserialize(json, INWIB2C_CSDisplayCustomerMDNHistoryRep.class);
	}
}
//DLE 05/10/2020 end