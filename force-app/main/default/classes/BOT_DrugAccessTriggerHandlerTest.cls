/*
Name            : BOT_DrugAccessTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 21-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class of BOT_DrugAccessTriggerHandler class.
*/
@isTest(seeAllData=false)
class BOT_DrugAccessTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	//To create the Account and Fromulary product records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'Employer');
        clsTestDataFactory.createFormularyProductRecords(5);
        
        //Test data validation
        system.assert([SELECT count() FROM Account] == 5);
        system.assert([SELECT count() FROM Formulary_Products_vod__c] == 5);
    }
    
    //Testing while creating a single Drug Access record
    static testMethod void createDrugAccessRecord()
    {
        Account objAccount;                                 //To store an Account record
        Formulary_Products_vod__c objFormularyProduct;      //To store a formulary product record
        List<BOT_Drug_Access__c> lstDrugAccess;             //To store a list of drug access records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create a Drug access record
        lstDrugAccess = clsTestDataFactory.createDrugAccessRecords(1, 1);
       	insert lstDrugAccess;
        
        //Querying the created test data
        objAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_Id__c LIMIT 1];
        objFormularyProduct = [SELECT Id, Market_vod__c FROM Formulary_products_vod__c ORDER BY BOT_Formulary_Product_ID__c LIMIT 1];
        lstDrugAccess = [SELECT Id, Name, BOT_Account__c, BOT_Formulary_Product__c FROM BOT_Drug_Access__c];
        
        //Test data validation
        system.assertEquals(lstDrugAccess[0].Name,objFormularyProduct.Market_vod__c);
        system.assertEquals(lstDrugAccess[0].BOT_Account__c, objAccount.Id);
        system.assertEquals(lstDrugAccess[0].BOT_Formulary_Product__c, objFormularyProduct.Id);
    }
    
    //Testing while creating a list of Drug Access records
    static testMethod void createDrugAccessRecords()
    {
        List<Account> lstAccount;                           	//To store a list of Account records
        List<Formulary_Products_vod__c> lstFormularyProduct;    //To store a list of formulary product records
        List<BOT_Drug_Access__c> lstDrugAccess;                 //To store a list of drug access records returned by test data factory
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a list of Drug access records
        lstDrugAccess = clsTestDataFactory.createDrugAccessRecords(5, 5);
       	insert lstDrugAccess;
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_Id__c];
        lstFormularyProduct = [SELECT Id, Market_vod__c FROM Formulary_products_vod__c ORDER BY BOT_Formulary_Product_ID__c];
        lstDrugAccess = [SELECT Id, Name, BOT_Account__c, BOT_Formulary_Product__c FROM BOT_Drug_Access__c ORDER BY BOT_Entity_Id__c];
        
        //Test data validation
        system.assertEquals(lstAccount.size(), 5);
        system.assertEquals(lstFormularyProduct.size(), 5);
        system.assertEquals(lstDrugAccess.size(), 25);
        for(Integer i = 0; i < 5; i++)
        {
        	for(Integer j = 0; j < 5; j++)
            {
            	system.assertEquals(lstDrugAccess[intTemp].BOT_Account__c, lstAccount[i].Id);
                system.assertEquals(lstDrugAccess[intTemp].BOT_Formulary_Product__c, lstFormularyProduct[j].Id);    
                system.assertEquals(lstDrugAccess[intTemp].Name,lstFormularyProduct[j].Market_vod__c);
                intTemp++;
            }
        }
    }
    
    //Testing while creating a Drug access record with out Entity Id
    static testMethod void createDrugAccessWithoutEntityID()
    {	
    	List<BOT_Drug_Access__c> lstDrugAccess;		//To store a list of drug access records returned by test data factory
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Drug access record without Entity Id
        lstDrugAccess = clsTestDataFactory.createDrugAccessWithoutEntityID(1,1);
        try {
        	insert lstDrugAccess;    
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity Id and Formulary Product Id fields are required to save the record: []', e.getMessage());
        }
    }
    
    //Testing while creating a Drug access record with out Formualry Product Id
    static testMethod void createDrugAccessWithoutFormualryProductID()
    {	
    	List<BOT_Drug_Access__c> lstDrugAccess;		//To store a list of drug access records returned by test data factory
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Drug access record without Formulary Product Id
        lstDrugAccess = clsTestDataFactory.createDrugAccessWithoutFormualryProductID(1,1);
        try {
        	insert lstDrugAccess;    
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity Id and Formulary Product Id fields are required to save the record: []', e.getMessage());
        }
    }    
}