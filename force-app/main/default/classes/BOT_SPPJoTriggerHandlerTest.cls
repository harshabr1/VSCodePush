/*
Name            : BOT_SPPJoTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 25-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is a test class for BOT_SpecialtyProviderJoTriggerHandler class.
*/
@isTest(seeAllData=false)
class BOT_SPPJoTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	//To create the Account records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'MCO');
		clsTestDataFactory.createAccountRecords(5,'Specialty Provider');
        
        //Test data validation
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'MCO'] == 5);
        system.assert([SELECT count() FROM Account WHERE Account_type__c = 'Specialty Provider'] == 5);
    }
    
    //Testing while creating a Specialty provider JO Record
    static testMethod void createSpecialtyProviderJORecord()
    {
    	Account objAccount;                                         //To store an Account record
        Account objSpecialtyprovider;								//To store a specialty provider Account
        List<BOT_Specialty_Provider_JO__c> lstSpecialtyProviderJO;  //To store a list of Junction object records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Specialty Provider Junction object record
        lstSpecialtyProviderJO = clsTestDataFactory.createSPPToAccountRecords(1,1);
       	insert lstSpecialtyProviderJO;
        
        //Querying the created test data
        objAccount = [SELECT Id FROM Account WHERE Account_type__c = 'MCO' ORDER BY BOT_Entity_ID__c LIMIT 1];
        objSpecialtyprovider = [SELECT Id FROM Account WHERE Account_type__c = 'Specialty Provider' ORDER BY BOT_Entity_ID__c LIMIT 1];
        lstSpecialtyProviderJO = [SELECT Id, BOT_Account__c, BOT_Specialty_Provider__c FROM BOT_Specialty_Provider_JO__c];
        
        //Test data validation
        system.assert(objAccount != null);
        system.assert(objSpecialtyprovider != null);
        system.assertEquals(lstSpecialtyProviderJO[0].BOT_Account__c, objAccount.Id);
        system.assertEquals(lstSpecialtyProviderJO[0].BOT_Specialty_Provider__c, objSpecialtyprovider.Id);
    }
    
    //Testing while creating a list of Specialty provider JO Records
    static testMethod void createSpecialtyProviderJORecords()
    {
    	List<Account> lstAccount;                                   //To store a list of Account records
        List<Account> lstSpecialtyprovider;							//To store a list of specialty provider Account records
        List<BOT_Specialty_Provider_JO__c> lstSpecialtyProviderJO;  //To store a list of Junction object records returned by test data factory
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a list of Specialty Provider Junction object records
        lstSpecialtyProviderJO = clsTestDataFactory.createSPPToAccountRecords(5,5);
       	insert lstSpecialtyProviderJO;
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account WHERE Account_type__c = 'MCO' ORDER BY BOT_Entity_ID__c];
        lstSpecialtyprovider = [SELECT Id FROM Account WHERE Account_type__c = 'Specialty Provider' ORDER BY BOT_Entity_ID__c];
        lstSpecialtyProviderJO = [SELECT Id, BOT_Account__c, BOT_Specialty_Provider__c FROM BOT_Specialty_Provider_JO__c ORDER BY BOT_Entity_ID__c];
        
        //Test data validation
        system.assert(lstAccount.size() == 5);
        system.assert(lstSpecialtyprovider.size() == 5);
        system.assert(lstSpecialtyProviderJO.size() == 25);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 5; j++)
            {
        		system.assertEquals(lstSpecialtyProviderJO[intTemp].BOT_Account__c, lstAccount[i].Id);
        		system.assertEquals(lstSpecialtyProviderJO[intTemp].BOT_Specialty_Provider__c, lstSpecialtyprovider[j].Id);
                intTemp++;
            }
        }
    }
    
    //Testing while creating a Specialty provider JO Record without Entity Id
    static testMethod void singleRecordNegativeScenario()
    {
    	List<BOT_Specialty_Provider_JO__c> lstSpecialtyProviderJO;  //To store a list of Junction object records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Specialty Provider to Account Junction object record
        lstSpecialtyProviderJO = clsTestDataFactory.createSPPToAccountWithoutEntityID(1,1);
        try {
        	insert lstSpecialtyProviderJO;
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity Id and Specialty provider ID fields are mandatory to save the record: []', e.getMessage());
        }
    }
}