/*
Name			: BOT_PlanProductTriggerHandler
Created By		: Sreenivasulu A
Created Date	: 14-AUG-2018
Overview		: This class is written by BusinessOne Technologies Inc. It is handler class of BOT_PlanProductTrigger trigger.
				  1. It is used to handle the name where having morethan 80 characters.
				  2. It populates the BOT_Account__c field.
				  3. It populates the BOT_Medical_Admin__c filed.

Modified By 	:Harsha BR
Modified date 	:12-SEP-2018
Reason 			:Added comments and modified the code to follow the salesforce standard best practices.

Modified by		: Sreenivasulu A
Modified date	: 09-OCT-2018
Reason			: Added data update functionility. It updates the BOT_Account__c field and BOT_Medical_Admin__c field when the record is created or updated.
*/
public with sharing class BOT_PlanProductTriggerHandler 
{
    //To populate SFDC Account ID and Manage the name field
    public static void manageNameAndPopulateAccountId(List<BOT_Plan_Product__c> lstPlanProducts, Set<Integer> setEntityIds)
    {
        Map<Integer, ID> mapAccountIds = new Map<Integer,ID>();		//To store BOT Entity Ids and SFDC Ids of Account object
        
        //To Retrieve SFDC Account Id by comparing BOT Entity Id and put in the map
        for(Account objAccount : [SELECT ID, BOT_Entity_ID__c FROM Account WHERE BOT_Entity_ID__c in : setEntityIds])
        {
            mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_ID__c), objAccount.Id);
        }
		
        for(BOT_Plan_Product__c objPlanProduct : lstPlanProducts)
        {
            //Populating BOT_Account__c field value
            objPlanProduct.BOT_Account__c = mapAccountIds.get(Integer.valueOf(objPlanProduct.BOT_Entity_ID__c));
        }
    }
    
    //To populate SFDC Medical Admin Id (Account Id)
    public static void updateMedicalAdminIds(List<BOT_Plan_Product__c> lstPlanProducts, set<Integer> setMedicalAdminIds)
    {
        Map<Integer, ID> mapAccountIds = new Map<Integer,ID>();				//To store BOT Entity Ids and SFDC Account Ids of Account object

        //To Retrieve SFDC Medical Admin Id by comparing BOT Medical Admin Id and put in the map
        for(Account objAccount : [SELECT Id, BOT_Entity_ID__c FROM Account WHERE BOT_Entity_ID__c in : setMedicalAdminIds])
        {
            mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_ID__c), objAccount.Id);
        }
		
        for(BOT_Plan_Product__c objPlanProduct : lstPlanProducts)
        {
            //Populating BOT_Medical_Admin__c field value
            objPlanProduct.BOT_Medical_Admin__c = mapAccountIds.get(Integer.valueOf(objPlanProduct.BOT_Medical_Admin_ID__c));
        }   
    }
}