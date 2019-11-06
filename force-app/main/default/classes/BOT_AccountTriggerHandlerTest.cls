/*
Name            : BOT_AccountTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 20-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class for BOT_AccountTriggerHandler.
*/
@isTest(seeAllData = false)
class BOT_AccountTriggerHandlerTest 
{
    //Testing while creating an Account record
    static testMethod void createAccountRecordWithParentId()
    {
        Account objParentAccount;			//To store the parent account record
        List<Account> lstAffiliateAccount;	//To store the list of affiliate account with parent Id
        
        //To create an Account record with parent ID
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'Tricare');
        lstAffiliateAccount = clsTestDataFactory.createAccountsWithParentId(1,1,'Tricare');
        insert lstAffiliateAccount;
        
        //Querying the created test data
        objParentAccount = [SELECT Id FROM Account WHERE BOT_Parent_Entity_ID__c = Null];
        lstAffiliateAccount = [SELECT Id, ParentId, Primary_Parent_vod__c, BOT_Is_BOT_Data__c, recordTypeId 
                               FROM Account WHERE BOT_Parent_Entity_ID__c != Null];
        
        //test data validation
        system.assertEquals(lstAffiliateAccount[0].Primary_Parent_vod__c, objParentAccount.Id);
        system.assertEquals(lstAffiliateAccount[0].ParentId, objParentAccount.Id);
		system.assertEquals(lstAffiliateAccount[0].recordTypeId, Schema.SObjectType.Account.getRecordTypeInfosByName().get('BOT Tricare').getRecordTypeId());
    }
    
    //Testing while creating the list of Account records
    static testMethod void createAccountRecordsWithParentId()
    {
        List<Account> lstParentAccount;		//To store a list of parent account records
        List<Account> lstAffiliateAccount;	//To store a list of affiliate account with parent Id
        ID accountRecordTypeId;				//To store record type Id
        Integer intTemp = 0;				//Temporary variable used as index position of plan prouduts list
        
        //To create a list of Account records with parent ID
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'Employer');
        lstAffiliateAccount = clsTestDataFactory.createAccountsWithParentId(5,5,'Employer');
       	insert lstAffiliateAccount;
        
        //Querying the Record type Id to validate the updated record type
        accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BOT Employer').getRecordTypeId();

        //Querying the created test data
        lstParentAccount = [SELECT Id FROM Account WHERE BOT_Parent_Entity_ID__c = Null];
        lstAffiliateAccount = [SELECT Id, ParentId, Primary_Parent_vod__c, recordTypeId FROM Account 
                               WHERE BOT_Parent_Entity_ID__c != Null AND BOT_Is_BOT_Data__c = true AND recordTypeId =: accountRecordTypeId
                               ORDER BY Primary_Parent_vod__c];
        
        //Test data validation
        system.assertEquals(lstParentAccount.size(), 5);
        system.assertEquals(lstAffiliateAccount.size(), 25);
        
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 5; j++)
            {
            	system.assertEquals(lstAffiliateAccount[intTemp].Primary_Parent_vod__c, lstParentAccount[i].Id);
                system.assertEquals(lstAffiliateAccount[intTemp].ParentId, lstParentAccount[i].Id);
                intTemp++;
            }
        }
    	
        //Testing while updating the Account records
        Set<Id> setAffiliateAccountIds = new Set<Id>();				//To hold the Affiliate Account Ids which we are going to update
        setAffiliateAccountIds.add(lstAffiliateAccount[0].Id);
        setAffiliateAccountIds.add(lstAffiliateAccount[1].Id);
        
        //Updating the Parent Entity Id and Account type
    	lstAffiliateAccount[0].BOT_Parent_Entity_ID__c = 4;
        lstAffiliateAccount[0].Account_Type__c = 'Tricare';
        lstAffiliateAccount[1].BOT_Parent_Entity_ID__c = 3;
        lstAffiliateAccount[1].Account_Type__c = 'Tricare';
        update lstAffiliateAccount;
        
        //Querying the Record type Id to validate the updated record type
        accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('BOT Tricare').getRecordTypeId();

        //Querying the updated test data
        lstAffiliateAccount = [SELECT Id, ParentId, Primary_Parent_vod__c FROM Account 
                               WHERE Id in : setAffiliateAccountIds AND recordTypeId =: accountRecordTypeId];
        
        //Test data validation
        system.assertEquals(lstAffiliateAccount[0].Primary_Parent_vod__c, lstParentAccount[4].Id);
        system.assertEquals(lstAffiliateAccount[1].Primary_Parent_vod__c, lstParentAccount[3].Id);		
    }
    
    //Testing while creating an Account record without Channel
    static testMethod void singleRecordNegativeScenario()
    {
        List<Account> lstAccount;		//To store a list of Account records 
        
        //To create an Account record with parent ID
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        lstAccount = clsTestDataFactory.createAccountsWithParentId(1,1,''); 
        
        try {
        	insert lstAccount;
        }
        catch(DMLException e) {
        	system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Account type field is mandatory for BOT records: []', e.getMessage());  
        }
    }
}