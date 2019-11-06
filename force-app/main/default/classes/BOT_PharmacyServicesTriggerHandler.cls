/*
Name            : BOT_PharmacyServicesTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 07-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a handler class of BOT_PharmacyServicesTrigger
				  It is used to populate the SFDC Account ID by using BOT Entity ID.

Modified By   : Harsha BR
Modified Date : 14-SEP-2018
Reason        : To move the business logic to the Apex class and to follow the naming conventions.
*/

public with sharing class BOT_PharmacyServicesTriggerHandler 
{
	public static void populateAccountAndPbmIds(List<BOT_Pharmacy_Service__c> lstPharmacyServices, Set<Integer> setBOTAccountIds)
    {
        Map<Integer, ID> mapAccountIds = new Map<Integer, ID>();	//To store the map of BOT Entity ID and Salesforce account ID
        
    	//Retrieving SFDC Account Id by comparing BOT Entity Id or BOT PBM Id 
        for(Account objAccount : [SELECT Id, BOT_Entity_Id__c FROM Account WHERE BOT_Entity_Id__c in : setBOTAccountIds])
        {
        	mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_Id__c), objAccount.Id);   
        }
        
        //To populate BOT_Account__c and BOT_PBM_Name__c fileds
        for(BOT_Pharmacy_Service__c objPharmacyService : lstPharmacyServices)
        {
        	objPharmacyService.BOT_Account__c = mapAccountIds.get(Integer.valueOf(objPharmacyService.BOT_Entity_ID__c));
            
            if(objPharmacyService.BOT_PBM_ID__c != Null)
            {
            	objPharmacyService.BOT_PBM_Name__c = mapAccountIds.get(Integer.valueOf(objPharmacyService.BOT_PBM_ID__c));
            }
        }
    }
}