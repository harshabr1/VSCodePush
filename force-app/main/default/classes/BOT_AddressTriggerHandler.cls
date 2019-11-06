/*
Name            : BOT_AddressTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 06-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a handler class of BOT_AddressTrigger trigger
				  1. It populates the SFDC Account ID by using BOT Entity ID for Business Account Address records.
				  2. It populates the SFDC Person Account ID by using BOT Person ID for Person Account Address records.
				  3. Updates the records type as BOT Address for the BOT records

Modified By 	:Harsha BR
Modified date 	:14-SEP-2018
Reason 			:Added comments and modified the code to follow the salesforce standard best practices.
*/
public with sharing class BOT_AddressTriggerHandler 
{
	//To populate the SFDC Account ID by using BOT Entity ID for Business Account Address records.
    public static void populateAccountId(List<Address_vod__c> lstAddress, Set<Integer> setAccountIds)
    {
    	Map<Integer, ID> mapAccountIds = new Map<Integer, ID>();	//Map of BOT Entity Ids and associated SFDC Account IDs
        
        //To get the BOT Address record type ID
        ID idAddressRecordTypeId = Schema.SObjectType.Address_vod__c.getRecordTypeInfosByName().get('BOT Address').getRecordTypeId();
        
        //To retrieve SFDC Account Ids by comparing BOT Entity Ids and put it in the map
        for(Account objAccount : [SELECT Id, BOT_Entity_Id__c FROM Account WHERE BOT_Entity_Id__c in : setAccountIds LIMIT 50000])
        {
        	mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_Id__c), objAccount.Id); 
        }
        
        //To populate the SFDC Account ID and RecordType ID
        for(Address_vod__c objAddress : lstAddress)
        {
        	objAddress.Account_vod__c = mapAccountIds.get(Integer.valueOf(objAddress.BOT_Entity_ID__c));
            objAddress.RecordTypeId = idAddressRecordTypeId;
        }
    }
    
    //To populate the SFDC Person Account ID by using BOT Person ID for Person Account Address records.
    public static void populatePersonId(List<Address_vod__c> lstAddress, Set<Integer> setAccountIds)
    {
    	Map<Integer, ID> mapAccountIds = new Map<Integer, ID>();	//Map of BOT Entity Ids and associated SFDC Account IDs
        
        //To get the BOT Address record type ID
        ID idAddressRecordTypeId = Schema.SObjectType.Address_vod__c.getRecordTypeInfosByName().get('BOT Address').getRecordTypeId();
        
        //To retrieve SFDC Account Ids by comparing BOT Entity Ids and put it in the map
        for(Account objAccount : [SELECT Id, BOT_Person_Id__c FROM Account WHERE BOT_Person_Id__c in : setAccountIds LIMIT 50000])
        {
        	mapAccountIds.put(Integer.valueOf(objAccount.BOT_Person_Id__c), objAccount.Id); 
        }
        
        //To populate the SFDC Account ID and RecordType ID
        for(Address_vod__c objAddress : lstAddress)
        {
        	objAddress.Account_vod__c = mapAccountIds.get(Integer.valueOf(objAddress.BOT_Person_Id__c));
            objAddress.RecordTypeId = idAddressRecordTypeId;
        }
    }
}