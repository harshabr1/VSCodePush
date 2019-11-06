/*
Name            : BOT_AddressTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 20-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class of BOT_AddressTriggerHandler class.
*/
@isTest(seeAllData=false)
class BOT_AddressTriggerHandlerTest 
{
  	//To create the common test data
    @testSetup static void createTestData()
    {
    	//To create the Account records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'MCO');
        clsTestDataFactory.createPersonAccountRecords(5);
        
        //Test data validation
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'MCO'] == 5);
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'Person Account'] == 5);
    }
    
    //Testing while creating an Address record for Business Account
    static testMethod void createAddressRecord()
    {
        Account objAccount;                 //To store a Business Account record
        List<Address_vod__c> lstAddress;   	//To store the list of Address records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create an address record
        lstAddress = clsTestDataFactory.createAddressRecords(1,1);
      	insert lstAddress;

        //Querying the created test data
        objAccount = [SELECT Id FROM Account WHERE Account_type__c = 'MCO' ORDER BY BOT_Entity_Id__c LIMIT 1];
        lstAddress = [SELECT Id, Account_vod__c, RecordTypeId FROM Address_vod__c LIMIT 1];
       	
        //Test data validation
        system.assert(objAccount != null);
        system.assert(lstAddress != null);
        system.assertEquals(lstAddress[0].Account_vod__c , objAccount.Id);
        system.assertEquals(lstAddress[0].RecordTypeId , Schema.SObjectType.Address_vod__c.getRecordTypeInfosByName().get('BOT Address').getRecordTypeId());
    }
    
    //Testing while creating an Address record for Person Account
    static testMethod void createPersonAddressRecord()
    {
        Account objAccount;                 //To store a Person Account record
        List<Address_vod__c> lstAddress;   	//To store the list of Address records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create an address record
        lstAddress = clsTestDataFactory.createPersonAddressRecords(1,1);
       	insert lstAddress;
        
        //Querying the created test data
        objAccount = [SELECT Id FROM Account WHERE Account_type__c = 'Person Account' ORDER BY BOT_Person_Id__c LIMIT 1];
        lstAddress = [SELECT Id, Account_vod__c, RecordTypeId FROM Address_vod__c LIMIT 1];
       	
        //Test data validation
        system.assert(objAccount != null);
        system.assert(lstAddress != null);
        system.assertEquals(lstAddress[0].Account_vod__c , objAccount.Id);
        system.assertEquals(lstAddress[0].RecordTypeId , Schema.SObjectType.Address_vod__c.getRecordTypeInfosByName().get('BOT Address').getRecordTypeId());
    }
    
    //Testing while creating the list of Address records for Business Accounts
    static testMethod void createAddressRecords()
    {
        List<Account> lstAccount;           //To store a list of Business Account records
        List<Address_vod__c> lstAddress;   	//To store a list of Address records returned by test data factory
        Integer intTemp = 0;
        ID idAddressRecordTypeId = Schema.SObjectType.Address_vod__c.getRecordTypeInfosByName().get('BOT Address').getRecordTypeId();
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        lstAddress = clsTestDataFactory.createAddressRecords(5,1);
       	insert lstAddress;
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account WHERE Account_type__c = 'MCO' ORDER BY BOT_Entity_Id__c];
        lstAddress = [SELECT Id, Account_vod__c, RecordTypeId FROM Address_vod__c ORDER By BOT_Entity_Id__c];
       	
        //Test data validation
        system.assert(lstAccount.size() == 5);
        system.assert(lstAddress.size() == 5);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 1; j++)
            {
            	system.assertEquals(lstAddress[intTemp].Account_vod__c , lstAccount[i].Id);
                system.assertEquals(lstAddress[intTemp].RecordTypeId , idAddressRecordTypeId);
                intTemp++;
			}
        }
    }
    
    //Testing while creating the list of Address records for Person Accounts
    static testMethod void createPersonAddressRecords()
    {
        List<Account> lstAccount;           //To store a list of Person Account records
        List<Address_vod__c> lstAddress;   	//To store a list of Address records returned by test data factory
        Integer intTemp = 0;
        ID idAddressRecordTypeId = Schema.SObjectType.Address_vod__c.getRecordTypeInfosByName().get('BOT Address').getRecordTypeId();
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        lstAddress = clsTestDataFactory.createPersonAddressRecords(5,1);
       	insert lstAddress;
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account WHERE Account_type__c = 'Person Account' ORDER BY BOT_Entity_Id__c];
        lstAddress = [SELECT Id, Account_vod__c, RecordTypeId FROM Address_vod__c ORDER By BOT_Person_Id__c];
       	
        //Test data validation
        system.assert(lstAccount.size() == 5);
        system.assert(lstAddress.size() == 5);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 1; j++)
            {
            	system.assertEquals(lstAddress[intTemp].Account_vod__c , lstAccount[i].Id);
                system.assertEquals(lstAddress[intTemp].RecordTypeId , idAddressRecordTypeId);
                intTemp++;
			}
        }
    }
    
    //Testing while creating an Address Record without Entity Id
    static testMethod void createAddressRecordsWithoutEntityId()
    {
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        try{
        	//To create a list of address records
        	clsTestDataFactory.createAddressRecords(5,1);
        }
        
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity ID field is required to save the record: []', e.getMessage());
        }
    }
    
    //Testing while creating an Address Record without Entity Id
    static testMethod void createAddressRecordsWithDifferentUser()
    {
    	List<Address_vod__c> lstAddress;   	//To store the list of Address records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create the test user
        User testUser = clsTestDataFactory.createTestUser();
        
        //To create the Address record with a test user
        System.runAs(testUser)
        {
        	//To create an address record
        	lstAddress = clsTestDataFactory.createPersonAddressRecords(1,1);
        
        	try{
        		insert lstAddress;
        	}
        	catch(Exception e)
        	{
            	system.debug('Exception '+e.getMessage()+ ' found in class BOT_AddressTriggerHandlerTest at line number '+e.getLineNumber());
        	}    
        }

        //Querying the created test data
        lstAddress = [SELECT Id, Account_vod__c, RecordTypeId FROM Address_vod__c LIMIT 1];
       	
        //Test data validation
        system.assert(lstAddress != null);
    }
}