/*
Name            : BOT_TheraClassTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 25-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class of BOT_TheraClassTriggerHandler class.
*/
@isTest(seeAllData = false)
class BOT_TheraClassTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	//To create the Account records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'Specialty Provider');
        
        //Test data validation
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'Specialty Provider'] == 5);
    }
    
    //Testing while creating a Thera class record
    static testMethod void createTheraClassRecord()
    {
       	Account objSpecialtyProvider;     		//To store a Specilary provider Account record
        List<BOT_Thera_Class__c> lstTheraClass; //To store a list of Thera class records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create a Thera class record
        lstTheraClass = clsTestDataFactory.createTheraClassWithSpecialtyId(1,1);
       	insert lstTheraClass;
        
        //Querying the created test data
        objSpecialtyProvider = [SELECT Id FROM Account ORDER BY BOT_Entity_ID__c LIMIT 1];
        lstTheraClass = [SELECT Id, BOT_Specialty_Provider__c FROM BOT_Thera_Class__c LIMIT 1];
        
        //Test data validation
        system.assertEquals(lstTheraClass[0].BOT_Specialty_Provider__c, objSpecialtyProvider.Id);
    }
    
    //To create a list of Thera class records
    static testMethod void createTheraClassRecords()
    {
       	List<Account> lstSpecialtyProvider;     //To store a list of Specilary provider Account records
        List<BOT_Thera_Class__c> lstTheraClass; //To store a list of Thera class records returned by test data factory
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create a list of Thera class records
        lstTheraClass = clsTestDataFactory.createTheraClassWithSpecialtyId(5,5);
       	insert lstTheraClass;        
        
        //Querying the created test data
        lstSpecialtyProvider = [SELECT Id FROM Account ORDER BY BOT_Entity_ID__c];
        lstTheraClass = [SELECT Id, BOT_Specialty_Provider__c FROM BOT_Thera_Class__c ORDER BY BOT_Specialty_Provider_ID__c];
        
        //Test data validation
       	system.assertEquals(lstSpecialtyProvider.size(), 5);
        system.assertEquals(lstTheraClass.size(), 25);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 5; j++)
            {
	        	system.assertEquals(lstTheraClass[intTemp].BOT_Specialty_Provider__c, lstSpecialtyProvider[i].Id);
                intTemp++;
            }
        }
    }
    
    //Testing while creating a Thera class record without Specialty provider Id
    static testMethod void createTheraClassWithoutSpecialtyId()
    {
        List<BOT_Thera_Class__c> lstTheraClass; //To store a list of Thera class records returned by test data factory
       	BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
		
        //To create a Thera class record
        lstTheraClass = clsTestDataFactory.createTheraClassWithoutSpecialtyId(1,1);
        try {
        	insert lstTheraClass;
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Specialty provider Id field is mandatory to save the record: []', e.getMessage());
        }
    }
}