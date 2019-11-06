/*
Name            : BOT_PharmacyServicesTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 21-SEP-2018
Overview        : it is implemented by BusinessOne Technologies Inc.It is a test class of BOT_PharmacyServicesTriggerHandler.
*/
@isTest(seeAllData=false)
class BOT_PharmacyServicesTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	//To create the Account records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'MCO');
		clsTestDataFactory.createAccountRecords(5,'PBM');

        //Test data validation
		system.assert([SELECT count() FROM Account WHERE Account_Type__c = 'MCO'] == 5);
        system.assert([SELECT count() FROM Account WHERE Account_Type__c = 'PBM'] == 5);
    }
    
    //Testing while creating a single Pharmacy service record
    static testMethod void createPharmacyService()
    {
        Account objAccount;								//To store an Account record
        Account objPBMAccount;							//To store a PBM Account record
        BOT_Pharmacy_Service__c objPharmacyService;		//To store a Pharmacy service record

        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();

        //To create a Pharmacy service record
        clsTestDataFactory.createPharmacyServices(1,1,'Formulary development/Admin');
        
        //Querying the created test data
        objAccount = [SELECT Id FROM Account WHERE Account_Type__c = 'MCO' ORDER BY BOT_Entity_Id__c LIMIT 1];
        objPBMAccount = [SELECT Id FROM Account WHERE Account_Type__c = 'PBM' ORDER BY BOT_Entity_Id__c LIMIT 1];
        objPharmacyService = [SELECT Id, BOT_Account__c, BOT_PBM_Name__c FROM BOT_Pharmacy_Service__c];
        
        //Test data validation
        system.assertEquals(objPharmacyService.BOT_Account__c, objAccount.Id);        
        system.assertEquals(objPharmacyService.BOT_PBM_Name__c, objPBMAccount.Id);
    }
    
    //Testing while creating a list of pharmacy service records
    static testMethod void createPharmacyServices()
    {
        List<Account> lstAccount;								//To store a List of Account records
        List<Account> lstPBMAccount;							//To store a List of PBM Account records
        List<BOT_Pharmacy_Service__c> lstPharmacyServices;		//To store a pharmacy services records
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();

        //To create a list of Pharmacy service records
        clsTestDataFactory.createPharmacyServices(5,10,'Formulary development/Admin');
        clsTestDataFactory.createPharmacyServices(5,10,'Mail order');
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account WHERE Account_Type__c = 'MCO'];
        lstPBMAccount = [SELECT Id FROM Account WHERE Account_Type__c = 'PBM'];
        lstPharmacyServices = [SELECT Id, BOT_Account__c, BOT_PBM_Name__c FROM BOT_Pharmacy_Service__c];
        
        //Test data validation
        system.assertEquals(lstAccount.size(), 5);
        system.assertEquals(lstPBMAccount.size(), 5);
        system.assertEquals(lstPharmacyServices.size(), 100);
        for(Integer i = 0; i < 5; i++)
        {
        	for(Integer j = 0; j < 10; j++)
            {
            	system.assertEquals(lstPharmacyServices[intTemp].BOT_Account__c, lstAccount[i].Id);        
        		system.assertEquals(lstPharmacyServices[intTemp].BOT_PBM_Name__c, lstPBMAccount[i].Id);
                intTemp++;
            }
        }
	}
    
    //Testing while creating a Pharmacy service Record without Entity Id
    static testMethod void singleRecordNegativeScenario()
    {
    	BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        try {
        	clsTestDataFactory.createPharmacyServicesWithoutEntityID(1,1,'Mail order');
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity Id field is mandatory to save the record: []', e.getMessage());
        }
    }
}