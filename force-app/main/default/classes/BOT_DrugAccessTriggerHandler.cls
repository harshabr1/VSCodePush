/*
Name            : BOT_DrugAccessTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 07-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is a handler class to BOT_DrugAccessTrigger trigger. 
				  It is used to populate the SFDC Account ID and SFDC Formulary Product ID by comparing BOT Entity ID and BOT Drug ID respectively.

Modified By 	:Harsha BR
Modified date 	:12-SEP-2018
Reason 			:Added comments and modified the code to follow the salesforce standard best practices.
*/
public with sharing class BOT_DrugAccessTriggerHandler 
{
	public static void populateAccountAndProductIds(List<BOT_Drug_Access__c> lstDrugAccess, Set<Integer> setBOTEntityIds, Set<Integer> setBOTFormularyproductIds)
    {
        Map<Integer, ID> mapAccountIds;										//Map of BOT Entity ID and its asssociated SFDC Account ID
        Map<Integer, Formulary_Products_vod__c> mapFormularyProduct;		//Map of BOT Formulary Product ID and formulary product record
        Formulary_Products_vod__c objFormularyProduct1;						//To store a formulary product record;
        
        //To Retrieve SFDC Accout Ids by comparing BOT Account Ids and put in the map 
        mapAccountIds = new Map<Integer, ID>();
        for(Account objAccount : [SELECT Id, BOT_Entity_ID__c FROM Account WHERE BOT_Entity_ID__c IN : setBOTEntityIds LIMIT 50000])
        {
        	mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_ID__c), objAccount.Id);
        }
        
        //Retrieving SFDC Formulary product record by comparing BOT Formulary Product ID and put in the map
        mapFormularyProduct = new Map<Integer, Formulary_Products_vod__c>();
        for(Formulary_Products_vod__c objFormularyProduct : [SELECT Id, BOT_Formulary_Product_ID__c, market_vod__c FROM Formulary_Products_vod__c WHERE BOT_Formulary_Product_ID__c IN : setBOTFormularyproductIds LIMIT 50000])
        {
        	mapFormularyProduct.put(Integer.valueOf(objFormularyProduct.BOT_Formulary_Product_ID__c), objFormularyProduct);
        }
        
        //To populate BOT_Account__c, BOT_Formulary_Product__c and Market (Name) fileds of Drug Access object
        for(BOT_Drug_Access__c objDrugAccess : lstDrugAccess)
        {
            objDrugAccess.BOT_Account__c = mapAccountIds.get(Integer.valueOf(objDrugAccess.BOT_Entity_ID__c));
            objFormularyProduct1 = mapFormularyProduct.get(Integer.valueOf(objDrugAccess.BOT_Formulary_Product_ID__c));
            objDrugAccess.BOT_Formulary_Product__c = objFormularyProduct1.Id;
            objDrugAccess.Name = objFormularyProduct1.Market_vod__c;
        }
    }
}