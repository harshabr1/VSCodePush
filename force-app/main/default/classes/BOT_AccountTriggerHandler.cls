/*
Name            : BOT_AccountTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 05-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is used to update the RecordType ID's and
                  parent Salesforce ID's on the Child accounts.

Modified By 	:Harsha BR
Modified date 	:12-SEP-2018
Reason 			:Added comments and modified the code to follow the salesforce standard best practices.
*/
public with sharing class BOT_AccountTriggerHandler 
{
    //Used to autopoplate the record type Id and SFDC Parent Id.
    public static void updateRecordtypeID(List<Account> lstAccounts)
    {
        Map<String, Id> mapRecordtypeIds = new Map<String, Id>();		//Used to store the Record type name and its associated salesforce ID
        
        //To Retrieve SFDC RecordTypeId by comparing Account, Channel and put in the map
        for(RecordType objRecordTypeId : [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' AND Name LIKE 'BOT%' LIMIT 50000])
        {
            mapRecordtypeIds.put(objRecordTypeId.Name.toUpperCase(), objRecordTypeId.Id);
        }
		
        //Updating appropriate recordTypeId
        for(Account objAccount : lstAccounts)
        {             
            objAccount.RecordTypeId = mapRecordtypeIds.get('BOT '+objAccount.Account_Type__c.toUpperCase());
        }
    }
    
    //Used to autopoplate the SFDC Parent Id.
    public static void updateParentID(List<Account> lstAccounts, Set<Integer> setEntityParentIds)
    {
    	Map<Integer, Id> mapEntityParentIds = new Map<Integer, Id>();	//Used to store the BOT Entity ID and its associated salesforce ID
        
        //To Retrieve SFDC Parent Id by comparing BOT parent Entity Id and put in the map
        for(Account objAccount : [SELECT Id, BOT_Entity_Id__c FROM Account WHERE BOT_Entity_Id__c in : setEntityParentIds LIMIT 50000])
        {
        	mapEntityParentIds.put(Integer.valueOf(objAccount.BOT_Entity_Id__c), objAccount.Id);
        }
        
        //Updating appropriate SFDC Parent entity ID
        for(Account objAccount : lstAccounts)
        {             
        	objAccount.Primary_Parent_vod__c = mapEntityParentIds.get(Integer.valueOf(objAccount.BOT_Parent_Entity_ID__c));
            objAccount.ParentId = objAccount.Primary_Parent_vod__c;
        }
    }
}