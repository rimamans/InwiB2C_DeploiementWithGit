//DLE 05/10/2020 begin
public with sharing class INWIB2C_CSDisplayCustomerMDNHistoryReq {
public CSDisplayCustomerMDNHistoryInteraction CSDisplayCustomerMDNHistoryInteraction ;
	public CSOperationInfo CSOperationInfo;

	public class CSDisplayCustomerMDNHistoryInteraction{
		public string id;
		public string historyType;
		public CSCustomer CSCustomer;
		public CSDisplayCustomerMDNHistoryInteraction (string id , string historyType , CSCustomer CSCustomer){
			this.id = id;
			this.historyType = historyType;
			this.CSCustomer = CSCustomer;
		}
	}
	public class CSCustomer{
		public CSOrder CSOrder;
		public CSCustomer(CSOrder CSOrder){
			this.CSOrder = CSOrder;
		}
	}
	public class CSOrder{
		public CSOffer CSOffer;
		public CSOrder(CSOffer CSOffer ){
			this.CSOffer = CSOffer;
		}
	}
	public class CSOffer{
		public CSProduct CSProduct;
		public CSOffer(CSProduct CSProduct){
			this.CSProduct = CSProduct;
		}
	}
	public class CSProduct{
		public CSMobileDirectoryNumber CSMobileDirectoryNumber;
		public CSProduct(CSMobileDirectoryNumber CSMobileDirectoryNumber){
			this.CSMobileDirectoryNumber = CSMobileDirectoryNumber;
		}
	} 
	public class CSMobileDirectoryNumber{
		public string mdn;
		public CSMobileDirectoryNumber(string mdn){
			this.mdn = mdn;
		}
	}

	public class CSOperationInfo{
	 	public string user;
	 	public string channel;
	 	public string uuid;
	 	public string startTime;
	 	public string endTime;
	 	public CSOperationInfo (string user , string channel , string uuid , string startDate , string endDate){
	 		this.user = user;
	 		this.channel = channel;
	 		this.uuid = uuid;
	 		this.startTime = startDate;
	 		this.endTime = endDate;
	 	}
	}
}
//DLE 05/10/2020 end