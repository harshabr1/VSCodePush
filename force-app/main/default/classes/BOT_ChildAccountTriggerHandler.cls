/*
Name            : BOT_ChildAccountTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 05-DEC-2018
Overview        : This class is written by BusinessOne Technologies Inc. It is a handler class of BOT_ChildAccountTrigger.
*/
public with sharing class BOT_ChildAccountTriggerHandler 
{
	//To populate the SFDC Parent Account ID and SFDC Child Account ID
    public static void updateParentAndAffiliateIds(List<Child_Account_vod__c> lstChildAccount, Set<Integer> setEntityIds)
    {
        Map<Integer, ID> mapAccountIds = new Map<Integer, ID>();	//To store BOT Entity Ids and associated SFDC Account Ids
        
        //Querying SFDC Account Ids by comparing BOT Entity Ids and put it in the map
        for(Account objAccount : [SELECT Id, BOT_Entity_Id__c FROM Account WHERE BOT_Entity_Id__c IN : setEntityIds])
        {
            mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_Id__c), objAccount.Id);
        }
        
        //To populate SFDC Parent Account Id and SFDC Child Account Ids
        for(Child_Account_vod__c objChildAccount : lstChildAccount)
        {
            objChildAccount.Parent_Account_vod__c = mapAccountIds.get(Integer.valueOf(objChildAccount.BOT_Parent_Account_ID__c));
            objChildAccount.Child_Account_vod__c = mapAccountIds.get(Integer.valueOf(objChildAccount.BOT_Affiliate_Account_ID__c));
            
            //To populate the External_ID_vod__c Veeva field value
            //This value contains SFDC Parent Account Id +__+ SFDC Child Account Id
            //This field is unique and used to avoid duplicates
            objChildAccount.External_ID_vod__c = objChildAccount.Parent_Account_vod__c + '__' + objChildAccount.Child_Account_vod__c;
        }
    }
    
    //To populate the SFDC Parent Account ID and SFDC Person Account ID
    public static void updateParentAndPersonIds(List<Child_Account_vod__c> lstPersonChildAccount, Set<Integer> setParentAccountIds,  Set<Integer> setAffiliatePersonIds)
    {
        Map<Integer, ID> mapParentAccountIds = new Map<Integer, ID>();		//To store BOT Parent Account Entity Ids and associated SFDC Account Ids
        Map<Integer, ID> mapAffiliatePersonIds = new Map<Integer, ID>();	//To store BOT Affiliate Person Ids and associated SFDC Person Account Ids
        
        //Querying SFDC Account Ids by comparing BOT Entity Ids and put it in the map
        for(Account objAccount : [SELECT Id, BOT_Entity_Id__c FROM Account WHERE BOT_Entity_Id__c IN : setParentAccountIds])
        {
            mapParentAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_Id__c), objAccount.Id);
        }
        
        //Querying SFDC Person Account Ids by comparing BOT Person Ids and put it in the map
        for(Account objAccount : [SELECT Id, BOT_Person_Id__c FROM Account WHERE BOT_Person_Id__c IN : setAffiliatePersonIds])
        {
            mapAffiliatePersonIds.put(Integer.valueOf(objAccount.BOT_Person_Id__c), objAccount.Id);
        }
        
        //To populate SFDC Parent Account Id and SFDC Child Person Account Ids
        for(Child_Account_vod__c objPersonChildAccount : lstPersonChildAccount)
        {
            objPersonChildAccount.Parent_Account_vod__c = mapParentAccountIds.get(Integer.valueOf(objPersonChildAccount.BOT_Parent_Account_ID__c));
            objPersonChildAccount.Child_Account_vod__c = mapAffiliatePersonIds.get(Integer.valueOf(objPersonChildAccount.BOT_Person_ID__c));
            
            //To populate the External_ID_vod__c Veeva field value
            //This value contains SFDC Parent Account Id +__+ SFDC Child Account Id
            //This field is unique and used to avoid duplicates
            objPersonChildAccount.External_ID_vod__c = objPersonChildAccount.Parent_Account_vod__c + '__' + objPersonChildAccount.Child_Account_vod__c;
        }
    }
}