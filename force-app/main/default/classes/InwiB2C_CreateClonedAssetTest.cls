@isTest
public class InwiB2C_CreateClonedAssetTest {
    @isTest(seeAllData=true)
    public static void CloneAssetTestMeth() {

        Map<String,Object> outMap = new  Map<String,Object>();
        Map<String,Object> options = new  Map<String,Object>();
        Map<String,Object> inputMap = new  Map<String,Object>();
        //Get the id of the template Asset
List<Order> ListOrderToClone = [SELECT id, accountid, contractid from Order where contractid !='' and accountid != '' limit 1];
        
        List<Asset> ListAssetsToClone = [SELECT id from Asset where ProductCode = 'INWIB2C_OFFERING_TICTAC_SANS_TERMINAL' limit 1];
        List<inwiB2C_CreateContractBulk__c> ListCreateContractObj = [SELECT id from inwiB2C_CreateContractBulk__c limit 1];
        //Insert the id in the metadata
        InwiB2C_IdAssetToClone__mdt newAssetId = new InwiB2C_IdAssetToClone__mdt(InwiB2C_AssetId__c = ListAssetsToClone[0].Id, Label= 'TicTacAsset');
        InwiB2C_IdAssetToClone__mdt newAssetId1 = new InwiB2C_IdAssetToClone__mdt(InwiB2C_AssetId__c = ListAssetsToClone[0].Id, Label= 'AssetDealer');
        
        inputMap.put('inwiB2C_CustomerId__c',ListOrderToClone[0].accountid);
        //inputMap.put('inwiB2C_ContratId__c',ListOrderToClone[0].contractid);
        //inputMap.put('inwiB2C_UpdateAttribute__c',true);
        //inputMap.put('inwiB2C_CheckOut__c',true);
        inputMap.put('inwiB2C_IdCreateContractBulk__c',ListCreateContractObj[0].Id);
        inputMap.put('inwiB2C_assetId__c',ListAssetsToClone[0].id );
        
        String InputString = Json.serialize(inputMap);
        
        InwiB2C_CreateClonedAsset.CloneAsset(InputString);

       

    }
}