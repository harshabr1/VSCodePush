/*
Name            : BOT_ChildAccountTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 05-DEC-2018
Overview        : This class is written by BusinessOne Technologies Inc. It is a test class of BOT_ChildAccountTriggerHandler class.
*/
@isTest(seeAllData = false)
class BOT_ChildAccountTriggerHandlerTest 
{
	//To create the common test data
    @testSetup static void createTestData()
    {
    	//To create the Account records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'MCO');
        clsTestDataFactory.createAccountRecords(5,'PBM');
		clsTestDataFactory.createPersonAccountRecords(5);
        
        //Test data validation
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'MCO'] == 5);
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'PBM'] == 5);
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'Person Account'] == 5);
    }
    
    //Testing while creating a Child Account record
    static testMethod void createChildAccount()
    {
    	Account objParentAccount;					//To store the Parent Account record
        Account objAffiliateAccount;				//To store the Affiliate Account record
        List<Child_Account_vod__c> lstChildAccount;	//To store the list of Child Account records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Child Account record
        lstChildAccount = clsTestDataFactory.createChildAccountRecords(1,1);
       	insert lstChildAccount;
        
        //Querying the created test data
       	objParentAccount = [SELECT Id from Account WHERE Account_Type__c = 'PBM' ORDER BY BOT_Entity_ID__c LIMIT 1];
        objAffiliateAccount = [SELECT Id from Account WHERE Account_Type__c = 'MCO' ORDER BY BOT_Entity_ID__c LIMIT 1];
        lstChildAccount = [SELECT Parent_Account_vod__c, Child_Account_vod__c, External_ID_vod__c FROM Child_Account_vod__c];
        
        //Test data validation
        system.assertEquals(lstChildAccount[0].Child_Account_vod__c, objAffiliateAccount.Id);
        system.assertEquals(lstChildAccount[0].Parent_Account_vod__c, objParentAccount.Id);
        system.assertEquals(lstChildAccount[0].External_ID_vod__c, objParentAccount.Id + '__' + objAffiliateAccount.Id);
    }
    
    //Testing while creating a Child Person Account record
    static testMethod void createChildPersonAccount()
    {
    	Account objParentAccount;					//To store the Parent Account record
        Account objPersonAccount;					//To store the Person Account record
        List<Child_Account_vod__c> lstChildAccount;	//To store the list of Child Account records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Child Person Account record
        lstChildAccount = clsTestDataFactory.createChildPersonAccountRecords(1,1);
       	insert lstChildAccount;
        
        //Querying the created test data
       	objParentAccount = [SELECT Id from Account WHERE Account_Type__c = 'MCO' ORDER BY BOT_Entity_ID__c LIMIT 1];
        objPersonAccount = [SELECT Id from Account WHERE Account_Type__c = 'Person Account' ORDER BY BOT_Person_ID__c LIMIT 1];
        lstChildAccount = [SELECT Parent_Account_vod__c, Child_Account_vod__c, External_ID_vod__c FROM Child_Account_vod__c];
        
        //Test data validation
        system.assertEquals(lstChildAccount[0].Child_Account_vod__c, objPersonAccount.Id);
        system.assertEquals(lstChildAccount[0].Parent_Account_vod__c, objParentAccount.Id);
        system.assertEquals(lstChildAccount[0].External_ID_vod__c, objParentAccount.Id + '__' + objPersonAccount.Id);
    }
    
    //Testing while creating the list of Child Account records
    static testMethod void createChildAccounts()
    {
    	List<Account> lstParentAccount;					//To store the list of Parent Account records
        List<Account> lstAffiliateAccount;				//To store the list of Affiliate Account records
        List<Child_Account_vod__c> lstChildAccount;		//To store a list of Child Account records returned by test data factory
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a list of Child Account records
        lstChildAccount = clsTestDataFactory.createChildAccountRecords(5,5);
       	
       	insert lstChildAccount;
        
        //Querying the created test data
       	lstParentAccount = [SELECT Id from Account WHERE Account_Type__c = 'PBM' ORDER BY BOT_Entity_Id__c];
        lstAffiliateAccount = [SELECT Id from Account WHERE Account_Type__c = 'MCO' ORDER BY BOT_Entity_ID__c];
        lstChildAccount = [SELECT Parent_Account_vod__c, Child_Account_vod__c, External_ID_vod__c 
                           FROM Child_Account_vod__c ORDER BY BOT_Parent_Account_ID__c, BOT_Affiliate_Account_ID__c];
        
        //Test data validation
        system.assertEquals(lstParentAccount.size(), 5);
        system.assertEquals(lstAffiliateAccount.size(), 5);
        system.assertEquals(lstChildAccount.size(), 25);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 5; j++)
            {
            	system.assertEquals(lstChildAccount[intTemp].Child_Account_vod__c, lstAffiliateAccount[j].Id);
        		system.assertEquals(lstChildAccount[intTemp].Parent_Account_vod__c, lstParentAccount[i].Id);
                system.assertEquals(lstChildAccount[intTemp].External_ID_vod__c, lstParentAccount[i].Id + '__' + lstAffiliateAccount[j].Id);
                intTemp++;
            }
        }
    }
    
    //Testing while creating the list of Child Person Account records
    static testMethod void createChildPersonAccounts()
    {
    	List<Account> lstParentAccount;					//To store the list of Parent Account records
        List<Account> lstPersonAccount;					//To store the list of Person Account records
        List<Child_Account_vod__c> lstChildAccount;		//To store the list of Child Account records returned by test data factory
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a list of Child Account records
        lstChildAccount = clsTestDataFactory.createChildPersonAccountRecords(5,5);
       	
       	insert lstChildAccount;

        //Querying the created test data
       	lstParentAccount = [SELECT Id from Account WHERE Account_Type__c = 'MCO' ORDER BY BOT_Entity_Id__c];
        lstPersonAccount = [SELECT Id from Account WHERE Account_Type__c = 'Person Account' ORDER BY BOT_Person_ID__c];
        lstChildAccount = [SELECT Parent_Account_vod__c, Child_Account_vod__c, External_ID_vod__c 
                           FROM Child_Account_vod__c ORDER BY BOT_Parent_Account_ID__c, BOT_Person_ID__c];
        
        //Test data validation
        system.assertEquals(lstParentAccount.size(), 5);
        system.assertEquals(lstPersonAccount.size(), 5);
        system.assertEquals(lstChildAccount.size(), 25);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 5; j++)
            {
            	system.assertEquals(lstChildAccount[intTemp].Child_Account_vod__c, lstPersonAccount[j].Id);
        		system.assertEquals(lstChildAccount[intTemp].Parent_Account_vod__c, lstParentAccount[i].Id);
                system.assertEquals(lstChildAccount[intTemp].External_ID_vod__c, lstParentAccount[i].Id + '__' + lstPersonAccount[j].Id);
                intTemp++;
            }
        }
    }

    
    //Testing while creating a Child Account records without BOT Entity ID
    static testMethod void createChildAccountWithoutEntityID()
    {
    	List<Child_Account_vod__c> lstChildAccount;	//To store a list of Child Account records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Child Account records without BOT Entity ID
        lstChildAccount = clsTestDataFactory.createChildAccountRecords(5,5);
       	
        try{
        	insert lstChildAccount;
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity Id and Person Account Id fields are mandatory to save the record: []', e.getMessage());
        }
    }
}