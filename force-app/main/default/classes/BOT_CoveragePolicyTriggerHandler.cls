/*
Name            : BOT_CoveragePolicyTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 04-FEB-2019
Overview        : It is implemented by BusinessOne Technologies Inc. It is a handler class of BOT_CoveragePolicyTrigger.
*/
public class BOT_CoveragePolicyTriggerHandler 
{
	public static void populateAccountAndProductIds(List<BOT_Coverage_Policy__c> lstCoveragePolicy, Set<Integer> setBOTEntityIds, Set<Integer> setBOTFormularyproductIds)
    {
        Map<Integer, ID> mapAccountIds = new Map<Integer, ID>();	//To store BOT Entity ID and asssociated SFDC Account ID
        Map<Integer, ID> mapFormularyProductIds;					//To store BOT Formulary Product ID and asssociated SFDC Formulary Product ID
        
        //Retrieving SFDC Accout Ids by comparing BOT Entity Ids and put in the map 
        for(Account objAccount : [SELECT Id, BOT_Entity_ID__c FROM Account WHERE BOT_Entity_ID__c IN : setBOTEntityIds LIMIT 50000])
        {
        	mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_ID__c), objAccount.Id);
        }
        
        //Retrieving SFDC Formulary product Id by comparing BOT Formulary Product ID and put in the map
        mapFormularyProductIds = new Map<Integer, Id>();
        for(Formulary_Products_vod__c objFormularyProduct : [SELECT Id, BOT_Formulary_Product_ID__c FROM Formulary_Products_vod__c WHERE BOT_Formulary_Product_ID__c IN : setBOTFormularyproductIds LIMIT 50000])
        {
        	mapFormularyProductIds.put(Integer.valueOf(objFormularyProduct.BOT_Formulary_Product_ID__c), objFormularyProduct.Id);
        }
        
        //To populate BOT_Account__c, BOT_Formulary_Product__c fileds of the Coverage Policy object
        for(BOT_Coverage_Policy__c objCoveragePolicy : lstCoveragePolicy)
        {
            objCoveragePolicy.BOT_Account__c = mapAccountIds.get(Integer.valueOf(objCoveragePolicy.BOT_Entity_ID__c));
            objCoveragePolicy.BOT_Formulary_Product__c = mapFormularyProductIds.get(Integer.valueOf(objCoveragePolicy.BOT_Formulary_Product_ID__c));
        }
    }
}