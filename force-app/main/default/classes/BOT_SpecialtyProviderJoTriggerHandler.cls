/*
Name            : BOT_SpecialtyProviderJoTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 06-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a helper class of BOT_SpecialtyProviderJoTrigger. 
				  It is used to populate the SFDC Entity ID and SFDC Specialty provider ID by comparing BOT Entity ID.

Modified By 	:Harsha BR
Modified date 	:12-SEP-2018
Reason 			:Added comments and modified the code to follow the salesforce standard best practices.
*/
public with sharing class BOT_SpecialtyProviderJoTriggerHandler 
{
	public static void populateAccountAndSpecialtyProviderIds(List<BOT_Specialty_Provider_JO__c> lstSpecialtyProviderJo, Set<Integer> setAccountIds)
    {
        Map<Integer, ID> mapAccountIds = new Map<Integer, ID>();		//To store BOT Entity ID and Salesforce Account ID
        
        //Retrieving the SFDC Account ID by comparing BOT Entity ID and put it in the map
        for(Account objAccount : [SELECT Id, BOT_Entity_Id__c FROM Account WHERE BOT_Entity_Id__c in : setAccountIds LIMIT 50000])
        {
        	mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_Id__c), objAccount.Id);
        }
        
        //to populate BOT_Account__c, BOT_Specialty_Provider__c fields with SFDC Account ID
        for(BOT_Specialty_Provider_JO__c objSpecilatyProviderJo : lstSpecialtyProviderJo)
        {
        	objSpecilatyProviderJo.BOT_Account__c = mapAccountIds.get(Integer.valueOf(objSpecilatyProviderJo.BOT_Entity_ID__c));
            objSpecilatyProviderJo.BOT_Specialty_Provider__c = mapAccountIds.get(Integer.valueOf(objSpecilatyProviderJo.BOT_Specialty_Provider_ID__c));
        }
    }
}